LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_PRODUCT),msm8625)
  -include $(LOCAL_PATH)/target/product/msm8625/Android.mk
endif
ifeq ($(TARGET_PRODUCT),msm8625_d9)
  -include $(LOCAL_PATH)/target/product/msm8625/Android.mk
endif
ifeq ($(TARGET_PRODUCT),msm8625_d9c)
  -include $(LOCAL_PATH)/target/product/msm8625/Android.mk
endif
ifeq ($(TARGET_PRODUCT),msm8625_i6)
  -include $(LOCAL_PATH)/target/product/msm8625/Android.mk
endif
ifeq ($(TARGET_PRODUCT),msm8625_i6c)
  -include $(LOCAL_PATH)/target/product/msm8625/Android.mk
endif
ifeq ($(TARGET_PRODUCT),msm8625_i6c_smartfren)
  -include $(LOCAL_PATH)/target/product/msm8625/Android.mk
endif
