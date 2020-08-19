#!/bin/bash

function check_libomp() {
  env_var_exists VERSION_libomp
}

function bundle_libomp() {
  try cp -av $DEPS_LIB_DIR/libomp.* $BUNDLE_LIB_DIR
}

function fix_binaries_libomp() {
  install_name_id @rpath/$LINK_libomp $BUNDLE_LIB_DIR/$LINK_libomp
}

function fix_binaries_libomp_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_libomp
}

function fix_paths_libomp() {
  :
}

function fix_paths_libomp_check() {
  :
}