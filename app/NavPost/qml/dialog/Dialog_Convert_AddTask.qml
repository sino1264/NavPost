import QtQuick
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick.Controls
import FluentUI.Controls
import FluentUI.impl
import NavPost


//         text: qsTr("选择要处理的观测文件是已经导入到工程的的还是从外部选择的（其实本质也还是就是输入文件，无非是内部的可以直接知道文件路径和一些基础信息）")

//         text: qsTr("如果是内部的，选择要处理的站点（静态站点下拉框）（默认为当前选中的观测文件归属的站点）")

//         text: qsTr("选择要处理的站点的观测文件（选中的站点的观测文件下拉框）（默认为当前选中观测文件）")

//         text: qsTr("按钮，点击是否要进行数据解析（解析后，能够知道原始数据具备的频点、采样间隔，起止时间（按理来说，如果是已经导入的文件，直接就知道了）")

//         text: qsTr("↓ 下一项↓")

//         text: qsTr("选择输出的路径，有下拉框，和文件路径选择框")

//         text: qsTr("配置要输出的格式（Rinex格式，只有选择Rinex4.0-EX，才会显示低轨卫星和军码频段")

//         text: qsTr("输出的频点（根据解析（如果有些频点没有，那就为灰色，不能勾选）")

//         text: qsTr("采样间隔，采样间隔不能小于原始数据的采样间隔，如果采样间隔已知，那么小于的都不能选（或者给出提示，实际采样间隔为多少")

//         text: qsTr("选择要转换的时间段（起始时间，截至时间，如果选择超出了，那就红色文字提示真实时间小于选择时间")


//         text: qsTr("↓ 下一项↓")


//         text: qsTr("设置文件的头部信息")



Item{
    property string title
    property PageContext context


    property bool visible_freq_setting:false
    property bool visible_header_setting:false

    Component.onCompleted: {
        contentDialog.open()
    }

    //导入文件配置的Dialog  用来配置导入文件的详细选项
    Dialog {
        id: contentDialog
        x: Math.ceil((parent.width - width) / 2)
        y: Math.ceil((parent.height - height) / 2)
        width: 1000//Math.ceil(parent.width / 2)
        // contentHeight: 400
        parent: Overlay.overlay
        modal: true
        title: qsTr("添加Rinex格式转换任务")
        standardButtons: Dialog.Ok | Dialog.Cancel

        Column{
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter
            Row{
                Label{
                    text: qsTr("输入配置")
                    font: Typography.subtitle
                }
            }
            Row{
                spacing: 5
                Label{
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("转换文件:")
                }
                TextField{
                    placeholderText: "请选择要转换的文件"

                    width: 600
                }
                Button{
                    anchors.verticalCenter: parent.verticalCenter
                    text: "选择已导入文件"
                }
                Button{
                    anchors.verticalCenter: parent.verticalCenter
                    text: "选择外部文件"
                }
            }
            Row{
                spacing: 5
                Label{
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("文件类型:")
                }
                ComboBox{
                    anchors.verticalCenter: parent.verticalCenter
                    model: ["CNB", "RTCM3", "Rinex"]
                    width: 600
                }



                Label{
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("数据采集日期:")
                }

                CalendarPicker {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 120
                }



            }

            Row{
                Label{
                    text: qsTr("转换配置")
                    font: Typography.subtitle
                }
            }


            Row{
                spacing: 5

                Label{
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Rinex版本：")
                }
                ComboBox{
                    width: 300
                    model: ["4.00","4.00-Ex"]
                }


                Label{
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("采样间隔：")
                }
                ComboBox{
                    width: 300
                    model: ["auto","0.01", "0.02", "0.05","0.1", "0.2", "0.5","1", "2", "5","10","15","30","60"]
                }
            }




            Row{
                spacing: 30

                Label{
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("卫星系统选择")
                }
            }

            Row{
                // spacing: 30
                CheckBox {
                    width: 120
                    text: "GPS"
                    checked: true
                }
                CheckBox {
                    width: 120
                    text: "GLO"
                    checked: true
                }
                CheckBox {
                    width: 120
                    text: "GAL"
                    checked: true
                }
                CheckBox {
                    width: 120
                    text: "SBAS"
                    checked: true
                }
                CheckBox {
                    width: 120
                    text: "QZS"
                    checked: true
                }
                CheckBox {
                    width: 120
                    text: "BDS"
                    checked: true
                }
                CheckBox {
                    width: 120
                    text: "IRNSS"
                    checked: true
                }
                CheckBox {
                    width: 120
                    text: "XW"
                    checked: true
                }
            }


            Row{
                spacing: 5

                Label{
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("卫星频点输出设置：")
                }

                Button{
                    text: qsTr("自定义输出频点")

                    onClicked: {
                        visible_freq_setting=!visible_freq_setting
                    }
                }

            }

            Row{
                visible: visible_freq_setting

                Frame{
                    height: 150
                    width:120

                    Column{
                        CheckBox {
                            text: "L1"
                            checked: true
                        }
                        CheckBox {
                            text: "L2"
                            checked: true
                        }
                        CheckBox {
                            text: "L5"
                            checked: true
                        }
                    }
                }

                Frame{
                    height: 150
                    width:120

                    Column{
                        CheckBox {
                            text: "G1"
                            checked: true
                        }
                        CheckBox {
                            text: "G2"
                            checked: true
                        }
                        CheckBox {
                            text: "G1a"
                            checked: true
                        }
                        CheckBox {
                            text: "G2a"
                            checked: true
                        }
                        CheckBox {
                            text: "G3"
                            checked: true
                        }

                    }

                }

                Frame{
                    height: 150
                    width:120

                    Column{
                        CheckBox {
                            text: "E1"
                            checked: true
                        }
                        CheckBox {
                            text: "E5a"
                            checked: true
                        }
                        CheckBox {
                            text: "E5b"
                            checked: true
                        }
                        CheckBox {
                            text: "E5"
                            checked: true
                        }
                        CheckBox {
                            text: "E6"
                            checked: true
                        }
                    }
                }
                Frame{
                    height: 150
                    width:120

                    Column{
                        CheckBox {
                            text: "L1"
                            checked: true
                        }
                        CheckBox {
                            text: "L5"
                            checked: true
                        }
                    }
                }
                Frame{
                    height: 150
                    width:120

                    Column{
                        CheckBox {
                            text: "L1"
                            checked: true
                        }
                        CheckBox {
                            text: "L2"
                            checked: true
                        }
                        CheckBox {
                            text: "L5"
                            checked: true
                        }
                        CheckBox {
                            text: "L6"
                            checked: true
                        }
                    }

                }
                Frame{
                    height: 270
                    width:120

                    Column{
                        CheckBox {
                            text: "B1I"
                            checked: true
                        }
                        CheckBox {
                            text: "B2I"
                            checked: true
                        }
                        CheckBox {
                            text: "B3I"
                            checked: true
                        }
                        CheckBox {
                            text: "B1C"
                            checked: true
                        }
                        CheckBox {
                            text: "B2a"
                            checked: true
                        }
                        CheckBox {
                            text: "B2b"
                            checked: true
                        }
                        CheckBox {
                            text: "B2(B2a+b2b)"
                            checked: true
                        }
                        CheckBox {
                            text: "B1A"
                            checked: true
                        }
                        CheckBox {
                            text: "B3A"
                            checked: true
                        }


                    }

                }



                Frame{
                    height: 150
                    width:120

                    Column{
                        CheckBox {
                            text: "L5"
                            checked: true
                        }
                        CheckBox {
                            text: "L9"
                            checked: true
                        }
                    }

                }

                Frame{
                    height: 150
                    width:120

                    Column{
                        CheckBox {
                            text: "L1"
                            checked: true
                        }
                        CheckBox {
                            text: "L2"
                            checked: true
                        }
                    }
                }

            }


            Row{
                Label{
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Rinex头信息设置：")
                }

                Button{
                    text: qsTr("自定义Header信息")

                    onClicked: {
                        visible_header_setting=!visible_header_setting
                    }
                }
            }


            Row{
                visible:visible_header_setting
                Column{
                    spacing: 5

                    Row{
                        Label{
                            text: qsTr("基站ID")
                            width: 200
                        }
                        TextField{
                            width:600
                        }
                    }

                    Row{
                        Label{
                            text: qsTr("生成机构/观测者名称/观测机构")
                            width: 200
                        }
                        TextField{

                        }
                        TextField{

                        }
                        TextField{

                        }
                    }

                    Row{
                        Label{
                            text: qsTr("注释")
                            width: 200
                        }
                        TextField{
                            width:600
                        }
                    }

                    Row{
                        Label{
                            text: qsTr("标记点名称/数量/类型")
                            width: 200
                        }
                        TextField{

                        }
                        TextField{

                        }
                        TextField{

                        }
                    }

                    Row{
                        Label{
                            text: qsTr("接收机数量/型号/版本")
                            width: 200
                        }
                        TextField{

                        }
                        TextField{

                        }
                        TextField{

                        }
                    }

                    Row{
                        Label{
                            text: qsTr("天线数量/型号")
                            width: 200
                        }
                        TextField{
                            width:300
                        }
                        TextField{
                            width:300
                        }
                    }

                    Row{
                        Label{
                            text: qsTr("概略位置/XYZ")
                            width: 200
                        }
                        TextField{

                        }
                        TextField{

                        }
                        TextField{

                        }
                    }

                    Row{
                        Label{
                            text: qsTr("天线高度/东向距离/北向距离")
                            width: 200
                        }
                        TextField{

                        }
                        TextField{

                        }
                        TextField{

                        }
                    }

                }
            }



            Row{
                Label{
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("输出配置")
                    font: Typography.subtitle
                }
            }

            Row{
                spacing: 5

                Label{
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("输出路径：")
                }

                TextField{
                    placeholderText: "TextField"

                    width: 600
                }

                Button{
                    anchors.verticalCenter: parent.verticalCenter
                    text: "选择输出路径"
                }

            }

        }
    }


}
