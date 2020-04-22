#
# CMake Script by Olivier Le Doeuff
# Copyright (c) 2019 - All Right Reserved
# add_qt_ios_app help you deploy iOs application with Qt.
#

cmake_minimum_required(VERSION 3.0.0 FATAL_ERROR)

# find the Qt root directoryn might break in future release
# Dependant on Qt5
if(NOT Qt5Core_DIR)
    find_package(Qt5Core REQUIRED)
endif(NOT Qt5Core_DIR)
get_filename_component(QT_IOS_QT_ROOT "${Qt5Core_DIR}/../../.." ABSOLUTE)

if(QT_IOS_QT_ROOT)
    message(STATUS "Found Qt Sdk for Ios: ${QT_IOS_QT_ROOT}")
else(QT_IOS_QT_ROOT)
    message(FATAL_ERROR "Fail to find Qt Sdk path.")
endif(QT_IOS_QT_ROOT)

# Keep track of our own directory for future use (and default value of plist.in)
set(QT_IOS_SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR})

# This little macro lets you set any Xcode specific property.
# This is from iOs CMake Toolchain
macro(qt_ios_set_xcode_property TARGET XCODE_PROPERTY XCODE_VALUE XCODE_RELVERSION)
  set(XCODE_RELVERSION_I "${XCODE_RELVERSION}")
  if(XCODE_RELVERSION_I STREQUAL "All")
    set_property(TARGET ${TARGET} PROPERTY XCODE_ATTRIBUTE_${XCODE_PROPERTY} "${XCODE_VALUE}")
  else()
    set_property(TARGET ${TARGET} PROPERTY XCODE_ATTRIBUTE_${XCODE_PROPERTY}[variant=${XCODE_RELVERSION_I}] "${XCODE_VALUE}")
  endif()
endmacro() # qt_ios_set_xcode_property

# We need that to parse arguments
include(CMakeParseArguments)

# Usage :
# add_qt_ios_app(MyApp
#    NAME "My App"
#    BUNDLE_IDENTIFIER "com.company.app"
#    VERSION "1.2.3"
#    SHORT_VERSION "1.2.3"
#    LONG_VERSION "1.2.3.456"
#    CUSTOM_PLIST "path/to/MacOSXBundleInfo.plist.in"
#    CODE_SIGN_IDENTITY "iPhone Developer"
#    TEAM_ID "AAAAAAAA"
#    COPYRIGHT "My Cool Copyright"
#    QML_DIR "${QT_IOS_QT_ROOT}/qml"
#    ASSET_DIR "path/to/Assets.xcassets"
#    MAIN_STORYBOARD "/path/to/Main.storyboard"
#        LAUNCHSCREEN_STORYBOARD "path/to/LaunchScreen.storyboard"
#        CATALOG_APPICON "AppIcon"
#        CATALOG_LAUNCHIMAGE "LaunchImage"
#    ORIENTATION_PORTRAIT
#    ORIENTATION_PORTRAIT_UPSIDEDOWN
#    ORIENTATION_LANDSCAPELEFT
#    ORIENTATION_LANDSCAPERIGHT
#    SUPPORT_IPHONE
#    SUPPORT_IPAD
#    REQUIRES_FULL_SCREEN
#    HIDDEN_STATUS_BAR
#    VERBOSE
# )
macro(add_qt_ios_app TARGET)

    set(QT_IOS_OPTIONS VERBOSE
        ORIENTATION_PORTRAIT
        ORIENTATION_PORTRAIT_UPDOWN
        ORIENTATION_LANDSCAPE_LEFT
        ORIENTATION_LANDSCAPE_RIGHT
        SUPPORT_IPHONE
        SUPPORT_IPAD
        REQUIRES_FULL_SCREEN
        HIDDEN_STATUS_BAR
        )
    set(QT_IOS_ONE_VALUE_ARG NAME
        BUNDLE_IDENTIFIER
        VERSION
        SHORT_VERSION
        LONG_VERSION
        CUSTOM_PLIST
        CODE_SIGN_IDENTITY
        TEAM_ID
        COPYRIGHT
        QML_DIR
        ASSET_DIR
        LAUNCHSCREEN_STORYBOARD
        MAIN_STORYBOARD
        CATALOG_APPICON
        CATALOG_LAUNCHIMAGE
        )
    set(QT_IOS_MULTI_VALUE_ARG )
     # parse the macro arguments
    cmake_parse_arguments(ARGIOS "${QT_IOS_OPTIONS}" "${QT_IOS_ONE_VALUE_ARG}" "${QT_IOS_MULTI_VALUE_ARG}" ${ARGN})

    # Copy arg variables to local variables
    set(QT_IOS_TARGET ${TARGET})
    set(QT_IOS_NAME ${ARGIOS_NAME})
    set(QT_IOS_BUNDLE_IDENTIFIER ${ARGIOS_BUNDLE_IDENTIFIER})
    set(QT_IOS_VERSION ${ARGIOS_VERSION})
    set(QT_IOS_SHORT_VERSION ${ARGIOS_SHORT_VERSION})
    set(QT_IOS_LONG_VERSION ${ARGIOS_LONG_VERSION})
    set(QT_IOS_CUSTOM_PLIST ${ARGIOS_CUSTOM_PLIST})
    if(NOT QT_IOS_CODE_SIGN_IDENTITY)
        set(QT_IOS_CODE_SIGN_IDENTITY ${ARGIOS_CODE_SIGN_IDENTITY})
    endif() # NOT QT_IOS_CODE_SIGN_IDENTITY
    if(NOT QT_IOS_TEAM_ID)
        set(QT_IOS_TEAM_ID ${ARGIOS_TEAM_ID})
    endif() # NOT QT_IOS_TEAM_ID
    set(QT_IOS_COPYRIGHT ${ARGIOS_COPYRIGHT})
    set(QT_IOS_QML_DIR ${ARGIOS_QML_DIR})
    set(QT_IOS_ASSET_DIR ${ARGIOS_ASSET_DIR})
    set(QT_IOS_LAUNCHSCREEN_STORYBOARD ${ARGIOS_LAUNCHSCREEN_STORYBOARD})
    set(QT_IOS_MAIN_STORYBOARD ${ARGIOS_MAIN_STORYBOARD})
    set(QT_IOS_CATALOG_APPICON ${ARGIOS_CATALOG_APPICON})
    set(QT_IOS_CATALOG_LAUNCHIMAGE ${ARGIOS_CATALOG_LAUNCHIMAGE})

    set(QT_IOS_ORIENTATION_PORTRAIT ${ARGIOS_ORIENTATION_PORTRAIT})
    set(QT_IOS_ORIENTATION_PORTRAIT_UPDOWN ${ARGIOS_ORIENTATION_PORTRAIT_UPDOWN})
    set(QT_IOS_ORIENTATION_LANDSCAPE_LEFT ${ARGIOS_ORIENTATION_LANDSCAPE_LEFT})
    set(QT_IOS_ORIENTATION_LANDSCAPE_RIGHT ${ARGIOS_ORIENTATION_LANDSCAPE_RIGHT})
    set(QT_IOS_SUPPORT_IPHONE ${ARGIOS_SUPPORT_IPHONE})
    set(QT_IOS_SUPPORT_IPAD ${ARGIOS_SUPPORT_IPAD})
    set(QT_IOS_REQUIRES_FULL_SCREEN ${ARGIOS_REQUIRES_FULL_SCREEN})
    set(QT_IOS_HIDDEN_STATUS_BAR ${ARGIOS_HIDDEN_STATUS_BAR})

    set(QT_IOS_VERBOSE ${ARGIOS_VERBOSE})

    # Warning if no default BUNDLE_IDENTIFIER is set
    if(NOT ARGIOS_BUNDLE_IDENTIFIER)
        if(QT_IOS_VERBOSE)
            message(WARNING "BUNDLE_IDENTIFIER not set when calling add_qt_ios_app. You will need to fix this by hand in XCode")
        endif() # QT_IOS_VERBOSE
    endif() # NOT ARGIOS_BUNDLE_IDENTIFIER

    # Warning if no version
    if(NOT ARGIOS_VERSION)
        if(QT_IOS_VERBOSE)
            message(WARNING "VERSION not set when calling add_qt_ios_app. This might result in warning in XCode")
        endif() # QT_IOS_VERBOSE
    endif() # NOT ARGIOS_VERSION

    # Default value for SHORT_VERSION
    if(NOT QT_IOS_SHORT_VERSION)
        if(QT_IOS_VERBOSE)
            message(STATUS "SHORT_VERSION not specified, default to VERSION")
        endif() # QT_IOS_VERBOSE
        set(QT_IOS_SHORT_VERSION ${ARGIOS_VERSION})
    endif() # NOT QT_IOS_SHORT_VERSION

    # Default value for long version
    if(NOT QT_IOS_LONG_VERSION)
        if(QT_IOS_VERBOSE)
            message(STATUS "LONG_VERSION not specified, default to VERSION")
        endif() # QT_IOS_VERBOSE
        set(QT_IOS_LONG_VERSION ${ARGIOS_VERSION})
    endif() # NOT QT_IOS_LONG_VERSION

    # Default value for plist file
    if(NOT QT_IOS_CUSTOM_PLIST)
        set(QT_IOS_CUSTOM_PLIST ${QT_IOS_SOURCE_DIR}/MacOSXBundleInfo.plist.in)
        if(QT_IOS_VERBOSE)
            message(STATUS "CUSTOM_PLIST not specified, default to ${QT_IOS_CUSTOM_PLIST}")
        endif() # QT_IOS_VERBOSE
    endif() # NOT QT_IOS_CUSTOM_PLIST

    # Default for qml dir set to qt sdk root
    if(NOT QT_IOS_QML_DIR)
        set(QT_IOS_QML_DIR "${QT_IOS_QT_ROOT}/qml")
        if(QT_IOS_VERBOSE)
            message(STATUS "QML_DIR not specified, default to ${QT_IOS_QML_DIR}")
        endif() # QT_IOS_VERBOSE
    endif() # NOT QT_IOS_QML_DIR

    # Warning, somework will be required in XCode
    if(NOT QT_IOS_CODE_SIGN_IDENTITY)
        set(QT_IOS_CODE_SIGN_IDENTITY "iPhone Developer")
        if(QT_IOS_VERBOSE)
            message(WARNING "CODE_SIGN_IDENTITY not specified, default to ${QT_IOS_CODE_SIGN_IDENTITY}. You might need to set it in XCode")
        endif() # QT_IOS_VERBOSE
    endif() # NOT QT_IOS_CODE_SIGN_IDENTITY

    # Warning, somework will be required in XCode
    if(NOT QT_IOS_TEAM_ID)
        set(QT_IOS_TEAM_ID "AAAAAAAA")
        if(QT_IOS_VERBOSE)
            message(WARNING "TEAM_ID not specified, default to ${QT_IOS_TEAM_ID}. You might need to set it in XCode")
        endif() # QT_IOS_VERBOSE
    endif() # NOT QT_IOS_TEAM_ID

    if(NOT QT_IOS_CATALOG_APPICON)
        set(QT_IOS_CATALOG_APPICON "AppIcon")
        if(QT_IOS_VERBOSE)
            message(STATUS "CATALOG_APPICON not specified, default to ${QT_IOS_CATALOG_APPICON}.")
        endif() # QT_IOS_VERBOSE
    endif() # NOT QT_IOS_CATALOG_APPICON

    if(NOT QT_IOS_CATALOG_LAUNCHIMAGE)
        set(QT_IOS_CATALOG_LAUNCHIMAGE "LaunchImage")
        if(QT_IOS_VERBOSE)
            message(STATUS "CATALOG_LAUNCHIMAGE not specified, default to ${QT_IOS_CATALOG_LAUNCHIMAGE}.")
        endif() # QT_IOS_VERBOSE
    endif() # NOT QT_IOS_CATALOG_LAUNCHIMAGE

    # Print macro configuration
    if(QT_IOS_VERBOSE)
        message(STATUS "------ QtIosCMake Configuration ------")
        message(STATUS "TARGET                              : ${QT_IOS_TARGET}")
        message(STATUS "NAME                                : ${QT_IOS_NAME}")
        message(STATUS "BUNDLE_IDENTIFIER                   : ${QT_IOS_BUNDLE_IDENTIFIER}")
        message(STATUS "VERSION                             : ${QT_IOS_VERSION}")
        message(STATUS "SHORT_VERSION                       : ${QT_IOS_SHORT_VERSION}")
        message(STATUS "LONG_VERSION                        : ${QT_IOS_LONG_VERSION}")
        message(STATUS "CUSTOM_PLIST                        : ${QT_IOS_CUSTOM_PLIST}")
        message(STATUS "CODE_SIGN_IDENTITY                  : ${QT_IOS_CODE_SIGN_IDENTITY}")
        message(STATUS "TEAM_ID                             : ${QT_IOS_TEAM_ID}")
        message(STATUS "COPYRIGHT                           : ${QT_IOS_COPYRIGHT}")
        message(STATUS "QML_DIR                             : ${QT_IOS_QML_DIR}")
        message(STATUS "ASSET_DIR                           : ${QT_IOS_ASSET_DIR}")
        message(STATUS "CATALOG_APPICON                     : ${QT_IOS_CATALOG_APPICON}")
        message(STATUS "CATALOG_LAUNCHIMAGE                 : ${QT_IOS_CATALOG_LAUNCHIMAGE}")
        message(STATUS "LAUNCHSCREEN_STORYBOARD             : ${QT_IOS_LAUNCHSCREEN_STORYBOARD}")
        message(STATUS "MAIN_STORYBOARD                     : ${QT_IOS_MAIN_STORYBOARD}")
        message(STATUS "ORIENTATION_PORTRAIT                : ${QT_IOS_ORIENTATION_PORTRAIT}")
        message(STATUS "ORIENTATION_PORTRAIT_UPDOWN         : ${QT_IOS_ORIENTATION_PORTRAIT_UPDOWN}")
        message(STATUS "ORIENTATION_LANDSCAPE_LEFT          : ${QT_IOS_ORIENTATION_LANDSCAPE_LEFT}")
        message(STATUS "ORIENTATION_LANDSCAPE_RIGHT         : ${QT_IOS_ORIENTATION_LANDSCAPE_RIGHT}")
        message(STATUS "SUPPORT_IPHONE                      : ${QT_IOS_SUPPORT_IPHONE}")
        message(STATUS "SUPPORT_IPAD                        : ${QT_IOS_SUPPORT_IPAD}")
        message(STATUS "REQUIRES_FULL_SCREEN                : ${QT_IOS_REQUIRES_FULL_SCREEN}")
        message(STATUS "HIDDEN_STATUS_BAR                   : ${QT_IOS_HIDDEN_STATUS_BAR}")
        message(STATUS "------ QtIosCMake END Configuration ------")
    endif() # QT_IOS_VERBOSE

    # Bundle executable.
    if(QT_IOS_VERBOSE)
        message(STATUS "Set property MACOSX_BUNDLE to ${QT_IOS_TARGET}")
    endif() # QT_IOS_VERBOSE
    set_target_properties(${QT_IOS_TARGET} PROPERTIES MACOSX_BUNDLE ON)

    # Qt Mess
    function(qt_ios_clean_paths)
        foreach(_path_group ${ARGN})
            foreach(_path ${${_path_group}})
                get_filename_component(_path_cleaned ${_path} REALPATH)
                file(TO_NATIVE_PATH ${_path_cleaned} _path_cleaned)
                set(_path_group_cleaned ${_path_group_cleaned} ${_path_cleaned})
            endforeach()
        set(${_path_group} ${_path_group_cleaned} PARENT_SCOPE)
        endforeach()
    endfunction()

    macro(qt_ios_handle_cyclical_linking LIBS)
        if(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX OR (CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND NOT APPLE))
            set(${LIBS} -Wl,--start-group ${${LIBS}} -Wl,--end-group)
        endif()
    endmacro()

    # let's not be picky, just throw all the available static libraries at the linker and let it figure out which ones are actually needed
    # a 'foreach' is used because 'target_link_libraries' doesn't handle lists correctly (the ; messes it up and nothing actually gets linked against)
    if(QT_IOS_TARGET_IS_WINDOWS)
        set(_DEBUG_SUFFIX d)
    elseif(QT_IOS_TARGET_IS_IOS OR QT_IOS_TARGET_IS_MAC)
        set(_DEBUG_SUFFIX _debug)
    else()
        set(_DEBUG_SUFFIX)
    endif()

    set(_LIBS_BASE_DIR "${QT_IOS_QT_ROOT}/lib")
    qt_ios_clean_paths(_LIBS_BASE_DIR)
    file(GLOB_RECURSE _QT_LIBS "${_LIBS_BASE_DIR}/*${CMAKE_STATIC_LIBRARY_SUFFIX}")
    foreach(_QT_LIB ${_QT_LIBS})
        string(REGEX MATCH ".*${_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}$" _IS_DEBUG_LIB ${_QT_LIB})
        string(REGEX MATCH ".*_iphonesimulator${_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}$" _IS_DEBUG_SIM_LIB ${_QT_LIB})
        string(REGEX MATCH ".*_iphonesimulator${CMAKE_STATIC_LIBRARY_SUFFIX}$" _IS_SIM_LIB ${_QT_LIB})
        string(REGEX MATCH ".*Qt5Bootstrap.*" _IS_BOOTSTRAP ${_QT_LIB})
        string(REGEX MATCH ".*Qt5QmlDevTools.*" _IS_DEVTOOLS ${_QT_LIB})

        if(NOT _IS_BOOTSTRAP AND NOT _IS_DEVTOOLS AND NOT _IS_DEBUG_SIM_LIB AND NOT _IS_SIM_LIB)
            if(_IS_DEBUG_LIB OR NOT _DEBUG_SUFFIX)
                set(QT_EXTRA_LIBS ${QT_EXTRA_LIBS} debug "${_QT_LIB}")
            endif()
            if(NOT _IS_DEBUG_LIB OR NOT _DEBUG_SUFFIX)
                set(QT_EXTRA_LIBS ${QT_EXTRA_LIBS} optimized "${_QT_LIB}")
            endif()
        endif()
    endforeach()

    set(_QML_BASE_DIR "${QT_IOS_QML_DIR}")
    qt_ios_clean_paths(_QML_BASE_DIR)
    file(GLOB_RECURSE _QML_PLUGINS "${_QML_BASE_DIR}/*${CMAKE_STATIC_LIBRARY_SUFFIX}")
    foreach(_QML_PLUGIN ${_QML_PLUGINS})
        string(REGEX MATCH ".*${_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}$" _IS_DEBUG_LIB ${_QML_PLUGIN})
        string(REGEX MATCH ".*_iphonesimulator${_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}$" _IS_DEBUG_SIM_LIB ${_QML_PLUGIN})
        string(REGEX MATCH ".*_iphonesimulator${CMAKE_STATIC_LIBRARY_SUFFIX}$" _IS_SIM_LIB ${_QML_PLUGIN})

        if(NOT _IS_DEBUG_SIM_LIB AND NOT _IS_SIM_LIB)
            if(_IS_DEBUG_LIB OR NOT _DEBUG_SUFFIX)
                set(QT_EXTRA_LIBS ${QT_EXTRA_LIBS} debug "${_QML_PLUGIN}")
            endif()
            if(NOT _IS_DEBUG_LIB OR NOT _DEBUG_SUFFIX)
                set(QT_EXTRA_LIBS ${QT_EXTRA_LIBS} optimized "${_QML_PLUGIN}")
            endif()
        endif()
    endforeach()

    set(_PLUGINS_BASE_DIR "${QT_IOS_QT_ROOT}/plugins")
    qt_ios_clean_paths(_PLUGINS_BASE_DIR)
    file(GLOB_RECURSE _QT_PLUGINS "${_PLUGINS_BASE_DIR}/*${CMAKE_STATIC_LIBRARY_SUFFIX}")
    foreach(_QT_PLUGIN ${_QT_PLUGINS})
        string(REGEX MATCH ".*${_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}$" _IS_DEBUG_LIB ${_QT_PLUGIN})
        string(REGEX MATCH ".*_iphonesimulator${_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}$" _IS_DEBUG_SIM_LIB ${_QT_PLUGIN})
        string(REGEX MATCH ".*_iphonesimulator${CMAKE_STATIC_LIBRARY_SUFFIX}$" _IS_SIM_LIB ${_QT_PLUGIN})

        if(NOT _IS_DEBUG_SIM_LIB AND NOT _IS_SIM_LIB)
            if(_IS_DEBUG_LIB OR NOT _DEBUG_SUFFIX)
                set(QT_EXTRA_LIBS ${QT_EXTRA_LIBS} debug "${_QT_PLUGIN}")
            endif()
            if(NOT _IS_DEBUG_LIB OR NOT _DEBUG_SUFFIX)
                set(QT_EXTRA_LIBS ${QT_EXTRA_LIBS} optimized "${_QT_PLUGIN}")
            endif()
        endif()
    endforeach()

    # Set almost every framework as extra library, may require some clean in the future.
    set(QT_EXTRA_LIBS ${QT_EXTRA_LIBS}
        "-framework Foundation -framework AVFoundation -framework SystemConfiguration -framework AssetsLibrary -framework OpenGLES \
        -framework CoreText -framework QuartzCore -framework CoreGraphics -framework ImageIO -framework Security -framework UIKit -framework WebKit \
        -framework CoreBluetooth -framework MobileCoreServices -framework QuickLook -framework AudioToolbox -framework CoreLocation \
        -framework Accelerate -framework CoreMedia -framework CoreVideo -framework MediaToolbox -framework MediaPlayer -framework GameController -framework CoreMotion -framework StoreKit -weak_framework Metal -lz"
        )

    # static linking
    set(QT_LIBRARIES ${QT_LIBRARIES} ${QT_EXTRA_LIBS})
    qt_ios_handle_cyclical_linking(QT_LIBRARIES)

    # Define entry point for correct initialization.
    # Maybe set this optionnal in the future if user wants to set his own entry point ?
    if(QT_IOS_VERBOSE)
        message(STATUS "Add -e _qt_main_wrapper linker flag to ${QT_IOS_TARGET} to change application entry point to create UIApplication before QApplication")
    endif() # QT_IOS_VERBOSE
    target_link_libraries(${QT_IOS_TARGET} PUBLIC ${QT_LIBRARIES} "-e _qt_main_wrapper")

    # Set XCode property for automatic code sign
    qt_ios_set_xcode_property(${QT_IOS_TARGET} CODE_SIGN_IDENTITY ${QT_IOS_CODE_SIGN_IDENTITY} "All")
    qt_ios_set_xcode_property(${QT_IOS_TARGET} DEVELOPMENT_TEAM ${QT_IOS_TEAM_ID} "All")

    # Ugly but working
    if(QT_IOS_SUPPORT_IPAD AND QT_IOS_SUPPORT_IPHONE)
        qt_ios_set_xcode_property(${QT_IOS_TARGET} TARGETED_DEVICE_FAMILY "1,2" "All")
    elseif(QT_IOS_SUPPORT_IPAD)
        qt_ios_set_xcode_property(${QT_IOS_TARGET} TARGETED_DEVICE_FAMILY "2" "All")
    else()
        qt_ios_set_xcode_property(${QT_IOS_TARGET} TARGETED_DEVICE_FAMILY "1" "All")
    endif()

    # Set AppIcon Catalog
    qt_ios_set_xcode_property (${QT_IOS_TARGET} ASSETCATALOG_COMPILER_APPICON_NAME ${QT_IOS_CATALOG_APPICON} "All")
    # Set LaunchImage Catalog
    qt_ios_set_xcode_property (${QT_IOS_TARGET} ASSETCATALOG_COMPILER_LAUNCHIMAGE_NAME ${QT_IOS_CATALOG_LAUNCHIMAGE} "All")

    # Set CMake variables for plist
    set(MACOSX_BUNDLE_EXECUTABLE_NAME ${QT_IOS_NAME})
    set(MACOSX_BUNDLE_INFO_STRING ${QT_IOS_NAME})
    set(MACOSX_BUNDLE_GUI_IDENTIFIER ${QT_IOS_BUNDLE_IDENTIFIER})
    set(MACOSX_BUNDLE_BUNDLE_NAME ${QT_IOS_NAME})
    #set(MACOSX_BUNDLE_ICON_FILE "${PROJECT_SOURCE_DIR}/platform/ios/Assets.xcassets/AppIcon.appiconset")
    set(MACOSX_BUNDLE_BUNDLE_VERSION ${QT_IOS_VERSION})
    set(MACOSX_BUNDLE_SHORT_VERSION_STRING ${QT_IOS_SHORT_VERSION})
    set(MACOSX_BUNDLE_LONG_VERSION_STRING ${QT_IOS_LONG_VERSION})
    set(MACOSX_BUNDLE_COPYRIGHT ${QT_IOS_COPYRIGHT})

    # Set require full screen
    if(QT_IOS_REQUIRES_FULL_SCREEN)
        set(MACOSX_BUNDLE_REQUIRES_FULL_SCREEN "YES")
        if(QT_IOS_VERBOSE)
            message(STATUS "Add UIRequiresFullScreen flag to Info.pList")
        endif() # QT_IOS_VERBOSE
    else() # QT_IOS_REQUIRES_FULL_SCREEN
        set(MACOSX_BUNDLE_REQUIRES_FULL_SCREEN "NO")
    endif() # QT_IOS_REQUIRES_FULL_SCREEN

    # Set hidden status bar
    if(QT_IOS_HIDDEN_STATUS_BAR)
        set(MACOSX_BUNDLE_HIDDEN_STATUS_BAR "true")
        if(QT_IOS_VERBOSE)
            message(STATUS "Add UIStatusBarHidden flag to Info.pList")
        endif() # QT_IOS_VERBOSE
    else() # QT_IOS_HIDDEN_STATUS_BAR
        set(MACOSX_BUNDLE_HIDDEN_STATUS_BAR "false")
    endif() # QT_IOS_HIDDEN_STATUS_BAR

    # Add orientation flags
    if(QT_IOS_ORIENTATION_PORTRAIT)
        set(MACOSX_BUNDLE_PORTRAIT "UIInterfaceOrientationPortrait")
        if(QT_IOS_VERBOSE)
            message(STATUS "Add UIInterfaceOrientationPortrait flag to Info.pList")
        endif() # QT_IOS_VERBOSE
    endif()
    if(QT_IOS_ORIENTATION_PORTRAIT_UPDOWN)
        set(MACOSX_BUNDLE_PORTRAITUPDOWN "UIInterfaceOrientationPortraitUpsideDown")
        if(QT_IOS_VERBOSE)
            message(STATUS "Add UIInterfaceOrientationPortraitUpsideDown flag to Info.pList")
        endif() # QT_IOS_VERBOSE
    endif()
    if(QT_IOS_ORIENTATION_LANDSCAPE_LEFT)
        set(MACOSX_BUNDLE_LANDSCAPELEFT "UIInterfaceOrientationLandscapeLeft")
        if(QT_IOS_VERBOSE)
            message(STATUS "Add UIInterfaceOrientationLandscapeLeft flag to Info.pList")
        endif() # QT_IOS_VERBOSE
    endif()
    if(QT_IOS_ORIENTATION_LANDSCAPE_RIGHT)
        set(MACOSX_BUNDLE_LANDSCAPERIGHT "UIInterfaceOrientationLandscapeRight")
        if(QT_IOS_VERBOSE)
            message(STATUS "Add UIInterfaceOrientationLandscapeRight flag to Info.pList")
        endif() # QT_IOS_VERBOSE
    endif()

    # Set Custom pList
    set_target_properties(${QT_IOS_TARGET} PROPERTIES MACOSX_BUNDLE_INFO_PLIST ${QT_IOS_CUSTOM_PLIST})

    # Add asset dir as ressource
    if(QT_IOS_ASSET_DIR)
        target_sources(${QT_IOS_TARGET} PRIVATE ${QT_IOS_ASSET_DIR})
        set_source_files_properties(${QT_IOS_ASSET_DIR} PROPERTIES MACOSX_PACKAGE_LOCATION Resources)
    else(QT_IOS_ASSET_DIR)
        if(QT_IOS_VERBOSE)
            message(STATUS "No Asset dir specified. This is the recommanded way to add Icons and LaunchImage")
        endif() # QT_IOS_VERBOSE
    endif() # QT_IOS_ASSET_DIR

    # Add Launchscreen storyboard as ressource
    if(QT_IOS_LAUNCHSCREEN_STORYBOARD)
        target_sources(${QT_IOS_TARGET} PRIVATE ${QT_IOS_LAUNCHSCREEN_STORYBOARD})
        set_source_files_properties(${QT_IOS_LAUNCHSCREEN_STORYBOARD} PROPERTIES MACOSX_PACKAGE_LOCATION Resources)
        string(REGEX MATCH "[a-zA-Z0-9 \\-_]*\\.storyboard" STORYBOARD_FILE_NAME ${QT_IOS_LAUNCHSCREEN_STORYBOARD})
        if(QT_IOS_VERBOSE)
            message(STATUS "Add UILaunchStoryboardName key with value ${STORYBOARD_FILE_NAME} in Info.pList")
        endif() # QT_IOS_VERBOSE
        set(MACOSX_BUNDLE_LAUNCHSCREEN_STORYBOARD ${STORYBOARD_FILE_NAME})
    else() # QT_IOS_LAUNCHSCREEN_STORYBOARD
        if(QT_IOS_VERBOSE)
            if(NOT QT_IOS_REQUIRES_FULL_SCREEN)
            message(WARNING "LaunchScreen.storyboard isn't specified, it's is now recommanded to have one if you don't set REQUIRES_FULL_SCREEN")
            endif() # NOT QT_IOS_REQUIRES_FULL_SCREEN
        endif() # QT_IOS_VERBOSE
    endif() # QT_IOS_LAUNCHSCREEN_STORYBOARD

    # Add Main storyboard as ressource
    if(QT_IOS_MAIN_STORYBOARD)
        target_sources(${QT_IOS_TARGET} PRIVATE ${QT_IOS_MAIN_STORYBOARD})
        set_source_files_properties(${QT_IOS_MAIN_STORYBOARD} PROPERTIES MACOSX_PACKAGE_LOCATION Resources)
        # We just need to set the filename without extension
        string(REGEX MATCH "([a-zA-Z0-9 \\-_]*)\\.storyboard" STORYBOARD_FILE_NAME ${QT_IOS_MAIN_STORYBOARD})
        if(QT_IOS_VERBOSE)
            message(STATUS "Add UIMainStoryboardFile key with value ${CMAKE_MATCH_1} in Info.pList")
        endif() # QT_IOS_VERBOSE
        set(MACOSX_BUNDLE_MAIN_STORYBOARD ${CMAKE_MATCH_1})
    endif(QT_IOS_MAIN_STORYBOARD)

endmacro()
