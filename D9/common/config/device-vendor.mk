# This file lists all qcom products and defines the QC_PROP flag which
# is used to enable projects inside $(QC_PROP_ROOT) directory.

# Also, This file intended for use by device/product makefiles
# to pick and choose the optional proprietary modules

# Root of Qualcomm Proprietary component tree
QC_PROP_ROOT := vendor/qcom/JSR/D9

PRODUCT_LIST := msm7625_surf
PRODUCT_LIST += msm7627a
PRODUCT_LIST += msm8625
PRODUCT_LIST += msm8625_d9

MSM7K_PRODUCT_LIST := msm7625_surf
MSM7K_PRODUCT_LIST += msm7627a
MSM7K_PRODUCT_LIST += msm8625_d9

FOTA_PRODUCT_LIST := msm7627a
FOTA_PRODUCT_LIST := msm8625_d9

ifneq (, $(filter $(PRODUCT_LIST), $(TARGET_PRODUCT)))

  include device/qcom/$(TARGET_PRODUCT)/BoardConfig.mk

  ifeq ($(call is-board-platform,msm8660),true)
    PREBUILT_BOARD_PLATFORM_DIR := msm8660_surf
  else ifeq ($(TARGET_PRODUCT),msm8625)
    PREBUILT_BOARD_PLATFORM_DIR := msm8625
  else ifeq ($(TARGET_PRODUCT),msm8625_d9)
    PREBUILT_BOARD_PLATFORM_DIR := msm8625
  else
    PREBUILT_BOARD_PLATFORM_DIR := $(TARGET_BOARD_PLATFORM)
  endif

  $(call inherit-product-if-exists, $(QC_PROP_ROOT)/prebuilt_obj/target/product/$(PREBUILT_BOARD_PLATFORM_DIR)/prebuilt.mk)

  ifeq ($(BUILD_TINY_ANDROID),true)
    #VENDOR_TINY_ANDROID_PACKAGES := $(QC_PROP_ROOT)/diag
    VENDOR_TINY_ANDROID_PACKAGES += $(QC_PROP_ROOT)/common/build/fusion_api_makefiles
    VENDOR_TINY_ANDROID_PACKAGES += $(QC_PROP_ROOT)/common/config

    ifeq ($(call is-board-platform-in-list,$(MSM7K_PRODUCT_LIST)),true)
      VENDOR_TINY_ANDROID_PACKAGES += hardware
      VENDOR_TINY_ANDROID_PACKAGES += external/wpa_supplicant

    endif

  endif # BUILD_TINY_ANDROID
endif

ifeq ($(call is-board-platform-in-list,$(FOTA_PRODUCT_LIST)),true)
-include  $(QC_PROP_ROOT)/Innopath/FOTA/fota.mk
endif

# Each line here corresponds to an optional LOCAL_MODULE built by
# Android.mk(s) in the proprietary projects. Where project
# corresponds to the vars here in CAPs.

# These modules are tagged with optional as their LOCAL_MODULE_TAGS
# wouldn't be present in your on target images, unless listed here
# explicitly.

