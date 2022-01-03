cmake_minimum_required(VERSION 3.17)
project(LEDAmbiente LANGUAGES CXX VERSION 1.0.0)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(APPLICATION_NAME ${PROJECT_NAME})


# QtCreator supports the following variables for Android, which are identical to qmake Android variables.
# Check https://doc.qt.io/qt/deployment-android.html for more information.
# They need to be set before the find_package(...) calls below.

#if(ANDROID)
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
#    if (ANDROID_ABI STREQUAL "armeabi-v7a")
#        set(ANDROID_EXTRA_LIBS
#            ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libcrypto.so
#            ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libssl.so)
#    endif()
#endif()

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Quick Widgets Network REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Quick Widgets Network REQUIRED)

set (SRC
    cpp/main.cpp
    cpp/application_engine.cpp
    cpp/model_devices.cpp
    cpp/device_manager.cpp
)

set (HDR
    cpp/application_engine.hpp
    cpp/model_devices.hpp
    cpp/device_manager.hpp
)

set( RCS
    #resources.qrc
    qml/qml.qrc
    resources.qrc
)

set(PROJECT_SOURCES
    ${SRC}
    ${HDR}
    ${RCS}
    ${TS_FILES}
)

# Directories where Qt Creator can find QML files.
# (Not needed for builds, but makes Qt Creator code completion happy.)
list(APPEND QML_IMPORT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/qml)

# Prevent adding duplicate values at each run of CMake.
list(REMOVE_DUPLICATES QML_IMPORT_PATH)

# The variable is cached in ${BUILD_DIR}/CMakeCache.txt. We need FORCE to
# change it there immediately. Also, add a comment to the cache file.
set(QML_IMPORT_PATH ${QML_IMPORT_PATH}
    CACHE STRING "Qt Creator 4.1 extra qml import paths"
    FORCE
)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(${APPLICATION_NAME}
        ${PROJECT_SOURCES}
    )
else()
    if(ANDROID)
        add_library(${APPLICATION_NAME} SHARED
            ${PROJECT_SOURCES}
        )
    else()
        add_executable(${APPLICATION_NAME}
          ${PROJECT_SOURCES}
        )
    endif()
endif()

target_compile_definitions(${APPLICATION_NAME}
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(${APPLICATION_NAME}
  PRIVATE
  Qt${QT_VERSION_MAJOR}::Core
  Qt${QT_VERSION_MAJOR}::Quick
  Qt${QT_VERSION_MAJOR}::Widgets
  Qt${QT_VERSION_MAJOR}::Network
)

