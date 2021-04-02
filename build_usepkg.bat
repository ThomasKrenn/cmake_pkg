::===============================================================
:: Configure 'usepkg'
::
::===============================================================
echo off

:: build 'bar' package
if not exist "bar_build" (
 md ba_build
)

if not exist "bar_install" (
 md bar_build
)

cmake -DCMAKE_INSTALL_PREFIX=.\bar_install -G  "Visual Studio 16 2019" -A x64 -B .\bar_build -S .\bar
cmake --build .\bar_build --config Release
cmake --install .\bar_build --config Release

echo ------------------------------------------
echo ------------------------------------------
echo ------------------------------------------

:: build 'usepkg' package
if not exist "usepkg_build" (
 md usepkg_build
)

if not exist "usepkg_install" (
 md usepkg_build
)
cmake -DCMAKE_INSTALL_PREFIX=.\usepkg_install -DCMAKE_PREFIX_PATH=.\bar_install\cmake -G  "Visual Studio 16 2019" -A x64 -B .\usepkg_build -S .\usepkg
cmake --build .\usepkg_build --config Release
cmake --install .\usepkg_build --config Release
