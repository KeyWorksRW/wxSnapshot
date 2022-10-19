
// This header file is used to create a pre-compiled header for use in the entire project

#pragma once

#define wxUSE_GUI         1
#define wxUSE_NO_MANIFEST 1
#define wxUSE_UNICODE     1

#include <wx/defs.h>  // Declarations/definitions common to all wx source files

#if defined(__WINDOWS__)
    #include <wx/msw/wrapcctl.h>  // Wrapper for the standard <commctrl.h> header

    #if wxUSE_COMMON_DIALOGS
        #include <commdlg.h>
    #endif
#endif
