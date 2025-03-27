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

    Component.onCompleted: {
        ResourceDataController.loadData()
    }

    Connections{
        target: ResourceDataController
        function onLoadDataStart(){
            panel_loading.visible = true
        }
        function onLoadDataSuccess(){
            dataModel.sourceData  = ResourceDataController.baseline_data
            panel_loading.visible = false
        }
    }

    Component{
        id: comp_row_avatar
        Item{
            RoundImageView{
                width: Math.min(parent.width,parent.height) - 16
                height: width
                radius: width/2
                borderWidth: 2
                sourceSize: Qt.size(width*2,height*2)
                source: rowModel.avatar
                anchors{
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 10
                }
            }
        }
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
    Component{
        id: comp_column_close
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
                id: btn_close
                icon.name: FluentIcons.graph_ChromeClose
                icon.width: 10
                icon.height: 10
                width: 28
                height: 28
                anchors{
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: 10
                }
                onClicked: {
                    dataGrid.columnSourceModel.remove(columnModel.index)
                }
            }
        }
    }
    Component{
        id: comp_row_move
        Item{
            Row{
                spacing: 5
                anchors{
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 10
                }
                Button{
                    text: qsTr("Up")
                    onClicked: {
                        dataGrid.closeEditor()
                        if(rowModel.index>0){
                            dataModel.move(rowModel.index,rowModel.index-1,1)
                        }
                    }
                }
                Button{
                    text: qsTr("Down")
                    onClicked: {
                        dataGrid.closeEditor()
                        if(rowModel.index<dataModel.count-1){
                            dataModel.move(rowModel.index,rowModel.index+1,1)
                        }
                    }
                }
            }
        }
    }
    Component{
        id: comp_row_action
        Item{
            Button{
                text: qsTr("Delete")
                anchors{
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 10
                }
                highlighted: true
                onClicked: {
                    dataGrid.closeEditor()
                    dataModel.remove(rowModel.index,1)
                }
            }
        }
    }
    Component{
        id: comp_edit_combobox
        ComboBox{
            model: ["20", "30", "40", "60"]
            editable: true
            Component.onCompleted: {
                editText = display
                this.contentItem.forceActiveFocus()
                this.contentItem.selectAll()
            }
            onActiveFocusChanged: {
                if(!activeFocus){
                    dataGrid.closeEditor()
                }
            }
            Keys.onEnterPressed: {
                changeDisplay()
            }
            Keys.onReturnPressed: {
                changeDisplay()
            }
            function changeDisplay(){
                rowModel[columnModel.dataIndex] = editText
                dataGrid.closeEditor()
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

        defaultHeight: 25
        defaultminimumHeight:25
        defaultmaximumHeight:240
        horizonalHeaderHeight:30


        sourceModel: dataModel
        onRowClicked:(model)=>{
                         console.debug(model.baseline_id)
                         Global.focusBaseline=model
                         Global.visable_right_top_side=true
                         Global.displayPropertyPage="/sidepage/property/baseline"
                         Global.update_visable()
                     }
        onRowRightClicked:(model)=>{
                              console.debug(model.baseline_id)
                              Global.displayPropertyPage="/sidepage/property/blank"
                          }
        columnSourceModel: ListModel{
            ListElement{
                title: qsTr("基线ID")
                dataIndex: "baseline_id"
                width: 200
                frozen: true
                delegate: function(){return comp_column_frozen}
            }
            ListElement{
                title: qsTr("基线类型")
                dataIndex: "baseline_type"
                editDelegate: function(){return comp_edit_combobox}
                width: 60
            }
            ListElement{
                title: qsTr("起点")
                dataIndex: "start_file"
                editDelegate: function(){return comp_edit_combobox}
                width: 200
            }
            ListElement{
                title: qsTr("终点")
                dataIndex: "end_file"
                editDelegate: function(){return comp_edit_combobox}
                width: 200
            }
            ListElement{
                title: qsTr("解算类型")
                dataIndex: "solution_type"
                editDelegate: function(){return comp_edit_combobox}
                width: 80
            }
            ListElement{
                title: qsTr("利用率")
                dataIndex: "utilization_percentage"
                editDelegate: function(){return comp_edit_combobox}
                width: 60
            }
            ListElement{
                title: qsTr("同步时间")
                dataIndex: "sync_seconds"
                editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("Ratio")
                dataIndex: "solution_ratio"
                editDelegate: function(){return comp_edit_combobox}
                width: 80
            }
            ListElement{
                title: qsTr("RMS")
                dataIndex: "solution_rms"
                editDelegate: function(){return comp_edit_combobox}
                width: 80
            }
            ListElement{
                title: qsTr("合格")
                dataIndex: "solution_check"
                editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("Dx")
                dataIndex: "solution_dx"
                editDelegate: function(){return comp_edit_combobox}
                width: 110
            }
            ListElement{
                title: qsTr("StdDx")
                dataIndex: "solution_stdx"
                editDelegate: function(){return comp_edit_combobox}
                width: 70
            }
            ListElement{
                title: qsTr("Dy")
                dataIndex: "solution_dy"
                editDelegate: function(){return comp_edit_combobox}
                width: 110
            }
            ListElement{
                title: qsTr("StdDy")
                dataIndex: "solution_stdy"
                editDelegate: function(){return comp_edit_combobox}
                width: 70
            }
            ListElement{
                title: qsTr("Dz")
                dataIndex: "solution_dz"
                editDelegate: function(){return comp_edit_combobox}
                width: 110
            }
            ListElement{
                title: qsTr("StdDz")
                dataIndex: "solution_stdz"
                editDelegate: function(){return comp_edit_combobox}
                width: 70
            }
            ListElement{
                title: qsTr("距离")
                dataIndex: "solution_horizontal_distance"
                editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("使用")
                dataIndex: "baseline_enuse"
                editDelegate: function(){return comp_edit_combobox}
                width: 80
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
}
