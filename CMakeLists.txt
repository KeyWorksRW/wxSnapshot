cmake_minimum_required(VERSION 3.20)

project(wxWidgets LANGUAGES CXX C)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_CXX_EXTENSIONS OFF)

if (MSVC)
    # /O1 often results in faster code than /O2 due to CPU caching
    string(REPLACE "/O2" "/O1" cl_optimize ${CMAKE_CXX_FLAGS_RELEASE})
    set(CMAKE_CXX_FLAGS_RELEASE ${cl_optimize} CACHE STRING "C++ Release flags" FORCE)

    string(REPLACE "/O2" "/O1" cl_optimize ${CMAKE_C_FLAGS_RELEASE})
    set(CMAKE_C_FLAGS_RELEASE ${cl_optimize} CACHE STRING "C Release flags" FORCE)

    # Using /Z7 instead of /Zi to avoid blocking while parallel compilers write to the pdb file.
    # This can considerably speed up build times at the cost of larger object files.
    string(REPLACE "/Zi" "/Z7" z_seven ${CMAKE_CXX_FLAGS_DEBUG})
    set(CMAKE_CXX_FLAGS_DEBUG ${z_seven} CACHE STRING "C++ Debug flags" FORCE)

    string(REPLACE "/Zi" "/Z7" z_seven ${CMAKE_C_FLAGS_DEBUG})
    set(CMAKE_C_FLAGS_DEBUG ${z_seven} CACHE STRING "C Debug flags" FORCE)
endif()

get_property(isMultiConfig GLOBAL
  PROPERTY GENERATOR_IS_MULTI_CONFIG
)

if (NOT isMultiConfig)
    message("\nBecause you are using a single target generator, you MUST specify")
    message("    a \"--config [Debug|Release]\" option with the cmake --build command\n")

    set(allowedBuildTypes Debug Release)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "${allowedBuildTypes}")

    if (NOT CMAKE_BUILD_TYPE)
        set(CMAKE_BUILD_TYPE Debug CACHE STRING "" FORCE)
    elseif (NOT CMAKE_BUILD_TYPE IN_LIST allowedBuildTypes)
        message(FATAL_ERROR "Unknown build type: ${CMAKE_BUILD_TYPE}")
    endif()
endif()

include(src/wxWidgets.cmake)  # This will set ${wxWidget_sources} and ${wxCLib_sources} with list of files

add_library(wxWidgets STATIC ${wxWidget_sources} )
add_library(wxCLib STATIC ${wxCLib_sources} )

if (MSVC)
    target_compile_definitions(wxWidgets PRIVATE
        __WXMSW__
        WIN32
    )
    target_compile_options(wxWidgets PRIVATE "$<$<CONFIG:Release>:/GL>")
endif()

target_compile_definitions(wxWidgets PRIVATE
    WXBUILDING
    _CRT_SECURE_NO_DEPRECATE=1
    _CRT_NON_CONFORMING_SWPRINTFS=1
    _SCL_SECURE_NO_WARNINGS=1
    wxUSE_UNICODE=1
    SCI_LEXER
    NO_CXX11_REGEX
    LINK_LEXERS
)

target_precompile_headers(wxWidgets PRIVATE "include/wx/wxprec.h")

target_include_directories(wxWidgets PRIVATE
    include
    if (WIN32)
        win
    endif()
    src/tiff/libtiff
    src/jpeg
    src/png
    src/zlib
    src/regex
    src/expat/expat/lib

    # Needed for the wx_stc library
    src/stc/scintilla/include
    src/stc/scintilla/lexlib
    src/stc/scintilla/src
)

target_include_directories(wxCLib PRIVATE
    include
    if (WIN32)
        win
    endif()
    src/tiff/libtiff
    src/jpeg
    src/zlib
    src/expat/expat/lib
)
