#!/bin/sh

## fail codes
FAIL_DOWNLAOD=3
FAIL_MOVING=2


## crackle tool
${ROOT}/crackle/crackle update
${ROOT}/crackle/crackle click maliit-inputcontext-gtk3


## export
export ARCH=${ARCH_TRIPLET%%-*}


# logging
LOG_FILE=${BUILD_DIR}`/bin/date +"%Y-%m-%d_%H-%M-%S"`_build.log
echo "--->logging at " + `/bin/date +"%Y-%m-%d_%H-%M-%S"` >> $LOG_FILE


## file managment
echo "--->managing files" >> $LOG_FILE
/bin/cp $ROOT/* $BUILD_DIR 2>/dev/null >> $LOG_FILE

/bin/sed -i "s/@CLICK_ARCH@/${ARCH_TRIPLET}/" ${BUILD_DIR}/freetube-ut.sh >> $LOG_FILE # change arch for launch script

/bin/cp -rn $BUILD_DIR/usr/lib/* $INSTALL_DIR/lib 2>/dev/null >> $LOG_FILE # copy maliit libs to install dir

/bin/chmod -R +x $INSTALL_DIR/lib/$ARCH_TRIPLET/* # make sure there is no permission problem for libs
/bin/chmod -R +x $INSTALL_DIR/lib/* 

/bin/mkdir -p ${CLICK_LD_LIBRARY_PATH}/gtk-3.0/3.0.0/immodules/ >> $LOG_FILE # make sure it exists before running
/bin/cp $ROOT/scripts/immodules.cache ${CLICK_LD_LIBRARY_PATH}/gtk-3.0/3.0.0/immodules/immodules.cache >> $LOG_FILE # copy gtk cache

/bin/sed -i "s/@CLICK_ARCH@/${ARCH_TRIPLET}/" ${CLICK_LD_LIBRARY_PATH}/gtk-3.0/3.0.0/immodules/immodules.cache >> $LOG_FILE # change arch for maliit in gtk cache

/bin/cp $BUILD_DIR/* $INSTALL_DIR 2>/dev/null >> $LOG_FILE # copying leftovers


## scripts
echo "--->copying scripts" >> $LOG_FILE
/bin/cp -r ${ROOT}/scripts $BUILD_DIR

if [ ! -d "$BUILD_DIR/scripts" ]; then # sanity check cp worked
  echo "directory ($BUILD_DIR/script) does not exist!, failed to copy build scripts" >> $LOG_FILE
  exit 1
fi

# freetube binariy downloader
echo "--->running freetube download script" >> $LOG_FILE
if ! $BUILD_DIR/scripts/freetube-d.sh >> $LOG_FILE; then # move app files to build
  echo "Error: freetube download script failed with exit code $?" >> $LOG_FILE
  exit $FAIL_DOWNLAOD
else
  echo "Successfully downloaded freetube binaries!" >> $LOG_FILE
fi

# patching freetube to use android libraries
/usr/bin/patchelf --replace-needed libEGL.so libEGL_adreno.so $INSTALL_DIR/app/freetube >> $LOG_FILE
/usr/bin/patchelf --replace-needed libGLESv2.so libGLESv2_adreno.so  $INSTALL_DIR/app/freetube >> $LOG_FILE
#/usr/bin/patchelf --replace-needed msm_drm_dri.so msm_dri.so $INSTALL_DIR/app/freetube >> $LOG_FILE
#MESA_LOADER is hardcoded patchelf won't work, we somehow need to get MESA_LOADER to load /usr/lib/aarch64-linux-gnu/dri/msm_dri.so
#until so no wayland.

# removing unnecessary files
/bin/rm -rf $INSTALL_DIR/app/libEGL.so >> $LOG_FILE # libs to remove
/bin/rm -rf $INSTALL_DIR/app/libGLESv2.so >> $LOG_FILE
/bin/rm -rf $INSTALL_DIR/app/AppRun >> $LOG_FILE # no need for launch script when we have our own

exit 0