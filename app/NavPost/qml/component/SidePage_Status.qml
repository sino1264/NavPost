import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.qmlmodels
import FluentUI.Controls
import FluentUI.impl
import NavPost
/*
//功能设计，这个主要就是根据当前选择的处理了任务，根据任务来获取状态信息，状态信息返回的是一个json字符串，通过解析json字符串，就能获取实时的信息了
//这个实时字符串包含的内容有：

处理统计信息
    任务状态：等待处理/处理中/已完成/已取消/（已删除）
    当前处理的进度： 0-10000 的一个浮点数（0.00-100.00）
    处理已经花费的时间（只传递开始处理的时间）

当前解的状态
    当前处理的时间： UTC秒数（历元的UTC时间）
    当前解的状态：   4、固定 5、浮点（参考GGA的定义）
    结果经度：
    结果纬度：
    结果高程：
    使用卫星数：
    RMS：
    其他信息：

同时提供了若干按钮，功能如下：
    查看日志：点击后，底部功能栏切换到对应的日志输出
    停止处理：点击后，终止该任务的处理功能

*/

Item{
    id:root

    property string title
    property PageContext context

    anchors.fill:parent
    GroupBox{
        id:function_box
        anchors.fill: parent
        padding: 5
        Item{
            width: parent.width
            height: 30
            Label{
                anchors{
                    left: parent.left
                    leftMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                text:qsTr("任务状态栏")
                font:Qt.font({pixelSize : 14, weight: Font.Bold})
            }

            IconButton{
                anchors{
                    right: parent.right
                    rightMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                icon.source: FluentIcons.graph_Pin
                icon.width: 15
                icon.height: 15
            }
        }


        Item{
            anchors.fill: parent
            anchors.topMargin: 30

            Column{
                anchors.fill: parent

                Row{
                    Icon{
                        source: FluentIcons.graph_Dial
                    }
                    ProgressBar{
                        from: 0
                        to: 1
                        value: 1
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}








