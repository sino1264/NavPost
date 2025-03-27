import QtQuick
import QtQuick.Controls
import FluentUI.Controls
import FluentUI.impl
import NavPost

Frame{
    anchors.fill: parent

    property string title
    property PageContext context


    property list<QtObject> originalItems : [
        PaneItem{
            key: "/page/table/station"
            title: "站点列表"
            icon.name: FluentIcons.graph_MapPin
        },
        PaneItem{
            key: "/page/table/obsfile"
            title: "观测文件列表"
            icon.name: FluentIcons.graph_Page
        },
        PaneItem{
            key: "/page/table/baseline"
            title: "基线列表"
            icon.name: FluentIcons.graph_ResizeTouchLarger
        },
        PaneItem{
            key: "/page/table/check"
            title: "检核列表"
            icon.name: FluentIcons.graph_Shield
        },
        PaneItem{
            key: "/page/table/closeloop"
            title: "闭合环"
            icon.name: FluentIcons.graph_DialShape2
        }

    ]
    property list<QtObject> originalFooterItems : [
        PaneItem{
            icon.name: FluentIcons.graph_Settings
            key: "/page/table/option"
            title: "Option"
        }
    ]
    PageRouter{
        id: page_router
        routes: {
            "/page/table/station":{url: R.resolvedUrl("qml/page/Page_Table_Station.qml"),singleton:true},
            "/page/table/obsfile":{url: R.resolvedUrl("qml/page/Page_Table_Obsfile.qml"),singleton:true},
            "/page/table/baseline":{url: R.resolvedUrl("qml/page/Page_Table_Baseline.qml"),singleton:true},
            "/page/table/closeloop":{url: R.resolvedUrl("qml/page/Page_Table_Closeloop.qml"),singleton:true},
            "/page/table/check":{url: R.resolvedUrl("qml/page/Page_Table_Check.qml"),singleton:true},
            "/page/table/option":{url: R.resolvedUrl("qml/page/Page_Table_Option.qml"),singleton:true}
        }
    }
    NavigationView{
        anchors.fill: parent
        //logo: "qrc:/qt/qml/Gallery/res/image/logo.png"
        //title: "FluentUI Gallery"
        router: page_router
        items: originalItems
        footerItems: originalFooterItems
        displayMode: NavigationViewType.Compact
        sideBarShadow: false
        goBackButton.visible: false
        appBarHeight: 0
        sideBarWidth:180
        // sideItemHeight:35
        onTap:
            (item)=>{
                if(item.key){
                    page_router.go(item.key,{info:item.title})
                }
            }
        Component.onCompleted: {
            page_router.go(Global.displayTablePage)
        }

        Connections{
            target:Global
            function onDisplayTablePageChanged(){
                page_router.go(Global.displayTablePage)
            }
        }

    }
}
