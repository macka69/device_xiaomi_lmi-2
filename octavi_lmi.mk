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

# Inherit some common Ricedroid stuff.
$(call inherit-product, vendor/octavi/config/common_full_phone.mk)

PRODUCT_NAME := octavi_lmi
PRODUCT_DEVICE := lmi
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_BRAND := POCO
PRODUCT_MODEL := POCO F2 Pro

# OctaviOS stuff
EXTRA_UDFPS_ANIMATIONS := true
WITH_GMS := true

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi
