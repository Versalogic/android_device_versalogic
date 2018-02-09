LOCAL_PATH := $(call my-dir)

ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
-include device/fsl-codec/fsl-codec.mk
endif

TARGET_BOOTLOADER_CONFIG = imx6q:mx6qtetraandroid_config
TARGET_BOARD_DTS_CONFIG = imx6q:imx6q-tetra.dtb

include device/fsl-proprietary/media-profile/media-profile.mk
include device/fsl-proprietary/sensor/fsl-sensor.mk
