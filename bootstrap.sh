#!/bin/bash
source variables.env

install_deps() {
  sudo apt update
  sudo apt install -y subversion build-essential libncurses5-dev libncursesw5-dev zlib1g-dev gawk git gettext libssl-dev xsltproc wget file unzip python python2 qemu-system-arm  fdisk ccache gcc binutils bzip2 flex python3 perl make  grep diffutils libz-dev libc-dev rsync
}
from_source() {
  git clone ${REPO_URL} -b ${REPO_BRANCH} src
  cd src
  ./scripts/feeds update -a
  ./scripts/feeds install -a
}

from_imagebuilder() {
  mkdir builder
  cd builder 
  wget "$BUILDER_FOLDER/$BUILDER_NAME"
  tar --strip-components=1 -xf "$BUILDER_NAME"
  rm -f "$BUILDER_NAME"
  echo 'src-git packages https://git.openwrt.org/feed/packages.git' > feeds.conf
  ./scripts/feeds update
  make image PROFILE=rpi-4 PACKAGES="$INCLUDE_PACKAGES $EXCLUDE_PACKAGES"
  cp "$BUILD_PATH" "$OUTPUT_DIR/$OUTPUT_NAME"
}

from_source
