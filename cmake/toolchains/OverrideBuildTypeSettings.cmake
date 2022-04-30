#####################################
# Default Build Configuration Flags #
#####################################
#
# Our ecosystem uses a different meaning for the default build types.
# Common flags are set in this file. You can use these default settings
# In your toolchain file by including this file.
#
# See the CMake Manual for CMAKE_<LANG>_FLAGS_INIT:
#	https://cmake.org/cmake/help/latest/variable/CMAKE_LANG_FLAGS_CONFIG_INIT.html

### Debug Flags
SET(CMAKE_C_FLAGS_DEBUG_INIT
	"-O0 -g3 -DDEBUG"
	CACHE
	INTERNAL "Default C compiler debug build flags.")
SET(CMAKE_CXX_FLAGS_DEBUG_INIT
	"-O0 -g3 -DDEBUG"
	CACHE
	INTERNAL "Default C++ compiler debug build flags.")
SET(CMAKE_ASM_FLAGS_DEBUG_INIT
	"-O0 -g3 -DDEBUG"
	CACHE
	INTERNAL "Default assembly compiler debug build flags")

### Release Flags
SET(CMAKE_C_FLAGS_RELEASE_INIT
	"-Os"
	CACHE
	INTERNAL "Default C compiler release build flags.")
SET(CMAKE_CXX_FLAGS_RELEASE_INIT
	"-Os"
	CACHE
	INTERNAL "Default C++ compiler release build flags.")
SET(CMAKE_ASM_FLAGS_RELEASE_INIT
	"-Os"
	CACHE
	INTERNAL "Default asm compiler release build flags.")
