cmake_minimum_required(VERSION 3.18)
project(StmNucleoBlinky
	VERSION 1.0
	DESCRIPTION "A CMake-based Blinky project for the NUCLEO-L476RG."
	LANGUAGES C CXX ASM)

set_property(GLOBAL PROPERTY C_STANDARD 11)
set(CMAKE_EXECUTABLE_SUFFIX ".elf")
set(CMAKE_EXPORT_COMPILE_COMMANDS true)

include(cmake/AddExecutableWithLinkerScriptDep.cmake)
include(cmake/GenerateMapFile.cmake)
include(cmake/Conversions.cmake)

##################
# Compiler Flags #
##################

# These prevent absolute paths from appearing in build artifacts.
# Absolute paths are build-host specific and can result in different
# binaries or inability to use or examine artifacts between hosts.
add_compile_options(
	"-fdebug-prefix-map=${CMAKE_SOURCE_DIR}=."
	"-ffile-prefix-map=${CMAKE_SOURCE_DIR}=."
)

# If we're not a subproject, globally apply our warning flags
if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
  add_compile_options(-Wall -Wextra)
endif()

#######################
# Process Source Tree #
#######################

add_subdirectory(Src)
