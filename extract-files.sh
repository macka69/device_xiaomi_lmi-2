#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=lmi
VENDOR=xiaomi

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in
        vendor/lib64/vendor.qti.hardware.camera.postproc@1.0-service-impl.so)
            hexdump -ve '1/1 "%.2X"' "${2}" | sed "s/210080529A0A0094/210080521F2003D5/g" | xxd -r -p > "${TMPDIR}/${1##*/}"
            mv "${TMPDIR}/${1##*/}" "${2}"
            ;;
        vendor/lib64/camera/components/com.mi.node.watermark.so)
            "${PATCHELF}" --add-needed "lib-watermarkshim.so" "${2}"
            ;;
        vendor/lib/mediadrm/libwvdrmengine.so | vendor/lib64/libsnsdiaglog.so | vendor/lib64/libsnsapi.so | vendor/lib64/libwvhidl.so | vendor/lib64/mediadrm/libwvdrmengine.so | vendor/lib64/sensors.ssc.so | vendor/lib64/libsensorcal.so | vendor/lib64/libssc.so |vendor/bin/sensors.qti)
             "${PATCHELF}" --replace-needed "libprotobuf-cpp-lite-3.9.1.so" "libprotobuf-cpp-full-3.9.1.so" "${2}"
            ;;
        vendor/lib64/libwvhidl.so)
            "${PATCHELF}" --replace-needed "libcrypto.so" "libcrypto-v34.so" "${2}"
            ;;
        vendor/lib/libaudioroute_ext.so)
            "${PATCHELF}" --replace-needed "libaudioroute.so" "libaudioroute-v34.so" "${2}"
            ;;
        vendor/lib/hw/audio.primary.kona.so)
            "${PATCHELF}" --replace-needed "libaudioroute.so" "libaudioroute-v34.so" "${2}"
            ;;
        odm/bin/hw/vendor.dolby_sp.media.c2@1.0-service)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "libcodec2_hidl@1.0.so" "libcodec2_hidl@1.0_sp.so" "${2}"
            "${PATCHELF}" --replace-needed "libcodec2_vndk.so" "libcodec2_vndk_sp.so" "${2}"
            ;;
        odm/lib64/libcodec2_store_dolby_sp.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "libcodec2_vndk.so" "libcodec2_vndk_sp.so" "${2}"
            ;;
        odm/lib64/libcodec2_soft_ac4dec_sp.so|odm/lib64/libcodec2_soft_ddpdec_sp.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "libcodec2_vndk.so" "libcodec2_vndk_sp.so" "${2}"
            "${PATCHELF}" --replace-needed "libcodec2_soft_common.so" "libcodec2_soft_common_sp.so" "${2}"
            "${PATCHELF}" --replace-needed "libstagefright_foundation.so" "libstagefright_foundation-v33.so" "${2}"
            ;;
        odm/lib64/libcodec2_vndk_sp.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "libui.so" "libui_sp.so" "${2}"
            "${PATCHELF}" --replace-needed "libstagefright_foundation.so" "libstagefright_foundation-v33.so" "${2}"
            ;;
        odm/lib64/libcodec2_hidl@1.0_sp.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "libcodec2_hidl_plugin.so" "libcodec2_hidl_plugin_sp.so" "${2}"
            "${PATCHELF}" --replace-needed "libcodec2_vndk.so" "libcodec2_vndk_sp.so" "${2}"
            ;;
        odm/lib64/libcodec2_hidl_plugin_sp.so|odm/lib64/libcodec2_soft_common_sp.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "libcodec2_vndk.so" "libcodec2_vndk_sp.so" "${2}"
            "${PATCHELF}" --replace-needed "libstagefright_foundation.so" "libstagefright_foundation-v33.so" "${2}"
            ;;
        odm/lib/libdlbdsservice_v3_6.so|odm/lib/libstagefright_soft_ddpdec.so|odm/lib64/libdlbdsservice_sp.so|odm/lib64/libdlbdsservice_v3_6.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "libstagefright_foundation.so" "libstagefright_foundation-v33.so" "${2}"
            ;;
        odm/lib64/libui_sp.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "android.hardware.graphics.common-V3-ndk.so" "android.hardware.graphics.common-V5-ndk.so" "${2}"
            "${PATCHELF}" --replace-needed "android.hardware.graphics.allocator-V1-ndk.so" "android.hardware.graphics.allocator-V2-ndk.so" "${2}"
            ;;
    esac
}

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}"

extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"

"${MY_DIR}/setup-makefiles.sh"
