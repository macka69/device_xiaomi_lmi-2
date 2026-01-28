/*
 * Copyright (C) 2024 The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 */

#include <android/log.h>
#include <stdint.h>
#include <atomic>

#define LOG_TAG "libgui_camera_shim"
#define ALOGV(...) __android_log_print(ANDROID_LOG_VERBOSE, LOG_TAG, __VA_ARGS__)

static std::atomic<int> buffer_count{0};

extern "C" {

int _ZNK7android17IProducerListener13getHalVariantEv() {
    ALOGV("getHalVariant() called - returning 0");
    return 0;
}

void _ZN7android18BnProducerListener16onBufferDetachedEi(int slot) {
    int count = ++buffer_count;
    ALOGV("onBufferDetached(slot=%d) called - total calls: %d", slot, count);
    
    // The actual buffer release is handled by the caller
    // We just need to acknowledge this callback
}

}
