cmake_minimum_required(VERSION 3.20)

project(wxLua LANGUAGES CXX C)

# This will build three libraries (lua_all, wxLua_all and lua_bitlib) and
# two executables (wxLua and wxLuaFreeze)

# While there are some settings for non-Windows platforms, they are not tested or currently used.

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_CXX_EXTENSIONS OFF)

set(wxLua_VERSION           "3.2.0.0")
set(wxLua_MAJOR_VERSION     "3")
set(wxLua_MINOR_VERSION     "2")
set(wxLua_RELEASE_VERSION   "5")
set(wxLua_SUBRELEASE_NUMBER "4")

if (MSVC)
    # /O1 often results in faster code than /O2 due to CPU caching
    string(REPLACE "/O2" "/O1" cl_optimize "${CMAKE_CXX_FLAGS_RELEASE}")
    set(CMAKE_CXX_FLAGS_RELEASE ${cl_optimize} CACHE STRING "C++ Release flags" FORCE)

    string(REPLACE "/O2" "/O1" cl_optimize "${CMAKE_C_FLAGS_RELEASE}")
    set(CMAKE_C_FLAGS_RELEASE ${cl_optimize} CACHE STRING "C Release flags" FORCE)

    # Using /Z7 instead of /Zi to avoid blocking while parallel compilers write to the pdb file.
    # This can considerably speed up build times at the cost of larger object files.
    string(REPLACE "/Zi" "/Z7" z_seven "${CMAKE_CXX_FLAGS_DEBUG}")
    set(CMAKE_CXX_FLAGS_DEBUG ${z_seven} CACHE STRING "C++ Debug flags" FORCE)

    string(REPLACE "/Zi" "/Z7" z_seven "${CMAKE_C_FLAGS_DEBUG}")
    set(CMAKE_C_FLAGS_DEBUG ${z_seven} CACHE STRING "C Debug flags" FORCE)

    # Use static runtime for Release builds to run with Wine without needing to install the dlls
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
else()
    # This should work for gcc and clang (including xcode which is based on clang)
    # -O2 can result in faster code than -O3 due to CPU caching.
    string(REPLACE "-O3" "-O2" cl_optimize "${CMAKE_CXX_FLAGS_RELEASE}")
    set(CMAKE_CXX_FLAGS_RELEASE ${cl_optimize} CACHE STRING "C++ Release flags" FORCE)
    string(REPLACE "-O3" "-O2" cl_optimize "${CMAKE_C_FLAGS_RELEASE}")
    set(CMAKE_C_FLAGS_RELEASE ${cl_optimize} CACHE STRING "C Release flags" FORCE)
endif()

get_property(isMultiConfig GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)

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

set (widget_dir ${CMAKE_CURRENT_LIST_DIR}/..)
set (widget_lib_dir ${CMAKE_CURRENT_LIST_DIR}/../build)

if (WIN32)
    set(setup_dir ${CMAKE_CURRENT_LIST_DIR}/../win)
endif()

include(lua_src/files.cmake)        # This will set ${lua_sources} with list of files
include(wxLua/modules/files.cmake)  # This will set ${wxLua_sources} with list of files

add_library(lua_all STATIC      ${lua_sources} )
add_library(wxLua_all STATIC    ${wxLua_sources} )
add_library(lua_bitlib STATIC   ${lua_bitlib_sources} )
add_library(wxLua_debug STATIC  ${wxLua_debug_sources} )

add_executable(lua
    lua_src/lua.c
)
target_link_libraries(lua PRIVATE lua_all)

add_executable(wxLua WIN32
    wxLua/apps/wxlua/wxlua.cpp
    wxLua/apps/wxlua/wxlua.rc
)

    add_executable(wxLuaFreeze WIN32
    wxLua/apps/wxluafreeze/wxluafreeze.cpp
)

if (MSVC)
    # /GL -- combined with the Linker flag /LTCG to perform whole program optimization in Release build
    # /FC -- Full path to source code file in diagnostics
    target_compile_options(wxLua PRIVATE "$<$<CONFIG:Release>:/GL>" "/FC" "/W4" "/Zc:__cplusplus" "/utf-8")
    target_link_options(wxLua PRIVATE "$<$<CONFIG:Release>:/LTCG>")

    target_compile_options(wxLuaFreeze PRIVATE "$<$<CONFIG:Release>:/GL>" "/FC" "/W4" "/Zc:__cplusplus" "/utf-8")
    target_link_options(wxLuaFreeze PRIVATE "$<$<CONFIG:Release>:/LTCG>")

    # Assume the manifest is in the resource file
    # target_link_options(wxLua PRIVATE "/manifest:no")
endif()

if (WIN32)
    target_link_libraries(wxLua PRIVATE lua_all wxLua_all lua_bitlib wxLua_debug
        wxCLib wxWidgets
        rpcrt4.lib advapi32.lib wininet.lib comctl32 Imm32 Shlwapi Version UxTheme WS2_32 Winmm)
    target_link_libraries(wxLuaFreeze PRIVATE lua_all wxLua_all lua_bitlib wxLua_debug
        wxCLib wxWidgets
        rpcrt4.lib advapi32.lib wininet.lib comctl32 Imm32 Shlwapi Version UxTheme WS2_32 Winmm)
else()
    target_link_libraries(wxLua PRIVATE lua_all wxLua_all lua_bitlib wxLua_debug
        wxCLib wxWidgets)
    target_link_libraries(wxLuaFreeze PRIVATE lua_all wxLua_all lua_bitlib wxLua_debug
        wxCLib wxWidgets)
endif()

# LUA_COMPAT is normally set to the previous version of the current Lua library
target_compile_definitions(wxLua_all PRIVATE LUA_COMPAT_5_3 wxUSE_UNICODE=1 wxUSE_GUI=1)

target_precompile_headers(wxLua_all PRIVATE "../include/wx/wxprec.h")
target_precompile_headers(wxLua PRIVATE "wxLua/apps/pch.h")
target_precompile_headers(wxLuaFreeze PRIVATE "wxLua/apps/pch.h")

target_include_directories(lua_all PRIVATE
    lua_src/
)

target_include_directories(lua_bitlib PRIVATE
    lua_src/
)

target_include_directories(wxLua_all PRIVATE
    ${setup_dir}
    ../include
    wxLua/modules/wxBind/setup/
    wxLua/modules/
    lua_src/
)

target_include_directories(wxLua_debug PRIVATE
    ${setup_dir}
    ../include
    wxLua/modules/wxBind/setup/
    wxLua/modules/
    lua_src/
)

target_include_directories(lua PRIVATE
    lua_src/
)

target_include_directories(wxLua PRIVATE
    ${setup_dir}
    ../include
    wxLua/modules/wxBind/setup/
    wxLua/modules/
    wxLua/
    lua_src/
)

target_include_directories(wxLuaFreeze PRIVATE
    ${setup_dir}
    ../include
    wxLua/modules/wxBind/setup/
    wxLua/modules/
    wxLua/
    lua_src/
)

# Currently we don't build the two wxWidgets libraries, which means we are hard-coding
# them to the build/ directory.  This is not ideal, but it works for now.
target_link_directories(wxLua PRIVATE
    $<$<CONFIG:Debug>:${widget_lib_dir}/Debug>
    $<$<CONFIG:Release>:${widget_lib_dir}/Release>
)

target_link_directories(wxLuaFreeze PRIVATE
    $<$<CONFIG:Debug>:${widget_lib_dir}/Debug>
    $<$<CONFIG:Release>:${widget_lib_dir}/Release>
)
