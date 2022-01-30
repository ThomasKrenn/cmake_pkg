#
# Bar Target 
#

set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN 1)

add_library(Bar1 SHARED "")
add_library(BAR::Bar1 ALIAS Bar1)

add_component(Bar1)

include(GenerateExportHeader)
generate_export_header(Bar1)

set(bar1_pub_header
  "include/bar1.h"
  "${CMAKE_CURRENT_BINARY_DIR}/bar1_export.h"
)
set_target_properties(Bar1 PROPERTIES PUBLIC_HEADER "${bar1_pub_header}")




target_include_directories(Bar1
PRIVATE
   ${CMAKE_CURRENT_SOURCE_DIR}
   ${CMAKE_CURRENT_SOURCE_DIR}/include
   ${CMAKE_CURRENT_BINARY_DIR} 
   ${CMAKE_BINARY_DIR}/include

#
# Build and install includes
#
INTERFACE
   # for BAR_EXPORT
   $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
   $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>

   $<INSTALL_INTERFACE:include>
)

target_sources( Bar1
PRIVATE
   bar1.cpp
   include/bar1.h
)

##
## compile definitions
##
target_compile_definitions( Bar1
 PRIVATE 
  "$<$<PLATFORM_ID:Windows>:_SBCS>"
  "$<$<PLATFORM_ID:Windows>:WIN32>"
  "$<$<PLATFORM_ID:Windows>:WIN64>"
)

##
## Position independent code in Linux
##
target_compile_options( Bar1
  PRIVATE 
  "$<$<PLATFORM_ID:Linux>:-fPIC>"
  "$<$<PLATFORM_ID:Linux>:-std=c++11>"
  "$<$<PLATFORM_ID:Windows>:/W3>"
)

set_target_properties(Bar1 PROPERTIES
  VERSION 1.2.3
  SOVERSION 1
)

install(TARGETS Bar1
EXPORT BarTargets
   RUNTIME  DESTINATION ${CMAKE_INSTALL_BINDIR}
   LIBRARY  DESTINATION ${CMAKE_INSTALL_LIBDIR}
   ARCHIVE  DESTINATION ${CMAKE_INSTALL_LIBDIR}
   INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
   PUBLIC_HEADER DESTINATION "include"
)


