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
                                    text: qsTr("帮助")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_Unknown
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon
                                }
                                IconButton {
                                    text: qsTr("版本说明")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_Copy
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon
                                }
                                Column {
                                    IconButton {
                                        text: qsTr("工作流程")
                                        width: iconbutton_width
                                        height: function_height.height*0.6// 半高按钮的高度

                                        icon.name: FluentIcons.graph_ToolTip
                                        icon.width: iconbutton_size
                                        icon.height: iconbutton_size
                                        spacing: 0
                                        display: IconButton.IconOnly//IconButton.TextUnderIcon//
                                    }
                                    IconButton {
                                        width: iconbutton_width
                                        height: function_height.height*0.4 // 半高按钮的高度
                                        Label{
                                            anchors{
                                                centerIn: parent
                                                verticalCenterOffset: -2
                                            }
                                            text: qsTr("工作流程")
                                        }
                                        Icon{
                                            source: FluentIcons.graph_FlickUp
                                            width: 10
                                            anchors{
                                                centerIn: parent
                                                verticalCenterOffset: 20
                                            }
                                        }

                                        onClicked: {
                                            menu.popup()
                                        }
                                        Menu {
                                            id:menu
                                            width: 140
                                            title: qsTr("File")
                                            Action { text: qsTr("New...")}
                                            Action { text: qsTr("Open...") }
                                            Action { text: qsTr("Save") }
                                            MenuSeparator { }
                                            MenuItem{
                                                text: qsTr("Quit")
                                            }
                                        }

                                    }
                                }
                                IconButton {
                                    text: qsTr("在线帮助")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_WebSearch
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon
                                }
                            }
                        }
                        Label{
                            height:groupname_height
                            text:qsTr("帮助")
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
                                    text: qsTr("激活")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_Completed
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon
                                }
                                IconButton {
                                    text: qsTr("模块管理")
                                    width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_Puzzle
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon
                                }
                            }
                        }
                        Label{
                            height:groupname_height
                            text:qsTr("许可")
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
                                    text: qsTr("提交BUG")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_Bug
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon
                                }

                                IconButton {
                                    text: qsTr("提交建议")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_FeedbackApp
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon
                                }
                            }
                        }
                        Label{
                            height:groupname_height
                            text:qsTr("反馈")
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
