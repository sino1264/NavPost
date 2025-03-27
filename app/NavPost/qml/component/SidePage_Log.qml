import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import FluentUI.Controls
import FluentUI.impl
import NavPost

Frame{
    id:root
    anchors.fill: parent

    property string title
    property PageContext context


    ListModel{
        id: tab_model
        ListElement{
            title: "操作日志"
        }
        ListElement{
            title: "任务输出"
        }
        ListElement{
            title: "Console"
        }
    }

    SegmentedControl {
        id: bar
        clip: true
        Repeater {
            model: tab_model
            SegmentedButton {
                id: btn_tab
                text: model.title
            }
        }

        onCurrentIndexChanged: {
            if(currentIndex==0){
                info_listview.visible=true
                debug_listview.visible=false
            }else{
                info_listview.visible=false
                debug_listview.visible=true
            }
        }
    }


    Frame{
        anchors{
            left: parent.left
            right: parent.right
            top: bar.bottom
            bottom: parent.bottom
            topMargin: 5
        }
        clip: true

        ListView {
            id: info_listview
            anchors.fill: parent
            model:  info_listmodel

            delegate: Item {
                width: info_listview.width
                implicitHeight: infoElement.height + 10
                Column {
                    width: parent.width
                    Text {
                        id: infoElement
                        text: "[" + model.level + "]: " + model.msg
                        wrapMode: Text.Wrap // 支持多行显示
                        width: parent.width
                        color: Theme.res.textFillColorPrimary
                    }
                }
            }
            ScrollBar.vertical: ScrollBar { // 添加垂直滚动条
                id: info_ScrollBar
                policy: ScrollBar.AlwaysOn // 始终显示滚动条
            }
        }


        ListView {
            id: debug_listview
            anchors.fill: parent
            model:  console_listmodel

            delegate: Item {
                width: debug_listview.width
                implicitHeight: consoleElement.height + 10
                Column {
                    width: parent.width
                    Text {
                        id: consoleElement
                        text: "[" + model.level + "]: " + model.msg
                        wrapMode: Text.Wrap // 支持多行显示
                        width: parent.width
                        color: Theme.res.textFillColorPrimary
                    }
                }
            }
            ScrollBar.vertical: ScrollBar { // 添加垂直滚动条
                id: console_ScrollBar
                policy: ScrollBar.AlwaysOn // 始终显示滚动条
            }
        }
    }


    // ListView{
    //     id:myList
    // }
    // myList.positionViewAtBeginning() //回滚到列表头部
    // myList.positionViewAtEnd()  //回滚到列表底部

    // //	回滚到任一行
    // myList.positionViewAtIndex(int index, PositionMode mode)
    // //	其中PositonMode的常用取值为
    // //  ListView.Beginning - 列表头部 (或水平方向列表的左侧)
    // //  ListView.Center -列表中心位置
    // //  ListView.End - 列表底部 (或水平方向列表的右侧)
    // //例如：
    // //回滚到最后一行
    // myList.positionViewAtIndex(myList.count - 1, ListView.Beginning)




    ListModel{
        id:info_listmodel
    }
    ListModel{
        id:console_listmodel
    }
    ListModel{
        id:task_listmodel
    }



    Component.onCompleted: {
        var logs=LogRecordManager.get_all_logs("default")
        for (var i = 0; i < logs.length; i++) {
            console_listmodel.append(logs[i])
            if(logs[i].level==="info")
            {
                info_listmodel.append(logs[i])
            }
        }
    }

    Timer {
        id: console_timer
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            var logs=LogRecordManager.get_new_logs("default")
            for (var i = 0; i < logs.length; i++) {
                console_listmodel.append(logs[i])
                if(logs[i].level==="info")
                {
                    info_listmodel.append(logs[i])
                }
            }
        }
    }




}
