import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import FluentUI.Controls
import FluentUI.impl
import NavPost

Item{
    id:root

    property string title
    property PageContext context

    anchors.fill:parent
    GroupBox{
        id:function_box
        anchors.fill: parent
        padding: 5
        Item{
            width: parent.width
            height: 30
            Label{
                anchors{
                    left: parent.left
                    leftMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                text:qsTr("图层管理栏")
                font:Qt.font({pixelSize : 14, weight: Font.Bold})
            }

            IconButton{
                anchors{
                    right: parent.right
                    rightMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                icon.source: FluentIcons.graph_Pin
                icon.width: 15
                icon.height: 15
            }
        }


        Item{
            anchors.fill: parent
            anchors.topMargin: 30


        }
    }

}



