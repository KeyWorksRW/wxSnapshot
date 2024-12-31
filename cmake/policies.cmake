#############################################################################
# Name:        build/cmake/policies.cmake
# Purpose:     CMake policies for wxWidgets
# Author:      Tobias Taschner
# Created:     2016-10-21
# Copyright:   (c) 2016 wxWidgets development team
# Licence:     wxWindows licence
#############################################################################

# ##############################################################################
#
# Modifications by KeyWorks Software
#
# ##############################################################################

if(POLICY CMP0025)
    # Compiler id for Apple Clang is now AppleClang.
    cmake_policy(SET CMP0025 NEW)
endif()

if(POLICY CMP0038)
    # Targets may not link directly to themselves.
    cmake_policy(SET CMP0038 NEW)
endif()

if(POLICY CMP0042)
    # MACOSX_RPATH is enabled by default.
    cmake_policy(SET CMP0042 NEW)
endif()

if(POLICY CMP0057)
    # Support new if() IN_LIST operator.
    cmake_policy(SET CMP0057 NEW)
endif()

if(POLICY CMP0072)
    # FindOpenGL prefers GLVND by default when available.
    cmake_policy(SET CMP0072 NEW)
endif()

if(POLICY CMP0079)
    # target_link_libraries() allows use with targets in other directories.
    cmake_policy(SET CMP0079 NEW)
endif()
