#!/bin/bash

DESC_wxmac="Cross-platform C++ GUI toolkit (wxWidgets for macOS)"

# version of your package
VERSION_wxmac_major=3.0
VERSION_wxmac=${VERSION_wxmac_major}.4
LINK_wxmac_version=3.0.0.4.0

# dependencies of this recipe
DEPS_wxmac=( jpeg png libtiff )

# url of the package
URL_wxmac=https://github.com/wxWidgets/wxWidgets/releases/download/v${VERSION_wxmac}/wxWidgets-${VERSION_wxmac}.tar.bz2

# md5 of the package
MD5_wxmac=b0035731777acc5597cea8982da10317

# default build path
BUILD_wxmac=$BUILD_PATH/wxmac/$(get_directory $URL_wxmac)

# default recipe path
RECIPE_wxmac=$RECIPES_PATH/wxmac

patch_wxmac_linker_links () {
  install_name_tool -id "@rpath/libwx_baseu_net-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_baseu_net.dylib
  install_name_tool -id "@rpath/libwx_osx_cocoau_gl-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_osx_cocoau_gl.dylib
  install_name_tool -id "@rpath/libwx_osx_cocoau_aui-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_osx_cocoau_aui.dylib
  install_name_tool -id "@rpath/libwx_baseu-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_baseu.dylib
  install_name_tool -id "@rpath/libwx_osx_cocoau_qa-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_osx_cocoau_qa.dylib
  install_name_tool -id "@rpath/libwx_osx_cocoau_xrc-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_osx_cocoau_xrc.dylib
  install_name_tool -id "@rpath/libwx_osx_cocoau_stc-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_osx_cocoau_stc.dylib
  install_name_tool -id "@rpath/libwx_osx_cocoau_ribbon-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_osx_cocoau_ribbon.dylib
  install_name_tool -id "@rpath/libwx_osx_cocoau_core-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_osx_cocoau_core.dylib
  install_name_tool -id "@rpath/libwx_osx_cocoau_adv-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_osx_cocoau_adv.dylib
  install_name_tool -id "@rpath/libwx_osx_cocoau_html-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_osx_cocoau_html.dylib
  install_name_tool -id "@rpath/libwx_osx_cocoau_propgrid-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_osx_cocoau_propgrid.dylib
  install_name_tool -id "@rpath/libwx_osx_cocoau_richtext-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_osx_cocoau_richtext.dylib
  install_name_tool -id "@rpath/libwx_baseu_xml-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_baseu_xml.dylib
  install_name_tool -id "@rpath/libwx_osx_cocoau_media-${LINK_wxmac_version}.dylib" ${STAGE_PATH}/lib/libwx_osx_cocoau_media.dylib
}

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_wxmac() {
  cd $BUILD_wxmac

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_wxmac() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libwx_baseu-${VERSION_wxmac_major}.dylib -nt $BUILD_wxmac/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_wxmac() {
  try rsync -a $BUILD_wxmac/ $BUILD_PATH/wxmac/build-$ARCH/
  try cd $BUILD_PATH/wxmac/build-$ARCH
  push_env

  try ${CONFIGURE} \
     --enable-clipboard \
     --enable-controls \
     --enable-dataviewctrl \
     --enable-display \
     --enable-dnd \
     --enable-graphics_ctx \
     --enable-std_string \
     --enable-svg \
     --enable-unicode \
     --enable-webkit \
     --with-expat \
     --with-libjpeg \
     --with-libpng \
     --with-libtiff \
     --with-opengl \
     --with-osx_cocoa \
     --with-zlib \
     --disable-precomp-headers \
     --disable-monolithic \
     --with-macosx-version-min=${MACOSX_DEPLOYMENT_TARGET}


  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  patch_wxmac_linker_links

  pop_env
}

# function called after all the compile have been done
function postbuild_wxmac() {
  verify_lib "libwx_baseu-${VERSION_wxmac_major}.dylib"
  verify_lib "libwx_baseu_net-${VERSION_wxmac_major}.dylib"
  verify_lib "libwx_baseu_xml-${VERSION_wxmac_major}.dylib"
  verify_lib "libwx_osx_cocoau_html-${VERSION_wxmac_major}.dylib"

  verify_bin wx-config
}

# function to append information to config file
function add_config_info_wxmac() {
  append_to_config_file "# wxmac-${VERSION_wxmac}: ${DESC_wxmac}"
  append_to_config_file "export VERSION_wxmac=${VERSION_wxmac}"
}