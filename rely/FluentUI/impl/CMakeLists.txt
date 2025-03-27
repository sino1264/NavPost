cmake_minimum_required(VERSION 3.21)

project(FluentUIImpl VERSION 1.0.0)

set(CMAKE_AUTOMOC ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 COMPONENTS Quick QuickControls2 REQUIRED)

if (FLUENTUI_BUILD_STATIC_LIB)
    set(PLUGIN_TARGET_NAME "")
else ()
    set(PLUGIN_TARGET_NAME ${PROJECT_NAME})
endif ()

qt_add_library(${PROJECT_NAME} ${FLUENTUI_LIB_TYPE})

set(QML_FILES
    Objects.qml
    SyntaxHighlighter.qml
)

set(SOURCE_FILES
    qrcode/qrencode_inner.h  qrcode/config.h
    qrcode/qrspec.h qrcode/qrspec.cpp
    qrcode/split.h qrcode/split.cpp
    qrcode/rsecc.h qrcode/rsecc.cpp
    qrcode/bitstream.h qrcode/bitstream.cpp
    qrcode/mask.h qrcode/mask.cpp
    qrcode/mmask.h qrcode/mmask.cpp
    qrcode/mqrspec.h qrcode/mqrspec.cpp
    qrcode/qrencode.h qrcode/qrencode.cpp
    qrcode/qrinput.h qrcode/qrinput.cpp

    stdafx.h def.h
    FluentUI.h FluentUI.cpp
    DataGridModel.h DataGridModel.cpp
    TreeDataGridModel.h TreeDataGridModel.cpp
    Frameless.h Frameless.cpp
    Tools.h Tools.cpp
    RoundRectangle.h RoundRectangle.cpp
    SyntaxHighlighterImpl.h SyntaxHighlighterImpl.cpp
    TextCharFormat.h TextCharFormat.cpp
    LineNumberModel.h LineNumberModel.cpp
    ControlBackgroundImpl.h ControlBackgroundImpl.cpp
    InputBackgroundImpl.h InputBackgroundImpl.cpp
    FileWatcher.h FileWatcher.cpp
    WatermarkImpl.h WatermarkImpl.cpp
    QRCodeImpl.h QRCodeImpl.cpp
    ImageItem.h ImageItem.cpp
    DesktopCaptureItem.h DesktopCaptureItem.cpp
    TourBackgroundImpl.h TourBackgroundImpl.cpp
    TabBackgroundImpl.h TabBackgroundImpl.cpp
    StarterImpl.h StarterImpl.cpp
    Resource.h Resource.cpp
)

if (APPLE)
    list(APPEND SOURCE_FILES OSXHideTitleBar.h OSXHideTitleBar.mm)
endif ()

qt_add_qml_module(${PROJECT_NAME}
    URI "FluentUI.impl"
    VERSION "${PROJECT_VERSION}"
    TYPEINFO "plugins.qmltypes"
    DESIGNER_SUPPORTED
    PLUGIN_TARGET ${PLUGIN_TARGET_NAME}
    QML_FILES ${QML_FILES}
    SOURCES ${SOURCE_FILES}
    RESOURCE_PREFIX /qt/qml
    OUTPUT_DIRECTORY ${FLUENTUI_QML_PLUGIN_DIRECTORY}/impl
)

target_compile_definitions(${PROJECT_NAME} PRIVATE
    HAVE_CONFIG_H
)

if (APPLE)
    target_link_libraries(${PROJECT_NAME} PRIVATE
        "-framework Foundation"
        "-framework Cocoa"
    )
endif ()

set_target_properties(${PROJECT_NAME} PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
    DEBUG_POSTFIX "d"
)

target_compile_definitions(${PROJECT_NAME}
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt6::Quick
    Qt6::QuickControls2
)
