#
# SPDX-FileCopyrightText: 2021 The Android Open-Source Project
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-FileCopyrightText: The Calyx Institute
# SPDX-License-Identifier: Apache-2.0
#

# Kernel
TARGET_LINUX_KERNEL_VERSION := 6.1
TARGET_KERNEL_DEVICE := akita
TARGET_KERNEL_DIR := device/google/$(TARGET_KERNEL_DEVICE)-kernels/$(TARGET_LINUX_KERNEL_VERSION)
TARGET_KERNEL_PLATFORM_SOURCE := google/gs-$(TARGET_LINUX_KERNEL_VERSION)

ifneq ($(TARGET_BOOTS_16K),true)
PRODUCT_16K_DEVELOPER_OPTION := true
endif

# Inherit from zuma
include device/google/zuma/device-shipping-common.mk

# Bionic
PRODUCT_CHECK_PREBUILT_MAX_PAGE_SIZE := true

# Display
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/permissions/permissions_com.android.pixeldisplayservice.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/permissions_com.android.pixeldisplayservice.xml

# EUICC
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/permissions/permissions_com.google.android.euicc.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/permissions_com.google.android.euicc.xml

# Fingerprint
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml

# Google Camera
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/sysconfig/the_experiences.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/the_experiences.xml

# Overlays
PRODUCT_PACKAGES += \
    FrameworkResOverlayProductAkita \
    FrameworkResOverlayVendorAkita \
    PixelDisplayServiceOverlayProductAkita \
    PixelNfcOverlayAkita \
    SafetyRegulatoryInfoOverlayProductAkita \
    SettingsAkitaOverlay \
    SettingsGoogleAkitaOverlay \
    ShannonImsOverlayProductAkita \
    SystemUIGoogleOverlayVendorAkita

PRODUCT_PACKAGES += \
    ApertureOverlayAkita

# Properties
TARGET_PRODUCT_PROP += $(DEVICE_PATH)/$(DEVICE_CODENAME)/product.prop
TARGET_VENDOR_PROP += $(DEVICE_PATH)/$(DEVICE_CODENAME)/vendor.prop

# Recovery
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/init.recovery.device.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.akita.rc

PRODUCT_PACKAGES += \
    init.recovery.akita.touch.rc

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH)

# VINTF
DEVICE_PRODUCT_COMPATIBILITY_MATRIX_FILE += \
    $(DEVICE_PATH)/vintf/device_framework_matrix_product.xml

# Window extensions
$(call inherit-product, $(SRC_TARGET_DIR)/product/window_extensions.mk)
