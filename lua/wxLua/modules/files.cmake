set (wxLua_sources

    # wxLua
    ${CMAKE_CURRENT_LIST_DIR}/wxLua/wxlbind.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxLua/wxlcallb.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxLua/wxlconsole.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxLua/wxllua.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxLua/wxlobject.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxLua/wxlstate.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxLua/wxlua_bind.cpp

    # wxAdv
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxadv_bind.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxadv_wxladv.cpp

    # wxAui
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxaui_bind.cpp

    # wxBase
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxbase_base.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxbase_bind.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxbase_config.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxbase_data.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxbase_datetime.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxbase_file.cpp

    # wxCore
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxcore_appframe.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxcore_bind.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxcore_clipdrag.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxcore_controls.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxcore_core.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxcore_defsutils.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxcore_dialogs.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxcore_event.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxcore_gdi.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxcore_geometry.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxcore_graphics.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxcore_help.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxcore_image.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxcore_mdi.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxcore_menutool.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxcore_picker.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxcore_print.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxcore_sizer.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxcore_windows.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxcore_wxlcore.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxwebview_bind.cpp

    # wxGl
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxgl_bind.cpp

    # wxHtml
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxhtml_bind.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxhtml_wxlhtml.cpp

    # wxMedia
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxmedia_bind.cpp

    # wxNet
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxnet_bind.cpp

    # wxRichtext
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxrichtext_bind.cpp

    # wxStc
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxstc_bind.cpp

    # wxXml
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxxml_bind.cpp

    # wxXrc
    ${CMAKE_CURRENT_LIST_DIR}/wxBind/src/wxxrc_bind.cpp

)

set (lua_bitlib_sources

    ${CMAKE_CURRENT_LIST_DIR}/wxlua/bit.c
    ${CMAKE_CURRENT_LIST_DIR}/wxlua/lbitlib.c

)

set (wxLua_debug_sources

    ${CMAKE_CURRENT_LIST_DIR}/wxLua/debugger/wxldserv.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxLua/debugger/wxldtarg.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxLua/debugger/wxlsock.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxLua/debugger/wxluadebugger_bind.cpp

    ${CMAKE_CURRENT_LIST_DIR}/wxLua/debug/wxldebug.cpp
    ${CMAKE_CURRENT_LIST_DIR}/wxLua/debug/wxlstack.cpp

)
