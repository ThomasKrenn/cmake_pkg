::===============================================================
:: Configure, build and install 'BAR'
::
::===============================================================
echo off

:: build 'bar' package
if not exist "bar_build" (
 md bar_build
)

if not exist "bar_install" (
 md bar_install
)

cmake -DCMAKE_INSTALL_PREFIX=.\bar_install -G  "Visual Studio 16 2019" -A x64 -B .\bar_build -S .\bar
cmake --build .\bar_build --config Release
cmake --install .\bar_build --config Release

