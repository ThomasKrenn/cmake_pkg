# cd <buildir>
# cmake -DCMAKE_INSTALL_PREFIX=<install dir> -G  "Visual Studio 16 2019" -A x64 ..

# cmake -DCMAKE_INSTALL_PREFIX=<install dir> -G  "Visual Studio 14 2015 Win64" ..
# 
# cmake -DCMAKE_INSTALL_PREFIX=<install dir> -G  "Unix Makefiles"  ..
#

cmake_minimum_required(VERSION 3.12)

project(usepkg)


set(CMAKE_PREFIX_PATH "M:/cppplay/cpkg/bar_install/cmake")

# If this variable is enabled, CMake automatically adds CMAKE_CURRENT_SOURCE_DIR 
# and CMAKE_CURRENT_BINARY_DIR to the include path for each directory. These additional
# include directories do not propagate down to subdirectories. This is useful mainly for 
# out-of-source builds, where files generated into the build tree are included by files
# located in the source tree.

# set(CMAKE_INCLUDE_CURRENT_DIR ON)


# find_package(BAR)
find_package(BAR COMPONENTS Bar1 Bar2 REQUIRED)


file(GENERATE OUTPUT bar-gen CONTENT "<TARGET_FILE:BAR::Bar1>=$<TARGET_FILE:BAR::Bar1>\n")

get_target_property(BAR1_INCLUDE_DIR BAR::Bar1 INTERFACE_INCLUDE_DIRECTORIES)
message(STATUS "BAR1_INCLUDE_DIR=${BAR1_INCLUDE_DIR}")

get_target_property(bar1_imported_location BAR::Bar1 IMPORTED_LOCATION_RELWITHDEBINFO)
get_filename_component(bar1_LIBRARY_DIR ${bar1_imported_location} DIRECTORY)
message(STATUS "bar1_LIBRARY_DIR=${bar1_LIBRARY_DIR}")
message(STATUS "bar1_IMPORTED_LOCATION_RELWITHDEBINFO=${bar1_imported_location}")


# get_cmake_property(_variableNames VARIABLES)
# message(STATUS "###################################################")
# foreach (_variableName ${_variableNames})
#     message(STATUS "${_variableName}=${${_variableName}}")
# endforeach()
# message(STATUS "###################################################")

# Tell CMake to create the helloworld executable
add_executable(usepkg "")


target_include_directories(usepkg
 PRIVATE
   ${CMAKE_CURRENT_SOURCE_DIR}
)

target_sources(usepkg 
PRIVATE
  usepkg.cpp
)

target_link_libraries(usepkg
 PRIVATE
    BAR::Bar1
    BAR::Bar2
)

install(TARGETS usepkg
LIBRARY DESTINATION lib
ARCHIVE DESTINATION lib
RUNTIME DESTINATION bin

)

set(CPACK_GENERATOR "ZIP")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "tom the best") # required

include(CPack)
