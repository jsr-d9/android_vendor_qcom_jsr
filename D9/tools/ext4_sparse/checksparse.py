#!/usr/bin/python
#===========================================================================

#  This script parses "rawprogram.xml" looking for sparse="true" tags
#  if found, it tries to find the sparse files and updates rawprogram.xml
#  such that msp.py, T32 and QPST can program them

# REFERENCES

#  $Header: //source/qcom/qct/core/pkg/bootloaders/rel/1.0/boot_images/core/storage/tools/jsdcc/partition_load_pt/checksparse.py#8 $
#  $DateTime: 2011/07/27 11:30:43 $ 
#  $Author: coresvc $

# when          who     what, where, why 
# --------      ---     ------------------------------------------------------- 
# 2011-07-26    ah      Correct mistake in usage
# 2011-07-21    ah      Handles non-sparse images better
# 2011-07-13    ah      Better error messages for user experience
# 2011-05-26    ah      Output rawprogram.xml as tags/comments back, change input args
# 2011-05-25    ab      Original version

# Copyright (c) 2007-2010
# Qualcomm Technologies Incorporated.
# All Rights Reserved.
# Qualcomm Confidential and Proprietary
# ===========================================================================*/

import struct, os, sys
import re
import shutil
from types import *
import math
import struct

if sys.version_info < (2,5): 
    sys.stdout.write("\n\nERROR: This script needs Python version 2.5 or greater, detected as ")
    print sys.version_info
    sys.exit()  # error

from xml.etree import ElementTree as ET
#from elementtree.ElementTree import ElementTree
from xml.etree.ElementTree import Element, SubElement, Comment, tostring
from xml.dom import minidom
from copy import deepcopy
import getopt


"""
typedef struct sparse_header {
  __le32	magic;		/* 0xed26ff3a */
  __le16	major_version;	/* (0x1) - reject images with higher major versions */
  __le16	minor_version;	/* (0x0) - allow images with higer minor versions */
  __le16	file_hdr_sz;	/* 28 bytes for first revision of the file format */
  __le16	chunk_hdr_sz;	/* 12 bytes for first revision of the file format */
  __le32	blk_sz;		/* block size in bytes, must be a multiple of 4 (4096) */
  __le32	total_blks;	/* total blocks in the non-sparse output image */
  __le32	total_chunks;	/* total chunks in the sparse input image */
  __le32	image_checksum; /* CRC32 checksum of the original data, counting "don't care" */
                /* as 0. Standard 802.3 polynomial, use a Public Domain */
                /* table implementation */
} sparse_header_t;
typedef struct chunk_header {
  __le16	chunk_type;	/* 0xCAC1 -> raw; 0xCAC2 -> fill; 0xCAC3 -> don't care */
  __le16	reserved1;
  __le32	chunk_sz;	/* in blocks in output image */
  __le32	total_sz;	/* in bytes of chunk input file including chunk header and data */
} chunk_header_t;
"""
# Struct related definitions
sparse_header_t = struct.Struct('<LHHHHLLLL')
chunk_header_t = struct.Struct('<HHLL')
SPARSE_HEADER_MAGIC = 0xed26ff3a
CHUNK_TYPE_RAW = 0xCAC1
CHUNK_TYPE_FILL = 0xCAC2
CHUNK_TYPE_DONT_CARE = 0xCAC3
_LARGEFILE64_SOURCE = 1
_FILE_OFFSET_BITS = 64
COPY_BUF_SIZE = (1024*1024)
#This will be malloc'ed with the size of blk_sz from the sparse file header
SPARSE_HEADER_MAJOR_VER = 1
SPARSE_HEADER_LEN = sparse_header_t.size
CHUNK_HEADER_LEN = chunk_header_t.size

def usage():
    print """
Usage: python simg2img.py [OPTION...]
Parses the sparse images from the input xml and generates the output chunks
as well as the new xml.

Examples:
  # Look for sparse images in rawprogram0.xml, create update rawprogram0.xml

  Options:

  -i, --input=FILE           rawprogram0.xml
  -o, --output=FILE          new rawprogram0.xml
  -s, --search_path=PATH     path to sparse image
  -?, --help                 give this help list

  Example

  python checksparse.py -i rawprogram0.xml -s C:\path1 -s C:\path2 -s C:\path3
  python checksparse.py -i rawprogram0.xml -s C:\path1 -s C:\path2 -o rawprogram00.xml

    """

def process_raw_chunk(fp_in, fp_out, blocks, blk_sz): 
    length = (1L * blocks) * blk_sz
    chunk = None

    while length!=0:
        if length > COPY_BUF_SIZE:
            chunk = COPY_BUF_SIZE
        else:
            chunk = length
        copybuf = fp_in.read(chunk)
        fp_out.write(copybuf)
        length -= chunk

def prettify(elem):
    """Return a pretty-printed XML string for the Element.
    """
    rough_string = ET.tostring(elem, 'utf-8')
    reparsed = minidom.parseString(rough_string)
    return reparsed.toprettyxml(indent="  ")

def main():
    if len(sys.argv) < 2:
        usage()
        sys.exit(-1)
    try:
        opts, args = getopt.getopt(sys.argv[1:], "i:o:?s:x:", ["input=", "outputpath=", "help", "search_path=", "xmlout="])
    except getopt.GetoptError, err:
        # print help information and exit:
        print str(err) # will print something like "option -a not recognized"
        usage()
        sys.exit(-2)


    paths = []
    rawprogram_xml = None
    new_xml = None
    #output_path = os.getcwd()
    for o, a in opts:
        if o in ("-i", "--input"):
            rawprogram_xml = a
        elif o in ("-o", "--output"):
            new_xml = a
        elif o in ("-s", "--search_path"):
            paths.append(a)
            output_path = a
        elif o in ("-?", "--help"):
            usage()
            sys.exit()
        else:
            assert False, "unhandled option"

#    import pdb; pdb.set_trace()

    if rawprogram_xml is None:
        print "Input xml file must be specified!"
        usage()
        sys.exit(-3)

    if new_xml is None:
        new_xml = rawprogram_xml    # backup to original place (if read-only, flag an error)
    rawprogram_xml_root = ET.parse(rawprogram_xml)
    try:
        xml_iter = rawprogram_xml_root.iter()
    except AttributeError:
        xml_iter = rawprogram_xml_root.getiterator()
    rawprogram_xml_root_element = rawprogram_xml_root.getroot()
    position = 0
    num_sparse_files = 0

    rawprogram_xml_root_element.insert(0, (Comment("NOTE: Sector size is 512bytes")))
    rawprogram_xml_root_element.insert(0, (Comment("NOTE: This is an ** Autogenerated file **")))

    for xml_element in xml_iter:
        if xml_element.tag == 'program' and xml_element.attrib['filename'] != '' and 'sparse' in xml_element.attrib and xml_element.attrib['sparse'].lower() == 'true':
            print "FOUND: sparse file found", xml_element.attrib['filename']
            del xml_element.attrib['sparse']
            # TODO: Deal with these attribs
            del xml_element.attrib['size_in_KB']
            if 'start_byte_hex' in xml_element.attrib:
                del xml_element.attrib['start_byte_hex']
			
            filename = find_file(xml_element.attrib['filename'], paths)
            results = genfile(filename, int(xml_element.attrib['start_sector']), output_path)
            if results == -1:
                #sys.exit(-5)
                continue

            num_sparse_files = num_sparse_files + 1

            for i in range(len(results)):
                result = results[i]
                new_element = deepcopy(xml_element)
                new_element.attrib.update(result)
                rawprogram_xml_root_element.insert(position+i, new_element)
            rawprogram_xml_root_element.remove(xml_element)
        position = position + 1
    if num_sparse_files > 0:
        print "Found",num_sparse_files,"files"
        rough_string = "<?xml version=\"1.0\" ?>\n%s" % ET.tostring(rawprogram_xml_root.getroot())
        #reparsed = minidom.parseString(rough_string)
        #rough_string = reparsed.toprettyxml(indent="  ")
        rough_string = re.sub(" +\n","",rough_string)
        rough_string = re.sub("><",">\n  <",rough_string)
        #temp = re.sub("^\s+","",temp)
        #temp = re.sub("\s+$","",temp)


        print "Backing up '%s' to '%s'" % (rawprogram_xml,os.path.basename(rawprogram_xml))
        try:
            shutil.copyfile(rawprogram_xml,os.path.basename(rawprogram_xml)+".bak")
        except:
            print "ERROR: Could not create backup"

        try:
            opfile = open(new_xml, "w")
        except:
            print "\nERROR: Unable to write to '%s'" % new_xml
            print "\nPlease use -o option to specify output filename"
            print "\nEx.\n\tpython checksparse.py -i rawprogram0.xml -o rawprogramNEW.xml\n\n"
            sys.exit()
        opfile.write( rough_string )
        opfile.close()
        print "\nSUCCESS: Created \"%s\"" % new_xml

        print """
            To see this message means your rawprogram.xml had at least 1 sparse image
            Your rawprogram.xml is now updated to be able to program it
        """

        #rawprogram_xml_root.write(new_xml, encoding="us-ascii")
    else:
        print "\nNo sparse images found\n"


def genfile(filename, current_start_sector, output_path):
    # Misc variable declarations
    in_fp = None
    out_fp = None
    sparse_header = {}
    chunk_header = {}
    total_blocks = 0
    chunk_number = 1
    file_name = None
    file_ext = None
    results = []
    temp = None

    basename, file_ext = os.path.splitext(filename)
    file_ext = ".unsparse"
    file_name = os.path.basename(basename)
    in_fp = open(filename, "rb")

    all_bytes = sparse_header_t.unpack(in_fp.read(SPARSE_HEADER_LEN))
    sparse_header['magic'] = all_bytes[0]
    sparse_header['major_version'] = all_bytes[1]
    sparse_header['minor_version'] = all_bytes[2]
    sparse_header['file_hdr_sz'] = all_bytes[3]
    sparse_header['chunk_hdr_sz'] = all_bytes[4]
    sparse_header['blk_sz'] = all_bytes[5]
    sparse_header['total_blks'] = all_bytes[6]
    sparse_header['total_chunks'] = all_bytes[7]
    sparse_header['image_checksum'] = all_bytes[8]

    if sparse_header['magic'] != SPARSE_HEADER_MAGIC:
        print "Bad magic ", sparse_header['magic'], " '%s' is probably not a sparse image\n" % filename
        return -1

    if sparse_header['major_version'] != SPARSE_HEADER_MAJOR_VER:
        print "Unknown major version number ", sparse_header['major_version']
        return -1

    if sparse_header['file_hdr_sz'] > SPARSE_HEADER_LEN:
        # Skip the remaining bytes in a header that is longer than
        # we expected.
        in_fp.seek(sparse_header['file_hdr_sz'] - SPARSE_HEADER_LEN, os.SEEK_CUR)

    for i in range(sparse_header['total_chunks']):
        all_bytes = chunk_header_t.unpack(in_fp.read(CHUNK_HEADER_LEN))
        chunk_header['chunk_type'] = all_bytes[0]
        chunk_header['reserved1'] = all_bytes[1]
        chunk_header['chunk_sz'] = all_bytes[2]
        chunk_header['total_sz'] = all_bytes[3]

        if sparse_header['chunk_hdr_sz'] > CHUNK_HEADER_LEN:
            # Skip the remaining bytes in a header that is longer than
            # we expected.
            in_fp.seek(sparse_header['chunk_hdr_sz'] - CHUNK_HEADER_LEN, os.SEEK_CUR)

        if chunk_header['chunk_type'] == CHUNK_TYPE_RAW:
            if chunk_header['total_sz'] != (sparse_header['chunk_hdr_sz'] + (chunk_header['chunk_sz'] * sparse_header['blk_sz'])):
                print "Bogus chunk size for chunk %d, type Raw" % i
                return -1
            temp = (1L * chunk_header['chunk_sz']) * sparse_header['blk_sz']
            if temp % 512 == 0:
                file_size_sectors = temp/512
                size_in_KB = file_size_sectors/2
                start_byte_hex = current_start_sector * 512
            else:
                print "File chunk size %d is not a sector-multiple" % temp
                return -1
            if out_fp is None or out_fp.closed:
                print "\tcreating %s" % os.path.join(output_path, "%s_%d%s" % (file_name, chunk_number, file_ext))
                out_fp = open(os.path.join(output_path, "%s_%d%s" % (file_name, chunk_number, file_ext)), "wb")
                results.append({'filename': "%s_%d%s" % (file_name, chunk_number, file_ext), 'num_partition_sectors': str(file_size_sectors),'size_in_KB': str(size_in_KB), 'sparse': 'false', 'start_byte_hex': str(start_byte_hex), 'start_sector': str(current_start_sector)})
                chunk_number += 1
            else:
                results[-1]['num_partition_sectors'] = str(int(results[-1]['num_partition_sectors']) + file_size_sectors)
            process_raw_chunk(in_fp, out_fp, chunk_header['chunk_sz'], sparse_header['blk_sz'])
            current_start_sector += file_size_sectors
            total_blocks = total_blocks + chunk_header['chunk_sz']
        elif chunk_header['chunk_type'] == CHUNK_TYPE_DONT_CARE:
            if (not out_fp is None) and not out_fp.closed:
                out_fp.close()
            if chunk_header['total_sz'] != sparse_header['chunk_hdr_sz']:
                print "Bogus chunk size for chunk %d, type Dont Care" % i
                return -1
            temp = (1L * chunk_header['chunk_sz']) * sparse_header['blk_sz']
            if temp%512 == 0:
                current_start_sector += (temp/512)
            else:
                print "Number of bytes skipped %d is not a sector-multiple" % temp
                return -1
            total_blocks = total_blocks + chunk_header['chunk_sz']
        else:
            if (not out_fp is None) and not out_fp.closed:
                out_fp.close()
            print "Unknown chunk type 0x%4.4x" % chunk_header['chunk_type']
            return -1

    in_fp.close()
    if (not out_fp is None) and not out_fp.closed:
        out_fp.close()

    if sparse_header['total_blks'] != total_blocks:
        print "Wrote %d blocks, expected to write %d blocks\n" % (total_blocks, sparse_header['total_blks'])
        return -1
    
    return results

def find_file(filename, search_paths):
    for some_path in search_paths:
        temp = os.path.join(some_path, filename)
        if os.path.isfile(temp):
            return temp
    if os.path.isfile(filename):
        return filename

    print "\nERROR: Couldn't locate sparse file '%s'. This file needs to be opened and parsed to continue\n" % filename

    print """
        NOTE: To see this error message means
              Your rawprogram.xml file has at least 1 sparse image
              But, this python script couldn't located it the sparse image

        NOTE: To correct this simply provide enough search paths for this program to find your sparse image
              Ex. python checksparse.py -i rawprogram0.xml -p C:\\path1 -p C:\\path2 -p C:\\path3
              Ex. python checksparse.py -i rawprogram0.xml -p C:\\windows\\temp -p C:\\temp
              Ex. python checksparse.py -i rawprogram0.xml -p ..\\temp

        """

    print "You provided the following paths"
    for path in search_paths:
        print path


    sys.exit(-4)

if __name__ == "__main__":
    main()
