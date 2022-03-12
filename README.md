# STM32 Blinky
Blinky on an STM32 Nucleo board built entirely using CMake.

## About the Project
This project is my first exercise completing a fully functional build for an embedded target using the CMake build system.  As is customary, I have chosen to implement Blinky.

Other goals for this project are to be cross-platform and simple to use.  End users should be able to build the project and flash a device with minimal effort.

## Project Status
Blinky is functional for the NUCLEO-L476RG.  Other Nucleo boards could be added, but I haven't created build configurations for them yet.

The project builds using CMake, but there is no proper install target yet.  Currently, a `flash_device.sh` script is provided, which requires that you have J-Link (not ST-Link) drivers installed.  This works to load a Nucleo board, although it will pop up a limited-use license agreement.

Build and load has been verified in:
- [x] Windows Git Bash
- [x] Windows Cmd.exe
- [x] Ubuntu in Windows/WSL
- [ ] Native Linux system
- [ ] Mac OS X

## Getting Started

### Requirements
First things first, if you don't already have Git, install that first.  Please see the install instructions for [Linux, Mac and Windows](https://git-scm.com/downloads).  If installing for Windows, this will also install Git Bash.

Also, if on Mac, you need to install [Homebrew](https://brew.sh/).  
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Most of the rest of this guide will use `apt` and `brew` for Linux and Mac respectively, but follow more specific instructions for Windows.

#### CMake Build System
**Windows**  
Download and run the latest MSI installer for x64 based systems from the [CMake downloads page](https://cmake.org/download/).

**Mac**  
Download a DMG file from the same link above ...OR...  
```
brew install cmake
```

**Linux/WSL**  
```
sudo apt-get install cmake
```
Note that Ubuntu package registries tend to be somewhat out of date.  For example, the CMake package referenced for Ubuntu 20.04LTS is [3.16.3](https://packages.ubuntu.com/focal/cmake), which will fail for this project (minimum required CMake is 3.18).  One suggestion for getting around this is to use `pip` to install Cmake.   
```
pip3 install cmake
```

#### Ninja
CMake is a build system generator; It is not the build system itself.  It will generate the build files for the build system of our choice based on our CMake scripts.  In our case, we are using Ninja as the actual build system.

**Windows**  
This one leaves you a little bit on your own.  As far as I can tell, there is no installer for Ninja.  I recommend going to the [latest release](https://github.com/ninja-build/ninja/releases/tag/v1.10.2) on the GitHub repo and downloaded `ninja-win.zip`.  After unzipping you will find the Ninja executable.  The main thing is that this needs to be in your Windows PATH environment variable.  For this, I made a `%USERPROFILE%\tools` directory and added its path to my user's PATH environment variable in `Advanced System Settings`.  This approach of adding to the PATH variable should be used for any tools that do not already add themselves to the path.

**Mac**  
```
brew install ninja
```

**Linux/WSL**  
```
sudo apt install ninja-build
```

#### Make
Although we are using CMake as the build system, CMake in itself is not inherently a one-touch system.  Multiple commands are needed the first time the build is run.  To make this truly one-touch, we use a Makefile shim as inspired by the CMake course at [Embedded Artistry](https://embeddedartistry.com/).  This means we need `make` at the command line.

**Windows**  
For Windows, we will install MinGW and add the MSYS package in the install configuration.  I recommend to use [this download](https://sourceforge.net/projects/mingw/) and follow [these instructions](https://www.ics.uci.edu/~pattis/common/handouts/mingweclipse/mingw.html).

**Mac**  
If you haven't already, you may need to "Install Command Line Tools" from Xcode, although I am not certain whether this is necessary.

**Linux/WSL**  
If, for whatever reason, `make` is not already available in your shell:  
```
sudo apt install build-essential
```

#### GNU ARM Embedded Toolchain
This is the toolchain to compile and link the project and generate the final `.hex` file output to be loaded onto the board.  Ninja is not the compiler or linker.  Like make, it is only a system for determining what components need compiling and linking when (re)running a build.

Prebuilt ARM GCC packages for Windows, Mac and Linux can be [downloaded from the ARM website](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads).

**Windows**  
For Windows, the package will be an installer that places its contents in `C:\Program Files (x86)\GNU Arm Embedded Toolchain\<version>`.  Inside this is a `bin` folder that needs to be added to your path.  See instructions above.

**Mac and Linux**  
The zip file can be unzipped anywhere.  I recommend placing this in your home path (e.g. `~/toolchains`.  Wherever the `bin` folder for this ends up, you need to add it to your PATH.  Do this in `~/.bash_profile` or `~/.bashrc`.  Example:
```
export PATH="$PATH:$HOME/toolchains/gcc-arm-none-eabi/bin/"
```

### Building
Issue `make` from the root directory where you clone this repo.  It will handle configuring the initial CMake run and automatically run Ninja afterwords.  After the first run, `make` can be invoked again to run Ninja without rerunning CMake.  Note that if any CMake script files are modified, this will cause a rerun of CMake.  All dependencies are properly tracked.

The build outputs are `build`, `build.map` and `build.hex` in the `build/Src` directory.

**Note:** `build` is the ELF file although it is not named `build.elf`.

### Loading
There is, as of yet, no proper install target.  Instead, you will need to follow directions below depending on how your Nucleo board appears when connected to your computer.  By default, Nucleo boards have a built-in ST-Link.  The Nucleo should identify as an ST-Link when connected to your computer.  However, the on-board ST-Link [can be converted to a J-Link](https://www.segger.com/products/debug-probes/j-link/models/other-j-links/st-link-on-board/), which allows for use of the capabilities of the J-Link.

#### If your Nucleo shows up as ST-Link
- If you do not have it already, download and install [STM32 Cube Programmer](https://www.st.com/en/development-tools/stm32cubeprog.html).
- Run the build as described above.
- Connect your Nucleo board.
- Start STM32CubeProgrammer.
- Click the green 'Connect' button in the upper right.  Make sure the status above the 'Connect' button changes to Connected.  If this fails, check that your board is enumerating correclty and/or check the drop-down selection to the left of the 'Connect' button.
- After connecting, on the left-hand set of icons, select the one that looks like an arrow pointing down into a device.  The title above the active area of the GUI should change to "Erasing & Programming".
- For the file path, click 'Browse' and select the `Blinky.hex` file that is in the `build/Src` subfolder.  The `build` folder appears after running the build.
- Select 'Run after programming'.
- Click 'Start Programming'.
- Click the green 'Disconnect' button in the upper right.
 
The board should now be blinking the LED once per second.

#### If your Nucleo shows up as a J-Link
- If you do not have them already, download and install the [SEGGER J-Link drivers](https://www.segger.com/downloads/jlink/).
- Run the build as described above.
- Run `./flash-device.sh` from the root directory of the repo.  (On Windows, this can be done from Git Bash.)
 
The board should now be blinking the LED once per second.

### Testing
Not yet implemented

### Cleaning
`make clean` removes the build files. `make distclean` blows away the `build` folder.

### Debugging
**Note:** No IDE is necessary for editing, buidling or debugging the code and no instructions here should be taken as an indication otherwise.  Use of an IDE is a matter of personal preference.

Debugging has been proven on Eclipse CDT with GNU MCU plug-in using the GDB SEGGER J-Link Debugger launch configuration.  It has not yet been proven on VS Code.

#### Eclipse
_Instructions not yet written_

#### VS Code
_Instructions not yet written_

## Need help?
If you need further assistance or have any questions, please file a GitHub issue.

## Future Work
- Add a proper install target possibly using CMake's `install()` command.  I need to explore this further since I don't fully understand `install()` yet.  At the very least, install should be platform agnostic and actually flash the hardware.
- Possibly fix the install script to allow load over ST-Link as well as J-Link.
- Figure out why adding `-specs=nano.specs` and `-specs=nosys.specs` didn't work.  I got a strange error about "attempt to rename spec 'link' to already defined spec 'nano_link'".  Googling that is not helpful.  I gave up and removed all `-specs=` flags.  (STMCubeIDE is using these flags though, so I dunno what gives.)
- Figure out how to specify the build variant at the command line (e.g. `Debug` vs `Release`).
- Follow up with other things like CI, static analysis, clang formatter, and so forth.

## License
MIT license.  See LICENSE file for details.

## Acknowledgments
A huge shout-out and thanks to Phillip Johnston and the folks at [Embedded Artistry](https://embeddedartistry.com/).
