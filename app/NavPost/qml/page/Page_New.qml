import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import FluentUI.Controls
import FluentUI.impl
// import QtWebEngine
ScrollablePage{

    title: qsTr("新建")

    columnSpacing:10

    Item{
        Layout.fillWidth: true
        implicitHeight: create_project_row.height

        // visible: root.expanded

        Flickable{
            anchors.fill: parent
            contentWidth: create_project_row.width

            Row{
                id:create_project_row

                IconButton{
                    height:200
                    width:200
                    Icon{
                        anchors{
                            horizontalCenter: parent.horizontalCenter
                            top:parent.top
                            topMargin: 20
                        }
                        source: FluentIcons.graph_Page
                        color:Theme.res.textFillColorTertiary
                        width: 120
                        height: 120
                    }
                    Label{
                        text: qsTr("空白工程")
                        font:Typography.bodyStrong
                        Component.onCompleted:{font.bold=true}
                        anchors{
                            horizontalCenter: parent.horizontalCenter
                            bottom: parent.bottom
                            bottomMargin: 20
                        }
                    }

                    onClicked:{
                        Global.displayScreen="/screen/main"
                    }
                }

                IconButton{
                    height:200
                    width:200
                    Icon{
                        anchors{
                            horizontalCenter: parent.horizontalCenter
                            top:parent.top
                            topMargin: 20
                        }
                        source: FluentIcons.graph_Page
                        color:Theme.res.textFillColorTertiary
                        width: 120
                        height: 120
                    }
                    Label{
                        text: qsTr("工程向导")
                        font:Typography.bodyStrong
                        Component.onCompleted:{font.bold=true}
                        anchors{
                            horizontalCenter: parent.horizontalCenter
                            bottom: parent.bottom
                            bottomMargin: 20
                        }
                    }
                    onClicked:{
                        Global.displayScreen="/screen/init"
                    }
                }
            }
        }
    }

    Rectangle{
        Layout.fillWidth: true
        height: 1
        color: control.palette.mid
    }

}
