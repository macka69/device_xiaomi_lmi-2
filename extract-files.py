#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project  
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)
from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import (
    lib_fixup_remove,
    lib_fixups,
    lib_fixups_user_type,
)

# Device-specific blob fixups
blob_fixups: blob_fixups_user_type = {
    # Camera postproc service - hexdump patch for ARM64 instruction fix
    'vendor/lib64/vendor.qti.hardware.camera.postproc@1.0-service-impl.so': blob_fixup()
        .binary_regex_replace(b'\x21\x00\x80\x52\x9A\x0A\x00\x94', b'\x21\x00\x80\x52\x1F\x20\x03\xD5'),
    
    # Watermark node - add watermark shim library
    'vendor/lib64/camera/components/com.mi.node.watermark.so': blob_fixup()
        .add_needed('lib-watermarkshim.so'),
    
    # Multiple files - replace protobuf lite with full version
    'vendor/lib/mediadrm/libwvdrmengine.so': blob_fixup()
        .replace_needed('libprotobuf-cpp-lite-3.9.1.so', 'libprotobuf-cpp-full-3.9.1.so'),
    'vendor/lib64/libsnsdiaglog.so': blob_fixup()
        .replace_needed('libprotobuf-cpp-lite-3.9.1.so', 'libprotobuf-cpp-full-3.9.1.so'),
    'vendor/lib64/libsnsapi.so': blob_fixup()
        .replace_needed('libprotobuf-cpp-lite-3.9.1.so', 'libprotobuf-cpp-full-3.9.1.so'),
    'vendor/lib64/libwvhidl.so': blob_fixup()
        .replace_needed('libprotobuf-cpp-lite-3.9.1.so', 'libprotobuf-cpp-full-3.9.1.so')
        .replace_needed('libcrypto.so', 'libcrypto-v34.so'),
    'vendor/lib64/mediadrm/libwvdrmengine.so': blob_fixup()
        .replace_needed('libprotobuf-cpp-lite-3.9.1.so', 'libprotobuf-cpp-full-3.9.1.so'),
    'vendor/lib64/sensors.ssc.so': blob_fixup()
        .replace_needed('libprotobuf-cpp-lite-3.9.1.so', 'libprotobuf-cpp-full-3.9.1.so'),
    'vendor/lib64/libsensorcal.so': blob_fixup()
        .replace_needed('libprotobuf-cpp-lite-3.9.1.so', 'libprotobuf-cpp-full-3.9.1.so'),
    'vendor/lib64/libssc.so': blob_fixup()
        .replace_needed('libprotobuf-cpp-lite-3.9.1.so', 'libprotobuf-cpp-full-3.9.1.so'),
    'vendor/bin/sensors.qti': blob_fixup()
        .replace_needed('libprotobuf-cpp-lite-3.9.1.so', 'libprotobuf-cpp-full-3.9.1.so'),
    
    # Audio route library version fixes
    'vendor/lib/libaudioroute_ext.so': blob_fixup()
        .replace_needed('libaudioroute.so', 'libaudioroute-v34.so'),
    'vendor/lib/hw/audio.primary.kona.so': blob_fixup()
        .replace_needed('libaudioroute.so', 'libaudioroute-v34.so'),
} # fmt: skip

# Device-specific library fixups
lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    # Add any device-specific library fixups here
    # Example:
    # (
    #     'libsample',
    # ): lib_fixup_remove,
}

# Namespace imports for device-specific HALs and interfaces
namespace_imports = [
    'hardware/qcom-caf/sm8250',
    'hardware/xiaomi',
    'vendor/qcom/opensource/commonsys-intf/display',
    'vendor/qcom/opensource/commonsys/display', 
    'vendor/qcom/opensource/dataservices',
    'vendor/qcom/opensource/display',
]

# Create the extract utils module for lmi device
module = ExtractUtilsModule(
    'lmi',
    'xiaomi',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
)

# Add proprietary files list
module.add_proprietary_file('proprietary-files.txt')

# Add conditional proprietary files if needed
# module.add_proprietary_file('proprietary-files-extra.txt').add_copy_files_guard(
#     'TARGET_EXTRA_FEATURES', 'true'
# )

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
