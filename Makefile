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

OPTIONS ?=
INTERNAL_OPTIONS =

TOOLCHAIN ?=
ifeq ($(TOOLCHAIN),)
	INTERNAL_OPTIONS += -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/cross/stm32l476rg.cmake
else
	INTERNAL_OPTIONS += -DCMAKE_TOOLCHAIN_FILE=$(TOOLCHAIN)
endif

# Placing debug first makes it the default target if no target is given
.PHONY: debug
debug: INTERNAL_OPTIONS += -DCMAKE_BUILD_TYPE=Debug
debug: build/stm/debug/build.ninja
	$(Q)ninja -C build/stm/debug
build/stm/debug/build.ninja:
	$(Q)cmake -B build/stm/debug $(OPTIONS) $(INTERNAL_OPTIONS)

.PHONY: release
release: INTERNAL_OPTIONS += -DCMAKE_BUILD_TYPE=Release
release: build/stm/release/build.ninja
	$(Q)ninja -C build/stm/release
build/stm/release/build.ninja:
	$(Q)cmake -B build/stm/release $(OPTIONS) $(INTERNAL_OPTIONS)

all: debug release


.PHONY: clean
clean:
	$(Q) if [ -d build/stm/debug ]; then ninja -C build/stm/debug clean; fi
	$(Q) if [ -d build/stm/release ]; then ninja -C build/stm/release clean; fi

.PHONY: distclean
distclean:
	$(Q) rm -rf build/stm

.PHONY : help
help :
	@echo "usage: make [OPTIONS] <target>"
	@echo "  Options:"
	@echo "    > VERBOSE Show verbose output for Make rules. Default 0. Enable with 1."
	@echo "    > OPTIONS Configuration options to pass to a build. Default empty."
	@echo "Targets:"
	@echo "  Build targets: (default is debug)"
	@echo "    debug:     Build with debug flags"
	@echo "    release:	  Build with optimization"
	@echo "    default:   Build both debug and release targets"
	@echo "  clean: cleans build artifacts, keeping build files in place"
	@echo "  distclean: deletes the build directory"
