import QtQuick
import QtQuick.Controls
import FluentUI.Controls
import FluentUI.impl
// import Frame
import NavPost

Starter {
    id: starter
    appId: PROJECT_NAME
    singleton: true
    //windowIcon:Global.windowIcon
    onActiveApplicationChanged:
        (args)=> {
            WindowRouter.go("/",{type:0,args:args})
        }
    Connections{
        target: Theme
        function onDarkModeChanged(){
            SettingsHelper.saveDarkMode(Theme.darkMode)
        }
    }
    Component.onCompleted: {
        R.windowIcon =Global.windowIcon
        Global.starter = starter
        Theme.darkMode = SettingsHelper.getDarkMode()
        WindowRouter.routes = {
            "/": R.resolvedUrl("qml/window/MainWindow.qml"),
            "/standardwindow": R.resolvedUrl("qml/window/StandardWindow.qml"),
            "/singletaskwindow": R.resolvedUrl("qml/window/SingleTaskWindow.qml"),
            "/singleinstancewindow": R.resolvedUrl("qml/window/SingleInstanceWindow.qml"),
            "/page": R.resolvedUrl("qml/window/PageWindow.qml"),
        }
        WindowRouter.go("/")
    }
}
