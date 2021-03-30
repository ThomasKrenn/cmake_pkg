



function(add_component)
   get_property(tmp GLOBAL PROPERTY G_BUILD_COMPONENTS)
   foreach(arg ${ARGV})
       set(tmp "${tmp} ${arg}")
   endforeach()
   set_property(GLOBAL PROPERTY G_BUILD_COMPONENTS "${tmp}")
endfunction(add_component)
