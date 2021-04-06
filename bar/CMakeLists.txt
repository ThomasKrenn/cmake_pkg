cmake_minimum_required (VERSION 3.13)

# cd <buildir>
# cmake -DCMAKE_INSTALL_PREFIX=<install dir> -G  "Visual Studio 16 2019" -A x64 ..
# cmake -DCMAKE_INSTALL_PREFIX=<install dir> -G  "Visual Studio 14 2015 Win64" ..
# 
# cmake -DCMAKE_INSTALL_PREFIX=<install dir> -G  "Unix Makefiles"  ..
#


#
# Simple CMake package with two targets (Bar::Bar1 and Bar::Bar2)
# that can be used from the build tree.  
# Set the CMAKE_PREFIX_PATH variable to import the <bar install tree>.
#
#
# Version number of the project
#
file(STRINGS "VERSION" BARVersion LIMIT_COUNT 1)

project(BAR
   LANGUAGES C CXX
   VERSION ${BARVersion}
   HOMEPAGE_URL "github.com/ThomasKrenn/cmake_pkg"
)


message("CMAKE_SYSTEM_NAME: ${CMAKE_SYSTEM_NAME}")
message("CMAKE_PROJECT_VERSION_MINOR: ${CMAKE_PROJECT_VERSION_MINOR}")

set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set_property(GLOBAL PROPERTY PREDEFINED_TARGETS_FOLDER "CMakeBuild")
set_property(GLOBAL PROPERTY AUTOGEN_TARGETS_FOLDER CMakeMoc)


# ${CMAKE_SOURCE_DIR}/src/buildinfo/
#  -P ${CMAKE_SOURCE_DIR}/cmake/create-barversion.cmake
#
set(VERSION_IN   "${CMAKE_SOURCE_DIR}/VERSION")
set(VERSION_TEMPL "${CMAKE_SOURCE_DIR}/cmake/bar_version.h.in")
set(VERSION_HDR  "${CMAKE_BINARY_DIR}/src/buildinfo/bar_version.h")

add_custom_command(OUTPUT "${VERSION_HDR}"
                   COMMAND ${CMAKE_COMMAND}
                     -E echo "## custom command Generate version information"

                   COMMAND ${CMAKE_COMMAND}
                     -DCONFIG_IN=${VERSION_IN}
                     -DCONFIG_TEMPL=${VERSION_TEMPL}
                     -DCONFIG_OUT=${VERSION_HDR}
                     -P ${CMAKE_SOURCE_DIR}/cmake/create-barversion.cmake
                   DEPENDS ${VERSION_IN}
                   COMMENT Generate version information
)

# dummy target the triggers the custom command whenever the input changes
add_custom_target(configure_version ALL  
  SOURCES "${VERSION_HDR}"
)
                   
#
# global property component
#
set_property(GLOBAL PROPERTY G_BUILD_COMPONENTS)
include(cmake/BarMacros.cmake)


add_subdirectory(src)

get_property(BUILD_COMPONENTS GLOBAL PROPERTY G_BUILD_COMPONENTS)
message(STATUS "BUILD_COMPONENTS: ${BUILD_COMPONENTS}")

#
# package config
#
set(package_dir "${CMAKE_CURRENT_BINARY_DIR}/cmake/${PROJECT_NAME}")
set(namespace "${PROJECT_NAME}::")

include(CMakePackageConfigHelpers)

write_basic_package_version_file(
   "cmake/${PROJECT_NAME}/${PROJECT_NAME}ConfigVersion.cmake"
   VERSION 1.2.3
   COMPATIBILITY AnyNewerVersion
)

configure_package_config_file(
   "cmake/BarConfig.cmake.in"
   "cmake/${PROJECT_NAME}/${PROJECT_NAME}Config.cmake"
   INSTALL_DESTINATION "cmake/${PROJECT_NAME}"
   INSTALL_PREFIX ${CMAKE_CURRENT_BINARY_DIR}
)

install(
  FILES "${package_dir}/${PROJECT_NAME}Config.cmake"
        "${package_dir}/${PROJECT_NAME}ConfigVersion.cmake"
  DESTINATION "cmake/${PROJECT_NAME}"
)

install(
   EXPORT BarTargets
   NAMESPACE ${namespace}
   FILE "${PROJECT_NAME}Targets.cmake"
   DESTINATION "cmake/${PROJECT_NAME}"
)

#
# creates the targets for this package for clients that use the build_tree
# use 'TARGETS Bar1 Bar2' to export targets by name
export( 
  EXPORT BarTargets
  NAMESPACE ${namespace}
  FILE cmake/${PROJECT_NAME}/${PROJECT_NAME}Targets.cmake
 )




