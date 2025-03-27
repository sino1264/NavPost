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
                                    text: qsTr("处理基线")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_Go
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon
                                }


                                Column {
                                    IconButton {
                                        text: qsTr("处理参数配置")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_Equalizer
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5
                                    }
                                    IconButton {
                                        text: qsTr("重新生成基线")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_RepeatAll
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5
                                    }
                                }

                                IconButton {
                                    text: qsTr("基线列表")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_List
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon

                                    onClicked: {
                                        Global.displayMidTop="/page/main"
                                        Global.displayMidTop="/page/baseline"
                                    }
                                }

                                Column {
                                    IconButton {
                                        text: qsTr("查看解算结果")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_ShowResults
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5
                                    }
                                    IconButton {
                                        text: qsTr("输出解算结果")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_Share
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5
                                    }
                                }

                            }
                        }
                        Label{
                            height:groupname_height
                            text:qsTr("基线")
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
                                    text: qsTr("网平差")
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
                                        text: qsTr("平差配置")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_Equalizer
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5
                                    }

                                    IconButton {
                                        text: qsTr("站点管理")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_MapPin
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5
                                    }
                                }

                                Column {

                                    IconButton {
                                        text: qsTr("查看平差结果")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name:  FluentIcons.graph_ShowResults
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5
                                    }

                                    IconButton {
                                        text: qsTr("清除平差结果")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_Broom
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5
                                    }
                                }
                            }
                        }
                        Label{
                            height:groupname_height
                            text:qsTr("平差")
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

                                Column {
                                    IconButton {
                                        text: qsTr("生成报告")
                                        width: iconbutton_width
                                        height: function_height.height*0.6// 半高按钮的高度

                                        icon.name: FluentIcons.graph_MoveToFolder
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
                                            text: qsTr("生成报告")
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
                                            menu1.popup()
                                        }
                                        Menu {
                                            id:menu1
                                            width: 140
                                            title: qsTr("File")
                                            Action { text: qsTr("生成基线报告")}
                                            Action { text: qsTr("生成平差报告") }
                                            Action { text: qsTr("生成闭合环报告") }
                                            MenuSeparator { }
                                            MenuItem{
                                                text: qsTr("生成静态网报告")
                                            }
                                        }

                                    }
                                }


                                Column {
                                    IconButton {
                                        text: qsTr("报告配置")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_ProvisioningPackage
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5
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

                                Column {
                                    IconButton {
                                        text: qsTr("查看报告")
                                        width: iconbutton_width
                                        height: function_height.height*0.6// 半高按钮的高度

                                        icon.name: FluentIcons.graph_Website
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
                                            text: qsTr("查看报告")
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





                            }
                        }
                        Label{
                            height:groupname_height
                            text:qsTr("报告")
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
