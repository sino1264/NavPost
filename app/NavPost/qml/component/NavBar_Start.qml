import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import FluentUI.Controls
import FluentUI.impl
import NavPost

// ContentPage
Item{
    id:root

    anchors.fill: parent
    property string title
    property PageContext context
    property int group_height:root.height-function_box.padding*2
    property int function_height:group_height-groupname_height

    property int groupbox_padding:5 //内容与背景边框的间距
    property int group_spacing:5  //每个组之间的间距
    property int group_padding:5  //每个组内按键与组边框的间距
    property int groupname_height:20 //每个组名的高度

    property int iconbutton_spacing: 10 //每个标准按键，图标和文字的间距
    property int iconbutton_size: 22    //标准按键，图标的宽度
    property int iconbutton_width:60    //标准按键，按键的指定宽度（一般都是默认宽度）

    GroupBox{
        id:function_box
        anchors.fill: parent
        padding: groupbox_padding
        Flickable{

            anchors.fill: parent
            contentWidth: rowItem.width
            // contentHeight: rowItem.height
            interactive: contentWidth > width

            Row{
                id:rowItem
                spacing: group_spacing
                Frame{
                    width: implicitWidth

                    Column{
                        Frame{
                            width: implicitWidth
                            Row {
                                padding: group_padding
                                IconButton {
                                    text: qsTr("导入")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_ReturnToWindow
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon



                                    onClicked: {
                                        import_menu.popup()
                                    }
                                    Menu {
                                        id:import_menu
                                        width: 140
                                        title: qsTr("导入文件")
                                        MenuItem{
                                            text: qsTr("观测数据")
                                            onTriggered: {
                                            Global.open_dialog("/dialog/file/import_obs")
                                            }
                                        }
                                        MenuSeparator { }
                                        MenuItem{
                                            text: qsTr("广播星历")
                                        }
                                        MenuItem{
                                            text: qsTr("精密星历")
                                            enabled: false
                                        }
                                        MenuSeparator { }
                                        MenuItem{
                                            text: qsTr("惯导原始数据")
                                            enabled: false
                                        }
                                    }
                                }
                                Column {
                                    IconButton {
                                        text: qsTr("导入配置")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_ProvisioningPackage
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5

                                        onClicked: {
                                            import_option_dialog.open()
                                        }

                                        Dialog{
                                            id:import_option_dialog

                                            x: Math.ceil((parent.width - width) / 2)
                                            y: Math.ceil((parent.height - height) / 2)
                                            parent: Overlay.overlay
                                            modal: true
                                            title: qsTr("导入文件配置")
                                            standardButtons: Dialog.Yes | Dialog.No

                                            width: 600
                                            contentHeight: 300
                                            Frame{
                                                anchors.fill: parent
                                            }
                                            Component.onCompleted:
                                            {
                                                // open()
                                            }
                                        }
                                    }

                                    IconButton {
                                        text: qsTr("导入列表")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_FileExplorer
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5

                                        onClicked: {
                                            baseline_refresh_dialog.open()
                                        }

                                        Dialog{
                                            id:baseline_refresh_dialog

                                            x: Math.ceil((parent.width - width) / 2)
                                            y: Math.ceil((parent.height - height) / 2)
                                            parent: Overlay.overlay
                                            modal: true
                                            title: qsTr("重新组成基线")
                                            standardButtons: Dialog.Yes | Dialog.No

                                            width: 600
                                            contentHeight: 300
                                            Frame{
                                                anchors.fill: parent
                                            }
                                            Component.onCompleted:
                                            {
                                                // open()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        Label{
                            height:groupname_height
                            text:qsTr("文件")
                            font:Typography.bodyStrong
                            // color:Theme.res.textFillColorPrimary
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }

                Frame{
                    width: implicitWidth

                    Column{
                        Frame{
                            width: implicitWidth
                            Row {
                                padding: group_padding
                                IconButton {
                                    text: qsTr("新建站点")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_MapPin
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon

                                    onClicked: {
                                        Global.open_dialog("/dialog/station/add_new")
                                    }
                                }
                                Column {
                                    IconButton {
                                        text: qsTr("管理站点")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_GroupList
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5

                                        onClicked: {
                                             Global.open_dialog("/dialog/station/manage_exist")
                                        }
                                    }

                                    IconButton {
                                        text: qsTr("编辑站点")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_Edit
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5

                                        onClicked: {
                                             Global.open_dialog("/dialog/station/edit_property")
                                        }
                                    }
                                }
                            }
                        }
                        Label{
                            height:groupname_height
                            text:qsTr("站点")
                            font:Typography.bodyStrong
                            // color:Theme.res.textFillColorPrimary
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }

                Frame{
                    width: implicitWidth

                    Column{
                        Frame{
                            width: implicitWidth
                            Row {
                                padding: group_padding
                                IconButton {
                                    text: qsTr("平面视图")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_TiltUp
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon

                                    onClicked: {
                                        Global.displayMidTop="/page/map"
                                    }
                                }
                                Column {

                                    IconButton {
                                        text: checked?qsTr("隐藏格网"):qsTr("显示格网")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_TiltDown
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5

                                        // highlighted: checked
                                        checked: false
                                        checkable: true

                                        onClicked: {
                                            Global.mapPageOption_Draw_Grid=checked
                                        }

                                        Component.onCompleted: {
                                            checked=  Global.mapPageOption_Draw_Grid
                                        }
                                    }

                                    IconButton {
                                        text: qsTr("图层管理")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_MapLayers
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5

                                        onClicked: {
                                            if(Global.visable_left_bottom_side)
                                            {
                                                Global.visable_left_bottom_side=false
                                            }
                                            else
                                            {
                                                Global.visable_left_bottom_side=true
                                            }
                                            Global.update_visable()
                                        }
                                    }
                                }
                            }
                        }
                        Label{
                            height:groupname_height
                            text:qsTr("视图")
                            font:Typography.bodyStrong
                            // color:Theme.res.textFillColorPrimary
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }

                Frame{
                    width: implicitWidth

                    Column{
                        Frame{
                            width: implicitWidth
                            Row {
                                padding: group_padding
                                IconButton {
                                    text: qsTr("资源视图")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_DeviceLaptopNoPic
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon

                                    onClicked: {
                                        Global.displayMidTop="/page/table"
                                    }
                                }

                                Column {
                                    IconButton {
                                        text: qsTr("站点列表")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_BulletedList
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5

                                        onClicked: {
                                            Global.displayMidTop="/page/table"
                                            Global.displayTablePage="/page/table/station"
                                        }

                                    }
                                    IconButton {
                                        text: qsTr("文件列表")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_BulletedList
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5

                                        onClicked: {
                                            Global.displayMidTop="/page/table"
                                            Global.displayTablePage="/page/table/obsfile"
                                        }
                                    }

                                }

                                Column {
                                    IconButton {
                                        text: qsTr("基线列表")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_BulletedList
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5

                                        onClicked: {
                                            Global.displayMidTop="/page/table"
                                            Global.displayTablePage="/page/table/baseline"
                                        }
                                    }


                                    IconButton {
                                        text: qsTr("数据检核")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_CheckList
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5

                                        onClicked: {
                                            Global.displayMidTop="/page/table"
                                            Global.displayTablePage="/page/table/check"
                                        }
                                    }
                                }

                                Column {
                                    IconButton {
                                        text: qsTr("闭合环")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_AllApps
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5

                                        onClicked: {
                                            Global.displayMidTop="/page/table"
                                            Global.displayTablePage="/page/table/closeloop"
                                        }
                                    }

                                    IconButton {
                                        text: qsTr("数据区间")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_BulletedList
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5

                                        onClicked: {
                                            Global.displayMidTop="/page/dataspan"
                                        }
                                    }

                                }

                            }
                        }
                        Label{
                            height:groupname_height
                            text:qsTr("资源管理")
                            font:Typography.bodyStrong
                            // color:Theme.res.textFillColorPrimary
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }

                Frame{
                    width: implicitWidth

                    Column{
                        Frame{
                            width: implicitWidth
                            Row {
                                padding: group_padding

                                IconButton {
                                    text: qsTr("任务队列")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_TaskView
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon

                                    onClicked: {
                                        Global.displayMidTop="/page/task"
                                    }
                                }

                                Column {
                                    IconButton {
                                        text: qsTr("处理选项")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_SpeedHigh
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5

                                        onClicked: {
                                            process_option_dialog.open()
                                        }

                                        Dialog{
                                            id:process_option_dialog

                                            x: Math.ceil((parent.width - width) / 2)
                                            y: Math.ceil((parent.height - height) / 2)
                                            parent: Overlay.overlay
                                            modal: true
                                            title: qsTr("配置任务队列同时开启的线程等功能，是否输出日志，保存日志等选项")
                                            standardButtons: Dialog.Yes | Dialog.No

                                            width: 600
                                            contentHeight: 300
                                            Frame{
                                                anchors.fill: parent
                                            }
                                            Component.onCompleted:
                                            {
                                                // open()
                                            }
                                        }
                                    }

                                    IconButton {
                                        text: qsTr("状态监控")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_Diagnostic
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5

                                        onClicked: {
                                            Global.visable_right_bottom_side=!Global.visable_right_bottom_side
                                            Global.update_visable()
                                        }
                                    }
                                }

                            }
                        }
                        Label{
                            height:groupname_height
                            text:qsTr("任务管理")
                            font:Typography.bodyStrong
                            // color:Theme.res.textFillColorPrimary
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }

                Frame{
                    width: implicitWidth

                    Column{
                        Frame{
                            width: implicitWidth
                            Row {
                                padding: group_padding

                                IconButton {
                                    text: qsTr("工程信息")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_Paste
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon


                                    onClicked: {
                                        project_info_dialog.open()
                                    }

                                    Dialog{
                                        id:project_info_dialog

                                        x: Math.ceil((parent.width - width) / 2)
                                        y: Math.ceil((parent.height - height) / 2)
                                        parent: Overlay.overlay
                                        modal: true
                                        title: qsTr("展示这个工程的基本信息，工程名，中央子午线，创建日期等")
                                        standardButtons: Dialog.Yes | Dialog.No

                                        width: 600
                                        contentHeight: 300
                                        Frame{
                                            anchors.fill: parent
                                        }
                                        Component.onCompleted:
                                        {
                                            // open()
                                        }
                                    }

                                }

                                IconButton {
                                    text: qsTr("工程配置")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_Label
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon


                                    onClicked: {
                                        project_opotion_dialog.open()
                                    }

                                    Dialog{
                                        id:project_opotion_dialog

                                        x: Math.ceil((parent.width - width) / 2)
                                        y: Math.ceil((parent.height - height) / 2)
                                        parent: Overlay.overlay
                                        modal: true
                                        title: qsTr("配置工程的中央子午线\坐标单位显示等")
                                        standardButtons: Dialog.Yes | Dialog.No

                                        width: 600
                                        contentHeight: 300
                                        Frame{
                                            anchors.fill: parent
                                        }
                                        Component.onCompleted:
                                        {
                                            // open()
                                        }
                                    }

                                }

                                Column {
                                    IconButton {
                                        text: qsTr("显示配置")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_ProvisioningPackage
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5


                                        onClicked: {
                                            project_display_dialog.open()
                                        }

                                        Dialog{
                                            id:project_display_dialog

                                            x: Math.ceil((parent.width - width) / 2)
                                            y: Math.ceil((parent.height - height) / 2)
                                            parent: Overlay.overlay
                                            modal: true
                                            title: qsTr("配置工程的显示的单位等、语言等")
                                            standardButtons: Dialog.Yes | Dialog.No

                                            width: 600
                                            contentHeight: 300
                                            Frame{
                                                anchors.fill: parent
                                            }
                                            Component.onCompleted:
                                            {
                                                // open()
                                            }
                                        }

                                    }

                                    IconButton {
                                        text: qsTr("存储配置")
                                        // width: iconbutton_width
                                        // height: function_height.height*0.4// 半高按钮的高度

                                        icon.name: FluentIcons.graph_FileExplorer
                                        icon.width: iconbutton_size*0.8
                                        icon.height: iconbutton_size*0.8
                                        spacing: 5

                                        onClicked: {
                                            project_save_option_dialog.open()
                                        }

                                        Dialog{
                                            id:project_save_option_dialog

                                            x: Math.ceil((parent.width - width) / 2)
                                            y: Math.ceil((parent.height - height) / 2)
                                            parent: Overlay.overlay
                                            modal: true
                                            title: qsTr("配置工程的保存文件的选项")
                                            standardButtons: Dialog.Yes | Dialog.No

                                            width: 600
                                            contentHeight: 300
                                            Frame{
                                                anchors.fill: parent
                                            }
                                            Component.onCompleted:
                                            {
                                                // open()
                                            }
                                        }

                                    }
                                }
                                IconButton {
                                    text: qsTr("保存")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_Save
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon
                                }
                                IconButton {
                                    text: qsTr("导出")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_Share
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon


                                    onClicked: {
                                        project_export_dialog.open()
                                    }

                                    Dialog{
                                        id:project_export_dialog

                                        x: Math.ceil((parent.width - width) / 2)
                                        y: Math.ceil((parent.height - height) / 2)
                                        parent: Overlay.overlay
                                        modal: true
                                        title: qsTr("将工程的数据导出的选项，可以导出基线结果，解算结果等")
                                        standardButtons: Dialog.Yes | Dialog.No

                                        width: 600
                                        contentHeight: 300
                                        Frame{
                                            anchors.fill: parent
                                        }
                                        Component.onCompleted:
                                        {
                                            // open()
                                        }
                                    }

                                }
                            }
                        }
                        Label{
                            height:groupname_height
                            text:qsTr("工程")
                            font:Typography.bodyStrong
                            // color:Theme.res.textFillColorPrimary
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }

            }
        }
    }

}
