cmake_minimum_required(VERSION 3.18)
project(StmNucleoBlinky
	VERSION 1.0
	DESCRIPTION "A CMake-based Blinky project for the NUCLEO-L476RG."
	LANGUAGES C CXX ASM)

set_property(GLOBAL PROPERTY C_STANDARD 11)
set(CMAKE_EXECUTABLE_SUFFIX ".elf")

include(cmake/AddExecutableWithLinkerScriptDep.cmake)
include(cmake/GenerateMapFile.cmake)
include(cmake/Conversions.cmake)

##################
# Compiler Flags #
##################

# If we're not a subproject, globally apply our warning flags
if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
  add_compile_options(-Wall -Wextra)
endif()

#######################
# Process Source Tree #
#######################

add_subdirectory(Src)
