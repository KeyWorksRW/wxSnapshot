# ############################################################################
# Purpose:     Common CMake functions for wxWidgets
# Author:      Tobias Taschner
# Created:     2016-09-20
# Copyright:   (c) 2016 wxWidgets development team
# Licence:     wxWindows licence
# ############################################################################

# ##############################################################################
#
# Modifications by KeyWorks Software
#
# ##############################################################################

include( CMakeDependentOption )
include( CMakePrintHelpers )

macro( wx_string_append var str )
    string( APPEND ${var} ${str} )
endmacro()

# Add a option and mark is as advanced if it starts with wxUSE_
# wx_option(<name> <desc> [default] [STRINGS strings])
# The default is ON if third parameter is not specified
function( wx_option name desc )
    cmake_parse_arguments( OPTION "" "" "STRINGS" ${ARGN} )

    if( ARGC EQUAL 2 )
        set( default ON )
    else()
        set( default ${OPTION_UNPARSED_ARGUMENTS} )
    endif()

    if( OPTION_STRINGS )
        set( cache_type STRING )
    else()
        set( cache_type BOOL )
    endif()

    set( ${name} "${default}" CACHE ${cache_type} "${desc}" )
    string( SUBSTRING ${name} 0 6 prefix )

    if( prefix STREQUAL "wxUSE_" )
        mark_as_advanced( ${name} )
    endif()

    if( OPTION_STRINGS )
        set_property( CACHE ${name} PROPERTY STRINGS ${OPTION_STRINGS} )

        # Check valid value
        set( value_is_valid FALSE )
        set( avail_values )

        foreach( opt ${OPTION_STRINGS} )
            if( ${name} STREQUAL opt )
                set( value_is_valid TRUE )
                break()
            endif()

            wx_string_append( avail_values " ${opt}" )
        endforeach()

        if( NOT value_is_valid )
            message( FATAL_ERROR "Invalid value \"${${name}}\" for option ${name}. Valid values are: ${avail_values}" )
        endif()
    endif()
endfunction()

# Force a new value for an option created with wx_option
function( wx_option_force_value name value )
    get_property( helpstring CACHE ${name} PROPERTY HELPSTRING )
    get_property( type CACHE ${name} PROPERTY TYPE )
    set( ${name} ${value} CACHE ${type} ${helpstring} FORCE )
endfunction()

macro( wx_dependent_option option doc default depends force )
    if( ${option}_ISSET MATCHES "^${option}_ISSET$" )
        set( ${option}_AVAILABLE 1 )

        foreach( d ${depends} )
            string( REGEX REPLACE " +" ";" CMAKE_DEPENDENT_OPTION_DEP "${d}" )

            if( ${CMAKE_DEPENDENT_OPTION_DEP} )
            else()
                set( ${option}_AVAILABLE 0 )
            endif()
        endforeach()

        if( ${option}_AVAILABLE )
            wx_option( ${option} "${doc}" "${default}" )
            set( ${option} "${${option}}" CACHE BOOL "${doc}" FORCE )
        else()
            if( ${option} MATCHES "^${option}$" )
            else()
                set( ${option} "${${option}}" CACHE INTERNAL "${doc}" )
            endif()

            set( ${option} ${force} )
        endif()
    else()
        set( ${option} "${${option}_ISSET}" )
    endif()
endmacro()
