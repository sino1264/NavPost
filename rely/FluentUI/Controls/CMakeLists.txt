cmake_minimum_required(VERSION 3.21)

project(FluentUIControls VERSION 1.0.0)

set(CMAKE_AUTOMOC ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 COMPONENTS Quick ShaderTools QuickControls2 REQUIRED)

if (FLUENTUI_BUILD_STATIC_LIB)
    set(PLUGIN_TARGET_NAME "")
else ()
    set(PLUGIN_TARGET_NAME ${PROJECT_NAME})
endif ()

qt_add_library(${PROJECT_NAME} ${FLUENTUI_LIB_TYPE})

set(QML_FILES
    StandardButton.qml
    NavigationView.qml
    PaneItem.qml
    AppBar.qml
    Breadcrumb.qml
    PaneItemExpander.qml
    AccentColor.qml
    IconButton.qml
    Icon.qml
    AutoLoader.qml
    ColorResource.qml
    FramelessWindow.qml
    ListTile.qml
    AutoSuggestBox.qml
    TextBox.qml
    MultiLineTextBox.qml
    ControlBackground.qml
    InputBackground.qml
    FocusItem.qml
    RoundImageView.qml
    RoundClip.qml
    PageRouter.qml
    ContentPage.qml
    Shadow.qml
    PaneItemSeparator.qml
    PaneItemHeader.qml
    InputMenu.qml
    NavigationMenuItem.qml
    NavigationMenu.qml
    HighlightRectangle.qml
    ScrollablePage.qml
    StackPage.qml
    SyntaxView.qml
    Expander.qml
    FilledButton.qml
    ToggleButton.qml
    HyperlinkButton.qml
    DropDownButton.qml
    DropDownPopup.qml
    TimePicker.qml
    NumberBox.qml
    DatePicker.qml
    DataGrid.qml
    TreeDataGrid.qml
    ProgressRing.qml
    InfoBar.qml
    InfoBarManager.qml
    ColorPicker.qml
    CalendarPicker.qml
    InfoBadge.qml
    HotLoader.qml
    Watermark.qml
    Tour.qml
    QRCode.qml
    WindowResultLauncher.qml
    Pagination.qml
    Acrylic.qml
    Chart.qml
    SplitLayout.qml
    StaggeredLayout.qml
    Starter.qml
    BannerLayout.qml
    FlipLayout.qml
    RatingControl.qml
    TabView.qml
    QMLHighlighter.qml
    ProgressButton.qml
    FastBlur.qml
    OpacityMask.qml
    CopyableText.qml
    PageContext.qml
    PageRouterView.qml
    Marquee.qml
    ColorOverlay.qml
    IconLabel.qml
    ShortcutPicker.qml
    MultiSelectComboBox.qml
    Chip.qml
    PasswordBox.qml
    PillButton.qml
    SegmentedControl.qml
    SegmentedButton.qml
    Shimmer.qml
    LinearGradient.qml
    RadialGradient.qml
    Timeline.qml
    DialogWindow.qml
    ContentDialog.qml
)

set(QML_SINGLETONS
    Theme.qml
    Colors.qml
    Typography.qml
    FluentIcons.qml
    WindowRouter.qml
)

set(RESOURCES_FILES
    font/FluentIcons.ttf
    Chart.js
    noise.webp
    shaders/opacitymask_invert.frag.qsb
    shaders/fastblur.frag.qsb
    shaders/fastblur_internal.frag.qsb
    shaders/fastblur_internal.vert.qsb
    shaders/opacitymask.frag.qsb
    shaders/coloroverlay.frag.qsb
    shaders/lineargradient.vert.qsb
    shaders/lineargradient_mask.frag.qsb
    shaders/lineargradient_nomask.frag.qsb
    shaders/radialgradient.vert.qsb
    shaders/radialgradient_mask.frag.qsb
    shaders/radialgradient_nomask.frag.qsb
)

set(SHADERS_FILES
    shaders/opacitymask_invert.frag
    shaders/fastblur.frag
    shaders/fastblur_internal.frag
    shaders/fastblur_internal.vert
    shaders/opacitymask.frag
    shaders/coloroverlay.frag
    shaders/lineargradient_nomask.frag
    shaders/lineargradient.vert
    shaders/lineargradient_mask.frag
    shaders/radialgradient_nomask.frag
    shaders/radialgradient.vert
    shaders/radialgradient_mask.frag
)

set_source_files_properties(${QML_SINGLETONS} PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(${PROJECT_NAME}
    URI "FluentUI.Controls"
    VERSION "${PROJECT_VERSION}"
    TYPEINFO "plugins.qmltypes"
    DESIGNER_SUPPORTED
    PLUGIN_TARGET ${PLUGIN_TARGET_NAME}
    QML_FILES ${QML_FILES} ${QML_SINGLETONS}
    RESOURCES ${RESOURCES_FILES}
    RESOURCE_PREFIX /qt/qml
    OUTPUT_DIRECTORY ${FLUENTUI_QML_PLUGIN_DIRECTORY}/Controls
)

qt_add_shaders(${PROJECT_NAME} shaders
    BATCHABLE
    PRECOMPILE
    OPTIMIZED
    FILES ${SHADERS_FILES}
)

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
)
if (FLUENTUI_BUILD_STATIC_LIB)
    target_link_libraries(
        ${PROJECT_NAME} PRIVATE
        FluentUIImplplugin
    )
endif()
