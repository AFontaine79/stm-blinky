####################################
# arm-none-eabi-gcc Base Toolchain #
####################################
#
# To include this file as a base toolchain file,
# include it at the bottom of the derived toolchain file.
#
# You can define CPU_FLAGS that will be passed to CMAKE_*_FLAGS to select the CPU
# (and any other necessary CPU-specific flags)
# You can define VFP_FLAGS to select the desired floating-point configuration
# You can define LD_FLAGS to control linker flags for your target

#################
# System Config #
#################

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)
# Represents the name of the specific processor type, e.g. Cortex-M4
if(NOT CPU_NAME)
	set(CPU_NAME generic)
endif()

####################
# Toolchain Config #
####################

set(CMAKE_C_COMPILER    arm-none-eabi-gcc)
set(CMAKE_ASM_COMPILER  arm-none-eabi-gcc)

# Test compiles will use static libraries, so we won't need to define linker flags
# and scripts for linking to succeed
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

################
# Common Flags #
################
# Note that CPU_FLAGS, LD_FLAGS, and VFP_FLAGS are set by other Toolchain files
# that include this file.
#
# See the CMake Manual for CMAKE_<LANG>_FLAGS_INIT:
#	https://cmake.org/cmake/help/latest/variable/CMAKE_LANG_FLAGS_INIT.html

set(CMAKE_C_FLAGS_INIT
	"${CPU_FLAGS} ${VFP_FLAGS} -fdata-sections -ffunction-sections --specs=nano.specs"
	CACHE
	INTERNAL "Default C compiler flags.")
set(CMAKE_CXX_FLAGS_INIT
	"${CPU_FLAGS} ${VFP_FLAGS} -fdata-sections -ffunction-sections --specs=nano.specs"
	CACHE
	INTERNAL "Default C++ compiler flags.")
set(CMAKE_ASM_FLAGS_INIT
	"${CPU_FLAGS} -x assembler-with-cpp"
	CACHE
	INTERNAL "Default ASM compiler flags.")
set(CMAKE_EXE_LINKER_FLAGS_INIT
	"${LD_FLAGS} --specs=nosys.specs -Wl,--gc-sections -static -Wl,--start-group -lc -lm -Wl,--end-group"
	CACHE
	INTERNAL "Default linker flags.")

# Build configuration overrides are specified by setting CMAKE_USER_MAKE_RULES_OVERRIDE.
#   https://cmake.org/cmake/help/latest/variable/CMAKE_USER_MAKE_RULES_OVERRIDE.html
set(CMAKE_USER_MAKE_RULES_OVERRIDE "${CMAKE_CURRENT_LIST_DIR}/../OverrideBuildTypeSettings.cmake")
