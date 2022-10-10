# Inherit some common stuff.
TARGET_DISABLE_EPPE := true
$(call inherit-product, vendor/calyx/config/common_phone.mk)

# Inherit device configuration
$(call inherit-product, device/google/zuma/calyx_common.mk)
$(call inherit-product, device/google/akita/akita/device-calyx.mk)
$(call inherit-product, device/google/akita/aosp_akita.mk)

## Device identifier. This must come after all inclusions
PRODUCT_NAME := calyx_akita
PRODUCT_MODEL := Pixel 8a
PRODUCT_BRAND := google

PRODUCT_BUILD_PROP_OVERRIDES += \
    TARGET_PRODUCT=akita \
    PRIVATE_BUILD_DESC="akita-user 14 UD2A.240505.001 11628456 release-keys"

BUILD_FINGERPRINT := google/akita/akita:14/UD2A.240505.001/11628456:user/release-keys

PRODUCT_RESTRICT_VENDOR_FILES := false

$(call inherit-product, vendor/google/akita/akita-vendor.mk)
