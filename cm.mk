# Boot animation
TARGET_SCREEN_HEIGHT := 720
TARGET_SCREEN_WIDTH := 1280

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_tablet_wifionly.mk)

# Inherit device configuration
$(call inherit-product, device/hardkernel/odroidx/odroidx.mk)

## Device identifier. This must come after all inclusions
PRODUCT_DEVICE := odroidx
PRODUCT_NAME := cm_odroidx
PRODUCT_BRAND := Hardkernel
PRODUCT_MODEL := ODROID-X
PRODUCT_MANUFACTURER := Hardkernel