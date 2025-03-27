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
                    text: "基线属性"
                    verticalAlignment: Qt.AlignVCenter
                }
                content: com_baseline
            }
            ExpanderEx{
                width: parent.width
                expander_height:30

                expanded:true
                header: Label{
                    text: "解"
                    verticalAlignment: Qt.AlignVCenter
                }
                content: com_solution
            }
        }
    }


    Component{
        id:com_baseline
        Item{
            height: 180
            Column{
                spacing: 3
                anchors.fill: parent
                ComItem{
                    item_name:qsTr("基线ID")
                    delegate:TextField{
                        placeholderText: Global.focusBaseline.baseline_id
                    }
                }
                ComItem{
                    item_name:qsTr("起点文件")
                    delegate:TextField{
                        placeholderText: Global.focusBaseline.start_file
                    }
                }
                ComItem{
                    item_name:qsTr("终点文件")
                    delegate:TextField{
                        placeholderText: Global.focusBaseline.end_file
                    }
                }
                ComItem{
                    item_name:qsTr("起点名")
                    delegate:TextField{
                        placeholderText: Global.focusBaseline.start_station
                    }
                }
                ComItem{
                    item_name:qsTr("终点名")
                    delegate:TextField{
                        placeholderText: Global.focusBaseline.end_station
                    }
                }
                ComItem{
                    item_name:qsTr("同步时段")
                    delegate:TextField{
                        placeholderText: Global.focusBaseline.sync_seconds
                    }
                }
            }
        }
    }

    Component{
        id:com_solution
        Item{
            height: 480
            Column{
                spacing: 3
                anchors.fill: parent
                ComItem{
                    item_name:qsTr("RMS")
                    delegate:TextField{
                        placeholderText: Global.focusBaseline.solution_rms
                    }
                }
                ComItem{
                    item_name:qsTr("Ratio")
                    delegate:TextField{
                        placeholderText: Global.focusBaseline.solution_ratio
                    }
                }
                ComItem{
                    item_name:qsTr("Dx")
                    delegate:TextField{
                        placeholderText: Global.focusBaseline.solution_dx
                    }
                }
                ComItem{
                    item_name:qsTr("Dy")
                    delegate:TextField{
                        placeholderText: Global.focusBaseline.solution_dy
                    }
                }
                ComItem{
                    item_name:qsTr("Dz")
                    delegate:TextField{
                        placeholderText: Global.focusBaseline.solution_dz
                    }
                }
                ComItem{
                    item_name:qsTr("平距")
                    delegate:TextField{
                        placeholderText: Global.focusBaseline.solution_horizontal_distance
                    }
                }
                ComItem{
                    item_name:qsTr("斜距")
                    delegate:TextField{
                        placeholderText: Global.focusBaseline.solution_slope_distance
                    }
                }
                ComItem{
                    item_name:qsTr("高差")
                    delegate:TextField{
                        placeholderText: Global.focusBaseline.solution_elevation_difference
                    }
                }
                ComItem{
                    item_name:qsTr("NS前进方位角")
                    delegate:TextField{
                        placeholderText: Global.focusBaseline.solution_forward_angle
                    }
                }
                ComItem{
                    item_name:qsTr("椭球距离")
                    delegate:TextField{
                        placeholderText: Global.focusBaseline.solution_ellipsoidal_distance
                    }
                }
                ComItem{
                    item_name:qsTr("大地高")
                    delegate:TextField{
                        placeholderText: Global.focusBaseline.solution_geodetic_height
                    }
                }
                ComItem{
                    item_name:qsTr("RDOP")
                    delegate:TextField{
                       placeholderText: Global.focusBaseline.solution_RDOP
                    }
                }
                ComItem{
                    item_name:qsTr("PDOP")
                    delegate:TextField{
                        placeholderText: Global.focusBaseline.solution_PDOP
                    }
                }
                ComItem{
                    item_name:qsTr("HDOP")
                    delegate:TextField{
                        placeholderText: Global.focusBaseline.solution_HDOP
                    }
                }
                ComItem{
                    item_name:qsTr("VDOP")
                    delegate:TextField{
                        placeholderText: Global.focusBaseline.solution_VDOP
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
