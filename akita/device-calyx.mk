DEVICE_PACKAGE_OVERLAYS += device/google/akita/akita/overlay-calyx

TARGET_VENDOR_PROP += device/google/akita/akita/vendor.prop

$(call inherit-product, device/google/akita/device-calyx.mk)
