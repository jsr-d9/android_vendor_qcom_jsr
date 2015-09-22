PREBUILT_PATH := $(call my-dir)


LOCAL_PATH          := $(PREBUILT_PATH)
include $(CLEAR_VARS)
LOCAL_MODULE        := iv_mpeg4_dec_lib
LOCAL_MODULE_TAGS   := optional debug
LOCAL_MODULE_CLASS  := STATIC_LIBRARIES
LOCAL_MODULE_SUFFIX := .a
LOCAL_SRC_FILES     := ../../.././target/product/msm8625/obj/STATIC_LIBRARIES/iv_mpeg4_dec_lib_intermediates/iv_mpeg4_dec_lib.a
include $(BUILD_PREBUILT)

LOCAL_PATH          := $(PREBUILT_PATH)
include $(CLEAR_VARS)
LOCAL_MODULE        := libqc-surfaceflinger
LOCAL_MODULE_TAGS   := optional debug
LOCAL_MODULE_CLASS  := STATIC_LIBRARIES
LOCAL_MODULE_SUFFIX := .a
LOCAL_SRC_FILES     := ../../.././target/product/msm8625/obj/STATIC_LIBRARIES/libqc-surfaceflinger_intermediates/libqc-surfaceflinger.a
include $(BUILD_PREBUILT)

LOCAL_PATH          := $(PREBUILT_PATH)
include $(CLEAR_VARS)
LOCAL_MODULE        := libqc-dalvik
LOCAL_MODULE_TAGS   := optional debug
LOCAL_MODULE_CLASS  := STATIC_LIBRARIES
LOCAL_MODULE_SUFFIX := .a
LOCAL_SRC_FILES     := ../../.././target/product/msm8625/obj/STATIC_LIBRARIES/libqc-dalvik_intermediates/libqc-dalvik.a
include $(BUILD_PREBUILT)


LOCAL_PATH          := $(PREBUILT_PATH)
include $(CLEAR_VARS)
LOCAL_MODULE        := liboemcrypto_rpc
LOCAL_MODULE_TAGS   := optional debug
LOCAL_MODULE_CLASS  := STATIC_LIBRARIES
LOCAL_MODULE_SUFFIX := .a
LOCAL_SRC_FILES     := ../../.././target/product/msm8625/obj/STATIC_LIBRARIES/liboemcrypto_rpc_intermediates/liboemcrypto_rpc.a
include $(BUILD_PREBUILT)

LOCAL_PATH          := $(PREBUILT_PATH)
include $(CLEAR_VARS)
LOCAL_MODULE        := iv_h264_dec_lib
LOCAL_MODULE_TAGS   := optional debug
LOCAL_MODULE_CLASS  := STATIC_LIBRARIES
LOCAL_MODULE_SUFFIX := .a
LOCAL_SRC_FILES     := ../../.././target/product/msm8625/obj/STATIC_LIBRARIES/iv_h264_dec_lib_intermediates/iv_h264_dec_lib.a
include $(BUILD_PREBUILT)

LOCAL_PATH          := $(PREBUILT_PATH)
include $(CLEAR_VARS)
LOCAL_MODULE        := iv_h264_enc_lib
LOCAL_MODULE_TAGS   := optional debug
LOCAL_MODULE_CLASS  := STATIC_LIBRARIES
LOCAL_MODULE_SUFFIX := .a
LOCAL_SRC_FILES     := ../../.././target/product/msm8625/obj/STATIC_LIBRARIES/iv_h264_enc_lib_intermediates/iv_h264_enc_lib.a
include $(BUILD_PREBUILT)

LOCAL_PATH          := $(PREBUILT_PATH)
include $(CLEAR_VARS)
LOCAL_MODULE        := libqc-skia
LOCAL_MODULE_TAGS   := optional debug
LOCAL_MODULE_CLASS  := STATIC_LIBRARIES
LOCAL_MODULE_SUFFIX := .a
LOCAL_SRC_FILES     := ../../.././target/product/msm8625/obj/STATIC_LIBRARIES/libqc-skia_intermediates/libqc-skia.a
include $(BUILD_PREBUILT)

LOCAL_PATH          := $(PREBUILT_PATH)
include $(CLEAR_VARS)
LOCAL_MODULE        := libqc-mpctl
LOCAL_MODULE_TAGS   := optional debug
LOCAL_MODULE_CLASS  := STATIC_LIBRARIES
LOCAL_MODULE_SUFFIX := .a
LOCAL_SRC_FILES     := ../../.././target/product/msm8625/obj/STATIC_LIBRARIES/libqc-mpctl_intermediates/libqc-mpctl.a
include $(BUILD_PREBUILT)

LOCAL_PATH          := $(PREBUILT_PATH)
include $(CLEAR_VARS)
LOCAL_MODULE        := libASFParserLib
LOCAL_MODULE_TAGS   := optional debug
LOCAL_MODULE_CLASS  := STATIC_LIBRARIES
LOCAL_MODULE_SUFFIX := .a
LOCAL_SRC_FILES     := ../../.././target/product/msm8625/obj/STATIC_LIBRARIES/libASFParserLib_intermediates/libASFParserLib.a
include $(BUILD_PREBUILT)

LOCAL_PATH          := $(PREBUILT_PATH)
include $(CLEAR_VARS)
LOCAL_MODULE        := libqc-sqlite
LOCAL_MODULE_TAGS   := optional debug
LOCAL_MODULE_CLASS  := STATIC_LIBRARIES
LOCAL_MODULE_SUFFIX := .a
LOCAL_SRC_FILES     := ../../.././target/product/msm8625/obj/STATIC_LIBRARIES/libqc-sqlite_intermediates/libqc-sqlite.a
include $(BUILD_PREBUILT)

LOCAL_PATH          := $(PREBUILT_PATH)
include $(CLEAR_VARS)
LOCAL_MODULE        := libsensors_lib
LOCAL_MODULE_TAGS   := optional debug
LOCAL_MODULE_CLASS  := STATIC_LIBRARIES
LOCAL_MODULE_SUFFIX := .a
LOCAL_SRC_FILES     := ../../.././target/product/msm8625/obj/STATIC_LIBRARIES/libsensors_lib_intermediates/libsensors_lib.a
include $(BUILD_PREBUILT)


LOCAL_PATH          := $(PREBUILT_PATH)
include $(CLEAR_VARS)
LOCAL_MODULE        := com.qualcomm.snapdragon.sdk.camera.QCCameraSDK
LOCAL_MODULE_TAGS   := optional debug
LOCAL_MODULE_CLASS  := JAVA_LIBRARIES
LOCAL_MODULE_SUFFIX := $(COMMON_JAVA_PACKAGE_SUFFIX)
LOCAL_SRC_FILES     := ../../.././target/common/obj/JAVA_LIBRARIES/com.qualcomm.snapdragon.sdk.camera.QCCameraSDK_intermediates/javalib.jar
include $(BUILD_PREBUILT)

LOCAL_PATH          := $(PREBUILT_PATH)
include $(CLEAR_VARS)
LOCAL_MODULE        := com.qualcomm.snapdragon.sdk.sensors.QCSensorSDK
LOCAL_MODULE_TAGS   := optional debug
LOCAL_MODULE_CLASS  := JAVA_LIBRARIES
LOCAL_MODULE_SUFFIX := $(COMMON_JAVA_PACKAGE_SUFFIX)
LOCAL_SRC_FILES     := ../../.././target/common/obj/JAVA_LIBRARIES/com.qualcomm.snapdragon.sdk.sensors.QCSensorSDK_intermediates/javalib.jar
include $(BUILD_PREBUILT)

LOCAL_PATH          := $(PREBUILT_PATH)
include $(CLEAR_VARS)
LOCAL_MODULE        := com.qualcomm.snapdragon.sdk.location
LOCAL_MODULE_TAGS   := optional debug
LOCAL_MODULE_CLASS  := JAVA_LIBRARIES
LOCAL_MODULE_SUFFIX := $(COMMON_JAVA_PACKAGE_SUFFIX)
LOCAL_SRC_FILES     := ../../.././target/common/obj/JAVA_LIBRARIES/com.qualcomm.snapdragon.sdk.location_intermediates/javalib.jar
include $(BUILD_PREBUILT)

LOCAL_PATH          := $(PREBUILT_PATH)
include $(CLEAR_VARS)
LOCAL_MODULE        := com.qualcomm.snapdragon.sdk.audio.QCAudioSDK
LOCAL_MODULE_TAGS   := optional debug
LOCAL_MODULE_CLASS  := JAVA_LIBRARIES
LOCAL_MODULE_SUFFIX := $(COMMON_JAVA_PACKAGE_SUFFIX)
LOCAL_SRC_FILES     := ../../.././target/common/obj/JAVA_LIBRARIES/com.qualcomm.snapdragon.sdk.audio.QCAudioSDK_intermediates/javalib.jar
include $(BUILD_PREBUILT)
