# cd <buildir>
# cmake -DCMAKE_INSTALL_PREFIX=<install dir> -G  "Visual Studio 16 2019" -A x64 ..

# cmake -DCMAKE_INSTALL_PREFIX=<install dir> -G  "Visual Studio 14 2015 Win64" ..
# 
# cmake -DCMAKE_INSTALL_PREFIX=<install dir> -G  "Unix Makefiles"  ..
#

cmake_minimum_required(VERSION 3.20)

#
# CMake 3.12 - CMAKE_PROJECT_VERSION 
# Set of variables provides the version details
#
set(CMAKE_PROJECT_VERSION_MAJOR    3)
set(CMAKE_PROJECT_VERSION_MINOR    4)
set(CMAKE_PROJECT_VERSION_PATCH    5)
set(CMAKE_PROJECT_VERSION_TWEAK    6)
set(PROJECT_VERSION_DATE           "2021-01-02") 


add_definitions(-DPKG_VERSION_MAJOR=${CMAKE_PROJECT_VERSION_MAJOR})
add_definitions(-DPKG_VERSION_MINOR=${CMAKE_PROJECT_VERSION_MINOR})
add_definitions(-DPKG_VERSION_REVISION=${CMAKE_PROJECT_VERSION_PATCH})
add_definitions(-DPKG_VERSION_BUILD=${CMAKE_PROJECT_VERSION_TWEAK})
add_definitions(-DPKG_VERSION_DATE=${PROJECT_VERSION_DATE})


project(usepkg
   HOMEPAGE_URL "github.com/ThomasKrenn/cmake_pkg"
   VERSION ${CMAKE_PROJECT_VERSION_MAJOR}.${CMAKE_PROJECT_VERSION_MINOR}.${CMAKE_PROJECT_VERSION_PATCH}.${CMAKE_PROJECT_VERSION_TWEAK}
)

#
# find package debug helper
#
message(STATUS "CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")
set(CMAKE_FIND_DEBUG_MODE TRUE)

# If this variable is enabled, CMake automatically adds CMAKE_CURRENT_SOURCE_DIR 
# and CMAKE_CURRENT_BINARY_DIR to the include path for each directory. These additional
# include directories do not propagate down to subdirectories. This is useful mainly for 
# out-of-source builds, where files generated into the build tree are included by files
# located in the source tree.

# set(CMAKE_INCLUDE_CURRENT_DIR ON)


# find_package(BAR)
find_package(BAR COMPONENTS Bar1 Bar2
PATHS ../bar_install/cmake
REQUIRED)


file(GENERATE OUTPUT bar-gen CONTENT "<TARGET_FILE:BAR::Bar1>=$<TARGET_FILE:BAR::Bar1>\n")

get_target_property(BAR1_INCLUDE_DIR BAR::Bar1 INTERFACE_INCLUDE_DIRECTORIES)
message(STATUS "BAR1_INCLUDE_DIR=${BAR1_INCLUDE_DIR}")

if(MSVC)
 get_target_property(bar1_imported_location BAR::Bar1 IMPORTED_LOCATION_RELWITHDEBINFO)
 get_filename_component(bar1_LIBRARY_DIR ${bar1_imported_location} DIRECTORY)
 message(STATUS "bar1_LIBRARY_DIR=${bar1_LIBRARY_DIR}")
 message(STATUS "bar1_IMPORTED_LOCATION_RELWITHDEBINFO=${bar1_imported_location}")
else()
 get_target_property(bar1_imported_location BAR::Bar1 IMPORTED_LOCATION_RELEASE)
 get_filename_component(bar1_LIBRARY_DIR ${bar1_imported_location} DIRECTORY)
 message(STATUS "bar1_LIBRARY_DIR=${bar1_LIBRARY_DIR}")
 message(STATUS "bar1_IMPORTED_LOCATION_RELEASE=${bar1_imported_location}")
endif()


if (CMAKE_SYSTEM_NAME MATCHES "Darwin")
   include(GNUInstallDirs)

   # rpath used for rcc and uic when compiling a user application
   file(RELATIVE_PATH USEPKG_BIN_RPATH "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_BINDIR}"
                                   "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}")

   set(CMAKE_INSTALL_RPATH "@executable_path/${USEPKG_BIN_RPATH}")

elseif (CMAKE_SYSTEM_NAME MATCHES "(Linux|OpenBSD|FreeBSD|NetBSD|DragonFly)")
   include(GNUInstallDirs)

   # rpath used for rcc and uic when compiling a user application
   file(RELATIVE_PATH USEPKG_BIN_RPATH "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_BINDIR}"
                                   "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}")

   set(CMAKE_INSTALL_RPATH "$ORIGIN/${USEPKG_BIN_RPATH}")


elseif (CMAKE_SYSTEM_NAME MATCHES "Windows")
   set(CMAKE_INSTALL_BINDIR bin)
   set(CMAKE_INSTALL_LIBDIR lib)
   set(CMAKE_INSTALL_INCLUDEDIR include)

endif()

configure_file(cmakeversion.go.in cmakeversion.go @ONLY)

# -------------- DEBUG HELP -------------------------
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
