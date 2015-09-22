# Copyright (C) 2013 Sony Mobile Communication
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE        := need
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS  := STATIC_LIBRARIES
$(shell mkdir -p $(TARGET_OUT)/lib)
$(shell cp -r -n $(LOCAL_PATH)/lib/* $(TARGET_OUT)/lib)


$(shell mkdir -p $(TARGET_OUT)/etc)
$(shell cp -r -n $(LOCAL_PATH)/etc/* $(TARGET_OUT)/etc)


$(shell mkdir -p $(TARGET_OUT)/bin)
$(shell cp -r -n $(LOCAL_PATH)/bin/* $(TARGET_OUT)/bin)

include $(BUILD_PREBUILT)