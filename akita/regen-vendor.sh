#!/bin/bash
#
# Copyright (C) 2019-2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

_input_image="${1}"
_output_file="${2}"

if [ -z "${_input_image}" ]; then
    echo "No input image supplied"
    exit 1
fi

if [ -z "${_output_file}" ]; then
    echo "No output filename supplied"
    exit 1
fi

VENDOR_SKIP_FILES=(
    # Standard build output with vendor image build enabled
    "bin/["
    "bin/acpi"
    "bin/awk"
    "bin/base64"
    "bin/basename"
    "bin/blockdev"
    "bin/boringssl_self_test64"
    "bin/brctl"
    "bin/cal"
    "bin/cat"
    "bin/chattr"
    "bin/chcon"
    "bin/checkpoint_gc"
    "bin/chgrp"
    "bin/chmod"
    "bin/chown"
    "bin/chroot"
    "bin/chrt"
    "bin/cksum"
    "bin/clear"
    "bin/cmp"
    "bin/comm"
    "bin/cp"
    "bin/cpio"
    "bin/cut"
    "bin/date"
    "bin/dd"
    "bin/devmem"
    "bin/df"
    "bin/diff"
    "bin/dirname"
    "bin/dmesg"
    "bin/dos2unix"
    "bin/du"
    "bin/dump/dump_aoc"
    "bin/dump/dump_devfreq"
    "bin/dump/dump_display"
    "bin/dump/dump_gti0.sh"
    "bin/dump/dump_modem.sh"
    "bin/dump/dump_modemlog"
    "bin/dump/dump_pcie.sh"
    "bin/dump/dump_perf"
    "bin/dump/dump_pixel_metrics"
    "bin/dump/dump_power.sh"
    "bin/dump/dump_sensors"
    "bin/dump/dump_soc"
    "bin/dump/dump_storage.sh"
    "bin/dump/dump_thermal.sh"
    "bin/dump/dump_trusty.sh"
    "bin/dump/dump_umfw_stat"
    "bin/dump/dump_wlan.sh"
    "bin/dumpsys"
    "bin/echo"
    "bin/egrep"
    "bin/env"
    "bin/expand"
    "bin/expr"
    "bin/fallocate"
    "bin/false"
    "bin/fgrep"
    "bin/file"
    "bin/find"
    "bin/flock"
    "bin/fmt"
    "bin/free"
    "bin/fsync"
    "bin/getconf"
    "bin/getenforce"
    "bin/getevent"
    "bin/getprop"
    "bin/gpu_counter_producer"
    "bin/grep"
    "bin/groups"
    "bin/gunzip"
    "bin/gzip"
    "bin/head"
    "bin/hostname"
    "bin/hw/android.hardware.audio.service"
    "bin/hw/android.hardware.boot-service.default-zuma"
    "bin/hw/android.hardware.cas-service.example"
    "bin/hw/android.hardware.composer.hwc3-service.pixel"
    "bin/hw/android.hardware.contexthub-service.generic"
    "bin/hw/android.hardware.drm-service.clearkey"
    "bin/hw/android.hardware.dumpstate-service"
    "bin/hw/android.hardware.gatekeeper-service.trusty"
    "bin/hw/android.hardware.gnss-service"
    "bin/hw/android.hardware.health-service.zuma"
    "bin/hw/android.hardware.health.storage-service.default"
    "bin/hw/android.hardware.memtrack-service.pixel"
    "bin/hw/android.hardware.nfc-service.st"
    "bin/hw/android.hardware.power-service.pixel-libperfmgr"
    "bin/hw/android.hardware.power.stats-service.pixel"
    "bin/hw/android.hardware.secure_element-service.thales"
    "bin/hw/android.hardware.security.keymint-service.rust.trusty"
    "bin/hw/android.hardware.sensors-service.multihal"
    "bin/hw/android.hardware.thermal-service.pixel"
    "bin/hw/android.hardware.usb-service"
    "bin/hw/android.hardware.usb.gadget-service"
    "bin/hw/android.hardware.vibrator-service.cs40l26"
    "bin/hw/android.hardware.wifi-service"
    "bin/hw/battery_mitigation"
    "bin/hw/disable_contaminant_detection.sh"
    "bin/hw/gnssd"
    "bin/hw/hostapd"
    "bin/hw/wpa_supplicant"
    "bin/hwclock"
    "bin/i2cdetect"
    "bin/i2cdump"
    "bin/i2cget"
    "bin/i2cset"
    "bin/iconv"
    "bin/id"
    "bin/ifconfig"
    "bin/inotifyd"
    "bin/insmod"
    "bin/insmod.sh"
    "bin/install"
    "bin/ionice"
    "bin/iorenice"
    "bin/kill"
    "bin/killall"
    "bin/ln"
    "bin/load_policy"
    "bin/log"
    "bin/logger"
    "bin/logname"
    "bin/logwrapper"
    "bin/losetup"
    "bin/ls"
    "bin/lsattr"
    "bin/lsmod"
    "bin/lsof"
    "bin/lspci"
    "bin/lsusb"
    "bin/md5sum"
    "bin/microcom"
    "bin/misc_writer"
    "bin/mkdir"
    "bin/mkfifo"
    "bin/mknod"
    "bin/mkswap"
    "bin/mktemp"
    "bin/modinfo"
    "bin/modprobe"
    "bin/more"
    "bin/mount"
    "bin/mountpoint"
    "bin/mv"
    "bin/nc"
    "bin/netcat"
    "bin/netstat"
    "bin/nice"
    "bin/nl"
    "bin/nohup"
    "bin/nproc"
    "bin/nsenter"
    "bin/od"
    "bin/paste"
    "bin/patch"
    "bin/pgrep"
    "bin/pidof"
    "bin/pixelstats-vendor"
    "bin/pkill"
    "bin/pmap"
    "bin/printenv"
    "bin/printf"
    "bin/ps"
    "bin/pwd"
    "bin/readelf"
    "bin/readlink"
    "bin/realpath"
    "bin/rebalance_interrupts-vendor"
    "bin/renice"
    "bin/restorecon"
    "bin/rm"
    "bin/rmdir"
    "bin/rmmod"
    "bin/rtcwake"
    "bin/runcon"
    "bin/sed"
    "bin/sendevent"
    "bin/sendhint"
    "bin/seq"
    "bin/setenforce"
    "bin/setprop"
    "bin/setsid"
    "bin/sh"
    "bin/sha1sum"
    "bin/sha224sum"
    "bin/sha256sum"
    "bin/sha384sum"
    "bin/sha512sum"
    "bin/sleep"
    "bin/sort"
    "bin/split"
    "bin/start"
    "bin/stat"
    "bin/stop"
    "bin/storageproxyd"
    "bin/strings"
    "bin/stty"
    "bin/swapoff"
    "bin/swapon"
    "bin/sync"
    "bin/sysctl"
    "bin/tac"
    "bin/tail"
    "bin/tar"
    "bin/taskset"
    "bin/tee"
    "bin/test"
    "bin/thermal_symlinks"
    "bin/time"
    "bin/timeout"
    "bin/toolbox"
    "bin/top"
    "bin/touch"
    "bin/toybox_vendor"
    "bin/tr"
    "bin/true"
    "bin/truncate"
    "bin/trusty_apploader"
    "bin/tty"
    "bin/uclampset"
    "bin/ulimit"
    "bin/umount"
    "bin/uname"
    "bin/uniq"
    "bin/unix2dos"
    "bin/unlink"
    "bin/unshare"
    "bin/uptime"
    "bin/usleep"
    "bin/uudecode"
    "bin/uuencode"
    "bin/uuidgen"
    "bin/vi"
    "bin/vmstat"
    "bin/vndservice"
    "bin/vndservicemanager"
    "bin/watch"
    "bin/wc"
    "bin/which"
    "bin/whoami"
    "bin/xargs"
    "bin/xxd"
    "bin/yes"
    "bin/zcat"
    "build.prop"
    "etc/NOTICE.xml.gz"
    "etc/a2dp_audio_policy_configuration_7_0.xml"
    "etc/a2dp_in_audio_policy_configuration_7_0.xml"
    "etc/aoc/BLUETOOTH.dat"
    "etc/aoc/HANDSET.dat"
    "etc/aoc/HANDSFREE.dat"
    "etc/aoc/HEADSET.dat"
    "etc/aoc/mcps.dat"
    "etc/aoc/recording.gatf"
    "etc/aoc/smartfeature.gstf"
    "etc/atrace/atrace_categories.txt"
    "etc/audio_effects.xml"
    "etc/audio_platform_configuration.xml"
    "etc/audio_policy_configuration.xml"
    "etc/audio_policy_configuration_a2dp_offload_disabled.xml"
    "etc/audio_policy_configuration_bluetooth_legacy_hal.xml"
    "etc/audio_policy_configuration_le_offload_disabled.xml"
    "etc/audio_policy_volumes.xml"
    "etc/bluetooth/bt_vendor_overlay.conf"
    "etc/bluetooth_audio_policy_configuration_7_0.xml"
    "etc/bluetooth_power_limits.csv"
    "etc/bluetooth_power_limits_G576D_CA.csv"
    "etc/bluetooth_power_limits_G576D_EU.csv"
    "etc/bluetooth_power_limits_G576D_JP.csv"
    "etc/bluetooth_power_limits_G576D_US.csv"
    "etc/bluetooth_power_limits_G6GPR_CA.csv"
    "etc/bluetooth_power_limits_G6GPR_EU.csv"
    "etc/bluetooth_power_limits_G6GPR_US.csv"
    "etc/bluetooth_power_limits_G8HHN_EU.csv"
    "etc/bluetooth_power_limits_G8HHN_US.csv"
    "etc/bluetooth_power_limits_GKV4X_CA.csv"
    "etc/bluetooth_power_limits_GKV4X_EU.csv"
    "etc/bluetooth_power_limits_GKV4X_US.csv"
    "etc/default_volume_tables.xml"
    "etc/display_colordata_cal0.pb"
    "etc/display_colordata_dev_cal0.pb"
    "etc/display_golden_google-ak3b_cal0.pb"
    "etc/fs_config_dirs"
    "etc/fs_config_files"
    "etc/fstab.modem"
    "etc/fstab.persist"
    "etc/fstab.zram.2g"
    "etc/fstab.zram.3g"
    "etc/fstab.zram.40p"
    "etc/fstab.zram.4g"
    "etc/fstab.zram.50p"
    "etc/fstab.zram.50p-1g"
    "etc/fstab.zram.50p-2g"
    "etc/fstab.zram.5g"
    "etc/fstab.zram.60p"
    "etc/fstab.zram.6g"
    "etc/fstab.zuma"
    "etc/fstab.zuma-fips"
    "etc/gnss/ca.pem"
    "etc/gnss/gps.cfg"
    "etc/group"
    "etc/hearing_aid_audio_policy_configuration_7_0.xml"
    "etc/init.common.cfg"
    "etc/init/android.hardware.audio.service.rc"
    "etc/init/android.hardware.boot-service.default-zuma.rc"
    "etc/init/android.hardware.contexthub-service.generic.rc"
    "etc/init/android.hardware.drm-service.clearkey.rc"
    "etc/init/android.hardware.dumpstate-service.rc"
    "etc/init/android.hardware.gatekeeper-service.trusty.rc"
    "etc/init/android.hardware.health-service.zuma.rc"
    "etc/init/android.hardware.power-service.pixel-libperfmgr.rc"
    "etc/init/android.hardware.power.stats-service.pixel.rc"
    "etc/init/android.hardware.secure_element_gto.rc"
    "etc/init/android.hardware.security.keymint-service.rust.trusty.rc"
    "etc/init/android.hardware.sensors-service-multihal.rc"
    "etc/init/android.hardware.thermal-service.pixel.rc"
    "etc/init/android.hardware.usb-service.rc"
    "etc/init/android.hardware.usb.gadget-service.rc"
    "etc/init/android.hardware.vibrator-service.cs40l26.rc"
    "etc/init/android.hardware.wifi-service.rc"
    "etc/init/android.hardware.wifi.supplicant-service.rc"
    "etc/init/atrace_categories.rc"
    "etc/init/battery_mitigation.rc"
    "etc/init/boringssl_self_test.rc"
    "etc/init/cas-default.rc"
    "etc/init/health-storage-default.rc"
    "etc/init/hostapd.android.rc"
    "etc/init/hw/init.akita.rc"
    "etc/init/hw/init.zuma.rc"
    "etc/init/hw/init.zuma.usb.rc"
    "etc/init/hwc3-pixel.rc"
    "etc/init/init.aoc.rc"
    "etc/init/init.gnss.rc"
    "etc/init/init.module.rc"
    "etc/init/init.pixel.rc"
    "etc/init/init.storage.rc"
    "etc/init/init.touch.gti0.rc"
    "etc/init/memtrack.rc"
    "etc/init/nfc-service-default.rc"
    "etc/init/pixel-mm-gki.rc"
    "etc/init/pixel-thermal-symlinks.rc"
    "etc/init/pixelstats-vendor.zuma.rc"
    "etc/init/rebalance_interrupts-vendor.gs101.rc"
    "etc/init/vndservicemanager.rc"
    "etc/le_audio_codec_capabilities.xml"
    "etc/libnfc-hal-st.conf"
    "etc/libse-gto-hal.conf"
    "etc/linker.config.pb"
    "etc/media_codecs.xml"
    "etc/media_codecs_c2.xml"
    "etc/media_codecs_performance.xml"
    "etc/media_codecs_performance_c2.xml"
    "etc/media_profiles_V1_0.xml"
    "etc/mixer_paths.xml"
    "etc/mixer_paths_ti.xml"
    "etc/mkshrc"
    "etc/modem/Pixel_stability.cfg"
    "etc/modem/Pixel_stability.nprf"
    "etc/modem/default.cfg"
    "etc/modem/default.nprf"
    "etc/modem/default_metrics.xml"
    "etc/modem/display_primary_mipi_coex_table.csv"
    "etc/modem/display_primary_ssc_coex_table.csv"
    "etc/modem/logging.conf"
    "etc/modem_ml_models.conf"
    "etc/panel_config_google-ak3b_cal0.pb"
    "etc/passwd"
    "etc/permissions/android.hardware.audio.low_latency.xml"
    "etc/permissions/android.hardware.audio.pro.xml"
    "etc/permissions/android.hardware.bluetooth.prebuilt.xml"
    "etc/permissions/android.hardware.bluetooth_le.prebuilt.xml"
    "etc/permissions/android.hardware.camera.concurrent.xml"
    "etc/permissions/android.hardware.camera.flash-autofocus.xml"
    "etc/permissions/android.hardware.camera.front.xml"
    "etc/permissions/android.hardware.camera.full.xml"
    "etc/permissions/android.hardware.camera.raw.xml"
    "etc/permissions/android.hardware.context_hub.xml"
    "etc/permissions/android.hardware.device_unique_attestation.xml"
    "etc/permissions/android.hardware.fingerprint.xml"
    "etc/permissions/android.hardware.hardware_keystore.xml"
    "etc/permissions/android.hardware.keystore.app_attest_key.xml"
    "etc/permissions/android.hardware.location.gps.prebuilt.xml"
    "etc/permissions/android.hardware.nfc.ese.xml"
    "etc/permissions/android.hardware.nfc.hce.xml"
    "etc/permissions/android.hardware.nfc.hcef.xml"
    "etc/permissions/android.hardware.nfc.xml"
    "etc/permissions/android.hardware.opengles.aep.xml"
    "etc/permissions/android.hardware.se.omapi.ese.xml"
    "etc/permissions/android.hardware.se.omapi.uicc.xml"
    "etc/permissions/android.hardware.sensor.accelerometer.xml"
    "etc/permissions/android.hardware.sensor.barometer.xml"
    "etc/permissions/android.hardware.sensor.compass.xml"
    "etc/permissions/android.hardware.sensor.dynamic.head_tracker.xml"
    "etc/permissions/android.hardware.sensor.gyroscope.xml"
    "etc/permissions/android.hardware.sensor.hifi_sensors.xml"
    "etc/permissions/android.hardware.sensor.light.xml"
    "etc/permissions/android.hardware.sensor.proximity.xml"
    "etc/permissions/android.hardware.sensor.stepcounter.xml"
    "etc/permissions/android.hardware.sensor.stepdetector.xml"
    "etc/permissions/android.hardware.telephony.carrierlock.xml"
    "etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml"
    "etc/permissions/android.hardware.usb.accessory.xml"
    "etc/permissions/android.hardware.usb.host.xml"
    "etc/permissions/android.hardware.vulkan.compute.xml"
    "etc/permissions/android.hardware.vulkan.level.xml"
    "etc/permissions/android.hardware.vulkan.version.xml"
    "etc/permissions/android.hardware.wifi.aware.xml"
    "etc/permissions/android.hardware.wifi.direct.xml"
    "etc/permissions/android.hardware.wifi.passpoint.xml"
    "etc/permissions/android.hardware.wifi.rtt.xml"
    "etc/permissions/android.hardware.wifi.xml"
    "etc/permissions/android.software.device_id_attestation.xml"
    "etc/permissions/android.software.ipsec_tunnel_migration.xml"
    "etc/permissions/android.software.ipsec_tunnels.xml"
    "etc/permissions/android.software.midi.xml"
    "etc/permissions/android.software.opengles.deqp.level.xml"
    "etc/permissions/android.software.verified_boot.xml"
    "etc/permissions/android.software.vulkan.deqp.level.xml"
    "etc/permissions/aosp_excluded_hardware.xml"
    "etc/permissions/com.nxp.mifare.xml"
    "etc/permissions/handheld_core_hardware.xml"
    "etc/permissions/vendor.android.hardware.camera.preview-dis.xml"
    "etc/powerhint.json"
    "etc/r_submix_audio_policy_configuration.xml"
    "etc/selinux/plat_pub_versioned.cil"
    "etc/selinux/plat_sepolicy_vers.txt"
    "etc/selinux/precompiled_sepolicy"
    "etc/selinux/precompiled_sepolicy.plat_sepolicy_and_mapping.sha256"
    "etc/selinux/precompiled_sepolicy.product_sepolicy_and_mapping.sha256"
    "etc/selinux/precompiled_sepolicy.system_ext_sepolicy_and_mapping.sha256"
    "etc/selinux/selinux_denial_metadata"
    "etc/selinux/vendor_file_contexts"
    "etc/selinux/vendor_hwservice_contexts"
    "etc/selinux/vendor_mac_permissions.xml"
    "etc/selinux/vendor_property_contexts"
    "etc/selinux/vendor_seapp_contexts"
    "etc/selinux/vendor_sepolicy.cil"
    "etc/selinux/vendor_service_contexts"
    "etc/selinux/vndservice_contexts"
    "etc/sound_trigger_configuration.xml"
    "etc/sysconfig/component-overrides.xml"
    "etc/task_profiles.json"
    "etc/thermal_info_config.json"
    "etc/thermal_info_config_charge.json"
    "etc/thermal_info_config_charge_proto.json"
    "etc/thermal_info_config_proto.json"
    "etc/ueventd.rc"
    "etc/usb_audio_policy_configuration.xml"
    "etc/vintf/compatibility_matrix.xml"
    "etc/vintf/manifest.xml"
    "etc/vintf/manifest/android.hardware.cas-service.xml"
    "etc/vintf/manifest/android.hardware.contexthub-service.generic.xml"
    "etc/vintf/manifest/android.hardware.drm-service.clearkey.xml"
    "etc/vintf/manifest/android.hardware.dumpstate-service.xml"
    "etc/vintf/manifest/android.hardware.gatekeeper-service.trusty.xml"
    "etc/vintf/manifest/android.hardware.gnss@vendor.xml"
    "etc/vintf/manifest/android.hardware.health-service.zuma.xml"
    "etc/vintf/manifest/android.hardware.power-service.pixel.xml"
    "etc/vintf/manifest/android.hardware.power.stats-service.pixel.xml"
    "etc/vintf/manifest/android.hardware.secure_element_gto.xml"
    "etc/vintf/manifest/android.hardware.security.keymint-service.rust.trusty.xml"
    "etc/vintf/manifest/android.hardware.sensors-multihal.xml"
    "etc/vintf/manifest/android.hardware.thermal-service.pixel.xml"
    "etc/vintf/manifest/android.hardware.usb-service.xml"
    "etc/vintf/manifest/android.hardware.usb.gadget-service.xml"
    "etc/vintf/manifest/android.hardware.vibrator-service.cs40l26.xml"
    "etc/vintf/manifest/android.hardware.wifi-service.xml"
    "etc/vintf/manifest/android.hardware.wifi.hostapd.xml"
    "etc/vintf/manifest/android.hardware.wifi.supplicant.xml"
    "etc/vintf/manifest/bluetooth_audio.xml"
    "etc/vintf/manifest/health-storage-default.xml"
    "etc/vintf/manifest/hwc3-default.xml"
    "etc/vintf/manifest/manifest_gralloc_aidl.xml"
    "etc/vintf/manifest/memtrack.xml"
    "etc/vintf/manifest/nfc-service-default.xml"
    "etc/vintf/manifest/pixel-display-default.xml"
    "etc/waves_config.ini"
    "etc/waves_preset.mps"
    "etc/wifi/coex_table.xml"
    "etc/wifi/p2p_supplicant_overlay.conf"
    "etc/wifi/wpa_supplicant.conf"
    "etc/wifi/wpa_supplicant_overlay.conf"
    "firmware/R-cs35l41-dsp1-spk-cali.bin"
    "firmware/R-cs35l41-dsp1-spk-diag.bin"
    "firmware/R-cs35l41-dsp1-spk-prot.bin"
    "firmware/cs35l41-dsp1-spk-cali.bin"
    "firmware/cs35l41-dsp1-spk-cali.wmfw"
    "firmware/cs35l41-dsp1-spk-diag.bin"
    "firmware/cs35l41-dsp1-spk-diag.wmfw"
    "firmware/cs35l41-dsp1-spk-prot.bin"
    "firmware/cs35l41-dsp1-spk-prot.wmfw"
    "firmware/fast_switch1.txt"
    "firmware/fast_switch1.txt.txt"
    "firmware/fast_switch2.txt"
    "firmware/fast_switch2.txt.txt"
    "firmware/fast_switch3.txt"
    "firmware/fast_switch3.txt.txt"
    "firmware/fast_switch4.txt"
    "firmware/fast_switch4.txt.txt"
    "firmware/kepler.bin"
    "lib/modules/acpm_mbox_test.ko"
    "lib/modules/aoc_alsa_dev.ko"
    "lib/modules/aoc_channel_dev.ko"
    "lib/modules/aoc_char_dev.ko"
    "lib/modules/aoc_control_dev.ko"
    "lib/modules/aoc_uwb_platform_drv.ko"
    "lib/modules/aoc_uwb_service_dev.ko"
    "lib/modules/arm_dsu_pmu.ko"
    "lib/modules/bcm_dbg.ko"
    "lib/modules/bcmdhd4383.ko"
    "lib/modules/cfg80211.ko"
    "lib/modules/cl_dsp-core.ko"
    "lib/modules/cp_thermal_zone.ko"
    "lib/modules/cs40l26-core.ko"
    "lib/modules/cs40l26-i2c.ko"
    "lib/modules/dbgcore-dump.ko"
    "lib/modules/exynos-seclog.ko"
    "lib/modules/ftm5.ko"
    "lib/modules/goodix_brl_touch.ko"
    "lib/modules/goodixfp.ko"
    "lib/modules/goog_touch_interface.ko"
    "lib/modules/google_dock.ko"
    "lib/modules/google_dual_batt_gauge.ko"
    "lib/modules/gxp.ko"
    "lib/modules/heatmap.ko"
    "lib/modules/lwis.ko"
    "lib/modules/mac80211.ko"
    "lib/modules/mailbox-wc.ko"
    "lib/modules/mali_kutf.ko"
    "lib/modules/mali_kutf_clk_rate_trace_test_portal.ko"
    "lib/modules/max77729_charger.ko"
    "lib/modules/max77729_uic.ko"
    "lib/modules/modules.alias"
    "lib/modules/modules.blocklist"
    "lib/modules/modules.dep"
    "lib/modules/modules.load"
    "lib/modules/modules.softdep"
    "lib/modules/nitrous.ko"
    "lib/modules/panel-boe-nt37290.ko"
    "lib/modules/pinctrl-slg51002.ko"
    "lib/modules/qm35.ko"
    "lib/modules/rio.ko"
    "lib/modules/rt6160-regulator.ko"
    "lib/modules/sec_touch.ko"
    "lib/modules/snd-soc-cs35l41-i2c.ko"
    "lib/modules/snd-soc-cs35l41-spi.ko"
    "lib/modules/snd-soc-cs35l41.ko"
    "lib/modules/snd-soc-cs40l26.ko"
    "lib/modules/snd-soc-tas256x.ko"
    "lib/modules/snd-soc-wm-adsp.ko"
    "lib/modules/softdog.ko"
    "lib/modules/st33spi.ko"
    "lib/modules/stmvl53l1.ko"
    "lib/modules/vh_preemptirq_long.ko"
    "lib64/PixelVibratorStats.so"
    "lib64/android.frameworks.sensorservice-V1-ndk.so"
    "lib64/android.frameworks.sensorservice@1.0.so"
    "lib64/android.frameworks.stats-V1-ndk.so"
    "lib64/android.frameworks.stats-V2-ndk.so"
    "lib64/android.hardware.audio.common-V2-ndk.so"
    "lib64/android.hardware.audio.common-util.so"
    "lib64/android.hardware.audio.common@5.0.so"
    "lib64/android.hardware.audio.common@7.0-enums.so"
    "lib64/android.hardware.audio.common@7.0-util.so"
    "lib64/android.hardware.audio.common@7.0.so"
    "lib64/android.hardware.audio.common@7.1-enums.so"
    "lib64/android.hardware.audio.common@7.1-util.so"
    "lib64/android.hardware.audio.effect@7.0-util.so"
    "lib64/android.hardware.audio.effect@7.0.so"
    "lib64/android.hardware.audio@7.0.so"
    "lib64/android.hardware.audio@7.1-util.so"
    "lib64/android.hardware.audio@7.1.so"
    "lib64/android.hardware.bluetooth.audio-V3-ndk.so"
    "lib64/android.hardware.bluetooth.audio-impl.so"
    "lib64/android.hardware.bluetooth.audio@2.0.so"
    "lib64/android.hardware.bluetooth.audio@2.1.so"
    "lib64/android.hardware.boot-V1-ndk.so"
    "lib64/android.hardware.boot@1.0.so"
    "lib64/android.hardware.boot@1.1.so"
    "lib64/android.hardware.cas-V1-ndk.so"
    "lib64/android.hardware.contexthub-V2-ndk.so"
    "lib64/android.hardware.drm-V1-ndk.so"
    "lib64/android.hardware.dumpstate-V1-ndk.so"
    "lib64/android.hardware.gatekeeper-V1-ndk.so"
    "lib64/android.hardware.gnss-V3-ndk.so"
    "lib64/android.hardware.graphics.allocator-V1-ndk.so"
    "lib64/android.hardware.graphics.common-V3-ndk.so"
    "lib64/android.hardware.graphics.composer3-V2-ndk.so"
    "lib64/android.hardware.health-V2-ndk.so"
    "lib64/android.hardware.health.storage-V1-ndk.so"
    "lib64/android.hardware.nfc-V1-ndk.so"
    "lib64/android.hardware.power-V1-ndk.so"
    "lib64/android.hardware.power-V2-ndk.so"
    "lib64/android.hardware.power-V3-ndk.so"
    "lib64/android.hardware.power-V4-ndk.so"
    "lib64/android.hardware.power.stats-V2-ndk.so"
    "lib64/android.hardware.power.stats-impl.gs-common.so"
    "lib64/android.hardware.power.stats-impl.pixel.so"
    "lib64/android.hardware.power.stats-impl.zuma.so"
    "lib64/android.hardware.radio@1.0.so"
    "lib64/android.hardware.radio@1.1.so"
    "lib64/android.hardware.secure_element-V1-ndk.so"
    "lib64/android.hardware.secure_element.thales.libse.so"
    "lib64/android.hardware.security.keymint-V1-ndk.so"
    "lib64/android.hardware.security.keymint-V3-ndk.so"
    "lib64/android.hardware.security.secureclock-V1-ndk.so"
    "lib64/android.hardware.sensors-V2-ndk.so"
    "lib64/android.hardware.sensors@1.0.so"
    "lib64/android.hardware.sensors@2.0-ScopedWakelock.so"
    "lib64/android.hardware.sensors@2.0.so"
    "lib64/android.hardware.sensors@2.1.so"
    "lib64/android.hardware.soundtrigger@2.1.so"
    "lib64/android.hardware.soundtrigger@2.2.so"
    "lib64/android.hardware.soundtrigger@2.3.so"
    "lib64/android.hardware.thermal-V1-ndk.so"
    "lib64/android.hardware.thermal@1.0.so"
    "lib64/android.hardware.thermal@2.0.so"
    "lib64/android.hardware.usb-V2-ndk.so"
    "lib64/android.hardware.usb.gadget-V1-ndk.so"
    "lib64/android.hardware.usb.gadget@1.0.so"
    "lib64/android.hardware.vibrator-V2-ndk.so"
    "lib64/android.hardware.wifi-V1-ndk.so"
    "lib64/android.hardware.wifi.hostapd-V1-ndk.so"
    "lib64/android.hardware.wifi.supplicant-V2-ndk.so"
    "lib64/android.hidl.allocator@1.0.so"
    "lib64/android.media.audio.common.types-V2-ndk.so"
    "lib64/android.system.keystore2-V1-ndk.so"
    "lib64/arm.graphics-V1-ndk.so"
    "lib64/chre_atoms_log.so"
    "lib64/chremetrics-cpp.so"
    "lib64/com.google.hardware.pixel.display-V9-ndk.so"
    "lib64/hw/android.hardware.audio.effect@7.0-impl.so"
    "lib64/hw/android.hardware.audio@7.1-impl.so"
    "lib64/hw/android.hardware.soundtrigger@2.3-impl.so"
    "lib64/hw/android.hardware.vibrator-impl.cs40l26.so"
    "lib64/hw/audio.bluetooth.default.so"
    "lib64/hw/audio.primary.default.so"
    "lib64/hw/audio.r_submix.default.so"
    "lib64/hw/audio.usb.default.so"
    "lib64/hw/audio.usbv2.default.so"
    "lib64/hw/gralloc.default.so"
    "lib64/hw/local_time.default.so"
    "lib64/hw/power.default.so"
    "lib64/hw/vibrator.default.so"
    "lib64/libalsautils.so"
    "lib64/libalsautilsv2.so"
    "lib64/libbinderdebug.so"
    "lib64/libbluetooth_audio_session.so"
    "lib64/libbluetooth_audio_session_aidl.so"
    "lib64/libdisppower-pixel.so"
    "lib64/libdump.so"
    "lib64/libeffects.so"
    "lib64/libeffectsconfig.so"
    "lib64/libexynosdisplay.so"
    "lib64/libhwjpeg.so"
    "lib64/libion_google.so"
    "lib64/libkeystore-engine-wifi-hidl.so"
    "lib64/libmediautils_vendor.so"
    "lib64/libmemtrack-pixel.so"
    "lib64/libmemunreachable.so"
    "lib64/libnbaio_mono.so"
    "lib64/libperfmgr.so"
    "lib64/libpixelatoms_defs.so"
    "lib64/libpixelhealth.so"
    "lib64/libpixelmitigation.so"
    "lib64/libpixelstats.so"
    "lib64/libreference-ril.so"
    "lib64/libril.so"
    "lib64/librilutils.so"
    "lib64/libsensorndkbridge.so"
    "lib64/libtinyalsav2.so"
    "lib64/libtrusty.so"
    "lib64/libvibratorutils.so"
    "lib64/libwifi-hal.so"
    "lib64/libwpa_client.so"
    "lib64/mediacas/libclearkeycasplugin.so"
    "lib64/mediadrm/libdrmclearkeyplugin.so"
    "lib64/nfc_nci.st21nfc.default.so"
    "lib64/pixel-power-ext-V1-ndk.so"
    "lib64/pixel_stateresidency_provider_aidl_interface-ndk.so"
    "lib64/pixelatoms-cpp.so"
    "lib64/soundfx/libaudiopreprocessing.so"
    "lib64/soundfx/libbundlewrapper.so"
    "lib64/soundfx/libdownmix.so"
    "lib64/soundfx/libdynproc.so"
    "lib64/soundfx/libeffectproxy.so"
    "lib64/soundfx/libhapticgenerator.so"
    "lib64/soundfx/libldnhncr.so"
    "lib64/soundfx/libreverbwrapper.so"
    "lib64/soundfx/libvisualizer.so"
    "odm/etc/build.prop"
    "odm/etc/group"
    "odm/etc/passwd"
    "odm_dlkm/etc/build.prop"
    "overlay/EmergencyInfo__auto_generated_rro_vendor.apk"
    "overlay/NfcNci__auto_generated_rro_vendor.apk"
    "overlay/Settings__auto_generated_rro_vendor.apk"
    "overlay/StorageManager__auto_generated_rro_vendor.apk"
    "overlay/SystemUI__auto_generated_rro_vendor.apk"
    "overlay/TeleService__auto_generated_rro_vendor.apk"
    "overlay/Traceur__auto_generated_rro_vendor.apk"
    "overlay/framework-res__auto_generated_rro_vendor.apk"
    "vendor_dlkm/etc/build.prop"
    "vendor_dlkm/etc/init.insmod.akita.cfg"

    # Exclude overlays, symlinks and extra files that we override

    # Overlays
    "overlay/DMService__auto_generated_rro_vendor.apk"
    "overlay/Flipendo__auto_generated_rro_vendor.apk"
    "overlay/SettingsGoogle__auto_generated_rro_vendor.apk"
    "overlay/StorageManagerGoogle__auto_generated_rro_vendor.apk"
    "overlay/SystemUIGoogle__auto_generated_rro_vendor.apk"

    # Symlinks
    "lib/modules"

    # Exclude files that compile with BUILD_WITHOUT_VENDOR := false
    # or manually added as build targets in device-lineage.mk

    # Audio
    "lib64/libaudioroutev2.so"
    "lib64/libtinycompress.so"

    # Bluetooth
    "lib64/android.hardware.bluetooth-V1-ndk.so"
    "lib64/hardware.google.bluetooth.bt_channel_avoidance@1.0.so"

    # Charger
    "etc/res/images/charger/battery_fail.png"
    "etc/res/images/charger/battery_scale.png"
    "etc/res/images/charger/main_font.png"
    "etc/res/values/charger/animation.txt"

    # Codec2
    "lib64/android.hardware.media.bufferpool2-V1-ndk.so"
    "lib64/android.hardware.media.c2@1.0.so"
    "lib64/android.hardware.media.c2@1.1.so"
    "lib64/android.hardware.media.c2@1.2.so"
    "lib64/libavservices_minijail.so"
    "lib64/libcodec2_hidl@1.0.so"
    "lib64/libcodec2_hidl@1.1.so"
    "lib64/libcodec2_hidl@1.2.so"
    "lib64/libcodec2_hidl_plugin.so"
    "lib64/libcodec2_soft_common.so"
    "lib64/libcodec2_vndk.so"
    "lib64/libexynosutils.so"
    "lib64/libexynosv4l2.so"
    "lib64/libmedia_ecoservice.so"
    "lib64/libsfplugin_ccodec_utils.so"
    "lib64/libstagefright_aidl_bufferpool2.so"
    "lib64/libstagefright_bufferpool@2.0.1.so"

    # Confirmation UI
    "lib64/android.hardware.confirmationui-V1-ndk.so"
    "lib64/android.hardware.confirmationui-lib.trusty.so"
    "lib64/android.hardware.confirmationui@1.0.so"
    "lib64/libteeui_hal_support.so"

    # Graphics
    "lib64/egl/libEGL_angle.so"
    "lib64/egl/libGLESv1_CM_angle.so"
    "lib64/egl/libGLESv2_angle.so"

    # HIDL
    "lib64/libhidltransport.so"
    "lib64/libhwbinder.so"

    # Identity credential
    "etc/permissions/android.hardware.identity_credential.xml"
    "lib64/android.hardware.identity-V5-ndk.so"
    "lib64/android.hardware.identity-support-lib.so"
    "lib64/libpuresoftkeymasterdevice.so"
    "lib64/libsoft_attestation_cert.so"

    # Sensors
    "lib64/android.frameworks.sensorservice@1.0.so"
    "lib64/hw/sensors.dynamic_sensor_hal.so"
    "lib64/libhidparser.so"

    # Trusty
    "lib64/android.trusty.stats.nw.setter-cpp.so"
    "lib64/libbinder_trusty.so"
    "lib64/lib_sensor_listener.so"
    "lib64/libtrusty_metrics.so"

    # Misc interfaces
    "lib64/android.frameworks.stats-V1-cpp.so"
    "lib64/android.hardware.authsecret-V1-ndk.so"
    "lib64/android.hardware.biometrics.common-V3-ndk.so"
    "lib64/android.hardware.biometrics.face-V3-ndk.so"
    "lib64/android.hardware.biometrics.face@1.0.so"
    "lib64/android.hardware.biometrics.fingerprint-V3-ndk.so"
    "lib64/android.hardware.gnss-V3-ndk.so"
    "lib64/android.hardware.health-V1-ndk.so"
    "lib64/android.hardware.input.common-V1-ndk.so"
    "lib64/android.hardware.input.processor-V1-ndk.so"
    "lib64/android.hardware.keymaster-V3-ndk.so"
    "lib64/android.hardware.keymaster-V4-ndk.so"
    "lib64/android.hardware.keymaster@3.0.so"
    "lib64/android.hardware.keymaster@4.0.so"
    "lib64/android.hardware.keymaster@4.1.so"
    "lib64/android.hardware.neuralnetworks-V4-ndk.so"
    "lib64/android.hardware.neuralnetworks@1.0.so"
    "lib64/android.hardware.neuralnetworks@1.1.so"
    "lib64/android.hardware.neuralnetworks@1.2.so"
    "lib64/android.hardware.neuralnetworks@1.3.so"
    "lib64/android.hardware.oemlock-V1-ndk.so"
    "lib64/android.hardware.power@1.0.so"
    "lib64/android.hardware.power@1.1.so"
    "lib64/android.hardware.power@1.2.so"
    "lib64/android.hardware.radio-V2-ndk.so"
    "lib64/android.hardware.radio.config-V2-ndk.so"
    "lib64/android.hardware.radio.config@1.0.so"
    "lib64/android.hardware.radio.config@1.1.so"
    "lib64/android.hardware.radio.config@1.2.so"
    "lib64/android.hardware.radio.data-V2-ndk.so"
    "lib64/android.hardware.radio.deprecated@1.0.so"
    "lib64/android.hardware.radio.ims-V1-ndk.so"
    "lib64/android.hardware.radio.messaging-V2-ndk.so"
    "lib64/android.hardware.radio.modem-V2-ndk.so"
    "lib64/android.hardware.radio.network-V2-ndk.so"
    "lib64/android.hardware.radio.sap-V1-ndk.so"
    "lib64/android.hardware.radio.sim-V2-ndk.so"
    "lib64/android.hardware.radio.voice-V2-ndk.so"
    "lib64/android.hardware.radio@1.2.so"
    "lib64/android.hardware.radio@1.3.so"
    "lib64/android.hardware.radio@1.4.so"
    "lib64/android.hardware.radio@1.5.so"
    "lib64/android.hardware.radio@1.6.so"
    "lib64/android.hardware.security.rkp-V3-ndk.so"
    "lib64/android.hardware.security.sharedsecret-V1-ndk.so"
    "lib64/android.hardware.weaver-V2-ndk.so"
    "lib64/com.google.hardware.pixel.display-V4-ndk.so"
    "lib64/com.google.hardware.pixel.display-V6-ndk.so"
    "lib64/hardware.google.ril_ext-V1-ndk.so"

    # Misc
    "bin/dump/dump_gsc.sh"
    "lib64/libjson.so"

    # Completely skip files that are not required

    # Google
    "etc/default-permissions/default-permissions_talkback.xml"

    # Shiba
    "apex/com.google.pixel.wifi.ext.apex"
    "lib64/vendor.google.wifi_ext-V1-ndk.so"
    "lib64/egl/libGLES_mali.so"
    "lib64/hw/vulkan.mali.so"
    "lib64/hw/vendor.google.whitechapel.audio.audioext@4.0-impl.so"
    "lib64/vendor.google.whitechapel.audio.audioext@4.0.so"
    "lib64/libdisplaycolor.so"
    "lib64/android.hardware.gnss.measurement_corrections@1.0.so"
    "lib64/android.hardware.gnss.measurement_corrections@1.1.so"
    "lib64/android.hardware.gnss.visibility_control@1.0.so"
    "lib64/android.hardware.gnss@1.0.so"
    "lib64/android.hardware.gnss@1.1.so"
    "lib64/android.hardware.gnss@2.0.so"
    "lib64/android.hardware.gnss@2.1.so"
)

# Initialize the helper
setup_vendor_deps "${ANDROID_ROOT}"

generate_prop_list_from_image "${_input_image}" "${_output_file}" VENDOR_SKIP_FILES

# Fixups
function presign() {
    sed -i "s|vendor/${1}$|vendor/${1};PRESIGNED|g" "${_output_file}"
}

function as_module() {
    sed -i "s|vendor/${1}$|-vendor/${1}|g" "${_output_file}"
}

function header() {
    sed -i "1s/^/${1}\n/" "${_output_file}"
}

as_module "lib64/libOpenCL.so"

header "# All blobs are extracted from Google factory images for each new ASB"
