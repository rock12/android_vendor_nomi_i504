#!/bin/bash

SOURCE=$1
TARGET=.

#
# wifi and gsm firmware's
#
FIRMWARE="/etc/firmware/"

#
# wmt_loader init kernel device modules, and loades a driver for /dev/stpwmt, then
# 6620_launcher load a firmware to the CPU using /dev/stpwmt.
# mt6572_82_patch_e1_0_hdr.bin, mt6572_82_patch_e1_1_hdr.bin - wifi firmware.
#
WIFI="/etc/wifi/ /bin/6620_wmt_lpbk /bin/6620_launcher /bin/6620_wmt_concurrency /bin/wmt_loader /lib/libbluetooth_mtk.so"

# 
# gralloc && hwcomposer - hardware layer. rest is userspace lib.so layer.
#
GL="/lib/egl/libGLESv1_CM_mali.so /lib/egl/libGLESv2_mali.so /lib/egl/libEGL_mali.so \
/lib/libm4u.so /lib/hw/hwcomposer.mt6580.so /lib/hw/gralloc.mt6580.so \
/lib/libdpframework.so /lib/libion.so /lib/libMali.so /lib/libged.so /lib/libgpu_aux.so /lib/libmtk_mali_user.so \
/lib/libgralloc_extra.so /lib/libion_mtk.so /lib/libpq_prot.so /lib/libbwc.so /lib/libgui_ext.so /lib/libperfservicenative.so \
/lib/libui_ext.so /lib/libui.so /lib/libdrmmtkutil.so /lib/libdrmmtkwhitelist.so /lib/libdrmmtkutil.so /bin/guiext-server"

#
# ccci_mdinit starts, depends on additional services:
# - drvbd - unix socket connection
# - nvram - folders /data/nvram, modem settings like IMEI
# - gsm0710muxd - /dev/radio/ ports for accessing the modem 
# - mdlogger
# - ccci_fsd
#
# ccci_mdinit loads modem_1_wg_n.img firmware to the CPU, waits for NVRAM to init using ENV variable.
# then starts the modem CPU. on success starts rest services mdlogger, gsm0710muxd ...
#
RIL="/lib/mtk-ril.so /lib/librilmtk.so /lib/libaed.so /bin/mtkrild /bin/mtkrildmd2 /lib/librilmtkmd2.so \
/bin/nvram_daemon /bin/nvram_agent_binder /lib/libnvram.so /lib/libcustom_nvram.so /lib/libnvram_sec.so /lib/mtk-rilmd2.so \
/lib/libhwm.so /lib/libnvram_platform.so /lib/libfile_op.so /lib/libnvram_daemon_callback.so /lib/libmtk_drvb.so \
/bin/gsm0710muxd /bin/gsm0710muxdmd2 /bin/ccci_mdinit /bin/aee /bin/mdlogger /lib/libmdloggerrecycle.so /bin/ccci_fsd /lib/libnvramagentclient.so /bin/dm_agent_binder \
/bin/atcid /bin/atci_service /lib/libccci_util.so /bin/md_ctrl"

AUDIO="/bin/audiocmdservice_atci /lib/libblisrc.so /lib/libspeech_enh_lib.so /lib/libaudiocustparam.so /lib/libaudiosetting.so \
/lib/libcvsd_mtk.so /lib/libmsbc_mtk.so /lib/libaudiocomponentengine.so \
/lib/libblisrc32.so /lib/libbessound_hd_mtk.so /lib/libmtklimiter.so /lib/libmtkshifter.so /lib/libaudiodcrflt.so \
/lib/libbluetoothdrv.so /lib/hw/audio.usb.default.so /lib/libtinycompress.so /lib/libtinyxml.so /etc/mtk_omx_core.cfg /lib/libaudiomtkdcremoval.so /lib/hw/audio.primary.mt6580.so \
/lib/libmtkplayer.so /lib/libvcodecdrv.so /lib/libvcodec_utility.so /lib/libssladp.so /lib/libmhalImageCodec.so /lib/libvcodec_oal.so  /lib/libvcodec_oal.so \
/lib/libmmprofile_jni.so /lib/libmmprofile.so /lib/libJpgDecPipe.so /lib/libGdmaScalerPipe.so /lib/libSwJpgCodec.so \
/lib/libMtkOmxAdpcmDec.so /lib/libMtkOmxAlacDec.so /lib/libMtkOmxCore.so /lib/libMtkOmxG711Dec.so /lib/libMtkOmxMp3Dec.so /lib/libMtkOmxVdec.so /lib/libMtkOmxVorbisEnc.so \
/lib/libMtkOmxAdpcmEnc.so /lib/libMtkOmxApeDec.so /lib/libMtkOmxFlacDec.so /lib/libMtkOmxGsmDec.so /lib/libMtkOmxRawDec.so /lib/libMtkOmxVenc.so"

CAMERA="/lib/libcam_mmp.so /lib/libcam.utils.so /lib/libfeatureio.so /lib/libcam.metadataprovider.so /lib/libcam.utils.sensorlistener.so \
/lib/libcam3_app.so /lib/libcam.halsensor.so /lib/libcameracustom.so /lib/hw/camera.mt6580.so /lib/libcam_platform.so /lib/libcam.iopipe_FrmB.so \
/lib/libcam.camshot.so /lib/libcam.exif.so /lib/libcam.exif.v3.so /lib/libcam.paramsmgr.so /lib/libcam.device3.so /lib/libcam3_hwnode.so \
/lib/libcam.client.so /lib/libcam_utils.so /lib/libcam3_pipeline.so /lib/libcam3_utils.so /lib/libcam.camadapter.so /lib/libcam.iopipe.so \
/lib/libcam.device1.so /lib/libcam.metadata.so /lib/libcamdrv.so /lib/libcam.campipe.so /lib/libcam.hal3a.v3.so /lib/libmtkjpeg.so \
/lib/libcamdrv_FrmB.so /lib/libcamalgo.so /lib/libcam3_hwpipeline.so /lib/libcam_hwutils.so /lib/libcamera_client_mtk.so /lib/libmmsdkservice.so \
/lib/libmtk_mmutils.so /lib/libcam.sdkclient.so /lib/libmmsdkservice.feature.so /lib/libcam1_utils.so /lib/libJpgEncPipe.so /lib/libimageio.so \
/lib/libmpo.so /lib/libmpoencoder.so /lib/libmpodecoder.so /lib/libmpojni.so /lib/libmpo.so /lib/lib3a.so /lib/libfeatureiodrv.so /lib/libimageio_plat_drv.so \
/lib/libimageio_plat_drv_FrmB.so /lib/libimageio_FrmB.so"

VENDOR="/vendor/lib/"

XBIN="/xbin/BGW /xbin/mnld"

OTHER="/bin/akmd8963 /bin/akmd8975 /bin/akmd09911 /bin/ami304d /bin/bmm050d /bin/mc6420d /bin/s62xd \
/lib/hw/sensors.mt6580.so /lib/hw/lights.default.so /bin/mtk_agpsd /bin/muxreport /bin/pppd_dt /bin/pppd \
/bin/memsicd3416x /bin/memsicd /lib/hw/memtrack.mt6580.so /bin/batterywarning /bin/thermal_manager /bin/lsm303md /lib/libbluetoothem_mtk.so /lib/libbluetooth_relayer.so \
/lib/libmnl.so /lib/libstagefrighthw.so /lib/libmtcloader.so /bin/permission_check /bin/xlog"

SYSTEM="$FIRMWARE $WIFI $GL $RIL $AUDIO $OTHER $VENDOR $XBIN $CAMERA"

# get data from a device
if [ -z $SOURCE ]; then
  for FILE in $SYSTEM ; do
    T=$TARGET/$FILE
    adb pull /system/$FILE $T
  done
  exit 0
fi

# get data from folder
for FILE in $SYSTEM ; do
  S=$SOURCE/$FILE
  T=$TARGET/$FILE
  mkdir -p $(dirname $T) || exit 1
  rsync -av --delete $S $T || exit 1
done
exit 0

