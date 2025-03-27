import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
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
                                    text: qsTr("载入进度条")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_Puzzle
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon

                                    onClicked: {
                                        tip_bottomright.showCustom(com_custom,10000)
                                    }

                                    Component{
                                        id: com_custom
                                        Pane{
                                            width: 400
                                            height: 100
                                            ProgressBar{
                                                anchors.bottom: parent.bottom
                                                width: parent.width

                                                indeterminate: true
                                            }
                                            Button{
                                                text: "Cancal"
                                                onClicked: {
                                                    // if(model.severity !== InfoBarType.Success){
                                                    //     model.severity = InfoBarType.Success
                                                    // }else{
                                                    infoControl.remove(model.index)
                                                    // }
                                                }
                                            }
                                        }
                                    }

                                }
                                IconButton {
                                    text: qsTr("保存工程")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_Puzzle
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon

                                    property int iter:0
                                    onClicked: {

                                        iter=iter%4;
                                        switch (iter) {
                                        case 0:
                                            tip_top.show(InfoBarType.Info,qsTr("工程保存中..."))
                                            break;
                                        case 1:
                                            tip_top.show(InfoBarType.Success,qsTr("工程保存成功！"))
                                            break;
                                        case 2:
                                            tip_top.show(InfoBarType.Warning,qsTr("任务处理中，当前状态下无法保存，请等待处理完成或取消正在处理的任务！"),3000)
                                            break;
                                        case 3:
                                            tip_top.show(InfoBarType.Error,qsTr("工程保存失败！请检查存储空间已满或软件权限不足！"),3000)
                                            break;
                                        default:
                                            console.log("Default case");
                                        }
                                        iter+=1

                                    }
                                }

                                IconButton {
                                    text: qsTr("添加站点")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_Puzzle
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon

                                    property int iter:0
                                    onClicked: {

                                        iter=iter%2;
                                        switch (iter) {
                                        case 0:
                                            tip_top.show(InfoBarType.Success,qsTr("站点已添加！"))
                                            break;
                                        case 1:
                                            tip_top.show(InfoBarType.Error,qsTr("站点添加失败！请检查是否已存在同名站点！"))
                                            break;
                                        default:
                                            console.log("Default case");
                                        }
                                        iter+=1
                                    }
                                }

                                IconButton {
                                    text: qsTr("导入文件")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_Puzzle
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon

                                    property int iter:0
                                    onClicked: {

                                        iter=iter%4;
                                        switch (iter) {
                                        case 0:
                                            tip_top.show(InfoBarType.Success,qsTr("文件已添加！"))
                                            break;
                                        case 1:
                                            tip_top.show(InfoBarType.Info,qsTr("缺少星历文件，无法进行单点定位"))
                                            break;
                                        case 2:
                                            tip_top.show(InfoBarType.Warning,qsTr("文件解析失败，请检查选择的文件格式是否正确"))
                                            break;
                                        case 3:
                                            tip_top.show(InfoBarType.Error,qsTr("文件添加失败，请检查文件是否移动、删除或程序权限不足！"))
                                            break;
                                        default:
                                            console.log("Default case");
                                        }
                                        iter+=1
                                    }
                                }


                                IconButton {
                                    text: qsTr("处理基线")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_Puzzle
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon

                                    property int iter:0
                                    onClicked: {

                                        iter=iter%4;
                                        switch (iter) {
                                        case 0:
                                            tip_bottomright.show(InfoBarType.Info,qsTr("基线B01(SHJD01-SHJD02) 处理任务已添加到队列。"))
                                            break;
                                        case 1:
                                            tip_bottomright.show(InfoBarType.Warning,qsTr("基线B01(SHJD01-SHJD02) 处理任务已开始处理。"))
                                            break;
                                        case 2:
                                            tip_bottomright.show(InfoBarType.Success,qsTr("基线B01(SHJD01-SHJD02) 处理任务处理成功！"))
                                            break;
                                        case 3:
                                            tip_bottomright.show(InfoBarType.Error,qsTr("基线B01(SHJD01-SHJD02) 处理任务处理失败!"))
                                            break;
                                        default:
                                            console.log("Default case");
                                        }
                                        iter+=1
                                    }
                                }


                            }
                        }
                        Label{
                            height:groupname_height
                            text:qsTr("提示/进度条测试")
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
                                    text: qsTr("解算结果合并")
                                    // width: iconbutton_width
                                    height:function_height.height  // 设置按键的高度

                                    icon.name: FluentIcons.graph_Puzzle
                                    icon.width: iconbutton_size
                                    icon.height: iconbutton_size
                                    spacing: iconbutton_spacing
                                    display: IconButton.TextUnderIcon

                                    onClicked: {
                                        contentDialog.open()
                                        // fileDialog.open()
                                    }


                                    // Component.onCompleted:
                                    // {
                                    //     contentDialog.open()
                                    // }

                                    Dialog {
                                        id: contentDialog
                                        x: Math.ceil((parent.width - width) / 2)
                                        y: Math.ceil((parent.height - height) / 2)
                                        width: Math.ceil(parent.width / 2)
                                        // contentHeight: 400
                                        parent: Overlay.overlay
                                        modal: true
                                        title: qsTr("结果文件导出")
                                        standardButtons: Dialog.Ok | Dialog.Cancel

                                        Column{
                                            spacing: 5

                                            anchors.horizontalCenter: parent.horizontalCenter

                                            Label{
                                                text: qsTr("文件输出配置")
                                                font:Typography.bodyLarge
                                            }

                                            Row{

                                                Label{
                                                    text: qsTr("结果输出路径:  ")
                                                    anchors.verticalCenter: parent.verticalCenter  // 垂直居中
                                                }

                                                TextBox{

                                                    width: 360
                                                    anchors.verticalCenter: parent.verticalCenter  // 垂直居中
                                                }

                                                IconButton{
                                                    icon.name: FluentIcons.graph_FolderOpen
                                                }
                                            }

                                            Row{
                                                Label{
                                                    text: qsTr("结果输出路径:  ")
                                                    anchors.verticalCenter: parent.verticalCenter  // 垂直居中
                                                }

                                                TextBox{
                                                    anchors.verticalCenter: parent.verticalCenter  // 垂直居中

                                                }
                                                Label{
                                                    text: qsTr("   ms     ")
                                                    anchors.verticalCenter: parent.verticalCenter  // 垂直居中
                                                }

                                                Switch{
                                                    text: qsTr("填充缺失历元")
                                                    anchors.verticalCenter: parent.verticalCenter  // 垂直居中
                                                }

                                            }

                                            Row{
                                                Label{
                                                    text: qsTr("文件合并类型:  ")
                                                    anchors.verticalCenter: parent.verticalCenter
                                                }
                                                ButtonGroup {
                                                    buttons: mergetype.children
                                                }
                                                Row {
                                                    id: mergetype
                                                    spacing: 67
                                                    RadioButton {
                                                        checked: true
                                                        text: qsTr("SOL")
                                                    }
                                                    RadioButton {
                                                        text: qsTr("GPGGA")
                                                    }
                                                }
                                            }

                                            Row{
                                                Label{
                                                    text: qsTr("数据合并规则:  ")
                                                    anchors.verticalCenter: parent.verticalCenter
                                                }
                                                ButtonGroup {
                                                    buttons: mergerule.children
                                                }
                                                Row {
                                                    id: mergerule
                                                    spacing: 40
                                                    RadioButton {
                                                        checked: true
                                                        text: qsTr("自动模式")
                                                    }
                                                    RadioButton {
                                                        text: qsTr("固定率优先")
                                                    }
                                                    RadioButton {
                                                        text: qsTr("距离优先")
                                                    }
                                                }
                                            }


                                            Label{
                                                text: qsTr("添加外部输入文件")
                                                font:Typography.bodyLarge
                                            }

                                            Row{
                                                spacing:335
                                                Label{
                                                    text: qsTr("已添加的文件：")
                                                    anchors.verticalCenter: parent.verticalCenter  // 垂直居中
                                                }
                                            }
                                            Row{

                                                Frame{
                                                    width:420
                                                    height: 200

                                                    ListView{
                                                        anchors.fill: parent

                                                        clip: true


                                                        model: listViewModel

                                                        delegate: IconButton{
                                                            width: 420
                                                            height: 30
                                                            Row{
                                                                leftPadding: 10
                                                                Label{
                                                                    text:  model.fileName
                                                                    width:350
                                                                    elide: Text.ElideMiddle
                                                                    anchors.verticalCenter: parent.verticalCenter  // 垂直居中
                                                                }

                                                                Button{
                                                                    text: qsTr("删除")

                                                                    onClicked: {
                                                                        listViewModel.remove(model.index)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }

                                                Column{

                                                    anchors.verticalCenter: parent.verticalCenter

                                                    spacing: 10


                                                    Button{
                                                        // icon.name: FluentIcons.graph_FolderOpen

                                                        text:qsTr("添加文件")
                                                        onClicked: {
                                                            fileDialog.open()
                                                        }
                                                    }


                                                    Button{
                                                        text:qsTr("清除文件")

                                                        onClicked: {
                                                            listViewModel.clear()
                                                        }

                                                    }

                                                    Button{
                                                        text: qsTr("执行合并")
                                                        highlighted: true

                                                    }

                                                }

                                            }

                                        }

                                        // 用于 ListView 的模型
                                        ListModel {
                                            id: listViewModel


                                            // 检查是否重复的方法
                                            function isDuplicate(newItem) {
                                                for (let i = 0; i < listViewModel.count; i++) {
                                                    if (listViewModel.get(i).fileName === newItem.fileName) {
                                                        return true; // 找到重复项
                                                    }
                                                }
                                                return false; // 没有找到重复项
                                            }

                                            // 添加元素的方法
                                            function addUniqueItem(newItem) {
                                                if (!isDuplicate(newItem)) {
                                                    listViewModel.append(newItem);
                                                } else {
                                                    console.log("Item is duplicate:", newItem.fileName);
                                                }
                                            }

                                        }

                                        FileDialog {
                                            id: fileDialog
                                            title: "选择文件"
                                            fileMode: FileDialog.OpenFiles

                                            onAccepted: {

                                                // console.log(selectedFiles,selectedFiles.length)
                                                for(let i=0;i<selectedFiles.length;i++)
                                                {
                                                    console.log(selectedFiles[i])
                                                    console.log(typeof selectedFiles[i]);

                                                    var item={ fileName: toAbsolutePath( selectedFiles[i].toString())}


                                                    listViewModel.addUniqueItem(item)


                                                }



                                                // full_path=currentFile
                                                // file_path=toAbsolutePath(full_path)
                                                // console.log("select obs file: "+file_path)
                                            }

                                            function toAbsolutePath(fileUrl) {
                                                var path = fileUrl;

                                                // Remove the "file://" prefix
                                                if (fileUrl.startsWith("file://")) {
                                                    path = fileUrl.replace("file://", "");

                                                    // Windows-specific adjustment
                                                    if (Qt.platform.os === "windows") {
                                                        // On Windows, paths after "file://" may start with a drive letter (e.g., "C:/")
                                                        // In this case, an additional slash might be present (e.g., "file:///C:/path")
                                                        if (path.length > 3 && path.charAt(2) === ':') {
                                                            path = path.substring(1); // Remove the leading slash before "C:/"
                                                        }
                                                    }
                                                }

                                                return path;
                                            }





                                        }



                                    }

                                }


                            }
                        }
                        Label{
                            height:groupname_height
                            text:qsTr("对话框功能")
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
