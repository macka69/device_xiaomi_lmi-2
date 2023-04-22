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
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

PRODUCT_NAME := lineage_lmi
PRODUCT_DEVICE := lmi
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_BRAND := POCO
PRODUCT_MODEL := POCO F2 Pro

# Rom Flags
RICE_MAINTAINER := macka
RICE_CHIPSET := Snapdragon®865
TARGET_HAS_UDFPS := true
TARGET_ENABLE_BLUR := true
TARGET_USE_PIXEL_FINGERPRINT := true
TARGET_OPTOUT_GOOGLE_TELEPHONY := true
TARGET_SUPPORTS_QUICK_TAP := true
TARGET_SUPPORTS_NEXT_GEN_ASSISTANT := true
WITH_GMS := true

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi
