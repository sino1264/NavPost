import QtQuick
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick.Controls
import FluentUI.Controls
import FluentUI.impl
import NavPost

Item{
    property string title
    property PageContext context


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
        title: qsTr("Rinex格式转换")
        standardButtons: Dialog.Ok | Dialog.Cancel

        Column{
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter



            Row{
                Label{
                    text: qsTr("卫星/频点设置")
                    font: Typography.subtitle
                }
            }

            Row{
                spacing: 30

                Label{
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
                        text: "BDS"
                        checked: true
                    }
                CheckBox {
                    width: 120
                        text: "QZS"
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
                spacing: 30

                Label{
                    text: qsTr("卫星频点设置")
                }
            }

            Row{

                Frame{
                    height: 150
                    width:120

                    Column{
                        CheckBox {
                                text: "L1"
                                checked: true
                            }
                        CheckBox {
                                text: "L2P"
                                checked: true
                            }
                        CheckBox {
                                text: "L2C"
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
                    }

                }

                Frame{
                    height: 150
                    width:120

                    Column{
                        CheckBox {
                                text: "E1C"
                                checked: true
                            }
                        CheckBox {
                                text: "E5B"
                                checked: true
                            }
                        CheckBox {
                                text: "E5A"
                                checked: true
                            }
                    }

                }

                Frame{
                    height: 270
                    width:120

                    Column{
                        CheckBox {
                                text: "B1"
                                checked: true
                            }
                        CheckBox {
                                text: "B2"
                                checked: true
                            }
                        CheckBox {
                                text: "B3"
                                checked: true
                            }
                        CheckBox {
                                text: "B1C"
                                checked: true
                            }
                        CheckBox {
                                text: "B2A"
                                checked: true
                            }
                        CheckBox {
                                text: "B2B"
                                checked: true
                            }
                        CheckBox {
                                text: "B1X"
                                checked: true
                            }
                        CheckBox {
                                text: "B2X"
                                checked: true
                            }
                        CheckBox {
                                text: "B3X"
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
                    text: qsTr("默认头部信息设置")
                    font: Typography.subtitle
                }
            }

            Row{
                spacing: 5
                Label{
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("生成机构/观测者名称/观测机构")
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
                    text: qsTr("输出配置")
                    font: Typography.subtitle
                }
            }

            Row{
                spacing: 30

                Label{
                     anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("默认输出位置选择")
                }

                ComboBox{

                    model: [qsTr("输出到工程目录下"), qsTr("输出到被转换文件同一路径"), qsTr("输出到自定义路径")]

                    width:240
                }

            }

            Row{
                spacing: 30

                Label{
                     anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("自定义输出路径：")
                }

                TextField{
                    placeholderText: "TextField"
                    width:480
                }

                Button{
                    text: qsTr("...")
                }

            }


        }
    }


}
