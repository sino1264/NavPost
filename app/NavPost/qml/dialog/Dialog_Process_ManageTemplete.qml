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
                    text: qsTr("↓ 下一项↓")
                }
            }
            Row{
                Label{
                    text: qsTr("选择处理模式")
                }
            }
            Row{
                Label{
                    text: qsTr("选择要使用的星历（与文件导入时候选中的星历一致）")
                }
            }


        }
    }


}
