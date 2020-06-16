#!/bin/sh

cd ${TMPDIR:-/tmp}

if [ $(uname) = 'Darwin' ]; then
  TEXDIR=${TINYTEX_DIR:-/opt/TinyTeX}
  alias download='curl -sL'
else
  TEXDIR=${TINYTEX_DIR:-/opt/TinyTeX}
  alias download='wget -qO-'
fi

download https://gitee.com/dennischan/CJupyterDocker/raw/master/cminimal-notebook/TinyTeX/install-base.sh | sh -s - "$@"

rm -rf $TEXDIR
mkdir -p $TEXDIR
mv texlive/* $TEXDIR
rm -r texlive

$TEXDIR/bin/*/tlmgr install $(download https://yihui.org/gh/tinytex/tools/pkgs-custom.txt | tr '\n' ' ')

if [ "$1" = '--admin' ]; then
  if [ "$2" != '--no-path' ]; then
    sudo $TEXDIR/bin/*/tlmgr path add
  fi
else
  $TEXDIR/bin/*/tlmgr path add || true
fi
