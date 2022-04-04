This repository contains a snapshot of the **wxWidgets** (https://github.com/wxWidgets/wxWidgets) sources. It is desgined to be used as a submodule of various KeyWorks Software repositories. As such, it only contains CMake build files, it does not contain documentation, samples, or anything not specifically needed for building the wxWidgets libraries.

For the official wxWidgets readme file, please see wxREADME.md.

The current snapshot of **wxWidgets** is version 3.1.6.

## CMake

The `CMakeLists.txt` file is _not_ the same file that is part of the wxWidgets repository. This is a custom version, designed to build two static librarys: **wxCLib** and **wxWidgets**.

The `wxWidgets.lib` library is a subset of the wxMondo library that would normally be built using the original wxWidgets build scripts. In particular, it does not include the following sub-libraries:

- wxGL (Mondo library doesn't include this either)
- wxMedia
- wxNet
- wxQA

The other difference between these libraries and the official wxWidgets libraries is the compiler options used. Under MSW, the compiler is told to optimize for space rather than speed (which often results in faster code due to CPU caching). Debug builds are built using using /Z7 instead of /Zi -- this results in a slightly larger PDB file, but faster compilation with ninja.

See https://docs.wxwidgets.org/trunk/page_libs.html for information about wxWidgets libraries and their dependencies on each other.

## MSVC notes

Do _not_ include `<msvc/wx/setup.h>` in your project -- this will add pragmas that pull in the official wxWidgets libraries. Instead, add the two libraries directly to **CMakeLists.txt** using **target_link_libraries**.
