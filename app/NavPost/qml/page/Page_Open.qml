import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import FluentUI.Controls
import FluentUI.impl
import NavPost

ContentPage{

    title: qsTr("打开")
    Item{
        id:left_side
        width: 300
        height: parent.height




    }

    Rectangle{
        height:parent.height
        width: 1
        color: control.palette.mid
        anchors{
            left: left_side.right
        }
    }

    Item{
        height: parent.height
        anchors{
            left: left_side.right
            right: parent.right
        }
    }



}
