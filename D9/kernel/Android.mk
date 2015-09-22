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
LOCAL_MODULE  := kernel_need
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS  := STATIC_LIBRARIES
$(shell mkdir -p $(PRODUCT_OUT)/obj/lib)
$(shell cp -rf $(LOCAL_PATH)/sensor/* $(PRODUCT_OUT)/obj/lib)

$(shell mkdir -p $(PRODUCT_OUT)/obj/KERNEL_OBJ/drivers/i2c/bosch)
$(shell cp -rf $(LOCAL_PATH)/bosch/* $(PRODUCT_OUT)/obj/KERNEL_OBJ/drivers/i2c/bosch)

$(shell mkdir -p $(PRODUCT_OUT)/obj/KERNEL_OBJ/drivers/input/misc)
$(shell cp -rf $(LOCAL_PATH)/misc/* $(PRODUCT_OUT)/obj/KERNEL_OBJ/drivers/input/misc)

$(shell mkdir -p $(PRODUCT_OUT)/obj/KERNEL_OBJ/drivers/input/touchscreen)
$(shell cp -rf $(LOCAL_PATH)/touchscreen/* $(PRODUCT_OUT)/obj/KERNEL_OBJ/drivers/input/touchscreen)

$(shell mkdir -p $(PRODUCT_OUT)/obj/KERNEL_OBJ/drivers/leds)
$(shell cp -rf $(LOCAL_PATH)/leds/* $(PRODUCT_OUT)/obj/KERNEL_OBJ/drivers/leds)

$(shell mkdir -p $(PRODUCT_OUT)/obj/KERNEL_OBJ/drivers/media/video/msm/sensors)
$(shell cp -rf $(LOCAL_PATH)/ov/* $(PRODUCT_OUT)/obj/KERNEL_OBJ/drivers/media/video/msm/sensors)

$(shell mkdir -p $(PRODUCT_OUT)/obj/KERNEL_OBJ/drivers/power)
$(shell cp -rf $(LOCAL_PATH)/power/* $(PRODUCT_OUT)/obj/KERNEL_OBJ/drivers/power)

$(shell mkdir -p $(PRODUCT_OUT)/obj/KERNEL_OBJ/drivers/video/msm)
$(shell cp -rf $(LOCAL_PATH)/mipi/* $(PRODUCT_OUT)/obj/KERNEL_OBJ/drivers/video/msm)

include $(BUILD_PREBUILT)