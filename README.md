# The-Forge.cmake

> This repo together with [the-forge-starter](https://github.com/cboiangiu/the-forge-starter) are a work in progress.

This repo contains a bunch of cmake files that can be used to build The-Forge with CMake.

Building
-------------

```
git clone https://github.com/cboiangiu/The-Forge.cmake.git
cd The-Forge.cmake
git submodule init
git submodule update
mkdir build
cd build
cmake ..
```

If downloading via zip (instead of using git submodules) manually download The-Forge and copy them into the root directory, or locate them via THE_FORGE_DIR CMake variables.

How To Use
-------------
This project is setup to be included a few different ways. To include The-Forge source code in your project simply use add_subdirectory to include this project. To build The-Forge binaries build the INSTALL target (or "make install"). The installed files will be in the directory specified by CMAKE_INSTALL_PREFIX which I recommend you set to "./install" so it will export to your build directory. Note you may want to build install on both Release and Debug configurations.
