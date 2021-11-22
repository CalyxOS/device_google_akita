# Inherit some common stuff.
$(call inherit-product, vendor/calyx/config/common_phone.mk)

# Inherit device configuration
$(call inherit-product, device/google/zuma/calyx_common.mk)
$(call inherit-product, device/google/akita/akita/device-calyx.mk)
$(call inherit-product, device/google/akita/aosp_akita.mk)

## Device identifier. This must come after all inclusions
PRODUCT_NAME := calyx_akita
PRODUCT_MODEL := Pixel 8
PRODUCT_BRAND := google

PRODUCT_BUILD_PROP_OVERRIDES += \
    TARGET_PRODUCT=akita \
    PRIVATE_BUILD_DESC="akita-user 14 UD1A.230803.041 10808477 release-keys"

BUILD_FINGERPRINT := google/akita/akita:14/UD1A.230803.041/10808477:user/release-keys

PRODUCT_RESTRICT_VENDOR_FILES := false
