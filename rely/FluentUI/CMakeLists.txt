cmake_minimum_required(VERSION 3.21)

project(FluentUI VERSION 1.0.0)

set(CMAKE_AUTOMOC ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 COMPONENTS Quick QuickControls2 REQUIRED)

set(QT_SDK_DIR "${Qt6_DIR}/../../..")
cmake_path(SET QT_SDK_DIR NORMALIZE ${QT_SDK_DIR})

set(FLUENTUI_QML_PLUGIN_DIRECTORY ${CMAKE_BINARY_DIR}/qt/qml/FluentUI)

if (FLUENTUI_BUILD_STATIC_LIB)
    set(FLUENTUI_LIB_TYPE "STATIC")
    set(PLUGIN_TARGET_NAME "")
else ()
    set(FLUENTUI_LIB_TYPE "SHARED")
    set(PLUGIN_TARGET_NAME ${PROJECT_NAME})
endif ()

qt_add_library(${PROJECT_NAME} ${FLUENTUI_LIB_TYPE})

set(QML_FILES
    Button.qml
    CheckBox.qml
    Switch.qml
    Label.qml
    Frame.qml
    Menu.qml
    MenuBar.qml
    MenuBarItem.qml
    MenuItem.qml
    MenuSeparator.qml
    ToolBar.qml
    StackView.qml
    Page.qml
    ProgressBar.qml
    RadioButton.qml
    Slider.qml
    ComboBox.qml
    TextField.qml
    GroupBox.qml
    TextArea.qml
    ScrollBar.qml
    Tumbler.qml
    DialogButtonBox.qml
    Dialog.qml
    ToolTip.qml
    TreeViewDelegate.qml
    TabButton.qml
    TabBar.qml
    Drawer.qml
    VerticalHeaderView.qml
    HorizontalHeaderView.qml
    SelectionRectangle.qml
    SplitView.qml
    Dial.qml
    Popup.qml
    PageIndicator.qml
    RangeSlider.qml
    Pane.qml
    DelayButton.qml
    SpinBox.qml
)

set(RESOURCES_FILES
    FluentUI_zh_CN.qm
    FluentUI_en_US.qm
)

qt_add_qml_module(${PROJECT_NAME}
    URI "FluentUI"
    VERSION "${PROJECT_VERSION}"
    TYPEINFO "plugins.qmltypes"
    DESIGNER_SUPPORTED
    PLUGIN_TARGET ${PLUGIN_TARGET_NAME}
    QML_FILES ${QML_FILES}
    RESOURCES ${RESOURCES_FILES}
    RESOURCE_PREFIX /qt/qml
    OUTPUT_DIRECTORY ${FLUENTUI_QML_PLUGIN_DIRECTORY}
)

if (NOT FLUENTUI_BUILD_STATIC_LIB)
    add_custom_target(${PROJECT_NAME}_install_plugin ALL
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/designer ${FLUENTUI_QML_PLUGIN_DIRECTORY}/designer
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${FLUENTUI_QML_PLUGIN_DIRECTORY} ${QT_SDK_DIR}/qml/FluentUI
        DEPENDS ${PROJECT_NAME}
        COMMENT "Installing ${PROJECT_NAME} plugin to Qt qml"
        SOURCES CMakeLists.txt
    )
endif ()

if (NOT CMAKE_SYSTEM_NAME STREQUAL "Emscripten")
    find_program(QT_LUPDATE NAMES lupdate lupdate-qt6)
    find_program(QT_LRELEASE NAMES lrelease lrelease-qt6)
    file(GLOB TS_FILE_PATHS ${CMAKE_CURRENT_LIST_DIR}/ *.ts)
    add_custom_target(${PROJECT_NAME}_translations
        COMMAND ${QT_LUPDATE} ${CMAKE_CURRENT_LIST_DIR} -ts ${PROJECT_NAME}_en_US.ts WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
        COMMAND ${QT_LUPDATE} ${CMAKE_CURRENT_LIST_DIR} -ts ${PROJECT_NAME}_zh_CN.ts WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
        COMMAND ${QT_LRELEASE} ${PROJECT_NAME}_en_US.ts WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
        COMMAND ${QT_LRELEASE} ${PROJECT_NAME}_zh_CN.ts WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
        SOURCES ${TS_FILE_PATHS}
    )
endif()

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
    FluentUIImpl
    FluentUIControls
)
if (FLUENTUI_BUILD_STATIC_LIB)
    target_link_libraries(
        ${PROJECT_NAME} PRIVATE
        FluentUIImplplugin
        FluentUIControlsplugin
    )
endif()

add_subdirectory(impl)
add_subdirectory(Controls)
