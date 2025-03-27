import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import FluentUI.Controls
import FluentUI.impl
import NavPost
import "../extra"

Item {
    id:root

    anchors.fill: parent

    property string title
    property PageContext context


    GroupBox{
        id:function_box
        anchors.fill: parent

        padding: 30
        Column{
            anchors{
                fill: parent
                leftMargin: 20
            }

            Item{
                width:root.width
                height: root.height*0.25
                Column{
                    spacing: 10

                    Label{
                        text: "工程已创建成功！"
                        font:Typography.title
                    }

                    Label{
                        text: "接下来，可以开始导入文件进行处理。"
                        font:Typography.bodyLarge
                    }
                }
            }
            Item{
                width:root.width
                height: root.height*0.6
                Column{
                    spacing: 5
                    Label{
                        text: "帮助"
                        font:Typography.title
                    }
                    Label{
                        text: "如果需要帮助，你可以选择以下操作："
                        font:Typography.bodyLarge
                    }
                    HyperlinkButton{
                        text: "启动界面引导"
                        font:Typography.bodystrong
                        onClicked: {
                            //Qt.openUrlExternally(text)
                        }
                    }
                    HyperlinkButton{
                        text: "查看使用说明"
                        font:Typography.bodystrong
                        onClicked: {
                            //Qt.openUrlExternally(text)
                        }
                    }
                    HyperlinkButton{
                        text: "访问官方网站"
                        font:Typography.bodystrong
                        onClicked: {
                            //Qt.openUrlExternally(text)
                        }
                    }
                    HyperlinkButton{
                        text: "提交反馈"
                        font:Typography.bodystrong
                        onClicked: {
                            //Qt.openUrlExternally(text)
                        }
                    }


                }

            }

        }

    }

    // ListModel{
    //     id: tab_info
    //     ListElement{path:"/page/map";title:qsTr("xxxx");icon:""}
    //     ListElement{path:"/page/main";title:qsTr("xxxx");icon:""}
    //     ListElement{path:"/page/dataspan";title:qsTr("xxxx");icon:""}
    // }

    // PageRouter{
    //     id: tab_router
    //     routes: {
    //         "/page/map": R.resolvedUrl("qml/page/Page_Map.qml"),
    //         "/page/main": R.resolvedUrl("qml/page/Page_Main.qml"),
    //         "/page/dataspan": R.resolvedUrl("qml/page/Page_DataSpan.qml")
    //     }
    // }


    // Component{
    //     id:com_page
    //     Item{
    //         id:root
    //         property var initialItem

    //         anchors.fill:parent
    //         HotLoader{
    //             id: loader_container
    //             FluentUI.dark: control.FluentUI.dark
    //             anchors{
    //                 fill: parent
    //                 topMargin: fitsAppBarWindows ? 0 : layout_appbar.height
    //             }
    //             source: {
    //                 if(root.initialItem){
    //                     return root.initialItem
    //                 }
    //                 return ""
    //             }
    //         }
    //         Component.onCompleted:{
    //             initialItem=tab_router.toUrl(Global.displayMidTop)
    //         }
    //     }
    // }


    // Component.onCompleted: {
    //     updateTabView()
    // }

    // Frame{
    //     anchors.fill: parent
    //     Layout.fillWidth: true
    //     Layout.topMargin: 0
    //     Layout.preferredHeight: 400
    //     padding: 0
    //     TabViewEx{
    //         id:tab_view
    //         addButtonVisibility:false
    //         onNewPressed:{
    //             newTab()
    //         }
    //     }
    // }

    // Connections{
    //     target:Global
    //     function onDisplayMidTopChanged(){
    //         updateTabView()
    //     }
    // }

    // //根据当前选择的视图 Global.displayMidTop,新建/切换窗格
    // function updateTabView(){

    //     //从tab_view中查找是否已经存在该页面
    //     for(var i=0;i<tab_view.tab_model.count;i++)
    //     {
    //         let item=tab_view.tab_model.get(i)
    //         if(Global.displayMidTop===item.key)
    //         {
    //             //存在，页面切换到页面的current_index
    //             tab_view.tab_nav.currentIndex=i;
    //             return
    //         }
    //     }

    //     //不存在，创建一个新窗格，查找指定的key的信息
    //     for (var j = 0; j < tab_info.count; j++) {
    //         if(Global.displayMidTop===tab_info.get(j).path)
    //         {
    //             //不存在，创建一个新的auto_loader页面，页面指向这个页面，添加到tab中
    //             tab_view.appendTab(item_info.key,item_info.icon,item_info.title,com_page)
    //             return
    //         }
    //     }

    //     throw new Error(`updateTabView '${Global.displayMidTop}' not found!`);
    // }

}
