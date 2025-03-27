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
        title: qsTr("新建静态处理任务")
        standardButtons: Dialog.Ok | Dialog.Cancel




        Column{
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter

            Item{

                width: 900
                height: 40

                ListModel{
                    id: tab_model
                    ListElement{
                        title: qsTr("选择处理站点")
                    }
                    ListElement{
                        title: qsTr("配置处理参数")
                    }
                    ListElement{
                        title: qsTr("配置参考站点")
                    }
                    ListElement{
                        title: qsTr("设置结果输出")
                    }

                    ListElement{
                        title: qsTr("确认处理任务")
                    }
                }

                SegmentedControl {
                    id: bar
                    clip: true
                    Repeater {
                        model: tab_model
                        SegmentedButton {
                            width: 180
                            id: btn_tab
                            text: model.title
                        }
                    }
                }
            }

            Frame{
                width: 900
                height: 400

                Column{
                    spacing:10

                    Row{
                        Label{
                            text: qsTr("选择参数模板:")
                        }

                        ComboBox{
                            width:360
                            model: ["不使用模板参数", "默认模板参数","单北斗","全系统","低轨","北斗军码"]
                        }

                    }

                    Row{
                        Label{
                            text: qsTr("解算模式:")
                        }

                        ComboBox{
                            model: ["Single", "DGNSS", "Kinematic","Static"]
                        }
                    }
                    Row{
                        Label{
                            text: qsTr("卫星系统:")
                        }
                    }

                    Row{
                        Label{
                            text: qsTr("频点组合:")
                        }
                    }
                    Row{
                        Label{
                            text: qsTr("卫星高度角限制:")
                        }
                    }
                    Row{
                        Label{
                            text: qsTr("对流层模型:")
                        }
                    }
                    Row{
                        Label{
                            text: qsTr("电离层模型:")
                        }
                    }
                }
            }

            Frame{
                width: 900
                height: 400

                Column{
                    spacing:10
                    Row{
                        Label{
                            text: qsTr("选择站点")
                        }

                        ComboBox{

                        }

                        Label{
                            text: qsTr("选择观测文件")
                        }

                        ComboBox{

                        }

                    }
                    Row{

                    }
                }
            }

            Row{
                Button{
                    text: qsTr("上一步")
                }
                Button{
                    text: qsTr("下一步")
                }
            }

            Row{
                Label{
                    text: qsTr("选择要处理的站点（静态站点下拉框）")
                }
            }
            Row{
                Label{
                    text: qsTr("选择要处理的站点的观测文件（选中的站点的观测文件下拉框）")
                }
            }
            Row{
                Label{
                    text: qsTr("勾选是否需要使用基站")
                }
            }
            Row{
                Label{
                    text: qsTr("选择要使用的基站（静态站点下拉框）")
                }
            }
            Row{
                Label{
                    text: qsTr("选择要使用基站的观测文件（选中的站点的观测文件下拉框）")
                }
            }
            Row{
                Label{
                    text: qsTr("选择要使用基站的观测文件的坐标（选中的站点的观测文件下拉框）")
                }
            }
            Row{
                Label{
                    text: qsTr("选择要使用的星历/精密星历、钟差，等改正文件，可以临时导入")
                }
            }


            Row{
                Label{
                    text: qsTr("↓ 下一项↓")
                }
            }
            Row{
                Label{
                    text: qsTr("选择解算模板（如果没有创建模板，那就展示（默认临时模板）")
                }
            }
            Row{
                Label{
                    text: qsTr("选择处理模式（单点、差分GNSS、动态、静态、PPP）")
                }
            }

            Row{
                Label{
                    text: qsTr("频点组合")
                }
            }

            Row{
                Label{
                    text: qsTr("截至高度角")
                }
            }
            Row{
                Label{
                    text: qsTr("电离层模型")
                }
            }
            Row{
                Label{
                    text: qsTr("对流层模型")
                }
            }
            Row{
                Label{
                    text: qsTr("使用的卫星系统")
                }
            }


        }
    }


}
