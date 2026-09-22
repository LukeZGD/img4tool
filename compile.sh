#!/usr/bin/env bash
# This script is for macOS. For Linux, see .github/workflows/makefile.yml
export MACOSX_DEPLOYMENT_TARGET=10.11
libplist_ver=2.0.4

export libgeneral_CFLAGS="-I/usr/local/include -stdlib=libc++"
export libgeneral_LIBS="-L/usr/local/lib -lgeneral"
export libplist_CFLAGS="-I/usr/local/include"
export libplist_LIBS="-L/usr/local/lib -lplist-2.0"

rm -rf libgeneral
git clone --filter=blob:none https://github.com/LukeZGD/libgeneral
cd libgeneral
./autogen.sh --enable-universal
make
sudo make install
cd ..
rm -rf libgeneral

./autogen.sh --enable-universal
make
sudo make install

mkdir -p output/lib
cp /usr/local/bin/img4tool output/
cp /usr/local/lib/libgeneral.0.dylib output/lib/
cp /usr/local/lib/libimg4tool.0.dylib output/lib/
cp /usr/local/lib/libplist-$libplist_ver.dylib output/lib/

install_name_tool -change /usr/local/lib/libgeneral.0.dylib @executable_path/lib/libgeneral.0.dylib output/img4tool
install_name_tool -change /usr/local/lib/libimg4tool.0.dylib @executable_path/lib/libimg4tool.0.dylib output/img4tool
install_name_tool -change /usr/local/lib/libplist-$libplist_ver.dylib @executable_path/lib/libplist-$libplist_ver.dylib output/img4tool

install_name_tool -id @loader_path/libgeneral.0.dylib output/lib/libgeneral.0.dylib
install_name_tool -id @loader_path/libimg4tool.0.dylib output/lib/libimg4tool.0.dylib
install_name_tool -id @loader_path/libplist-$libplist_ver.dylib output/lib/libplist-$libplist_ver.dylib

install_name_tool -change /usr/local/lib/libgeneral.0.dylib @executable_path/lib/libgeneral.0.dylib output/lib/libimg4tool.0.dylib
