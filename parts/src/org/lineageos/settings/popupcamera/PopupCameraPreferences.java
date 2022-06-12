/*
 * Copyright (C) 2019 The LineageOS Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.lineageos.settings.popupcamera;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

public class PopupCameraPreferences {

    private static final String TAG = "PopupCameraUtils";
    private static final boolean DEBUG = false;

    private static final String LED_KEY = "popup_led";
    private static final boolean LED_DEFAULT_VALUE = true;

    private static final String LED_COLOR_KEY = "popup_led_color";
    private static final String LED_COLOR_DEFAULT_VALUE = "5";

    private static final String SOUND_KEY = "popup_sound";
    private static final String SOUND_DEFAULT_VALUE = "0";

    private SharedPreferences mSharedPrefs;

    public PopupCameraPreferences(Context context) {
        mSharedPrefs = PreferenceManager.getDefaultSharedPreferences(context);
    }

    public boolean isLedAllowed() {
        return mSharedPrefs.getBoolean(LED_KEY, LED_DEFAULT_VALUE);
    }

    public String getLEDColor() {
        return mSharedPrefs.getString(LED_COLOR_KEY, LED_COLOR_DEFAULT_VALUE);
    }

    public String getSoundEffect() {
        return mSharedPrefs.getString(SOUND_KEY, SOUND_DEFAULT_VALUE);
    }
}
