#
# CMake Script by Olivier Le Doeuff
# Copyright (c) 2019 - All Right Reserved
# add_qt_ios_app help you deploy iOs application with Qt.
#

CMAKE_MINIMUM_REQUIRED(VERSION 3.0)

# find the Qt root directoryn might break in future release
# Dependant on Qt5
IF(NOT Qt5Core_DIR)
    find_package(Qt5Core REQUIRED)
ENDIF(NOT Qt5Core_DIR)
GET_FILENAME_COMPONENT(QT_IOS_QT_ROOT "${Qt5Core_DIR}/../../.." ABSOLUTE)

set(QT_IOS_QT_ROOT ${QT_IOS_QT_ROOT} CACHE STRING "Root of qt sdk for ios" FORCE)
IF(QT_IOS_QT_ROOT)
    MESSAGE(STATUS "Found Qt Sdk for Ios: ${QT_IOS_QT_ROOT}")
ELSE(QT_IOS_QT_ROOT)
    MESSAGE(FATAL_ERROR "Fail to find Qt Sdk path.")
ENDIF(QT_IOS_QT_ROOT)

# Keep track of our own directory for future use (and default value of plist.in)
SET(QT_IOS_SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR} CACHE STRING "Root AddQtIosApp.cmake script" FORCE)

# Indicate that the script have been called a least once
SET(QT_IOS_CMAKE_FOUND ON CACHE BOOL "QtIosCMake have been found." FORCE)
SET(QT_IOS_CMAKE_VERSION "1.0.0" CACHE STRING "QtIosCMake Version" FORCE)

MESSAGE(STATUS "QtIosCMake version ${QT_IOS_CMAKE_VERSION}")

# This little macro lets you set any Xcode specific property.
# This is from iOs CMake Toolchain
MACRO(qt_ios_set_xcode_property TARGET XCODE_PROPERTY XCODE_VALUE XCODE_RELVERSION)
  SET(XCODE_RELVERSION_I "${XCODE_RELVERSION}")
  IF(XCODE_RELVERSION_I STREQUAL "All")
    SET_PROPERTY(TARGET ${TARGET} PROPERTY
    XCODE_ATTRIBUTE_${XCODE_PROPERTY} "${XCODE_VALUE}")
  ELSE()
    SET_PROPERTY(TARGET ${TARGET} PROPERTY
    XCODE_ATTRIBUTE_${XCODE_PROPERTY}[variant=${XCODE_RELVERSION_I}] "${XCODE_VALUE}")
  ENDIF()
ENDMACRO(qt_ios_set_xcode_property)

# We need that to parse arguments
INCLUDE(CMakeParseArguments)

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
MACRO(add_qt_ios_app TARGET)

    SET(QT_IOS_OPTIONS VERBOSE
        ORIENTATION_PORTRAIT
        ORIENTATION_PORTRAIT_UPDOWN
        ORIENTATION_LANDSCAPE_LEFT
        ORIENTATION_LANDSCAPE_RIGHT
        SUPPORT_IPHONE
        SUPPORT_IPAD
        REQUIRES_FULL_SCREEN
        HIDDEN_STATUS_BAR
        )
    SET(QT_IOS_ONE_VALUE_ARG NAME
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
    SET(QT_IOS_MULTI_VALUE_ARG )
     # parse the macro arguments
    CMAKE_PARSE_ARGUMENTS(ARGIOS "${QT_IOS_OPTIONS}" "${QT_IOS_ONE_VALUE_ARG}" "${QT_IOS_MULTI_VALUE_ARG}" ${ARGN})

    # Copy arg variables to local variables
    SET(QT_IOS_TARGET ${TARGET})
    SET(QT_IOS_NAME ${ARGIOS_NAME})
    SET(QT_IOS_BUNDLE_IDENTIFIER ${ARGIOS_BUNDLE_IDENTIFIER})
    SET(QT_IOS_VERSION ${ARGIOS_VERSION})
    SET(QT_IOS_SHORT_VERSION ${ARGIOS_SHORT_VERSION})
    SET(QT_IOS_LONG_VERSION ${ARGIOS_LONG_VERSION})
    SET(QT_IOS_CUSTOM_PLIST ${ARGIOS_CUSTOM_PLIST})
    IF(NOT QT_IOS_CODE_SIGN_IDENTITY)
        SET(QT_IOS_CODE_SIGN_IDENTITY ${ARGIOS_CODE_SIGN_IDENTITY})
    ENDIF(NOT QT_IOS_CODE_SIGN_IDENTITY)
    IF(NOT QT_IOS_TEAM_ID)
        SET(QT_IOS_TEAM_ID ${ARGIOS_TEAM_ID})
    ENDIF(NOT QT_IOS_TEAM_ID)
    SET(QT_IOS_COPYRIGHT ${ARGIOS_COPYRIGHT})
    SET(QT_IOS_QML_DIR ${ARGIOS_QML_DIR})
    SET(QT_IOS_ASSET_DIR ${ARGIOS_ASSET_DIR})
    SET(QT_IOS_LAUNCHSCREEN_STORYBOARD ${ARGIOS_LAUNCHSCREEN_STORYBOARD})
    SET(QT_IOS_MAIN_STORYBOARD ${ARGIOS_MAIN_STORYBOARD})
    SET(QT_IOS_CATALOG_APPICON ${ARGIOS_CATALOG_APPICON})
    SET(QT_IOS_CATALOG_LAUNCHIMAGE ${ARGIOS_CATALOG_LAUNCHIMAGE})

    SET(QT_IOS_ORIENTATION_PORTRAIT ${ARGIOS_ORIENTATION_PORTRAIT})
    SET(QT_IOS_ORIENTATION_PORTRAIT_UPDOWN ${ARGIOS_ORIENTATION_PORTRAIT_UPDOWN})
    SET(QT_IOS_ORIENTATION_LANDSCAPE_LEFT ${ARGIOS_ORIENTATION_LANDSCAPE_LEFT})
    SET(QT_IOS_ORIENTATION_LANDSCAPE_RIGHT ${ARGIOS_ORIENTATION_LANDSCAPE_RIGHT})
    SET(QT_IOS_SUPPORT_IPHONE ${ARGIOS_SUPPORT_IPHONE})
    SET(QT_IOS_SUPPORT_IPAD ${ARGIOS_SUPPORT_IPAD})
    SET(QT_IOS_REQUIRES_FULL_SCREEN ${ARGIOS_REQUIRES_FULL_SCREEN})
    SET(QT_IOS_HIDDEN_STATUS_BAR ${ARGIOS_HIDDEN_STATUS_BAR})

    SET(QT_IOS_VERBOSE ${ARGIOS_VERBOSE})

    # Warning if no default BUNDLE_IDENTIFIER is set
    IF(NOT ARGIOS_BUNDLE_IDENTIFIER)
        IF(QT_IOS_VERBOSE)
        MESSAGE(WARNING "BUNDLE_IDENTIFIER not set when calling add_qt_ios_app. You will need to fix this by hand in XCode")
        ENDIF(QT_IOS_VERBOSE)
    ENDIF(NOT ARGIOS_BUNDLE_IDENTIFIER)

    # Warning if no version
    IF(NOT ARGIOS_VERSION)
        IF(QT_IOS_VERBOSE)
        MESSAGE(WARNING "VERSION not set when calling add_qt_ios_app. This might result in warning in XCode")
        ENDIF(QT_IOS_VERBOSE)
    ENDIF(NOT ARGIOS_VERSION)

    # Default value for SHORT_VERSION
    IF(NOT QT_IOS_SHORT_VERSION)
        IF(QT_IOS_VERBOSE)
        MESSAGE(STATUS "SHORT_VERSION not specified, default to VERSION")
        ENDIF(QT_IOS_VERBOSE)
        SET(QT_IOS_SHORT_VERSION ${ARGIOS_VERSION})
    ENDIF(NOT QT_IOS_SHORT_VERSION)

    # Default value for long version
    IF(NOT QT_IOS_LONG_VERSION)
        IF(QT_IOS_VERBOSE)
        MESSAGE(STATUS "LONG_VERSION not specified, default to VERSION")
        ENDIF(QT_IOS_VERBOSE)
        SET(QT_IOS_LONG_VERSION ${ARGIOS_VERSION})
    ENDIF(NOT QT_IOS_LONG_VERSION)

    # Default value for plist file
    IF(NOT QT_IOS_CUSTOM_PLIST)
        SET(QT_IOS_CUSTOM_PLIST ${QT_IOS_SOURCE_DIR}/MacOSXBundleInfo.plist.in)
        IF(QT_IOS_VERBOSE)
        MESSAGE(STATUS "CUSTOM_PLIST not specified, default to ${QT_IOS_CUSTOM_PLIST}")
        ENDIF(QT_IOS_VERBOSE)
    ENDIF(NOT QT_IOS_CUSTOM_PLIST)

    # Default for qml dir set to qt sdk root
    IF(NOT QT_IOS_QML_DIR)
        SET(QT_IOS_QML_DIR "${QT_IOS_QT_ROOT}/qml")
        IF(QT_IOS_VERBOSE)
        MESSAGE(STATUS "QML_DIR not specified, default to ${QT_IOS_QML_DIR}")
        ENDIF(QT_IOS_VERBOSE)
    ENDIF(NOT QT_IOS_QML_DIR)

    # Warning, somework will be required in XCode
    IF(NOT QT_IOS_CODE_SIGN_IDENTITY)
        SET(QT_IOS_CODE_SIGN_IDENTITY "iPhone Developer")
        IF(QT_IOS_VERBOSE)
        MESSAGE(WARNING "CODE_SIGN_IDENTITY not specified, default to ${QT_IOS_CODE_SIGN_IDENTITY}. You might need to set it in XCode")
        ENDIF(QT_IOS_VERBOSE)
    ENDIF(NOT QT_IOS_CODE_SIGN_IDENTITY)

    # Warning, somework will be required in XCode
    IF(NOT QT_IOS_TEAM_ID)
        SET(QT_IOS_TEAM_ID "AAAAAAAA")
        IF(QT_IOS_VERBOSE)
        MESSAGE(WARNING "TEAM_ID not specified, default to ${QT_IOS_TEAM_ID}. You might need to set it in XCode")
        ENDIF(QT_IOS_VERBOSE)
    ENDIF(NOT QT_IOS_TEAM_ID)

    IF(NOT QT_IOS_CATALOG_APPICON)
        SET(QT_IOS_CATALOG_APPICON "AppIcon")
        IF(QT_IOS_VERBOSE)
        MESSAGE(STATUS "CATALOG_APPICON not specified, default to ${QT_IOS_CATALOG_APPICON}.")
        ENDIF(QT_IOS_VERBOSE)
    ENDIF(NOT QT_IOS_CATALOG_APPICON)

    IF(NOT QT_IOS_CATALOG_LAUNCHIMAGE)
        SET(QT_IOS_CATALOG_LAUNCHIMAGE "LaunchImage")
        IF(QT_IOS_VERBOSE)
        MESSAGE(STATUS "CATALOG_LAUNCHIMAGE not specified, default to ${QT_IOS_CATALOG_LAUNCHIMAGE}.")
        ENDIF(QT_IOS_VERBOSE)
    ENDIF(NOT QT_IOS_CATALOG_LAUNCHIMAGE)

    # Print macro configuration
    IF(QT_IOS_VERBOSE)
        MESSAGE(STATUS "------ QtIosCMake Configuration ------")
        MESSAGE(STATUS "TARGET                              : ${QT_IOS_TARGET}")
        MESSAGE(STATUS "NAME                                : ${QT_IOS_NAME}")
        MESSAGE(STATUS "BUNDLE_IDENTIFIER                   : ${QT_IOS_BUNDLE_IDENTIFIER}")
        MESSAGE(STATUS "VERSION                             : ${QT_IOS_VERSION}")
        MESSAGE(STATUS "SHORT_VERSION                       : ${QT_IOS_SHORT_VERSION}")
        MESSAGE(STATUS "LONG_VERSION                        : ${QT_IOS_LONG_VERSION}")
        MESSAGE(STATUS "CUSTOM_PLIST                        : ${QT_IOS_CUSTOM_PLIST}")
        MESSAGE(STATUS "CODE_SIGN_IDENTITY                  : ${QT_IOS_CODE_SIGN_IDENTITY}")
        MESSAGE(STATUS "TEAM_ID                             : ${QT_IOS_TEAM_ID}")
        MESSAGE(STATUS "COPYRIGHT                           : ${QT_IOS_COPYRIGHT}")
        MESSAGE(STATUS "QML_DIR                             : ${QT_IOS_QML_DIR}")
        MESSAGE(STATUS "ASSET_DIR                           : ${QT_IOS_ASSET_DIR}")
        MESSAGE(STATUS "CATALOG_APPICON                     : ${QT_IOS_CATALOG_APPICON}")
        MESSAGE(STATUS "CATALOG_LAUNCHIMAGE                 : ${QT_IOS_CATALOG_LAUNCHIMAGE}")
        MESSAGE(STATUS "LAUNCHSCREEN_STORYBOARD             : ${QT_IOS_LAUNCHSCREEN_STORYBOARD}")
        MESSAGE(STATUS "MAIN_STORYBOARD                     : ${QT_IOS_MAIN_STORYBOARD}")
        MESSAGE(STATUS "ORIENTATION_PORTRAIT                : ${QT_IOS_ORIENTATION_PORTRAIT}")
        MESSAGE(STATUS "ORIENTATION_PORTRAIT_UPDOWN         : ${QT_IOS_ORIENTATION_PORTRAIT_UPDOWN}")
        MESSAGE(STATUS "ORIENTATION_LANDSCAPE_LEFT          : ${QT_IOS_ORIENTATION_LANDSCAPE_LEFT}")
        MESSAGE(STATUS "ORIENTATION_LANDSCAPE_RIGHT         : ${QT_IOS_ORIENTATION_LANDSCAPE_RIGHT}")
        MESSAGE(STATUS "SUPPORT_IPHONE                      : ${QT_IOS_SUPPORT_IPHONE}")
        MESSAGE(STATUS "SUPPORT_IPAD                        : ${QT_IOS_SUPPORT_IPAD}")
        MESSAGE(STATUS "REQUIRES_FULL_SCREEN                : ${QT_IOS_REQUIRES_FULL_SCREEN}")
        MESSAGE(STATUS "HIDDEN_STATUS_BAR                   : ${QT_IOS_HIDDEN_STATUS_BAR}")
        MESSAGE(STATUS "------ QtIosCMake END Configuration ------")
    ENDIF(QT_IOS_VERBOSE)

    # Bundle executable.
    IF(QT_IOS_VERBOSE)
    MESSAGE(STATUS "Set property MACOSX_BUNDLE to ${QT_IOS_TARGET}")
    ENDIF(QT_IOS_VERBOSE)
    SET_TARGET_PROPERTIES(${QT_IOS_TARGET} PROPERTIES MACOSX_BUNDLE ON)

    # Qt Mess
    FUNCTION(QT_IOS_CLEAN_PATHS)
        FOREACH(_path_group ${ARGN})
            FOREACH(_path ${${_path_group}})
                get_filename_component(_path_cleaned ${_path} REALPATH)
                file(TO_NATIVE_PATH ${_path_cleaned} _path_cleaned)
                set(_path_group_cleaned ${_path_group_cleaned} ${_path_cleaned})
            ENDFOREACH()
        set(${_path_group} ${_path_group_cleaned} PARENT_SCOPE)
        ENDFOREACH()
    ENDFUNCTION()

    macro(QT_IOS_HANDLE_CYCLICAL_LINKING LIBS)
        IF(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX OR (CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND NOT APPLE))
            set(${LIBS} -Wl,--start-group ${${LIBS}} -Wl,--end-group)
        ENDIF()
    ENDmacro()

    # let's not be picky, just throw all the available static libraries at the linker and let it figure out which ones are actually needed
    # a 'FOREACH' is used because 'target_link_libraries' doesn't handle lists correctly (the ; messes it up and nothing actually gets linked against)
    IF(QT_IOS_TARGET_IS_WINDOWS)
        set(_DEBUG_SUFFIX d)
    ELSEIF(QT_IOS_TARGET_IS_IOS OR QT_IOS_TARGET_IS_MAC)
        set(_DEBUG_SUFFIX _debug)
    else()
        set(_DEBUG_SUFFIX)
    ENDIF()

    set(_LIBS_BASE_DIR "${QT_IOS_QT_ROOT}/lib")
    QT_IOS_CLEAN_PATHS(_LIBS_BASE_DIR)
    file(GLOB_RECURSE _QT_LIBS "${_LIBS_BASE_DIR}/*${CMAKE_STATIC_LIBRARY_SUFFIX}")
    FOREACH(_QT_LIB ${_QT_LIBS})
        string(REGEX MATCH ".*${_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}$" _IS_DEBUG_LIB ${_QT_LIB})
        string(REGEX MATCH ".*_iphonesimulator${_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}$" _IS_DEBUG_SIM_LIB ${_QT_LIB})
        string(REGEX MATCH ".*_iphonesimulator${CMAKE_STATIC_LIBRARY_SUFFIX}$" _IS_SIM_LIB ${_QT_LIB})
        string(REGEX MATCH ".*Qt5Bootstrap.*" _IS_BOOTSTRAP ${_QT_LIB})
        string(REGEX MATCH ".*Qt5QmlDevTools.*" _IS_DEVTOOLS ${_QT_LIB})

        IF(NOT _IS_BOOTSTRAP AND NOT _IS_DEVTOOLS AND NOT _IS_DEBUG_SIM_LIB AND NOT _IS_SIM_LIB)
            IF(_IS_DEBUG_LIB OR NOT _DEBUG_SUFFIX)
                set(QT_EXTRA_LIBS ${QT_EXTRA_LIBS} debug "${_QT_LIB}")
            ENDIF()
            IF(NOT _IS_DEBUG_LIB OR NOT _DEBUG_SUFFIX)
                set(QT_EXTRA_LIBS ${QT_EXTRA_LIBS} optimized "${_QT_LIB}")
            ENDIF()
        ENDIF()
    ENDFOREACH()

    set(_QML_BASE_DIR "${QT_IOS_QML_DIR}")
    QT_IOS_CLEAN_PATHS(_QML_BASE_DIR)
    file(GLOB_RECURSE _QML_PLUGINS "${_QML_BASE_DIR}/*${CMAKE_STATIC_LIBRARY_SUFFIX}")
    FOREACH(_QML_PLUGIN ${_QML_PLUGINS})
        string(REGEX MATCH ".*${_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}$" _IS_DEBUG_LIB ${_QML_PLUGIN})
        string(REGEX MATCH ".*_iphonesimulator${_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}$" _IS_DEBUG_SIM_LIB ${_QML_PLUGIN})
        string(REGEX MATCH ".*_iphonesimulator${CMAKE_STATIC_LIBRARY_SUFFIX}$" _IS_SIM_LIB ${_QML_PLUGIN})

        IF(NOT _IS_DEBUG_SIM_LIB AND NOT _IS_SIM_LIB)
            IF(_IS_DEBUG_LIB OR NOT _DEBUG_SUFFIX)
                set(QT_EXTRA_LIBS ${QT_EXTRA_LIBS} debug "${_QML_PLUGIN}")
            ENDIF()
            IF(NOT _IS_DEBUG_LIB OR NOT _DEBUG_SUFFIX)
                set(QT_EXTRA_LIBS ${QT_EXTRA_LIBS} optimized "${_QML_PLUGIN}")
            ENDIF()
        ENDIF()
    ENDFOREACH()

    set(_PLUGINS_BASE_DIR "${QT_IOS_QT_ROOT}/plugins")
    QT_IOS_CLEAN_PATHS(_PLUGINS_BASE_DIR)
    file(GLOB_RECURSE _QT_PLUGINS "${_PLUGINS_BASE_DIR}/*${CMAKE_STATIC_LIBRARY_SUFFIX}")
    FOREACH(_QT_PLUGIN ${_QT_PLUGINS})
        string(REGEX MATCH ".*${_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}$" _IS_DEBUG_LIB ${_QT_PLUGIN})
        string(REGEX MATCH ".*_iphonesimulator${_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}$" _IS_DEBUG_SIM_LIB ${_QT_PLUGIN})
        string(REGEX MATCH ".*_iphonesimulator${CMAKE_STATIC_LIBRARY_SUFFIX}$" _IS_SIM_LIB ${_QT_PLUGIN})

        IF(NOT _IS_DEBUG_SIM_LIB AND NOT _IS_SIM_LIB)
            IF(_IS_DEBUG_LIB OR NOT _DEBUG_SUFFIX)
                set(QT_EXTRA_LIBS ${QT_EXTRA_LIBS} debug "${_QT_PLUGIN}")
            ENDIF()
            IF(NOT _IS_DEBUG_LIB OR NOT _DEBUG_SUFFIX)
                set(QT_EXTRA_LIBS ${QT_EXTRA_LIBS} optimized "${_QT_PLUGIN}")
            ENDIF()
        ENDIF()
    ENDFOREACH()

    # Set almost every framework as extra library, may require some clean in the future.
    SET(QT_EXTRA_LIBS ${QT_EXTRA_LIBS}
        "-framework Foundation -framework AVFoundation -framework SystemConfiguration -framework AssetsLibrary -framework OpenGLES \
        -framework CoreText -framework QuartzCore -framework CoreGraphics -framework ImageIO -framework Security -framework UIKit -framework WebKit \
        -framework CoreBluetooth -framework MobileCoreServices -framework QuickLook -framework AudioToolbox -framework CoreLocation \
        -framework Accelerate -framework CoreMedia -framework CoreVideo -framework MediaToolbox -framework MediaPlayer -framework GameController -framework CoreMotion -framework StoreKit -weak_framework Metal -lz"
        )

    # static linking
    SET(QT_LIBRARIES ${QT_LIBRARIES} ${QT_EXTRA_LIBS})
    QT_IOS_HANDLE_CYCLICAL_LINKING(QT_LIBRARIES)

    # Define entry point for correct initialization.
    # Maybe set this optionnal in the future if user wants to set his own entry point ?
    IF(QT_IOS_VERBOSE)
    MESSAGE(STATUS "Add -e _qt_main_wrapper linker flag to ${QT_IOS_TARGET} to change application entry point to create UIApplication before QApplication")
    ENDIF(QT_IOS_VERBOSE)
    TARGET_LINK_LIBRARIES(${QT_IOS_TARGET} ${QT_LIBRARIES} "-e _qt_main_wrapper")

    # Set XCode property for automatic code sign
    qt_ios_set_xcode_property(${QT_IOS_TARGET} CODE_SIGN_IDENTITY ${QT_IOS_CODE_SIGN_IDENTITY} "All")
    qt_ios_set_xcode_property(${QT_IOS_TARGET} DEVELOPMENT_TEAM ${QT_IOS_TEAM_ID} "All")

    # Ugly but working
    IF(QT_IOS_SUPPORT_IPAD AND QT_IOS_SUPPORT_IPHONE)
        qt_ios_set_xcode_property(${QT_IOS_TARGET} TARGETED_DEVICE_FAMILY "1,2" "All")
    ELSEIF(QT_IOS_SUPPORT_IPAD)
        qt_ios_set_xcode_property(${QT_IOS_TARGET} TARGETED_DEVICE_FAMILY "2" "All")
    ELSE()
        qt_ios_set_xcode_property(${QT_IOS_TARGET} TARGETED_DEVICE_FAMILY "1" "All")
    ENDIF()

    # Set AppIcon Catalog
    qt_ios_set_xcode_property (${QT_IOS_TARGET} ASSETCATALOG_COMPILER_APPICON_NAME ${QT_IOS_CATALOG_APPICON} "All")
    # Set LaunchImage Catalog
    qt_ios_set_xcode_property (${QT_IOS_TARGET} ASSETCATALOG_COMPILER_LAUNCHIMAGE_NAME ${QT_IOS_CATALOG_LAUNCHIMAGE} "All")

    # Set CMake variables for plist
    SET(MACOSX_BUNDLE_EXECUTABLE_NAME ${QT_IOS_NAME})
    SET(MACOSX_BUNDLE_INFO_STRING ${QT_IOS_NAME})
    SET(MACOSX_BUNDLE_GUI_IDENTIFIER ${QT_IOS_BUNDLE_IDENTIFIER})
    SET(MACOSX_BUNDLE_BUNDLE_NAME ${QT_IOS_NAME})
    #SET(MACOSX_BUNDLE_ICON_FILE "${PROJECT_SOURCE_DIR}/platform/ios/Assets.xcassets/AppIcon.appiconset")
    SET(MACOSX_BUNDLE_BUNDLE_VERSION ${QT_IOS_VERSION})
    SET(MACOSX_BUNDLE_SHORT_VERSION_STRING ${QT_IOS_SHORT_VERSION})
    SET(MACOSX_BUNDLE_LONG_VERSION_STRING ${QT_IOS_LONG_VERSION})
    SET(MACOSX_BUNDLE_COPYRIGHT ${QT_IOS_COPYRIGHT})

    # Set require full screen
    IF(QT_IOS_REQUIRES_FULL_SCREEN)
        SET(MACOSX_BUNDLE_REQUIRES_FULL_SCREEN "YES")
        IF(QT_IOS_VERBOSE)
            MESSAGE(STATUS "Add UIRequiresFullScreen flag to Info.pList")
        ENDIF(QT_IOS_VERBOSE)
    ELSE(QT_IOS_REQUIRES_FULL_SCREEN)
        SET(MACOSX_BUNDLE_REQUIRES_FULL_SCREEN "NO")
    ENDIF(QT_IOS_REQUIRES_FULL_SCREEN)

    # Set hidden status bar
    IF(QT_IOS_HIDDEN_STATUS_BAR)
        SET(MACOSX_BUNDLE_HIDDEN_STATUS_BAR "true")
        IF(QT_IOS_VERBOSE)
            MESSAGE(STATUS "Add UIStatusBarHidden flag to Info.pList")
        ENDIF(QT_IOS_VERBOSE)
    ELSE(QT_IOS_HIDDEN_STATUS_BAR)
        SET(MACOSX_BUNDLE_HIDDEN_STATUS_BAR "false")
    ENDIF(QT_IOS_HIDDEN_STATUS_BAR)

    # Add orientation flags
    IF(QT_IOS_ORIENTATION_PORTRAIT)
        SET(MACOSX_BUNDLE_PORTRAIT "UIInterfaceOrientationPortrait")
        IF(QT_IOS_VERBOSE)
            MESSAGE(STATUS "Add UIInterfaceOrientationPortrait flag to Info.pList")
        ENDIF(QT_IOS_VERBOSE)
    ENDIF()
    IF(QT_IOS_ORIENTATION_PORTRAIT_UPDOWN)
        SET(MACOSX_BUNDLE_PORTRAITUPDOWN "UIInterfaceOrientationPortraitUpsideDown")
        IF(QT_IOS_VERBOSE)
            MESSAGE(STATUS "Add UIInterfaceOrientationPortraitUpsideDown flag to Info.pList")
        ENDIF(QT_IOS_VERBOSE)
    ENDIF()
    IF(QT_IOS_ORIENTATION_LANDSCAPE_LEFT)
        SET(MACOSX_BUNDLE_LANDSCAPELEFT "UIInterfaceOrientationLandscapeLeft")
        IF(QT_IOS_VERBOSE)
            MESSAGE(STATUS "Add UIInterfaceOrientationLandscapeLeft flag to Info.pList")
        ENDIF(QT_IOS_VERBOSE)
    ENDIF()
    IF(QT_IOS_ORIENTATION_LANDSCAPE_RIGHT)
        SET(MACOSX_BUNDLE_LANDSCAPERIGHT "UIInterfaceOrientationLandscapeRight")
        IF(QT_IOS_VERBOSE)
            MESSAGE(STATUS "Add UIInterfaceOrientationLandscapeRight flag to Info.pList")
        ENDIF(QT_IOS_VERBOSE)
    ENDIF()

    # Set Custom pList
    SET_TARGET_PROPERTIES(${QT_IOS_TARGET} PROPERTIES MACOSX_BUNDLE_INFO_PLIST ${QT_IOS_CUSTOM_PLIST})

    # Add asset dir as ressource
    IF(QT_IOS_ASSET_DIR)
        TARGET_SOURCES(${QT_IOS_TARGET} PRIVATE ${QT_IOS_ASSET_DIR})
        SET_SOURCE_FILES_PROPERTIES(${QT_IOS_ASSET_DIR} PROPERTIES MACOSX_PACKAGE_LOCATION Resources)
    ELSE(QT_IOS_ASSET_DIR)
        IF(QT_IOS_VERBOSE)
            MESSAGE(STATUS "No Asset dir specified. This is the recommanded way to add Icons and LaunchImage")
        ENDIF(QT_IOS_VERBOSE)
    ENDIF(QT_IOS_ASSET_DIR)

    # Add Launchscreen storyboard as ressource
    IF(QT_IOS_LAUNCHSCREEN_STORYBOARD)
        TARGET_SOURCES(${QT_IOS_TARGET} PRIVATE ${QT_IOS_LAUNCHSCREEN_STORYBOARD})
        SET_SOURCE_FILES_PROPERTIES(${QT_IOS_LAUNCHSCREEN_STORYBOARD} PROPERTIES MACOSX_PACKAGE_LOCATION Resources)
        STRING(REGEX MATCH "[a-zA-Z0-9 \\-_]*\\.storyboard" STORYBOARD_FILE_NAME ${QT_IOS_LAUNCHSCREEN_STORYBOARD})
        IF(QT_IOS_VERBOSE)
            MESSAGE(STATUS "Add UILaunchStoryboardName key with value ${STORYBOARD_FILE_NAME} in Info.pList")
        ENDIF(QT_IOS_VERBOSE)
        SET(MACOSX_BUNDLE_LAUNCHSCREEN_STORYBOARD ${STORYBOARD_FILE_NAME})
    ELSE(QT_IOS_LAUNCHSCREEN_STORYBOARD)
        IF(QT_IOS_VERBOSE)
            IF(NOT QT_IOS_REQUIRES_FULL_SCREEN)
            MESSAGE(WARNING "LaunchScreen.storyboard isn't specified, it's is now recommanded to have one if you don't set REQUIRES_FULL_SCREEN")
            ENDIF(NOT QT_IOS_REQUIRES_FULL_SCREEN)
        ENDIF(QT_IOS_VERBOSE)
    ENDIF(QT_IOS_LAUNCHSCREEN_STORYBOARD)

    # Add Main storyboard as ressource
    IF(QT_IOS_MAIN_STORYBOARD)
        TARGET_SOURCES(${QT_IOS_TARGET} PRIVATE ${QT_IOS_MAIN_STORYBOARD})
        SET_SOURCE_FILES_PROPERTIES(${QT_IOS_MAIN_STORYBOARD} PROPERTIES MACOSX_PACKAGE_LOCATION Resources)
        # We just need to set the filename without extension
        STRING(REGEX MATCH "([a-zA-Z0-9 \\-_]*)\\.storyboard" STORYBOARD_FILE_NAME ${QT_IOS_MAIN_STORYBOARD})
        IF(QT_IOS_VERBOSE)
            MESSAGE(STATUS "Add UIMainStoryboardFile key with value ${CMAKE_MATCH_1} in Info.pList")
        ENDIF(QT_IOS_VERBOSE)
        SET(MACOSX_BUNDLE_MAIN_STORYBOARD ${CMAKE_MATCH_1})
    ENDIF(QT_IOS_MAIN_STORYBOARD)

ENDMACRO(add_qt_ios_app TARGET)
