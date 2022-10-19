# Lua, wxLua

_CAUTION!_ While you can build the libraries and all three executables, only the `lua` executable is fully functional. Expect to see significant changes both to the build process as well as the source code in the very near future. As long as this paragraph is here, consider this a work in progress that is only partially usable. Use at your own risk...

This sub-folder is primarily designed for some of the KeyWorks repositories that use wxLua. It contains snapshots of the development branches of both `Lua` and `wxLua`. Only the files necessary to build the libraries and the `lua.exe`, `wxLua.exe` and `wxLuaFreeze` executables are included here. See the original repositories for documentation, samples, etc.

- Lua (https://github.com/lua/lua) [LICENSE](LUA_LICENSE.md)
- wxLua (https://github.com/pkulchenko/wxlua) [LICENSE](WXLUA_LICENSE.md)

## Lua Differences

In this repository, `lua_all` is built as a single static library instead of three libraries.

## wxLua Differences

In this repository, `wxLua_all` is built as a single static library, and because it assumes that it will be used with the `wxWidgets` and `wxCLib` libraries that are built with this repository, it contains bindings to all of **wxWidgets**. This is in contrast to the official **wxLua** repository which builds a separate library for each wxWidgets module.

**wxWidgets** sometimes deprecates things in one release and removes them entirely in the following release. There are some functions that were deprecated in wxWidgets 3.1.2, and removed in wxWidgets 3.2.0. Since the wxWidgets snapshot here is at least current with the 3.2.0 release, the deprecated functions have been removed from the **wxLua** code.

## Building

The build process in this repository is much simpler than it is in the wxLua. Simply create a `build/` directory, run `cmake-gui`, click `configure` and then `generate`. You can nown run cmake the way you would with any other build script. Multi-build ninja configuration will give you the fastest build times.

## wxLua version number

The version for wxLua is set to the same version number as the wxWidgets version that is part of this repositories snapshot. That will generally be higher then the official **wxLua** repository version.
