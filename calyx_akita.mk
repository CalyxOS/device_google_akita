#
# SPDX-FileCopyrightText: 2021-2024 The LineageOS Project
# SPDX-FileCopyrightText: 2021-2024 The Calyx Institute
# SPDX-License-Identifier: Apache-2.0
#

# Inherit some common stuff
TARGET_DISABLE_EPPE := true
$(call inherit-product, vendor/calyx/config/common_phone.mk)

# Inherit device configuration
DEVICE_CODENAME := akita
DEVICE_PATH := device/google/akita
VENDOR_PATH := vendor/google/akita
$(call inherit-product, device/google/zuma/calyx_common.mk)
$(call inherit-product, $(DEVICE_PATH)/$(DEVICE_CODENAME)/device-calyx.mk)
$(call inherit-product, $(DEVICE_PATH)/aosp_$(DEVICE_CODENAME).mk)

# Device identifier. This must come after all inclusions
PRODUCT_BRAND := google
PRODUCT_MODEL := Pixel 8a
PRODUCT_NAME := calyx_$(DEVICE_CODENAME)

PRODUCT_BUILD_PROP_OVERRIDES := \
    BuildDesc=akita-user[[:space:]]15[[:space:]]AP3A.241005.015[[:space:]]12366759[[:space:]]release-keys \
    BuildFingerprint=google/akita/akita:15/AP3A.241005.015/12366759:user/release-keys \
    DeviceProduct=$(DEVICE_CODENAME)

PRODUCT_RESTRICT_VENDOR_FILES := false

$(call inherit-product, $(VENDOR_PATH)/$(DEVICE_CODENAME)-vendor.mk)
