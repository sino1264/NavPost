import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import FluentUI.Controls
import FluentUI.impl
import NavPost
ScrollablePage{

    id:root

    property bool expanded:true   //控制页面是否展开新建选项
    property var currentTime: new Date()

    columnSpacing:10

    Component.onCompleted: {
        var hour = currentTime.getHours();
        if (hour >= 5 && hour < 11) {
            root.title=qsTr("早上好!") ;
        } else if (hour >= 11 && hour < 14) {
            root.title=qsTr("中午好!") ;
        } else if (hour >= 14 && hour < 18) {
            root.title=qsTr("下午好!") ;
        } else {
            root.title=qsTr("晚上好!") ;
        }
    }


    // Frame{
    //     visible: false
    //     width: parent.width
    //     height: 30

    //     Row{
    //         spacing: 10
    //         Button{
    //             text: "切换到初始页面"
    //             icon.name: FluentIcons.graph_Copy
    //             icon.width: 18
    //             icon.height: 18
    //             spacing: 5

    //             onClicked:{
    //                 Global.displayScreen="/screen/init"
    //             }
    //         }
    //         Button{
    //             text: "切换到主页"
    //             icon.name: FluentIcons.graph_Copy
    //             icon.width: 18
    //             icon.height: 18
    //             spacing: 5

    //             onClicked:{
    //                 Global.displayScreen="/screen/main"
    //             }
    //         }
    //         Button{
    //             text: "切换到文件页面"
    //             icon.name: FluentIcons.graph_Copy
    //             icon.width: 18
    //             icon.height: 18
    //             spacing: 5

    //             onClicked:{
    //                 Global.displayScreen="/screen/file"
    //             }
    //         }
    //     }
    // }





    Item{
        Layout.fillWidth: true
        implicitHeight: expander_row.height

        Row{
            id:expander_row

            anchors{
                verticalCenter: parent.verticalCenter
            }
            padding: 0
            spacing: 10

            IconButton{
                text: "Expander"
                display: IconButton.IconOnly
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    root.expanded=!root.expanded
                }

                Icon{
                    anchors.centerIn: parent
                    rotation: root.expanded ? 180:90
                    source: FluentIcons.graph_ChevronUp
                    width: 20
                    height: 20
                    // color: control.enabled ? control.FluentUI.theme.res.textFillColorPrimary : control.FluentUI.theme.res.textFillColorDisabled
                    Behavior on rotation {
                        NumberAnimation{
                            duration: Theme.fastAnimationDuration
                            easing.type: Theme.animationCurve
                        }
                    }
                }
            }

            FilledButton{
                visible:!root.expanded
                text: qsTr("新建空白工程")
                font: Typography.bodyLarge

                onClicked:{
                    Global.displayScreen="/screen/main"
                }
            }

            Label{
                visible:root.expanded
                text: qsTr("新建")
                font: Typography.subtitle
            }
        }
    }

    Item{
        Layout.fillWidth: true
        implicitHeight: create_project_row.height

        visible: root.expanded

        Flickable{
            anchors.fill: parent
            contentWidth: create_project_row.width

            Row{
                id:create_project_row

                IconButton{
                    height:180
                    width:180
                    Icon{
                        anchors{
                            horizontalCenter: parent.horizontalCenter
                            top:parent.top
                            topMargin: 30
                        }
                        source: FluentIcons.graph_Page
                        color:Theme.res.textFillColorTertiary
                        width: 75
                        height: 75
                    }
                    Label{
                        text: qsTr("空白工程")
                        font:Typography.bodyStrong
                        Component.onCompleted:{font.bold=true}
                        anchors{
                            horizontalCenter: parent.horizontalCenter
                            bottom: parent.bottom
                            bottomMargin: 30
                        }
                    }

                    onClicked:{
                        // Global.displayScreen="/screen/main"

                        Global.open_dialog("/dialog/project/new_project")
                    }
                }

                IconButton{
                    height:180
                    width:180
                    Icon{
                        anchors{
                            horizontalCenter: parent.horizontalCenter
                            top:parent.top
                            topMargin: 30
                        }
                        source: FluentIcons.graph_Page
                        color:Theme.res.textFillColorTertiary
                        width: 75
                        height: 75
                    }
                    Label{
                        text: qsTr("工程向导")
                        font:Typography.bodyStrong
                        Component.onCompleted:{font.bold=true}
                        anchors{
                            horizontalCenter: parent.horizontalCenter
                            bottom: parent.bottom
                            bottomMargin: 30
                        }
                    }
                    onClicked:{
                        Global.displayScreen="/screen/init"
                    }
                }

                IconButton{
                    height:180
                    width:180
                    Icon{
                        anchors{
                            horizontalCenter: parent.horizontalCenter
                            top:parent.top
                            topMargin: 30
                        }
                        source: FluentIcons.graph_Page
                        color:Theme.res.textFillColorTertiary
                        width: 75
                        height: 75
                    }
                    Label{
                        text: qsTr("不创建工程")
                        font:Typography.bodyStrong
                        Component.onCompleted:{font.bold=true}
                        anchors{
                            horizontalCenter: parent.horizontalCenter
                            bottom: parent.bottom
                            bottomMargin: 30
                        }
                    }

                    onClicked:{
                        Global.displayScreen="/screen/main"
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

    Item{
        Layout.fillWidth: true
        implicitHeight: search_project_box.height


        AutoSuggestBox{

            id:search_project_box
            height: 40
            width: root.width*0.35

            items: generateRandomNames(100)
            placeholderText: qsTr("搜索")

            leftPadding: 50

            Icon{
                anchors{
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 15
                }

                source: FluentIcons.graph_Search
                width: 20
                height: 20
            }
            function generateRandomNames(numNames) {
                const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
                const names = []
                function generateRandomName() {
                    const nameLength = Math.floor(Math.random() * 5) + 4
                    let name = ''
                    for (let i = 0; i < nameLength; i++) {
                        const letterIndex = Math.floor(Math.random() * 26);
                        name += alphabet.charAt(letterIndex)
                    }
                    return name
                }
                for (let i = 0; i < numNames; i++) {
                    const name = generateRandomName()
                    names.push({title:name})
                }
                return names
            }
        }
    }

    Item{
        Layout.fillWidth: true
        implicitHeight:project_tabbar.height
        TabBar{
            id:project_tabbar
            width: parent.width
            clip: true
            leftPadding: 20
            height:30
            Repeater {
                model: tab_model
                TabButton {
                    id: btn_tab
                    text: model.title
                    font: Typography.bodyLarge
                    height:30
                }
            }
        }
        ListModel{
            id: tab_model
            ListElement{
                title: qsTr("最近")
            }
            ListElement{
                title:qsTr("已固定")
            }
        }
    }


    Item{
        Layout.fillWidth: true
        implicitHeight:40

        Icon{
            anchors{
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: 3
                left: parent.left
                leftMargin: 35
            }
            source: FluentIcons.graph_Page
            width:20
            color:Theme.res.textFillColorSecondary
        }

        Label{
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: 100
            }
            text: qsTr("名称")
            color:Theme.res.textFillColorSecondary
        }

        Label{
            anchors{
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: 100
            }

            width: 150
            text: qsTr("最后修改日期")
            color:Theme.res.textFillColorSecondary
        }

        Rectangle{
            width: parent.width
            height: 1
            color: control.palette.mid
            anchors.bottom: parent.bottom
        }
    }



    Shimmer{
        Layout.preferredWidth: layout_column.width
        Layout.preferredHeight: layout_column.height
        Column{
            id: layout_column
            spacing: 10
            width: root.width
            Repeater{
                model: 10
                delegate: Frame{
                    implicitWidth: layout_column.width
                    implicitHeight: 80

                    Rectangle{
                        id: avatar
                        width: 60
                        height: 60
                        // radius: 50
                        color: Theme.res.dividerStrokeColorDefault
                        anchors{
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            leftMargin: 20
                        }
                    }
                    Rectangle{
                        width: 240
                        height: 22
                        radius: 4
                        color: Theme.res.dividerStrokeColorDefault
                        anchors{
                            top: avatar.top
                            left: avatar.right
                            topMargin: 6
                            leftMargin: 20
                        }
                    }
                    Rectangle{
                        width: 400
                        height: 20
                        radius: 4
                        color: Theme.res.dividerStrokeColorDefault
                        anchors{
                            bottom: avatar.bottom
                            left: avatar.right
                            bottomMargin: 6
                            leftMargin: 20
                        }
                    }

                    Rectangle{
                        width: 200
                        height: 20
                        radius: 4
                        color: Theme.res.dividerStrokeColorDefault
                        anchors{
                            verticalCenter: avatar.verticalCenter
                            right:parent.right
                            rightMargin: 100
                        }
                    }

                }
            }
        }




    }




}
