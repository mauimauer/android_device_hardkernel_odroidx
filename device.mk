# Copyright (C) 2010 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# This file is the device-specific product definition file for
# smdk4x12. It lists all the overlays, files, modules and properties
# that are specific to this hardware: i.e. those are device-specific
# drivers, configuration files, settings, etc...

# Note that smdk4x12 is not a fully open device. Some of the drivers
# aren't publicly available in all circumstances, which means that some
# of the hardware capabilities aren't present in builds where those
# drivers aren't available. Such cases are handled by having this file
# separated into two halves: this half here contains the parts that
# are available to everyone, while another half in the vendor/ hierarchy
# augments that set with the parts that are only relevant when all the
# associated drivers are available. Aspects that are irrelevant but
# harmless in no-driver builds should be kept here for simplicity and
# transparency. There are two variants of the half that deals with
# the unavailable drivers: one is directly checked into the unreleased
# vendor tree and is used by engineers who have access to it. The other
# is generated by setup-makefile.sh in the same directory as this files,
# and is used by people who have access to binary versions of the drivers
# but not to the original vendor tree. Be sure to update both.



# These is the hardware-specific overlay, which points to the location
# of hardware-specific resource overrides, typically the frameworks and
# application settings that are stored in resourced.

LOCAL_PATH := device/hardkernel/odroidx

$(call inherit-product-if-exists, vendor/hardkernel/odroidx/odroidx-vendor.mk)

include $(LOCAL_PATH)/BoardConfig.mk

ifeq ($(BOARD_USES_EMMC),true)
DEVICE_PACKAGE_OVERLAYS := $(LOCAL_PATH)/overlay
else
DEVICE_PACKAGE_OVERLAYS := $(LOCAL_PATH)/overlay_sd
endif

ifeq ($(BOARD_USES_HGL),true)
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/conf/egl.cfg:system/lib/egl/egl.cfg
endif

ifeq ($(BOARD_USES_EMMC),true)
PRODUCT_COPY_FILES += \
	device/hardkernel/odroidx/vold_emmc.fstab:system/etc/vold.fstab
else
PRODUCT_COPY_FILES += \
	device/hardkernel/odroidx/vold_sd.fstab:system/etc/vold.fstab
endif

# Init files

PRODUCT_COPY_FILES += \
	device/hardkernel/odroidx/conf/init.odroidx.rc:root/init.odroidx.rc \
	device/hardkernel/odroidx/conf/fstab.odroidx:root/fstab.odroidx

ifeq ($(BOARD_WLAN_DEVICE), rt5370sta)
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
        ro.wlaniface=ra0
PRODUCT_COPY_FILES += \
	device/hardkernel/odroidx/conf/init.ra0.rc:root/init.wlan.rc
else
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
        ro.wlaniface=wlan0
PRODUCT_COPY_FILES += \
	device/hardkernel/odroidx/conf/init.wlan0.rc:root/init.wlan.rc
endif

PRODUCT_COPY_FILES += \
	device/hardkernel/odroidx/conf/init.odroidx.usb.rc:root/init.odroidx.usb.rc 

#-------------------------------------------------------------------------------------
#
# WIFI firmware
#
#-------------------------------------------------------------------------------------
ifeq ($(BOARD_WLAN_DEVICE),rt5370sta)

PRODUCT_PROPERTY_OVERRIDES += \
	wifi.interface=ra0 \
	wifi.supplicant_scan_interval=15

PRODUCT_PACKAGES += dhcpcd.conf
	
else ifeq ($(BOARD_WLAN_DEVICE), rtl8191su)

PRODUCT_PROPERTY_OVERRIDES += \
	wifi.interface=wlan0 \
	wifi.supplicant_scan_interval=15
endif

# For V4L2
ifeq ($(BOARD_USE_V4L2), true)
ifeq ($(BOARD_USE_V4L2_ION), true)
PRODUCT_COPY_FILES += \
	device/hardkernel/odroidx/conf/ueventd.odroidx.v4l2ion.rc:root/ueventd.odroidx.rc
else
PRODUCT_COPY_FILES += \
	device/hardkernel/odroidx/conf/ueventd.odroidx.v4l2.rc:root/ueventd.odroidx.rc
endif
else
PRODUCT_COPY_FILES += \
	device/hardkernel/odroidx/conf/ueventd.odroidx.rc:root/ueventd.odroidx.rc
endif

# Filesystem management tools
PRODUCT_PACKAGES += \
	make_ext4fs \
	setup_fs

# audio
PRODUCT_PACKAGES += \
	audio_policy.odroidx \
	audio.primary.odroidx \
	audio.a2dp.default \
	libaudioutils

PRODUCT_COPY_FILES += \
	device/hardkernel/odroidx/conf/audio_policy.conf:system/etc/audio_policy.conf

# ULP Audio
ifeq ($(USE_ULP_AUDIO),true)
PRODUCT_PACKAGES += \
	libaudiohw \
	MusicULP \
	libsa_jni
endif

# ALP Audio
ifeq ($(BOARD_USE_ALP_AUDIO),true)
PRODUCT_PACKAGES += \
	libOMX.SEC.MP3.Decoder
endif

# Libs
PRODUCT_PACKAGES += \
	libcamera \
	libstagefrighthw \
	com.android.future.usb.accessory

# Video Editor
PRODUCT_PACKAGES += \
	VideoEditorGoogle

# Misc other modules
PRODUCT_PACKAGES += \
	lights.odroidx \
	hwcomposer.odroidx \
	gralloc.odroidx

# Widevine DRM
PRODUCT_PACKAGES += com.google.widevine.software.drm.xml \
	com.google.widevine.software.drm \
	WidevineSamplePlayer \
	test-libwvm \
	test-wvdrmplugin \
	test-wvplayer_L1 \
	libdrmwvmplugin \
	libwvm \
	libWVStreamControlAPI_L1 \
	libwvdrm_L1

# OpenMAX IL configuration files
PRODUCT_COPY_FILES += \
	device/hardkernel/odroidx/media_profiles.xml:system/etc/media_profiles.xml \
	device/hardkernel/odroidx/media_codecs.xml:system/etc/media_codecs.xml

# OpenMAX IL modules
PRODUCT_PACKAGES += \
	libSEC_OMX_Core \
	libSEC_OMX_Resourcemanager \
	libOMX.SEC.AVC.Decoder \
	libOMX.SEC.M4V.Decoder \
	libOMX.SEC.M4V.Encoder \
	libOMX.SEC.AVC.Encoder

# hwconvertor modules
PRODUCT_PACKAGES += \
	libhwconverter \


	
# gps
PRODUCT_PACKAGES += \
	gps.odroidx

#-------------------------------------------------------------------------------------
#
# framework permission file
#
#-------------------------------------------------------------------------------------
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
	frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
	frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
	frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
	frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
	frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
	frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
	packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:system/etc/permissions/android.software.live_wallpaper.xml \
	frameworks/native/data/etc/android.hardware.camera.autofocus.xml:system/etc/permissions/android.hardware.camera.autofocus.xml \
	frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml


# The OpenGL ES API level that is natively supported by this device.
# This is a 16.16 fixed point number
PRODUCT_PROPERTY_OVERRIDES := \
	ro.opengles.version=131072

PRODUCT_PROPERTY_OVERRIDES += \
	hwui.render_dirty_regions=false

# Widevine DRM
PRODUCT_PROPERTY_OVERRIDES += \
	drm.service.enabled=true

# Set default USB interface
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
	persist.sys.usb.config=mass_storage

PRODUCT_CHARACTERISTICS := tablet

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml

$(call inherit-product, frameworks/native/build/tablet-dalvik-heap.mk)

PRODUCT_PROPERTY_OVERRIDES += \
	ro.sf.lcd_density=213

USE_PIXTREE_STAGEFRIGHT := false

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

## Installation helpers for the "OTA" packages

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/releasetools/installboot.sh:installboot.sh \
    $(LOCAL_PATH)/releasetools/install-emmc.sh:install-emmc.sh \
    $(LOCAL_PATH)/releasetools/README.txt:README.txt

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery/postrecoveryboot.sh:recovery/root/sbin/postrecoveryboot.sh \
    $(LOCAL_PATH)/recovery/setup-recovery:system/bin/setup-recovery \
    $(LOCAL_PATH)/recovery/pseudorec-to-sd:system/bin/pseudorec-to-sd \
    $(LOCAL_PATH)/recovery/kernel:system/pseudorec/recovery-kernel \
    $(LOCAL_PATH)/recovery/recoveryboot.scr:system/pseudorec/boot.scr


PRODUCT_AAPT_CONFIG := normal large tvdpi hdpi
PRODUCT_AAPT_PREF_CONFIG := tvdpi