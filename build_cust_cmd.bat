::===============================================================
:: Configure, build and install 'BAR'
::
::===============================================================
echo off

:: build 'bar' package
if not exist "cust_cmd_build" (
 md cust_cmd_build
)

if not exist "cust_cmd_install" (
 md cust_cmd_install
)

cmake -DCMAKE_INSTALL_PREFIX=.\cust_cmd_install -G  "Visual Studio 16 2019" -A x64 -B .\cust_cmd_build -S .\cust_cmd
cmake --build .\cust_cmd_build --config Release
cmake --install .\cust_cmd_build --config Release

