#!/bin/bash

function check_python_packages() {
  env_var_exists VERSION_python_packages
  env_var_exists DEPS_PYTHON_SITE_PACKAGES_DIR
  env_var_exists BUNDLE_PYTHON_SITE_PACKAGES_DIR
}

function bundle_python_packages() {
  try rsync -av \
     $DEPS_PYTHON_PACKAGES_DIR/ \
     $BUNDLE_PYTHON_PACKAGES_DIR/ \
     --exclude __pycache__

  mk_sym_link $BUNDLE_CONTENTS_DIR/MacOS/lib ../../Resources/python python$VERSION_major_python
}

function fix_binaries_python_packages() {
  install_name_change $DEPS_LIB_DIR/$LINK_unixodbc @rpath/$LINK_unixodbc $BUNDLE_PYTHON_SITE_PACKAGES_DIR/pyodbc.cpython-${VERSION_major_python//./}m-darwin.so
  install_name_change $DEPS_LIB_DIR/$LINK_libssl @rpath/$LINK_libssl $BUNDLE_PYTHON_SITE_PACKAGES_DIR/cryptography/hazmat/bindings/_openssl.abi3.so
  install_name_change $DEPS_LIB_DIR/$LINK_libcrypto @rpath/$LINK_libcrypto $BUNDLE_PYTHON_SITE_PACKAGES_DIR/cryptography/hazmat/bindings/_openssl.abi3.so
  install_name_change $DEPS_LIB_DIR/$LINK_libffi @rpath/$LINK_libffi $BUNDLE_PYTHON_SITE_PACKAGES_DIR/_cffi_backend.cpython-${VERSION_major_python//./}m-darwin.so

  install_name_change $DEPS_LIB_DIR/$LINK_libffi @rpath/$LINK_libffi $BUNDLE_PYTHON_SITE_PACKAGES_DIR/lxml/etree.cpython-${VERSION_major_python//./}m-darwin.so

  for i in \
    $LINK_libxml2 \
    $LINK_zlib \
    $LINK_libxslt \
    $LINK_libexslt
  do
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_PYTHON_SITE_PACKAGES_DIR/lxml/etree.cpython-${VERSION_major_python//./}m-darwin.so
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_PYTHON_SITE_PACKAGES_DIR/lxml/objectify.cpython-${VERSION_major_python//./}m-darwin.so
  done
}

function fix_binaries_python_packages_check() {
  verify_binary $BUNDLE_PYTHON_SITE_PACKAGES_DIR/pyodbc.cpython-${VERSION_major_python//./}m-darwin.so
  verify_binary $BUNDLE_PYTHON_SITE_PACKAGES_DIR/cryptography/hazmat/bindings/_openssl.abi3.so
  verify_binary $BUNDLE_PYTHON_SITE_PACKAGES_DIR/cryptography/hazmat/bindings/_openssl.abi3.so
  verify_binary $BUNDLE_PYTHON_SITE_PACKAGES_DIR/_cffi_backend.cpython-${VERSION_major_python//./}m-darwin.so
  verify_binary $BUNDLE_PYTHON_SITE_PACKAGES_DIR/lxml/etree.cpython-${VERSION_major_python//./}m-darwin.so
  verify_binary $BUNDLE_PYTHON_SITE_PACKAGES_DIR/lxml/objectify.cpython-${VERSION_major_python//./}m-darwin.so
}

function fix_paths_python_packages() {
  # patch shell scripts
  for i in \
      2to3 \
      2to3-${VERSION_major_python} \
      idle3 \
      idle${VERSION_major_python} \
      pyvenv \
      pyvenv-${VERSION_major_python} \
      pydoc3 \
      pydoc${VERSION_major_python} \
      pyrcc5 \
      pyuic5 \
      pylupdate5 \
      pipenv-resolver
  do
    fix_exec_link $QGIS_DEPS_STAGE_PATH/bin/python3 python3 $BUNDLE_BIN_DIR/$i
  done
}

function fix_paths_python_packages_check() {
  verify_file_paths $BUNDLE_BIN_DIR/pyrcc5
}