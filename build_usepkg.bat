::===============================================================
:: Configure 'usepkg'
::
::===============================================================
cd usepkg_build
cmake -DCMAKE_INSTALL_PREFIX=..\usepkg_install -G  "Visual Studio 16 2019" -A x64 ..\usepkg
