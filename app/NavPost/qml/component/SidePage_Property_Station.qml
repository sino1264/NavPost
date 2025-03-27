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
                    text: "常规"
                    verticalAlignment: Qt.AlignVCenter
                }
                content: com_common
            }
            ExpanderEx{
                width: parent.width
                expander_height:30

                expanded:true
                header: Label{
                    text: "坐标系统"
                    verticalAlignment: Qt.AlignVCenter
                }
                content: com_coord
            }
            ExpanderEx{
                width: parent.width
                expander_height:30

                expanded:true
                header: Label{
                    text: "大地坐标"
                    verticalAlignment: Qt.AlignVCenter
                }
                content: com_llh
            }
            ExpanderEx{
                width: parent.width
                expander_height:30

                expanded:true
                header: Label{
                    text: "空间直角坐标系"
                    verticalAlignment: Qt.AlignVCenter
                }
                content: com_ecef
            }
        }
    }

    Component{
        id:com_common
        Item{
            height: 90
            Column{
                spacing: 3
                anchors.fill: parent
                ComItem{
                    item_name:qsTr("点名")
                    delegate:TextField{
                        placeholderText: Global.focusStation.station_name
                    }
                }
                ComItem{
                    item_name:qsTr("编码")
                    delegate:TextField{
                        placeholderText: Global.focusStation.station_name
                    }
                }
                ComItem{
                    item_name:qsTr("站点备注")
                    delegate:TextField{
                        placeholderText: ""
                    }
                }
            }
        }
    }

    Component{
        id:com_coord
        Item{
            height:60
            Column{
                spacing: 3
                anchors.fill: parent
                ComItem{
                    item_name:qsTr("坐标来源")
                    delegate:TextField{
                        placeholderText: "WGS84坐标系统"
                    }
                }
                ComItem{
                    item_name:qsTr("坐标类型")
                    delegate:TextField{
                        placeholderText: "WGS-84"
                    }
                }
            }
        }
    }

    Component{
        id:com_llh
        Item{
            height: 90
            Column{
                spacing: 3
                anchors.fill: parent
                ComItem{
                    item_name:qsTr("纬度")
                    delegate:TextField{
                        placeholderText: Global.focusStation.llh_lat
                    }
                }
                ComItem{
                    item_name:qsTr("经度")
                    delegate:TextField{
                        placeholderText: Global.focusStation.llh_lon
                    }
                }
                ComItem{
                    item_name:qsTr("大地高")
                    delegate:TextField{
                        placeholderText: Global.focusStation.llh_height
                    }
                }
            }
        }
    }

    Component{
        id:com_ecef
        Item{
            height: 90
            Column{
                spacing: 3
                anchors.fill: parent
                ComItem{
                    item_name:qsTr("X")
                    delegate:TextField{
                        placeholderText: Global.focusStation.ecef_x
                    }
                }
                ComItem{
                    item_name:qsTr("Y")
                    delegate:TextField{
                        placeholderText: Global.focusStation.ecef_y
                    }
                }
                ComItem{
                    item_name:qsTr("Z")
                    delegate:TextField{
                        placeholderText: Global.focusStation.ecef_z
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
