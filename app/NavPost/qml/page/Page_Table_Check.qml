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

    DataGridController{
        id: controller
        onLoadDataStart: {
            panel_loading.visible = true
        }
        onLoadDataSuccess: {
            dataModel.sourceData  = controller.data
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
        // Button{
        //     text: qsTr("Clear")
        //     onClicked: {
        //         dataModel.clear()
        //     }
        // }
        // Button{
        //     text: qsTr("Add a row of Data")
        //     onClicked: {
        //         dataModel.append(controller.generateRowData())
        //     }
        // }
        // Button{
        //     text: qsTr("Insert a Row")
        //     onClicked: {
        //         if(dataGrid.view.currentIndex < 0){
        //             infoBarManager.showWarning(qsTr("Focus not acquired: Please click any item in the form as the target for insertion!"))
        //             return
        //         }
        //         dataModel.insert(dataGrid.view.currentIndex+1,controller.generateRowData())
        //     }
        // }
        // Button{
        //     text: qsTr("Deletes the selected row of data")
        //     onClicked: {
        //         var checkedItems = dataGrid.selectionModel.selectedIndexes
        //         if(checkedItems.length === 0){
        //             infoBarManager.showWarning(qsTr("Please select a row of data first!"))
        //             return
        //         }
        //         dataModel.removeItems(checkedItems)
        //     }
        // }
        // Button{
        //     text: qsTr("Modify the first row of data")
        //     onClicked: {
        //         dataModel.set(0,controller.generateRowData())
        //     }
        // }
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
                         console.debug(model.name)
                         Global.visable_right_top_side=true
                         Global.displayPropertyPage="/sidepage/property/obsfile"
                         Global.update_visable()
                     }
        onRowRightClicked:(model)=>{
                              console.debug(model.name)
                              Global.displayPropertyPage="/sidepage/property/blank"
                          }
        columnSourceModel: ListModel{
            ListElement{
                title: qsTr("文件名")
                dataIndex: "name"
                width: 100
                frozen: true
                delegate: function(){return comp_column_frozen}
            }
            ListElement{
                title: qsTr("测站")
                dataIndex: "age"
                editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("开始时间")
                dataIndex: "age"
                editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("结束时间")
                dataIndex: "age"
                editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("检核")
                dataIndex: "age"
                editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("利用率")
                dataIndex: "age"
                editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("MP1(L1/B1/G1/E1)")
                dataIndex: "age"
                editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("MP2(L2/B2/G2/E5a)")
                dataIndex: "age"
                editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("MP3(L5/B3/G3/E5b)")
                dataIndex: "age"
                editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("MP4(E5)")
                dataIndex: "age"
                editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("MP5(E6)")
                dataIndex: "age"
                editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("nSlip
")
                dataIndex: "age"
                editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("SNR(L1/B1/G1/E1)")
                dataIndex: "age"
                editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("SNR(L2/B2/G2/E5a)")
                dataIndex: "age"
                editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("SNR(L5/B3/G3/E5b)")
                dataIndex: "age"
                editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("SNR(E5)")
                dataIndex: "age"
                editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("SNR(E6)")
                dataIndex: "age"
                editDelegate: function(){return comp_edit_combobox}
                width: 100
            }
            ListElement{
                title: qsTr("Action")
                dataIndex: "action"
                width: 100
                frozen: true
                rowDelegate: function(){return comp_row_action}
                delegate: function(){return comp_column_frozen}
            }
        }
    }
    Component.onCompleted: {
        controller.loadData(5)
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
