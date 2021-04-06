cmake_minimum_required(VERSION 3.20)
project(SimpleCustomCmd)

set(MY_SOURCE my_input.txt)
set(MY_OUTPUT my_output.c)

#
# adding a custom command to produce an output:
#
add_custom_command(OUTPUT ${MY_OUTPUT} 
                   COMMAND ${CMAKE_COMMAND} -E echo "#--> Before touch (execute custom command)"                 
                   COMMAND ${CMAKE_COMMAND} -E touch ${MY_OUTPUT}
                   COMMAND ${CMAKE_COMMAND} -E echo "#--> After touch (execute custom command)"                 

                   DEPENDS ${MY_SOURCE} 
)

# add_library(myLib ${MY_OUTPUT})

#
# add a custom target; always excuted
# Add a target with no output so it will always be built.
#
add_custom_target( my_custom_target ALL
    COMMAND
        ${CMAKE_COMMAND} -E echo "#--> my_custom_target"
    SOURCES ${MY_OUTPUT}
    VERBATIM
)
