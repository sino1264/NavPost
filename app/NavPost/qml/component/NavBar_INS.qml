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
            interactive: contentWidth > width

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
                                    text: qsTr("导入")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_ReturnToWindow
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon
                                }

                                Column {
                                    IconButton {
                                        text: qsTr("配置参数")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_ProvisioningPackage
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5
                                    }

                                    IconButton {
                                        text: qsTr("文件管理")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_FileExplorer
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5
                                    }
                                }
                            }
                        }
                        Label{
                            height:groupname_height
                            text:qsTr("文件")
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
                                    text: qsTr("新建任务")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_Send
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon
                                }
                                Column {
                                    IconButton {
                                        text: qsTr("解算配置")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_GroupList
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5
                                    }

                                    IconButton {
                                        text: qsTr("预设管理")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_Edit
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5
                                    }
                                }
                                IconButton {
                                    text: qsTr("动态站点")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_StartPoint
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon
                                }
                            }
                        }
                        Label{
                            height:groupname_height
                            text:qsTr("处理")
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
                                    text: qsTr("平面视图")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_TiltUp
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon
                                }
                                Column {

                                    IconButton {
                                        text: qsTr("显示格网")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_TiltDown
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5

                                        highlighted: checked
                                        checked: false
                                        checkable: true
                                    }

                                    IconButton {
                                        text: qsTr("图层管理")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_MapLayers
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5
                                    }
                                }
                            }
                        }
                        Label{
                            height:groupname_height
                            text:qsTr("视图")
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
                                    text: qsTr("启动处理")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_Play
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon
                                }

                                Column {
                                    IconButton {
                                        text: qsTr("暂停处理")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_Pause
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5
                                    }

                                    IconButton {
                                        text: qsTr("终止处理")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_Stop
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5
                                    }
                                }

                                IconButton {
                                    text: qsTr("任务队列")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_TaskView
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon
                                }

                                Column {
                                    IconButton {
                                        text: qsTr("处理选项")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_SpeedHigh
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5
                                    }

                                    IconButton {
                                        text: qsTr("性能监控")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_Diagnostic
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5
                                    }
                                }

                            }
                        }
                        Label{
                            height:groupname_height
                            text:qsTr("任务列表")
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
