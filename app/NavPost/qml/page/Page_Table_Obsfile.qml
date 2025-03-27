import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import FluentUI.Controls
import FluentUI.impl
import NavPost
import "../extra"


Frame{
    id:root

    anchors.fill: parent

    property string title
    property PageContext context

    Connections{
        target: ResourceDataController
        function onUpdateObsFileDataStart(){
            panel_loading.visible = true
        }
        function onUpdateObsFileDataSuccess(){
            dataModel.sourceData  = ResourceDataController.obsfile_data
            panel_loading.visible = false
        }
    }

    Component.onCompleted: {
        ResourceDataController.updateObsFileData()
    }

    Component{
        id: comp_column_frozen
        Item{
            Label{
                anchors.fill: parent
                text: columnModel.title
                verticalAlignment: Qt.AlignVCenter
                leftPadding: 10
                rightPadding: 10
                elide: Label.ElideRight
            }
            IconButton{
                id: btn_pinned
                icon.name: FluentIcons.graph_Pinned
                icon.width: 12
                icon.height: 12
                width: 24
                height: 24
                icon.color: columnModel.frozen ? Theme.primaryColor : btn_pinned.FluentUI.textColor
                anchors.right: parent.right
                onClicked: {
                    columnModel.frozen = !columnModel.frozen
                }
            }
        }
    }


    DataGridModel{
        id: dataModel
    }
    RowLayout{
        id: layout_actions
        anchors{
            top: parent.top
            left: parent.left
        }
    }
    DataGridEx{
        id: dataGrid
        anchors{
            top: layout_actions.bottom
            bottom: parent.bottom
            left: parent.left
            leftMargin: 5
            right: parent.right
            rightMargin: 5
            topMargin: 5
            bottomMargin: 5
        }

        defaultHeight: 30
        defaultminimumHeight:25
        defaultmaximumHeight:240
        horizonalHeaderHeight:30


        sourceModel: dataModel
        onRowClicked:(model)=>{
                         console.debug(model.file_name,model.file_format)
                         Global.focusObsFile=model
                         Global.visable_right_top_side=true
                         Global.displayPropertyPage="/sidepage/property/obsfile"
                         Global.update_visable()
                     }
        onRowRightClicked:(model)=>{
                              console.debug(model.name)
                              // Global.displayPropertyPage="/sidepage/property/blank"
                              operate_item_menu.popup()
                          }

        Menu {
            id:operate_item_menu
            width: 150
            title: qsTr("操作观测文件")

            MenuItem{
                text: qsTr("查看原始文件")
                onTriggered: {
                }
            }
            MenuItem{
                text: qsTr("打开原始文件目录")
                onTriggered: {
                }
            }
            MenuSeparator { }

            MenuItem{
                text: qsTr("转换为Rinex文件")
                onTriggered: {
                    Global.open_dialog("/dialog/convert/add_task")
                }
            }

            MenuSeparator { }

            MenuItem{
                text: qsTr("数据质检")
                onTriggered: {
                }
            }
            MenuSeparator { }
            MenuItem{
                text: qsTr("单点定位")
                onTriggered: {
                }
            }
            MenuItem{
                text: qsTr("PPP解算")
                onTriggered: {
                }
            }

            MenuSeparator { }

            MenuItem{
                text: qsTr("编辑")
                onTriggered: {
                }
            }

            MenuItem{
                text: qsTr("删除")
                onTriggered: {
                }
            }
        }


        columnSourceModel: ListModel{
            ListElement{
                title: qsTr("文件名")
                dataIndex: "file_name"
                width: 200
                frozen: true
                delegate: function(){return comp_column_frozen}
            }
            ListElement{
                title: qsTr("文件类型")
                dataIndex: "file_format"
                rowDelegate: function(){return comp_file_format}
                // editDelegate: function(){return comp_edit_file_format}
                width: 100
            }
            ListElement{
                title: qsTr("测站")
                dataIndex: "station_name"
                //editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("站点类型")
                dataIndex: "station_type"
                rowDelegate: function(){return comp_station_type}
                width: 100
            }
            ListElement{
                title: qsTr("开始时间")
                dataIndex: "file_start_time"
                //editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("结束时间")
                dataIndex: "file_end_time"
                //editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("时间段")
                dataIndex: "file_time_span"
                //editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("量测方式")
                dataIndex: "measurement_method"
                //editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("量测天线高")
                dataIndex: "measurement_ant_height"
                //editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("天线相位中心高")
                dataIndex: "ant_phase_height"
                //editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("天线座底部高")
                dataIndex: "ant_pedestal_height"
                //editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("天线厂商")
                dataIndex: "ant_manufacturer"
                //editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("天线类型")
                dataIndex: "ant_type"
                //editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("接收机/SN")
                dataIndex: "receiver"
                //editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("接收机类型")
                dataIndex: "receiver_type"
                //editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("文件")
                dataIndex: "file_path"
                // editDelegate: function(){return comp_edit_combobox}
                width: 300
            }
        }
    }

    Pane{
        id: panel_loading
        anchors.fill: dataGrid
        ProgressRing{
            anchors.centerIn: parent
            indeterminate: true
        }
        background: Rectangle{
            color: Theme.res.solidBackgroundFillColorBase
        }
    }


    Component{
        id: comp_file_format
        Item{
            Label{
                text: format_model.get(display).text//"xxxx"//display==  String(display)
                elide: Label.ElideRight
                anchors{
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 10
                    right: parent.right
                    rightMargin: 10
                }
            }

            ListModel {
                id: format_model
                ListElement {text: qsTr("Rinex") ; def:DefFileFormat.RINEX }
                ListElement {text: qsTr("RTCM3"); def:DefFileFormat.RTCM3 }
                ListElement {text: qsTr("CNB"); def:DefFileFormat.CNB }
            }
        }
    }

    Component{
        id: comp_edit_file_format

        ComboBox{
            width:100
            height:30

            model: ListModel {
                id: format_model
                ListElement {text: qsTr("Rinex") ; def:DefFileFormat.RINEX }
                ListElement {text: qsTr("RTCM3"); def:DefFileFormat.RTCM3 }
                ListElement {text: qsTr("CNB"); def:DefFileFormat.CNB }
            }
            // editable: true
            textRole: "text"
            currentIndex: 0
            Component.onCompleted: {
                //初始化，判断文件的形式
                for(let i=0;i<model.count;i++)
                {
                    if(display===model.get(i).def)
                    {
                        currentIndex=i;
                        break;
                    }
                }
            }
            onCurrentIndexChanged: {
                // // console.log(currentIndex,model.get(currentIndex).text,model.get(currentIndex).def)
                // rowModel[columnModel.dataIndex]=model.get(currentIndex).def

                //获取UID
                //执行设置站点参数的函数

            }
        }
    }


    Component{
        id: comp_station_type
        Item{
            Label{
                text: station_model.get(display).text//"xxxx"//display==  String(display)
                elide: Label.ElideRight
                anchors{
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 10
                    right: parent.right
                    rightMargin: 10
                }
            }

            ListModel {
                id: station_model
                ListElement {text: qsTr("动态") ; def:DefStationType.Dynamic }
                ListElement {text: qsTr("静态"); def:DefStationType.Static }
            }
        }
    }


}
