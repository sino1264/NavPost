import QtQuick
import QtQuick.Controls
import FluentUI.Controls
import FluentUI.impl

Window {
    id: control
    default property alias content: content_dialog.contentData
    property alias dialog: content_dialog
    property alias standardButtons: content_dialog.standardButtons
    property int borderWidth: 5
    flags: Qt.FramelessWindowHint | Qt.Window
    visible: dialog.visible
    width: content_dialog.implicitWidth+(2*control.borderWidth)
    height: content_dialog.implicitHeight+(2*control.borderWidth)
    FluentUI.radius: 8
    FluentUI.theme: Theme.of(control)
    FluentUI.dark: Theme.dark
    FluentUI.primaryColor: Theme.primaryColor
    color: Colors.transparent
    ContentDialog{
        id: content_dialog
        title: control.title
        x: control.borderWidth
        y: control.borderWidth
        background: Rectangle {
            color: control.FluentUI.theme.res.solidBackgroundFillColorQuarternary
            border.color: control.FluentUI.theme.res.dividerStrokeColorDefault
            radius: control.FluentUI.radius
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.SizeAllCursor
                onPositionChanged: {
                    control.startSystemMove()
                }
            }
            Shadow{
                radius: control.FluentUI.radius
                anchors.fill: parent
            }
        }
    }
    function close(){
        content_dialog.close()
    }
    function open(){
        content_dialog.open()
    }
}
