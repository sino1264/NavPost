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
        title: qsTr("管理站点")
        standardButtons: Dialog.Ok | Dialog.Cancel

        Column{
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter
            Row{
                Label{
                    text: qsTr("两个页面（静态站点页面、动态站点页面）")
                }
            }
            Row{
                Label{
                    text: qsTr("站点列表")
                }
            }
            Row{
                Label{
                    text: qsTr("所有已经添加的站点")
                }
            }
            Row{
                Label{
                    text: qsTr("选择站点、可视性、编辑、禁用、删除")
                }
            }


        }
    }


}
