cmake_minimum_required( VERSION 3.20 )

# parse the version number from wx/version.h and include in wxMAJOR_VERSION and wxMINOR_VERSION
file( READ "${CMAKE_CURRENT_SOURCE_DIR}/include/wx/version.h" WX_VERSION_H_CONTENTS )
string( REGEX MATCH "wxMAJOR_VERSION[ \t]+([0-9]+)"
    wxMAJOR_VERSION ${WX_VERSION_H_CONTENTS} )
string( REGEX MATCH "([0-9]+)"
    wxMAJOR_VERSION ${wxMAJOR_VERSION} )
string( REGEX MATCH "wxMINOR_VERSION[ \t]+([0-9]+)"
    wxMINOR_VERSION ${WX_VERSION_H_CONTENTS} )
string( REGEX MATCH "([0-9]+)"
    wxMINOR_VERSION ${wxMINOR_VERSION} )
string( REGEX MATCH "wxRELEASE_NUMBER[ \t]+([0-9]+)"
    wxRELEASE_NUMBER ${WX_VERSION_H_CONTENTS} )
string( REGEX MATCH "([0-9]+)"
    wxRELEASE_NUMBER ${wxRELEASE_NUMBER} )

set( wxVERSION ${wxMAJOR_VERSION}.${wxMINOR_VERSION}.${wxRELEASE_NUMBER} )
set( wxCOPYRIGHT "2002-2025 wxWidgets" )

include( ${CMAKE_CURRENT_SOURCE_DIR}/cmake/policies.cmake NO_POLICY_SCOPE )

set( wxLANGUAGES C CXX )

if( APPLE )
    list( APPEND wxLANGUAGES OBJCXX )
endif()

project( wxWidgets33
    LANGUAGES ${wxLANGUAGES}
    VERSION ${wxVERSION}
    DESCRIPTION "wxWidgets 3.3.0" # see include/wx/version.h
    HOMEPAGE_URL "https://github.com/wxWidgets/wxWidgets"
)

# ###################### Options #######################

option( BUILD_SHARED_LIBS "Build wxWidgets shared libraries" OFF )

if( BUILD_SHARED_LIBS )
    message( NOTICE "Building wxWidgets shared libraries" )
else()
    message( NOTICE "Building wxWidgets static libraries" )
endif()

# ###################### Check for Multi-Config Generator #######################
get_property( isMultiConfig GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG )

if( NOT isMultiConfig )
    message( "\nBecause you are using a single target generator, you MUST specify" )
    message( "    a \"--config [Debug|Release]\" option with the cmake --build command\n" )

    set( allowedBuildTypes Debug Release )
    set_property( CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "${allowedBuildTypes}" )

    if( NOT CMAKE_BUILD_TYPE )
        set( CMAKE_BUILD_TYPE Debug CACHE STRING "" FORCE )
    elseif( NOT CMAKE_BUILD_TYPE IN_LIST allowedBuildTypes )
        message( FATAL_ERROR "Unknown build type: ${CMAKE_BUILD_TYPE}" )
    endif()
endif()

# ###################### General Settings #######################
include( ${CMAKE_CURRENT_SOURCE_DIR}/cmake/functions.cmake )

# When a static library is generated, then there's no significant need to finely control what wxUSE_
# options are set since the linker will only pull in code the application uses. However, some of the
# wxUSE_ options used here have different defaults then the official wxWidgets versions. That's
# primarily to avoid compiling code that would never be used by someone using this variant of the
# wxWidgets library (e.g., OLE, ActiveX, MS HTML Help, etc.)

wx_option( wxUSE_GUI "Use GUI" ON )

include( ${CMAKE_CURRENT_SOURCE_DIR}/cmake/toolkit.cmake )
include( ${CMAKE_CURRENT_SOURCE_DIR}/cmake/options.cmake )
include( ${CMAKE_CURRENT_SOURCE_DIR}/cmake/init.cmake )
include( ${CMAKE_CURRENT_SOURCE_DIR}/cmake/setup.cmake ) # will create include/wx/setup.h

# Note that the official version of wxWidgets defaults to C++11 -- this version defaults to C++17,
# and currently allows C++23 as the upper limit (versus C++20).

set( CMAKE_CXX_EXTENSIONS OFF )
set( CMAKE_C_STANDARD 99 ) # Use C99 standard
set( CMAKE_C_STANDARD_REQUIRED ON )

if( MSVC )
    # /O1 often results in faster code than /O2 due to CPU caching
    string( REPLACE "/O2" "/O1" cl_optimize ${CMAKE_CXX_FLAGS_RELEASE} )
    set( CMAKE_CXX_FLAGS_RELEASE ${cl_optimize} CACHE STRING "C++ Release flags" FORCE )

    string( REPLACE "/O2" "/O1" cl_optimize ${CMAKE_C_FLAGS_RELEASE} )
    set( CMAKE_C_FLAGS_RELEASE ${cl_optimize} CACHE STRING "C Release flags" FORCE )

    # Using /Z7 instead of /Zi to avoid blocking while parallel compilers write to the pdb file.
    # This can considerably speed up build times at the cost of larger object files.
    string( REPLACE "/Zi" "/Z7" z_seven ${CMAKE_CXX_FLAGS_DEBUG} )
    set( CMAKE_CXX_FLAGS_DEBUG ${z_seven} CACHE STRING "C++ Debug flags" FORCE )

    string( REPLACE "/Zi" "/Z7" z_seven ${CMAKE_C_FLAGS_DEBUG} )
    set( CMAKE_C_FLAGS_DEBUG ${z_seven} CACHE STRING "C Debug flags" FORCE )

    # Use static runtime for Release builds to run with Wine without needing to install the dlls
    if( NOT BUILD_SHARED_LIBS )
        set( CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>" )
    endif()
elseif( UNIX )
    # This should work for gcc and clang (including xcode which is based on clang)
    # -O2 can result in faster code than -O3 due to CPU caching.
    string( REPLACE "-O3" "-O2" cl_optimize ${CMAKE_CXX_FLAGS_RELEASE} )
    set( CMAKE_CXX_FLAGS_RELEASE ${cl_optimize} CACHE STRING "C++ Release flags" FORCE )
    string( REPLACE "-O3" "-O2" cl_optimize ${CMAKE_C_FLAGS_RELEASE} )
    set( CMAKE_C_FLAGS_RELEASE ${cl_optimize} CACHE STRING "C Release flags" FORCE )
endif()

# Determine minimum required OS at runtime
set( wxREQUIRED_OS_DESC "${CMAKE_SYSTEM_NAME} ${CMAKE_SYSTEM_PROCESSOR}" )

if( MSVC OR MINGW OR CYGWIN )
    set( wxREQUIRED_OS_DESC "Windows 11" )

    if( wxPLATFORM_ARCH )
        wx_string_append( wxREQUIRED_OS_DESC " (${wxPLATFORM_ARCH} Edition)" )
    endif()
elseif( APPLE )
    if( DEFINED CMAKE_OSX_DEPLOYMENT_TARGET )
        set( wxREQUIRED_OS_DESC "macOS ${CMAKE_OSX_DEPLOYMENT_TARGET} ${CMAKE_SYSTEM_PROCESSOR}" )
    endif()
endif()

message( STATUS "Configured wxWidgets ${wxVERSION} for ${CMAKE_SYSTEM_NAME}
    Min OS Version required at runtime: ${wxREQUIRED_OS_DESC}"
)

if( NOT BUILD_SNAPSHOT )
    set( CMAKE_SKIP_INSTALL_ALL ON )
    include( GNUInstallDirs )

    set( CMAKE_ARCHIVE_OUTPUT_DIRECTORY $<1:${CMAKE_BINARY_DIR}/lib> )
    set( CMAKE_LIBRARY_OUTPUT_DIRECTORY $<1:${CMAKE_BINARY_DIR}/lib> )
    set( CMAKE_RUNTIME_OUTPUT_DIRECTORY $<1:${CMAKE_BINARY_DIR}/lib> )
    set( CMAKE_DEBUG_POSTFIX d )
endif()

include( wxWidgets.cmake ) # This will set ${common_sources}, ${msw_sources}, ${unix_sources} and ${osx_sources}
include( wxCLib.cmake ) # This will set ${wxCLib_sources} with list of files

if( WIN32 )
    list( APPEND wxCLib_sources src/tiff/libtiff/tif_win32.c )
endif()

if( WIN32 )
    add_library( wxWidgets33 ${common_sources} ${msw_sources} )
elseif( APPLE )
    add_library( wxWidgets33 ${common_sources} ${osx_sources} )
elseif( UNIX )
    add_library( wxWidgets33 ${common_sources} ${unix_sources} )
endif()

if( UNIX )
    set( wxCLib_platform_files

        # src/gtk/treeentry_gtk.c
        src/tiff/libtiff/tif_unix.c
        src/tiff/libtiff/libtiff.def
    )
else()
    set( wxCLib_platform_files src/tiff/libtiff/tif_win32.c )

    # set (wxCLib_platform_files "")
endif()

add_library( wxCLib STATIC
    ${wxCLib_sources}
    ${wxCLib_platform_files}
)

if( BUILD_SHARED_LIBS )
    target_compile_definitions( wxWidgets33 PRIVATE WXMAKINGDLL )
endif()

if( MSVC )
    # /GL -- combined with the Linker flag /LTCG allows whole program optimization in Release build
    target_compile_options( wxWidgets33 PRIVATE "$<$<CONFIG:Release>:/GL>" )
elseif( UNIX )
    target_compile_options( wxWidgets33 PRIVATE "-fPIC" )
    target_compile_options( wxCLib PRIVATE "-fPIC" )
endif()

if( WIN32 )
    target_compile_definitions( wxWidgets33 PRIVATE
        __WXMSW__
        WIN32
    )
elseif( UNIX )
    target_compile_definitions( wxWidgets33 PRIVATE
        __WXGTK3__
        __WXGTK220__ # required for activityindicator.cpp to be pulled in
        __UNIX__
    )
endif()

target_compile_definitions( wxWidgets33 PRIVATE
    WXBUILDING
    _CRT_SECURE_NO_DEPRECATE=1
    _CRT_NON_CONFORMING_SWPRINTFS=1
    _SCL_SECURE_NO_WARNINGS=1
    SCI_LEXER
    NO_CXX11_REGEX
    LINK_LEXERS
)

if( WIN32 )
    target_compile_definitions( wxCLib PRIVATE
        PCRE2_CODE_UNIT_WIDTH=16
        NEWLINE_DEFAULT=2
        LINK_SIZE=2
        PARENS_NEST_LIMIT=250
        HEAP_LIMIT=20000000
        MATCH_LIMIT=10000000
        MATCH_LIMIT_DEPTH=10000000
        MAX_NAME_COUNT=10000
        MAX_NAME_SIZE=32
    )
else()
    target_compile_definitions( wxCLib PRIVATE
        PCRE2_CODE_UNIT_WIDTH=8
        NEWLINE_DEFAULT=2
        LINK_SIZE=2
        PARENS_NEST_LIMIT=250
        HEAP_LIMIT=20000000
        MATCH_LIMIT=10000000
        MATCH_LIMIT_DEPTH=10000000
        MAX_NAME_COUNT=10000
        MAX_NAME_SIZE=32
    )
endif()

target_precompile_headers( wxWidgets33 PRIVATE "include/wx/wxprec.h" )

target_include_directories( wxWidgets33 PRIVATE
    include
    src/tiff/libtiff
    src/jpeg
    src/png
    src/zlib
    3rdparty/pcre/src/wx
    src/expat/expat/lib

    # Needed for the wx_stc library
    src/stc/scintilla/include
    src/stc/lexilla/include
    src/stc/lexilla/access
    src/stc/lexilla/lexlib
    src/stc/scintilla/src

    3rdparty/lunasvg/include
    3rdparty/plutovg/include
)

target_include_directories( wxCLib PRIVATE
    include
    src/tiff/libtiff
    src/jpeg
    src/zlib
    3rdparty/pcre/src/wx
    src/expat/expat/lib
    3rdparty/plutovg/include
)

if( BUILD_SHARED_LIBS )
    if( WIN32 )
        target_link_libraries( wxWidgets33 PRIVATE wxCLib Winmm Ws2_32 Rpcrt4 Comctl32 )
    endif()
endif()

# Specify the input template
set( TEMPLATE_DIR ${CMAKE_SOURCE_DIR}/cmake )
set( TEMPLATE_FILE ${TEMPLATE_DIR}/wxSnapshotConfig.cmake.in )

# Create a Config.cmake file for the build tree
include( CMakePackageConfigHelpers )
configure_file(
    ${TEMPLATE_FILE}
    "${CMAKE_CURRENT_LIST_DIR}/wxSnapshotConfig.cmake"
    @ONLY
)
