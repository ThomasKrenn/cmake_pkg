#
# Bar2 Target 
#

set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN YES)

add_library(Bar2 SHARED "")
add_library(BAR::Bar2 ALIAS Bar2)

add_component(Bar2)

include(GenerateExportHeader)
generate_export_header(Bar2)

set(bar2_pub_header 
  "include/bar2.h" 
  "${CMAKE_CURRENT_BINARY_DIR}/bar2_export.h"
)
set_target_properties(Bar2 PROPERTIES PUBLIC_HEADER "${bar2_pub_header}")



target_include_directories(Bar2
PRIVATE
   ${CMAKE_CURRENT_SOURCE_DIR}
   ${CMAKE_CURRENT_SOURCE_DIR}/include
   ${CMAKE_CURRENT_BINARY_DIR} 
   ${CMAKE_BINARY_DIR}/include
   ${CMAKE_BINARY_DIR}/privateinclude

#
# Build and install includes
#
INTERFACE
   # for BAR_EXPORT
   $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
   $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>

   $<INSTALL_INTERFACE:include>
)

target_sources( Bar2
PRIVATE
   bar2.cpp
   include/bar2.h
)

##
## compile definitions
##
target_compile_definitions(Bar2
 PRIVATE 
  "$<$<PLATFORM_ID:Windows>:_SBCS>"
  "$<$<PLATFORM_ID:Windows>:WIN32>"
  "$<$<PLATFORM_ID:Windows>:WIN64>"
)

##
## Position independent code in Linux
##
target_compile_options(Bar2
  PRIVATE 
  "$<$<PLATFORM_ID:Linux>:-fPIC>"
  "$<$<PLATFORM_ID:Linux>:-std=c++11>"
  "$<$<PLATFORM_ID:Windows>:/W3>"
)

set_target_properties(Bar2 PROPERTIES
  VERSION 2.3.4
  SOVERSION 2
)

install(TARGETS Bar2
EXPORT BarTargets
   RUNTIME  DESTINATION ${CMAKE_INSTALL_BINDIR}
   LIBRARY  DESTINATION ${CMAKE_INSTALL_LIBDIR}
   ARCHIVE  DESTINATION ${CMAKE_INSTALL_LIBDIR}
   INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
   PUBLIC_HEADER DESTINATION "include"
)