import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import FluentUI.Controls
import FluentUI.impl
import NavPost

// ContentPage
Item{
    id:root

    anchors.fill: parent

    property string title
    property PageContext context
    property int group_height:root.height-function_box.padding*2
    property int function_height:group_height-groupname_height

    property int groupbox_padding:5 //内容与背景边框的间距
    property int group_spacing:5  //每个组之间的间距
    property int group_padding:5  //每个组内按键与组边框的间距
    property int groupname_height:20 //每个组名的高度

    property int iconbutton_spacing: 10 //每个标准按键，图标和文字的间距
    property int iconbutton_size: 22    //标准按键，图标的宽度
    property int iconbutton_width:60    //标准按键，按键的指定宽度（一般都是默认宽度）

    GroupBox{
        id:function_box
        anchors.fill: parent
        padding: groupbox_padding

        Flickable{

            anchors.fill: parent
            contentWidth: rowItem.width
            // contentHeight: rowItem.height

            Row{
                id:rowItem
                spacing: group_spacing
                Frame{
                    width: implicitWidth

                    Column{
                        Frame{
                            width: implicitWidth
                            Row {
                                padding: group_padding

                                IconButton {
                                    text: qsTr("结果图表")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_AreaChart
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon
                                }

                                Column {
                                    IconButton {
                                        text: qsTr("时间序列图")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_AreaChart
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5
                                    }

                                    IconButton {
                                        text: qsTr("平面轨迹图")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_AreaChart
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5
                                    }
                                }


                                IconButton {
                                    text: qsTr("质量图表")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_PieSingle
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon

                                    onClicked: {
                                        info_manager_top.show(InfoBarType.Warning,qsTr("未选中任何观测文件，请选中一个观测文件来查看数据质量！"))
                                        // info_manager_topleft.show(InfoBarType.Warning,qsTr("未选中任何观测文件，请选中一个观测文件来查看数据质量！"))
                                        // info_manager_topright.show(InfoBarType.Warning,qsTr("未选中任何观测文件，请选中一个观测文件来查看数据质量！"))
                                        // info_manager_bottom.show(InfoBarType.Warning,qsTr("未选中任何观测文件，请选中一个观测文件来查看数据质量！"))
                                        // info_manager_bottomleft.show(InfoBarType.Warning,qsTr("未选中任何观测文件，请选中一个观测文件来查看数据质量！"))
                                        // info_manager_bottomright.show(InfoBarType.Warning,qsTr("未选中任何观测文件，请选中一个观测文件来查看数据质量！"))
                                    }
                                }


                                Column {
                                    IconButton {
                                        text: qsTr("时间覆盖图")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_AreaChart
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5

                                    }
                                }
                            }
                        }
                        Label{
                            height:groupname_height
                            text:qsTr("数据可视化")
                            font:Typography.bodyStrong
                            // color:Theme.res.textFillColorPrimary
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }



                Frame{
                    width: implicitWidth

                    Column{
                        Frame{
                            width: implicitWidth
                            Row {
                                padding: group_padding
                                IconButton {
                                    text: qsTr("质量分析")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_MultiSelect
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon
                                }
                                Column {
                                    IconButton {
                                        text: qsTr("分析配置")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_Equalizer
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5
                                    }

                                    IconButton {
                                        text: qsTr("分析报告")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_ReportDocument
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5
                                    }
                                }
                            }
                        }
                        Label{
                            height:groupname_height
                            text:qsTr("质检工具")
                            font:Typography.bodyStrong
                            // color:Theme.res.textFillColorPrimary
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }

                Frame{
                    width: implicitWidth

                    Column{
                        Frame{
                            width: implicitWidth
                            Row {
                                padding: group_padding

                                IconButton {
                                    text: qsTr("Rinex转换")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_Bug
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon

                                    onClicked: {
                                        Global.open_dialog("/dialog/convert/add_task")
                                    }

                                }
                                Column {
                                    IconButton {
                                        text: qsTr("转换配置")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_ProvisioningPackage
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5

                                        onClicked: {
                                            Global.open_dialog("/dialog/convert/eidt_option")
                                        }
                                    }

                                    IconButton {
                                        text: qsTr("查看输出")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_FileExplorer
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5
                                    }
                                }
                                IconButton {
                                    text: qsTr("文件合并")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_MergeCall
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon
                                }
                                IconButton {
                                    text: qsTr("文件拆分")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_PrivateCall
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon
                                }


                            }
                        }
                        Label{
                            height:groupname_height
                            text:qsTr("文件工具")
                            font:Typography.bodyStrong
                            // color:Theme.res.textFillColorPrimary
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }

            }

        }
    }

}
