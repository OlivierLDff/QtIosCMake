cmake_minimum_required(VERSION 3.0.0 FATAL_ERROR)

include(${CMAKE_CURRENT_LIST_DIR}/AddQtIosApp.cmake)

set(QT_IOS_QT_ROOT ${QT_IOS_QT_ROOT} CACHE STRING "Root of qt sdk for ios" FORCE)
set(QT_IOS_SOURCE_DIR ${QT_IOS_SOURCE_DIR} CACHE STRING "Root AddQtIosApp.cmake script" FORCE)
set(QT_IOS_CMAKE_FOUND ON CACHE BOOL "QtIosCMake have been found." FORCE)
set(QT_IOS_CMAKE_VERSION "1.1.0" CACHE STRING "QtIosCMake Version" FORCE)