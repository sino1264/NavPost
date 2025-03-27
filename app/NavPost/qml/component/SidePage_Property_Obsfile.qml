import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI.impl
import FluentUI.Controls
import NavPost
import "../extra"

Frame{
    id:root

    anchors.fill: parent

    property string title
    property PageContext context

    property int item_name_width:width*0.35
    property int item_value_width:width*0.65
    property int item_height:27


    Flickable{
        anchors.fill: parent
        contentHeight: columnItem.height
        // contentHeight: rowItem.height
        interactive: contentHeight > height

        Column{
            id:columnItem
            width: root.width

            ExpanderEx{
                width: parent.width
                expander_height:30

                expanded:true
                header: Label{
                    text: "站点"
                    verticalAlignment: Qt.AlignVCenter
                }
                content: com_station
            }
            ExpanderEx{
                width: parent.width
                expander_height:30

                expanded:true
                header: Label{
                    text: "天线"
                    verticalAlignment: Qt.AlignVCenter
                }
                content: com_ant
            }
            ExpanderEx{
                width: parent.width
                expander_height:30

                expanded:true
                header: Label{
                    text: "仪器"
                    verticalAlignment: Qt.AlignVCenter
                }
                content: com_device
            }
            ExpanderEx{
                width: parent.width
                expander_height:30

                expanded:true
                header: Label{
                    text: "Rinex输出的天线配置"
                    verticalAlignment: Qt.AlignVCenter
                }
                content: com_rinex
            }
        }
    }



    Component{
        id:com_station
        Item{
            height: 30
            Column{
                spacing: 3
                anchors.fill: parent
                ComItem{
                    item_name:qsTr("站点名称")
                    delegate:TextField{
                        placeholderText: Global.focusObsFile.station_name
                    }
                }
            }
        }
    }

    Component{
        id:com_ant
        Item{
            height: 180
            Column{
                spacing: 3
                anchors.fill: parent
                ComItem{
                    item_name:qsTr("测量方式")
                    delegate:TextField{
                        placeholderText: Global.focusObsFile.measurement_method
                    }
                }
                ComItem{
                    item_name:qsTr("测量天线高")
                    delegate:TextField{
                        placeholderText: Global.focusObsFile.measurement_ant_height
                    }
                }
                ComItem{
                    item_name:qsTr("天线高一致性补偿")
                    delegate:TextField{
                        placeholderText: Global.focusObsFile.ant_height_corrent
                    }
                }
                ComItem{
                    item_name:qsTr("厂商")
                    delegate:TextField{
                        placeholderText: Global.focusObsFile.ant_manufacturer
                    }
                }
                ComItem{
                    item_name:qsTr("天线型号")
                    delegate:TextField{
                        placeholderText: Global.focusObsFile.ant_type
                    }
                }
                ComItem{
                    item_name:qsTr("天线SN号")
                    delegate:TextField{
                        placeholderText: Global.focusObsFile.ant_sn
                    }
                }
            }
        }
    }

    Component{
        id:com_device

        Item{
            height: 90
            Column{
                spacing: 3
                anchors.fill: parent
                ComItem{
                    item_name:qsTr("接收机/SN")
                    delegate:TextField{
                        placeholderText: Global.focusObsFile.receiver_sn
                    }
                }
                ComItem{
                    item_name:qsTr("接收机类型")
                    delegate:TextField{
                        placeholderText: Global.focusObsFile.receiver_type
                    }
                }
                ComItem{
                    item_name:qsTr("接收机版本号")
                    delegate:TextField{
                        placeholderText: Global.focusObsFile.receiver_version
                    }
                }
            }
        }
    }

    Component{
        id:com_rinex
        Item{
            height: 120
            Column{
                spacing: 3
                anchors.fill: parent
                ComItem{
                    item_name:qsTr("测量方式")
                    delegate:TextField{
                        placeholderText: Global.focusObsFile.rinex_measurement_method
                    }
                }
                ComItem{
                    item_name:qsTr("天线高")
                    delegate:TextField{
                        placeholderText: Global.focusObsFile.rinex_ant_height
                    }
                }
                ComItem{
                    item_name:qsTr("厂商")
                    delegate:TextField{
                        placeholderText: Global.focusObsFile.rinex_manufacturer
                    }
                }
                ComItem{
                    item_name:qsTr("天线类型")
                    delegate:TextField{
                        placeholderText: Global.focusObsFile.rinex_ant_type
                    }
                }
            }
        }
    }


    component ComItem:Item{
        property string item_name;
        property Component delegate

        width: item_name_width
        height:item_height
        // anchors.verticalCenter: parent.verticalCenter
        Row{
            spacing: 0
            Item{
                width: item_name_width
                height:item_height
                IconButton{
                    anchors.fill: parent
                    text: item_name
                }
            }
            Frame{
                width: item_value_width
                height:item_height
                AutoLoader{
                    anchors{
                        fill:parent
                    }
                    sourceComponent: delegate
                }
            }
        }
    }

    // component ExpanderEx:Item {
    //     FluentUI.theme: Theme.of(control)
    //     property bool expanded: false
    //     property Component content
    //     property Component header: comp_header
    //     property Component leading
    //     property Component trailing
    //     property string title
    //     property int expander_height
    //     id:control
    //     implicitHeight: Math.max((layout_control.height + layout_container.height),layout_control.height)
    //     implicitWidth: 400
    //     QtObject{
    //         id:d
    //         property bool flag: false
    //         property int contentHeight: Math.max(loader_content.height,30)
    //         function toggle(){
    //             d.flag = true
    //             expanded = !expanded
    //             d.flag = false
    //         }
    //     }
    //     Component{
    //         id: comp_header
    //         Label{
    //             text: control.title
    //             horizontalAlignment: Qt.AlignHCenter
    //             verticalAlignment: Qt.AlignVCenter
    //         }
    //     }
    //     clip: true
    //     Button{
    //         id: layout_control
    //         width: parent.width
    //         height: expander_height
    //         FluentUI.radius: 6
    //         activeFocusOnTab: true
    //         Keys.onSpacePressed: {
    //             d.toggle()
    //         }
    //         onClicked: {
    //             d.toggle()
    //         }
    //         RowLayout{
    //             anchors.fill: parent
    //             spacing: 0
    //             Loader{
    //                 Layout.fillHeight: true
    //                 sourceComponent: control.header
    //                 Layout.leftMargin: 20
    //             }
    //             Loader{
    //                 Layout.fillHeight: true
    //                 sourceComponent: control.leading
    //                 Layout.leftMargin: 10
    //                 visible: sourceComponent !== undefined
    //             }
    //             Item{
    //                 Layout.fillHeight: true
    //                 Layout.fillWidth: true
    //             }
    //             Loader{
    //                 sourceComponent: control.trailing
    //                 Layout.leftMargin: 8
    //                 Layout.alignment: Qt.AlignVCenter
    //                 visible: sourceComponent !== undefined
    //             }
    //             Item{
    //                 implicitWidth: 50
    //                 Layout.fillHeight: true
    //                 IconButton{
    //                     id: btn_icon
    //                     anchors.centerIn: parent
    //                     width: 30
    //                     height: 30
    //                     Icon{
    //                         anchors.centerIn: parent
    //                         rotation: expanded ? 0 : -180
    //                         source: FluentIcons.graph_ChevronUp
    //                         width: 15
    //                         height: 15
    //                         color: control.enabled ? control.FluentUI.theme.res.textFillColorPrimary : control.FluentUI.theme.res.textFillColorDisabled
    //                         Behavior on rotation {
    //                             NumberAnimation{
    //                                 duration: Theme.fastAnimationDuration
    //                                 easing.type: Theme.animationCurve
    //                             }
    //                         }
    //                     }
    //                     onClicked: {
    //                         d.toggle()
    //                     }
    //                 }
    //             }
    //         }
    //     }
    //     Item{
    //         id:layout_container
    //         anchors{
    //             top: layout_control.bottom
    //             topMargin: -1
    //             left: layout_control.left
    //         }
    //         visible: d.contentHeight+container.anchors.topMargin !== 0
    //         height: d.contentHeight+container.anchors.topMargin
    //         width: parent.width
    //         z:-999
    //         clip: true
    //         Rectangle{
    //             id:container
    //             anchors.fill: parent
    //             radius: 6
    //             clip: true
    //             border.color: control.FluentUI.theme.res.cardStrokeColorDefault
    //             color: control.FluentUI.theme.res.cardBackgroundFillColorSecondary
    //             anchors.topMargin: -d.contentHeight
    //             Loader{
    //                 id: loader_content
    //                 width: parent.width
    //                 sourceComponent: {
    //                     if(control.expanded){
    //                         return control.content
    //                     }
    //                     return undefined
    //                 }
    //             }
    //             states: [
    //                 State{
    //                     name:"expand"
    //                     when: control.expanded
    //                     PropertyChanges {
    //                         target: container
    //                         anchors.topMargin:0
    //                     }
    //                 },
    //                 State{
    //                     name:"collapsed"
    //                     when: !control.expanded
    //                     PropertyChanges {
    //                         target: container
    //                         anchors.topMargin: -d.contentHeight
    //                     }
    //                 }
    //             ]
    //             transitions: [
    //                 Transition {
    //                     to:"expand"
    //                     NumberAnimation {
    //                         properties: "anchors.topMargin"
    //                         duration: Theme.fastAnimationDuration
    //                         easing.type: Theme.animationCurve
    //                     }
    //                 },
    //                 Transition {
    //                     to:"collapsed"
    //                     NumberAnimation {
    //                         properties: "anchors.topMargin"
    //                         duration: Theme.fastAnimationDuration
    //                         easing.type: Theme.animationCurve
    //                     }
    //                 }
    //             ]
    //         }
    //     }
    // }





}
