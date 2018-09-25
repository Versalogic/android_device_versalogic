#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/soc/imx6dq.mk
include device/versalogic/tetra_6dq/build_id.mk
include device/fsl/imx6/BoardConfigCommon.mk
# tetra_6dq default target for EXT4
BUILD_TARGET_FS ?= ext4
include device/fsl/imx6/imx6_target_fs.mk

ifneq ($(BUILD_TARGET_FS),f2fs)
# build for ext4
ifeq ($(PRODUCT_IMX_CAR),true)
TARGET_RECOVERY_FSTAB = device/versalogic/tetra_6dq/fstab.freescale.car
PRODUCT_COPY_FILES +=	\
	device/versalogic/tetra_6dq/fstab.freescale.car:root/fstab.freescale
else
TARGET_RECOVERY_FSTAB = device/versalogic/tetra_6dq/fstab.freescale
PRODUCT_COPY_FILES +=	\
	device/versalogic/tetra_6dq/fstab.freescale:root/fstab.freescale
endif # PRODUCT_IMX_CAR
else
TARGET_RECOVERY_FSTAB = device/versalogic/tetra_6dq/fstab-f2fs.freescale
# build for f2fs
PRODUCT_COPY_FILES +=	\
	device/versalogic/tetra_6dq/fstab-f2fs.freescale:root/fstab.freescale
endif # BUILD_TARGET_FS

# Vendor Interface Manifest
ifeq ($(PRODUCT_IMX_CAR),true)
PRODUCT_COPY_FILES += \
    device/versalogic/tetra_6dq/manifest_car.xml:vendor/manifest.xml
else
PRODUCT_COPY_FILES += \
    device/versalogic/tetra_6dq/manifest.xml:vendor/manifest.xml
endif

TARGET_BOOTLOADER_BOARD_NAME := TETRA
PRODUCT_MODEL := TETRA-MX6DQ

TARGET_BOOTLOADER_POSTFIX := imx
TARGET_DTB_POSTFIX := -dtb

TARGET_RELEASETOOLS_EXTENSIONS := device/fsl/imx6
# UNITE is a virtual device.
BOARD_WLAN_DEVICE            := UNITE
WPA_SUPPLICANT_VERSION       := VER_0_8_UNITE

BOARD_WPA_SUPPLICANT_DRIVER  := NL80211
BOARD_HOSTAPD_DRIVER         := NL80211

BOARD_HOSTAPD_PRIVATE_LIB_BCM               := lib_driver_cmd_bcmdhd
BOARD_WPA_SUPPLICANT_PRIVATE_LIB_BCM        := lib_driver_cmd_bcmdhd

WIFI_DRIVER_FW_PATH_STA        := "/vendor/firmware/bcm/fw_bcmdhd.bin"
WIFI_DRIVER_FW_PATH_P2P        := "/vendor/firmware/bcm/fw_bcmdhd.bin"
WIFI_DRIVER_FW_PATH_AP         := "/vendor/firmware/bcm/fw_bcmdhd_apsta.bin"
WIFI_DRIVER_FW_PATH_PARAM      := "/sys/module/bcmdhd/parameters/firmware_path"

#for accelerator sensor, need to define sensor type here
BOARD_HAS_SENSOR := true
SENSOR_FXOS8700 := true

# for recovery service
TARGET_SELECT_KEY := 28

# we don't support sparse image.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false
# uncomment below lins if use NAND
#TARGET_USERIMAGES_USE_UBIFS = true


ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
UBI_ROOT_INI := device/versalogic/tetra_6dq/ubi/ubinize.ini
TARGET_MKUBIFS_ARGS := -m 4096 -e 516096 -c 4096 -x none
TARGET_UBIRAW_ARGS := -m 4096 -p 512KiB $(UBI_ROOT_INI)
endif

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
ifeq ($(TARGET_USERIMAGES_USE_EXT4),true)
$(error "TARGET_USERIMAGES_USE_UBIFS and TARGET_USERIMAGES_USE_EXT4 config open in same time, please only choose one target file system image")
endif
endif

BOARD_KERNEL_CMDLINE := console=ttymxc0,115200 androidboot.console=ttymxc0 consoleblank=0 vmalloc=128M init=/init video=mxcfb0:dev=hdmi,1920x1080M@60,bpp=32 video=mxcfb1:dev=ldb,LDB-XGA,if=RGB666 video=mxcfb2:off video=mxcfb3:off androidboot.hardware=freescale cma=448M androidboot.selinux=permissive androidboot.dm_verity=disabled 

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
#UBI boot command line.
# Note: this NAND partition table must align with MFGTool's config.
BOARD_KERNEL_CMDLINE +=  mtdparts=gpmi-nand:16m(bootloader),16m(bootimg),128m(recovery),-(root) gpmi_debug_init ubi.mtd=3
endif


# Broadcom BCM4339 BT
BOARD_HAVE_BLUETOOTH_BCM := false
#BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/versalogic/tetra_6dq/bluetooth

USE_ION_ALLOCATOR := false
USE_GPU_ALLOCATOR := false

PHONE_MODULE_INCLUDE := false 
# camera hal v3
IMX_CAMERA_HAL_V3 := true

#define consumer IR HAL support
IMX6_CONSUMER_IR_HAL := false

TARGET_BOOTLOADER_CONFIG := imx6q:mx6qtetraandroid_config 
TARGET_BOARD_DTS_CONFIG := imx6q:imx6q-tetra.dtb

BOARD_SEPOLICY_DIRS := \
       device/fsl/imx6/sepolicy \
       device/versalogic/tetra_6dq/sepolicy

ifeq ($(PRODUCT_IMX_CAR),true)
BOARD_SEPOLICY_DIRS += \
     packages/services/Car/car_product/sepolicy \
     device/generic/car/common/sepolicy
endif

PRODUCT_COPY_FILES +=	\
       device/versalogic/tetra_6dq/ueventd.freescale.rc:root/ueventd.freescale.rc

# Support gpt
BOARD_BPT_INPUT_FILES += device/fsl/common/partition/device-partitions-7GB.bpt
ADDITION_BPT_PARTITION = partition-table-14GB:device/fsl/common/partition/device-partitions-14GB.bpt \
                         partition-table-28GB:device/fsl/common/partition/device-partitions-28GB.bpt

# Vendor seccomp policy files for media components:
PRODUCT_COPY_FILES += \
       device/versalogic/tetra_6dq/seccomp/mediacodec-seccomp.policy:vendor/etc/seccomp_policy/mediacodec.policy \
       device/versalogic/tetra_6dq/seccomp/mediaextractor-seccomp.policy:vendor/etc/seccomp_policy/mediaextractor.policy

PRODUCT_COPY_FILES += \
       device/versalogic/tetra_6dq/app_whitelist.xml:system/etc/sysconfig/app_whitelist.xml

TARGET_BOARD_KERNEL_HEADERS := device/fsl/common/kernel-headers
