import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Templates as T
import FluentUI.Controls
import FluentUI.impl

T.ComboBox {
    FluentUI.theme: Theme.of(control)
    property var accentColor: FluentUI.theme.accentColor
    property bool highlighted: false
    id: control
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)
    leftPadding: padding + (!control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)
    rightPadding: padding + (control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)
    font: Typography.body
    selectTextByMouse: true
    FluentUI.textColor: {
        if(!control.enabled){
            return control.FluentUI.theme.res.textFillColorDisabled
        }
        if(control.pressed){
            return control.FluentUI.theme.res.textFillColorSecondary
        }
        if(control.flat && control.hovered){
            return control.FluentUI.theme.res.textFillColorTertiary
        }
        return control.FluentUI.theme.res.textFillColorPrimary
    }
    delegate: ListTile {
        id: control_menu_item
        required property var model
        required property int index
        width: ListView.view.width
        text: control.textRole ? control.model instanceof Array ? model.modelData[control.textRole] : model[control.textRole] : model.modelData
        highlighted: control.highlightedIndex === index
        hoverEnabled: control.hoverEnabled
        font: control.font
        leftPadding: 18
        background: FocusItem{
            radius: 4
            implicitHeight: 36
            implicitWidth: 100
            target: control_menu_item
            Rectangle{
                width: 3
                height: 18
                radius: 1.5
                anchors{
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 6
                }
                visible: control.currentIndex === index
                color: control.accentColor.defaultBrushFor(control.FluentUI.dark)
            }
            Rectangle{
                radius: 4
                anchors{
                    fill: parent
                    leftMargin: 6
                    rightMargin: 6
                }
                color: control_menu_item.highlighted ? control.FluentUI.theme.res.subtleFillColorSecondary : Theme.uncheckedInputColor(control_menu_item,true,true,control.FluentUI.dark)
            }
        }
    }
    indicator: Item{
        width: 35
        height: 35
        x: control.mirrored ? control.padding : control.width - width - control.padding
        y: (control.topPadding + (control.availableHeight - height) / 2) + (control.pressed ? 1 : 0)
        Behavior on y {
            NumberAnimation{ easing.type: Theme.animationCurve; duration: Theme.fastAnimationDuration }
        }
        Icon {
            color: control.enabled ? control.FluentUI.theme.res.textFillColorSecondary : control.FluentUI.theme.res.textFillColorDisabled
            source: FluentIcons.graph_ChevronDown
            width: 12
            height: 12
            anchors.centerIn: parent
        }
    }
    contentItem: T.TextField {
        leftPadding: 12
        text: control.editable ? control.editText : control.displayText
        enabled: control.editable
        autoScroll: control.editable
        readOnly: control.down
        inputMethodHints: control.inputMethodHints
        validator: control.validator
        selectByMouse: control.selectTextByMouse
        color: control.FluentUI.textColor
        font: control.font
        renderType: Theme.textRender
        selectionColor: control.accentColor.defaultBrushFor(control.FluentUI.dark)
        selectedTextColor: Colors.basedOnLuminance(selectionColor)
        verticalAlignment: Text.AlignVCenter
        z: 999
    }
    background: Item{
        implicitWidth: 120
        implicitHeight: 35
        InputBackground {
            anchors.fill: parent
            target: control
            radius: 4
            activeColor: control.accentColor.defaultBrushFor(control.FluentUI.dark)
            visible: control.editable
        }
        ControlBackground{
            anchors.fill: parent
            target: control
            radius: 4
            visible: !control.editable
        }
    }
    popup: T.Popup {
        topMargin: 8
        bottomMargin: 8
        width: control.width
        height: Math.min(contentItem.implicitHeight + topPadding + bottomPadding, control.Window.height - topMargin - bottomMargin)
        verticalPadding: 6
        FluentUI.dark: control.FluentUI.dark
        FluentUI.primaryColor: control.FluentUI.primaryColor
        y: control.editable ? control.height
                            : -0.25 * Math.max(implicitBackgroundHeight + topInset + bottomInset,
                                               contentHeight + topPadding + bottomPadding)
        enter: Transition {
            NumberAnimation { property: "height"; from: control.popup.height / 3; to: control.popup.height; easing.type: Theme.animationCurve; duration: Theme.mediumAnimationDuration }
        }
        contentItem: Item{
            implicitWidth: list_view.width
            implicitHeight: list_view.height
            clip: true
            ListView {
                id: list_view
                width: control.width
                implicitHeight: Math.min(contentHeight,control.FluentUI.minimumHeight)
                highlightMoveDuration: 0
                model: control.delegateModel
                currentIndex: control.highlightedIndex
                ScrollBar.vertical: ScrollBar {}
                boundsBehavior: ListView.StopAtBounds
            }
        }
        background: Rectangle{
            radius: 4
            border.width: 1
            color: control.FluentUI.theme.res.popupBackgroundColor
            border.color: control.FluentUI.theme.res.popupBorderColor
            Shadow{
                radius: 4
            }
        }
    }
}
