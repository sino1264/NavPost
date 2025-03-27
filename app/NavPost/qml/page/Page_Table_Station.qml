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
        function onUpdateStationDataStart(){
            panel_loading.visible = true
        }
        function onUpdateStationDataSuccess(){
            dataModel.sourceData  = ResourceDataController.station_data
            panel_loading.visible = false
        }
    }

    Component.onCompleted: {
        // ResourceDataController.load_Data()
        ResourceDataController.updateStationData()
    }

    Component{
        id:comp_common
        Item{
            Label{
                text: String(display)
                elide: Label.ElideRight
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors{
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 10
                    right: parent.right
                    rightMargin: 10
                }
            }
        }
    }

    Component{
        id:comp_lat2dms
        Item{
            Label{
                text: toDMS(display)
                elide: Label.ElideRight
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors{
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 10
                    right: parent.right
                    rightMargin: 10
                }

                function toDMS(degrees) {
                    // 判断正负，决定南北纬
                    let isPositive = degrees >= 0;
                    let direction = isPositive ? "N" : "S"; // 正数是北纬，负数是南纬

                    // 获取度数的绝对值（度数部分始终为正数）
                    let d = Math.abs(Math.floor(degrees));  // 取绝对值，避免负号影响后续显示

                    // 获取分数部分
                    let remainder = (Math.abs(degrees) - d) * 60;
                    let m = Math.floor(remainder);

                    // 获取秒数部分的小数部分
                    let sTotal = (remainder - m) * 60;
                    let sInteger = Math.floor(sTotal);  // 秒数的整数部分
                    let sDecimal = (sTotal - sInteger).toFixed(5).slice(1); // 秒数的小数部分，保留 5 位小数

                    // 确保秒数的整数部分总是两位，且小数部分保留五位
                    let sIntegerStr = sInteger.toString().padStart(2, '0');

                    // 补充空格：确保度数部分为三位数
                    let degreeStr = d.toString().padStart(3, ' ');

                    // 返回度分秒格式，加入南北纬信息
                    return `${degreeStr}° ${m.toString().padStart(2, '0')}' ${sIntegerStr}${sDecimal}" ${direction}`;
                }
            }
        }
    }

    Component{
        id:comp_lon2dms
        Item{
            Label{
                text: toDMS(display)
                elide: Label.ElideRight
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors{
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 10
                    right: parent.right
                    rightMargin: 10
                }

                function toDMS(degrees) {
                    // 判断正负，决定东西经
                    let isPositive = degrees >= 0;
                    let direction = isPositive ? "E" : "W"; // 正数是东经，负数是西经

                    // 获取度数的绝对值（度数部分始终为正数）
                    let d = Math.abs(Math.floor(degrees));  // 取绝对值，避免负号影响后续显示

                    // 获取分数部分
                    let remainder = (Math.abs(degrees) - d) * 60;
                    let m = Math.floor(remainder);

                    // 获取秒数部分的小数部分
                    let sTotal = (remainder - m) * 60;
                    let sInteger = Math.floor(sTotal);  // 秒数的整数部分
                    let sDecimal = (sTotal - sInteger).toFixed(5).slice(1); // 秒数的小数部分，保留 5 位小数

                    // 确保秒数的整数部分总是两位，且小数部分保留五位
                    let sIntegerStr = sInteger.toString().padStart(2, '0');

                    // 补充空格：确保度数部分为三位数
                    let degreeStr = d.toString().padStart(3, ' ');

                    // 返回度分秒格式，加入南北纬信息
                    return `${degreeStr}° ${m.toString().padStart(2, '0')}' ${sIntegerStr}${sDecimal}" ${direction}`;
                }
            }
        }
    }


    Component{
        id:comp_degree2dms
        Item{
            Label{
                text: toDMS(display)
                elide: Label.ElideRight
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors{
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 10
                    right: parent.right
                    rightMargin: 10
                }

                function toDMS(degrees) {
                    // 获取度数的整数部分
                    let d = Math.floor(degrees);

                    // 获取分数部分
                    let remainder = (degrees - d) * 60;
                    let m = Math.floor(remainder);

                    // 获取秒数部分的小数部分
                    let sTotal = (remainder - m) * 60;
                    let sInteger = Math.floor(sTotal);  // 秒数的整数部分
                    let sDecimal = (sTotal - sInteger).toFixed(5).slice(1); // 秒数的小数部分，保留 5 位小数

                    // 确保秒数的整数部分总是两位，且小数部分保留五位
                    let sIntegerStr = sInteger.toString().padStart(2, '0');

                    // 补充空格：确保度数部分为三位数
                    let degreeStr = d.toString().padStart(3, ' ');

                    // 返回度分秒格式
                    return `${degreeStr}° ${m.toString().padStart(2, '0')}' ${sIntegerStr}${sDecimal}"`;
                }

            }
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

        defaultHeight: 30
        defaultminimumHeight:25
        defaultmaximumHeight:240
        horizonalHeaderHeight:30


        sourceModel: dataModel
        onRowClicked:(model)=>{
                        console.debug(model.station_name)
                        Global.focusStation=model
                        Global.visable_right_top_side=true
                        Global.displayPropertyPage="/sidepage/property/station"
                        Global.update_visable()
                     }
        onRowRightClicked:(model)=>{
                              console.debug(model.station_name)
                              // Global.displayPropertyPage="/sidepage/property/blank"

                                operate_item_menu.popup()
                          }

        Menu {
            id:operate_item_menu
            width: 150
            title: qsTr("操作站点")

            MenuItem{
                text: qsTr("设置为控制点")
                onTriggered: {
                    // Global.open_dialog("/dialog/station/add_new")
                }
            }

             MenuSeparator { }
             MenuItem{
                 text: qsTr("编辑")
                 onTriggered: {
                      Global.open_dialog("/dialog/station/edit_property")
                 }
             }
             MenuItem{
                 text: qsTr("禁用")
                 onTriggered: {
                     // Global.open_dialog("/dialog/station/add_new")
                 }
             }
             MenuItem{
                 text: qsTr("删除")
                 onTriggered: {
                     // Global.open_dialog("/dialog/station/add_new")
                 }
             }
        }



        columnSourceModel: ListModel{
            ListElement{
                title: qsTr("站点名")
                dataIndex: "station_name"
                width: 100
                frozen: true
                delegate: function(){return comp_column_frozen}
                rowDelegate: function(){return comp_common}
            }
            ListElement{
                title: qsTr("北坐标(m)")
                dataIndex: "utm_n"
                width: 120
                delegate: function(){return comp_column_frozen}
                rowDelegate: function(){return comp_common}

            }
            ListElement{
                title: qsTr("东坐标(m)")
                dataIndex: "utm_e"
                delegate: function(){return comp_column_frozen}
                rowDelegate: function(){return comp_common}
                width: 120
            }
            ListElement{
                title: qsTr("高程(m)")
                dataIndex: "utm_u"
                delegate: function(){return comp_column_frozen}
                rowDelegate: function(){return comp_common}
                width: 100
            }
            ListElement{
                title: qsTr("当地经度")
                dataIndex: "llh_lon"
                delegate: function(){return comp_column_frozen}
                rowDelegate: function(){return comp_lon2dms}
                width: 150
            }
            ListElement{
                title: qsTr("当地纬度")
                dataIndex: "llh_lat"
                delegate: function(){return comp_column_frozen}
                rowDelegate: function(){return comp_lat2dms}
                width: 150
            }
            ListElement{
                title: qsTr("大地高(m)")
                dataIndex: "llh_height"
                delegate: function(){return comp_column_frozen}
                rowDelegate: function(){return comp_common}
                width: 100
            }
            ListElement{
                title: qsTr("X(m)")
                dataIndex: "ecef_x"
                delegate: function(){return comp_column_frozen}
                rowDelegate: function(){return comp_common}
                width: 120
            }
            ListElement{
                title: qsTr("Y(m)")
                dataIndex: "ecef_y"
                delegate: function(){return comp_column_frozen}
                rowDelegate: function(){return comp_common}
                width: 120
            }
            ListElement{
                title: qsTr("Z(m)")
                dataIndex: "ecef_z"
                delegate: function(){return comp_column_frozen}
                rowDelegate: function(){return comp_common}
                width: 120
            }
            ListElement{
                title: qsTr("经度")
                dataIndex: "llh_lon"
                delegate: function(){return comp_column_frozen}
                rowDelegate: function(){return comp_lon2dms}
                width: 150
            }
            ListElement{
                title: qsTr("纬度")
                dataIndex: "llh_lat"
                delegate: function(){return comp_column_frozen}
                rowDelegate: function(){return comp_lat2dms}
                width: 150
            }
            ListElement{
                title: qsTr("高程(m)")
                dataIndex: "llh_height"
                delegate: function(){return comp_column_frozen}
                rowDelegate: function(){return comp_common}
                width: 100
            }
            // ListElement{
            //     title: qsTr("Action")
            //     dataIndex: "action"
            //     width: 100
            //     frozen: true
            //     rowDelegate: function(){return comp_row_action}
            //     delegate: function(){return comp_column_frozen}
            // }
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
