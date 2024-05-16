DEVICE_PACKAGE_OVERLAYS += device/google/akita/overlay-calyx

# Display
PRODUCT_COPY_FILES += \
    device/google/shusky/permissions/permissions_com.android.pixeldisplayservice.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/permissions_com.android.pixeldisplayservice.xml

# EUICC
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.euicc.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.hardware.telephony.euicc.xml \
    frameworks/native/data/etc/android.hardware.telephony.euicc.mep.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.hardware.telephony.euicc.mep.xml \
    device/google/akita/permissions/permissions_com.google.android.euicc.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/permissions_com.google.android.euicc.xml

PRODUCT_PACKAGES += \
    EuiccSupportPixelOverlay

# For Google Camera
PRODUCT_COPY_FILES += \
    device/google/akita/the_experiences.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/the_experiences.xml

TARGET_PREBUILT_KERNEL := device/google/akita-kernel/Image.lz4

# Pixel Camera Services / Camera extensions
PRODUCT_COPY_FILES += \
    device/google/akita/permissions/permissions_com.google.android.apps.camera.services.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/permissions_com.google.android.apps.camera.services.xml

# wireless_charger HAL service
include device/google/gs-common/wireless_charger/wireless_charger.mk

# Build necessary packages for vendor

# Graphics
PRODUCT_PACKAGES += \
    android.hardware.graphics.common-V4-ndk.vendor

# HIDL
PRODUCT_PACKAGES += \
    libhidltransport.vendor \
    libhwbinder.vendor

# Misc
PRODUCT_PACKAGES += \
    libjson
