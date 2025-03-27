import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import FluentUI.Controls
import FluentUI.impl
import NavPost

Item{

    id:root

    property var initialItem

    anchors.fill:parent

    PageRouter{
        id: screen_router
        routes: {
            "/screen/init": R.resolvedUrl("qml/screen/Screen_Init.qml"),
            "/screen/main": {url:R.resolvedUrl("qml/screen/Screen_Main.qml"),singleton:true},
            "/screen/file": R.resolvedUrl("qml/screen/Screen_File.qml")
        }
    }


    PageRouter{
        id: dialog_router
        routes: {
            "/dialog/analysis/eidt_option": R.resolvedUrl("qml/dialog/Dialog_Analysis_EditOption.qml"),
            "/dialog/convert/add_task": R.resolvedUrl("qml/dialog/Dialog_Convert_AddTask.qml"),
            "/dialog/convert/eidt_option": R.resolvedUrl("qml/dialog/Dialog_Convert_EditOption.qml"),
            "/dialog/file/edit_option": R.resolvedUrl("qml/dialog/Dialog_File_EditOption.qml"),
            "/dialog/file/import_imu": R.resolvedUrl("qml/dialog/Dialog_File_ImportIMU.qml"),
            "/dialog/file/import_nav": R.resolvedUrl("qml/dialog/Dialog_File_ImportNav.qml"),
            "/dialog/file/import_obs": R.resolvedUrl("qml/dialog/Dialog_File_ImportObs.qml"),
            "/dialog/file/import_sp3": R.resolvedUrl("qml/dialog/Dialog_File_ImportSp3.qml"),
            "/dialog/file/manage_list": R.resolvedUrl("qml/dialog/Dialog_File_ManageList.qml"),
            "/dialog/process/add_task": R.resolvedUrl("qml/dialog/Dialog_Process_AddTask.qml"),
            "/dialog/process/edit_option": R.resolvedUrl("qml/dialog/Dialog_Process_EditOption.qml"),
            "/dialog/process/manage_templete": R.resolvedUrl("qml/dialog/Dialog_Process_ManageTemplete.qml"),
            "/dialog/project/new_project": R.resolvedUrl("qml/dialog/Dialog_Project_NewProject.qml"),
            "/dialog/station/add_new": R.resolvedUrl("qml/dialog/Dialog_Station_AddNew.qml"),
            "/dialog/station/edit_property": R.resolvedUrl("qml/dialog/Dialog_Station_EditProperty.qml"),
            "/dialog/station/manage_exist": R.resolvedUrl("qml/dialog/Dialog_Station_ManageExist.qml")

        }
    }


    InfoBarManager{
        id: tip_topright
        target: root
        edge: Qt.TopEdge | Qt.RightEdge
    }

    InfoBarManager{
        id: tip_top
        target: root
        edge: Qt.TopEdge
    }

    InfoBarManager{
        id: tip_topleft
        target: root
        edge: Qt.TopEdge | Qt.LeftEdge
    }

    InfoBarManager{
        id: tip_bottomright
        target: root
        edge: Qt.BottomEdge | Qt.RightEdge
    }

    InfoBarManager{
        id: tip_bottom
        target: root
        edge: Qt.BottomEdge
    }

    InfoBarManager{
        id: tip_bottomleft
        target: root
        edge: Qt.BottomEdge | Qt.LeftEdge
    }



    // 用于存储多个对话框的Loader
    HotLoader {
        id: dialogLoader

        // property string title
        // property var path
        // property var url
        // property var argument
        // property bool singleton
        // property var stackView: control
        // property var pageRouter: control.router
        // property alias __context: context
        // property var __current:{
        //     if(singleton){
        //         return url
        //     }
        //     return visible ? url : ""
        // }
        // on__CurrentChanged: {
        //     dialogLoader.setSource(__current,{context:context})
        // }
        // reload: function(){
        //     var timestamp = Date.now()
        //     var url = new URL(__current)
        //     url.searchParams.set('timestamp', timestamp);
        //     dialogLoader.setSource(url.toString(),{context:context})
        // }
        // StackView.onActivated: {
        //     context.activated()
        // }
        // StackView.onDeactivated: {
        //     context.deactivated()
        // }
        // PageContext{
        //     id: context
        //     path: dialogLoader.path
        //     url: dialogLoader.url
        //     argument: dialogLoader.argument
        //     singleton: dialogLoader.singleton
        //     view: dialogLoader.stackView
        //     router: dialogLoader.pageRouter
        // }
        // onLoaded: {
        //     dialogLoader.title = loader_panne.item.title
        // }

    }

    Connections{
        target: Global

        function  onOpen_dialog(path)
        {
            if(dialogLoader.source==dialog_router.toUrl(path))
            {
                console.log("reload dialog")
                dialogLoader.reload()
            }
            else
            {
                console.log("open dialog:"+path)
                dialogLoader.source =dialog_router.toUrl(path)
            }
        }
    }



    PageRouterView{
        id: screen_panne
        anchors.fill: parent
        router: screen_router
        clip: true

        Component.onCompleted: {
            screen_router.go(Global.displayScreen)
        }
    }

    Connections{
        target:Global
        function onDisplayScreenChanged(){
            screen_router.go(Global.displayScreen)
        }
    }


}

