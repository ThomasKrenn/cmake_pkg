#!/bin/sh

# configure, build install project 'usepkg'

if [ ! -d usepkg ]
then 
  echo "'usepkg' doesn't exists "
  exit 1
fi

if [ ! -d usepkg_build ]
then 
 mkdir usepkg_build
fi

if [ ! -d usepkg_install ]
then 
 mkdir usepkg_install
fi

prefix_path=./cmake_pkg/bar_install/cmake
install_path=./cmake_pkg/usepkg_install
echo
echo --------- cmake configure usepkg -----------
cmake -DCMAKE_INSTALL_PREFIX=${install_path} -DCMAKE_PREFIX_PATH=${prefix_path} -G "Unix Makefiles" -B usepkg_build -S usepkg

echo
echo --------- cmake build usepkg ----------
cmake --build usepkg_build --config Release

echo
echo ---------- cmake install usepkg ----------
cmake --install usepkg_build --config Release

#
# List elf header of binary
#
readelf -d usepkg_install/bin/usepkg | head -20

