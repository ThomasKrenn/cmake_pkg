#!/bin/sh

# BAR configure, build and install commands
# configure, build install project 'BAR'

if [ ! -d bar ]
then 
  echo "'bar' doesn't exists "
  exit 1
fi

if [ ! -d bar_build ]
then 
 mkdir bar_build
fi

if [ ! -d bar_install ]
then 
 mkdir bar_install
fi

install_path="./cmake_pkg/bar_install"
build_type=Release

echo
echo --------- cmake configure BAR -----------
cmake -DCMAKE_INSTALL_PREFIX=${install_path} -DCMAKE_BUILD_TYPE=${build_type} -G  "Unix Makefiles" -B bar_build -S bar

echo
echo --------- cmake build BAR ----------
cmake --build bar_build --config Release

echo
echo ---------- cmake install BAR ----------
cmake --install bar_build --config Release

