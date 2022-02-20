# you can set this to 1 to see all commands that are being run
VERBOSE ?= 0

ifeq ($(VERBOSE),1)
export Q :=
export VERBOSE := 1
else
export Q := @
export VERBOSE := 0
endif

# This skeleton is built for CMake's Ninja generator
export CMAKE_GENERATOR=Ninja

BUILDRESULTS ?= build
CONFIGURED_BUILD_DEP = $(BUILDRESULTS)/build.ninja

OPTIONS ?=
INTERNAL_OPTIONS =

TOOLCHAIN ?=
ifeq ($(TOOLCHAIN),)
	INTERNAL_OPTIONS += -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/cross/stm32l476rg.cmake
else
	INTERNAL_OPTIONS += -DCMAKE_TOOLCHAIN_FILE=$(TOOLCHAIN)
endif

BUILD_TYPE ?=
ifeq ($(BUILD_TYPE),)
	INTERNAL_OPTIONS += -DCMAKE_BUILD_TYPE=Debug
else
	INTERNAL_OPTIONS += -DCMAKE_BUILD_TYPE=$(BUILD_TYPE)
endif

all: default

.PHONY: default
default: | $(CONFIGURED_BUILD_DEP)
	$(Q)ninja -C $(BUILDRESULTS)

# Runs whenever the build has not been configured successfully
$(CONFIGURED_BUILD_DEP):
	$(Q)cmake -B $(BUILDRESULTS) $(OPTIONS) $(INTERNAL_OPTIONS)

.PHONY: clean
clean:
	$(Q) if [ -d "$(BUILDRESULTS)" ]; then ninja -C $(BUILDRESULTS) clean; fi

.PHONY: distclean
distclean:
	$(Q) rm -rf $(BUILDRESULTS)

# Manually Reconfigure a target, esp. with new options
.PHONY: reconfig
reconfig:
	$(Q) cmake -B $(BUILDRESULTS) $(OPTIONS) $(INTERNAL_OPTIONS)

.PHONY : help
help :
	@echo "usage: make [OPTIONS] <target>"
	@echo "  Options:"
	@echo "    > VERBOSE Show verbose output for Make rules. Default 0. Enable with 1."
	@echo "    > BUILDRESULTS Directory for build results. Default buildresults."
	@echo "    > BUILD_TYPE Specify the build type (default: RelWithDebInfo)"
	@echo "			Option are: Debug Release MinSizeRel RelWithDebInfo"
	@echo "    > OPTIONS Configuration options to pass to a build. Default empty."
	@echo "Targets:"
	@echo "  default: Builds all default targets ninja knows about"
	@echo "  clean: cleans build artifacts, keeping build files in place"
	@echo "  distclean: removes the configured build output directory"
	@echo "  reconfig: Reconfigure an existing build output folder with new settings"
