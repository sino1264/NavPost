import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import FluentUI.Controls
import FluentUI.impl
import NavPost

Item{

    id:root

    property string title
    property PageContext context

    width: parent.width
    height: 460
    property list<QtObject> originalItems : [
        PaneItem{
            key: "/"
            title: ""
            icon.name: FluentIcons.graph_Back
        },
        PaneItem{
            key: "/file/start"
            title: qsTr("开始")//"Start"
            icon.name: FluentIcons.graph_Home
        },
        PaneItem{
            key: "/file/new"
            title: qsTr("新建")//"New"
            icon.name: FluentIcons.graph_Page
        },
        PaneItem{
            key: "/file/open"
            title: qsTr("打开")//"Open"
            icon.name: FluentIcons.graph_FolderOpen
        },
        PaneItemSeparator{},
        PaneItem{
            key: "/file/info"
            title: qsTr("工程信息")//"Info"
            icon.name: FluentIcons.graph_Tablet
        },
        PaneItem{
            key: "/file/save"
            title: qsTr("保存")//"Save"
            icon.name: FluentIcons.graph_Save
        },
        PaneItem{
            key: "/file/saveas"
            title: qsTr("另存为")//"Save As"
            icon.name: FluentIcons.graph_SaveAs
        },
        PaneItem{
            key: "/file/export"
            title: qsTr("导出")//"Export"
            icon.name: FluentIcons.graph_Export
        },
        PaneItem{
            key: "/file/close"
            title: qsTr("关闭")//"Close"
            icon.name: FluentIcons.graph_ChromeClose
        }
    ]
    property list<QtObject> originalFooterItems : [
        PaneItem{
            icon.name: FluentIcons.graph_Settings
            key: "/file/setting"
            title: qsTr("设置")//"Settings"
        }
    ]
    PageRouter{
        id: page_router
        routes: {
            "/file/start": R.resolvedUrl("qml/page/Page_Start.qml"),
            "/file/new": R.resolvedUrl("qml/page/Page_New.qml"),
            "/file/open": R.resolvedUrl("qml/page/Page_Open.qml"),
            "/file/setting": R.resolvedUrl("qml/page/Page_Setting.qml")
        }
    }
    NavigationView{
        anchors.fill: parent
        logo: Global.windowIcon
        title: Global.windowName
        router: page_router
        items: originalItems
        footerItems: originalFooterItems
        displayMode: NavigationViewType.Open
        sideBarShadow: false
        sideItemHeight: 60
        sideBarWidth: 200
        goBackButton.visible:false
        logoDelegate: comp_logo

        onTap:
            (item)=>{
                if(item.key){
                    if(item.title===""){
                        Global.displayScreen="/screen/main"
                    }
                    else
                    {
                        page_router.go(item.key,{info:item.title})
                    }
                }
            }
        Component.onCompleted: {
            page_router.go("/file/start",{info:"Satrt"})
        }

        Component{
            id: comp_logo
            Image{
                width: Global.windowIcon ? 20 : 0
                height: width
                source: Global.windowIcon ? Global.windowIcon : ""
            }
        }

    }
}

