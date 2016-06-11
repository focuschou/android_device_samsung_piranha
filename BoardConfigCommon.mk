#
# Copyright (C) 2016 The CyanogenMod Project
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
#

# Inherit common omap4 board config
-include hardware/ti/omap4/BoardConfigCommon.mk

COMMON_PATH := device/samsung/piranha

BOARD_VENDOR := samsung

TARGET_SPECIFIC_HEADER_PATH := $(COMMON_PATH)/include

# Camera
TARGET_RELEASE_CPPFLAGS += -DNEEDS_VECTORIMPL_SYMBOLS
COMMON_GLOBAL_CFLAGS += -DREFBASE_JB_MR1_COMPAT_SYMBOLS

# CPU
TARGET_ARCH_VARIANT_CPU := cortex-a9
ARCH_ARM_HAVE_TLS_REGISTER := true
TARGET_GLOBAL_CFLAGS += -mtune=cortex-a9 -mfpu=neon -mfloat-abi=softfp
TARGET_GLOBAL_CPPFLAGS += -mtune=cortex-a9 -mfpu=neon -mfloat-abi=softfp

# Fonts
EXTENDED_FONT_FOOTPRINT := true

# Platform
TARGET_BOARD_PLATFORM := omap4

# RIL
BOARD_PROVIDES_LIBRIL := true
BOARD_MODEM_TYPE := xmm6262
BOARD_RIL_CLASS := ../../../device/samsung/piranha/ril

# Enable WEBGL in WebKit
ENABLE_WEBGL := true

# HWComposer
BOARD_USES_HWCOMPOSER := true
BOARD_USE_CUSTOM_HWC := true
BOARD_USE_SYSFS_VSYNC_NOTIFICATION := true
# set if the target supports FBIO_WAITFORVSYNC
TARGET_HAS_WAITFORVSYNC := true
TARGET_RUNNING_WITHOUT_SYNC_FRAMEWORK := true

# Setup custom omap4xxx defines
BOARD_USE_CUSTOM_LIBION := true

# External SGX Module
SGX_MODULES:
	make clean -C $(HARDWARE_TI_OMAP4_BASE)/pvr-source/eurasiacon/build/linux2/omap4430_android
	cp $(TARGET_KERNEL_SOURCE)/drivers/video/omap2/omapfb/omapfb.h $(KERNEL_OUT)/drivers/video/omap2/omapfb/omapfb.h
	make -j8 -C $(HARDWARE_TI_OMAP4_BASE)/pvr-source/eurasiacon/build/linux2/omap4430_android ARCH=arm KERNEL_CROSS_COMPILE=arm-eabi- CROSS_COMPILE=arm-eabi- KERNELDIR=$(KERNEL_OUT) TARGET_PRODUCT="blaze_tablet" BUILD=release TARGET_SGX=544sc PLATFORM_VERSION=4.0
	mv $(KERNEL_OUT)/../../target/kbuild/pvrsrvkm_sgx544_112.ko $(KERNEL_MODULES_OUT)
	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-unneeded $(KERNEL_MODULES_OUT)/pvrsrvkm_sgx544_112.ko

TARGET_KERNEL_MODULES += SGX_MODULES

# inherit from the proprietary version
-include vendor/samsung/piranha/BoardConfigVendor.mk
