#
# Copyright (C) 2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from the device configuration.
$(call inherit-product, device/xiaomi/lmi/device.mk)

# Inherit some common bliss stuff.
$(call inherit-product, vendor/bliss/config/common.mk)

# Set Boot Animination Resolution
TARGET_BOOT_ANIMATION_RES := 1080

BLISS_BUILDTYPE=OFFICIAL

PRODUCT_NAME := bliss_lmi
PRODUCT_DEVICE := lmi
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_BRAND := POCO
PRODUCT_MODEL := POCO F2 Pro

EXTRA_UDFPS_ANIMATIONS := true

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

BUILD_FINGERPRINT := Redmi/lmi/lmi:12/SKQ1.211006.001/V14.0.1.0.SJKMIXM:user/release-keys
