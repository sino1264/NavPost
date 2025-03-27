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

    property int depthPadding: 15
    property var current

    anchors.fill:parent
    GroupBox{
        id:function_box
        anchors.fill: parent
        padding: 5
        Item{
            width: parent.width
            height: 30
            Label{
                anchors{
                    left: parent.left
                    leftMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                text:qsTr("资源管理栏")
                font:Qt.font({pixelSize : 14, weight: Font.Bold})
            }

            IconButton{
                anchors{
                    right: parent.right
                    rightMargin: 10
                    verticalCenter: parent.verticalCenter
                }
                icon.source: FluentIcons.graph_Pin
                icon.width: 15
                icon.height: 15
            }
        }


        Frame{
            anchors.fill: parent
            anchors.topMargin: 30

            FileTreeDataController{
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
                id: comp_row_key
                Item{
                    id: item_layout
                    property var __display: display
                    property bool chekced:  {
                        if(!root.current){
                            return false
                        }
                        return __display === root.current
                    }
                    ListTile{
                        anchors.fill: parent
                        text: String(__display)
                        leftPadding: 6 + rowModel.depth * root.depthPadding
                        highlighted: item_layout.chekced
                        spacing: 0
                        leading: Row{
                            spacing: 0
                            IconButton{
                                opacity: rowModel.hasChildren
                                enabled: opacity
                                icon.name: FluentIcons.graph_ChevronDown
                                width: 20
                                height: 20
                                icon.width: 12
                                icon.height: 12
                                padding: 0
                                anchors{
                                    verticalCenter: parent.verticalCenter
                                }
                                contentItem.rotation: rowModel.expanded ? 0 : -90
                                onClicked: {
                                    item_layout.toggle()
                                }
                            }
                            Item{
                                width: 4
                                height: parent.height
                            }
                            Image{
                                width: 24
                                height: 24
                                source: rowModel.hasChildren ? "qrc:/qt/qml/NavPost/res/image/ic_folder.png" : "qrc:/qt/qml/NavPost/res/image/ic_file_text.png"
                                anchors{
                                    verticalCenter: parent.verticalCenter
                                }
                            }
                            Item{
                                width: 10
                                height: parent.height
                            }
                        }
                        onDoubleClicked: {
                            if(rowModel.hasChildren){
                                item_layout.toggle()
                            }
                        }
                        onClicked: {
                            root.current = __display
                        }
                        Rectangle{
                            height: 18
                            radius: 1.5
                            width: 3
                            visible: item_layout.chekced
                            color: Theme.accentColor.defaultBrushFor()
                            anchors{
                                verticalCenter: parent.verticalCenter
                                left: parent.left
                            }
                        }
                    }

                    clip: true
                    function toggle(){
                        if(rowModel.expanded){
                            dataModel.collapse(rowModel.index)
                        }else{
                            dataModel.expand(rowModel.index)
                        }
                    }
                }
            }
            TreeDataGridModel{
                id: dataModel
            }
            TreeDataGrid{
                id: dataGrid
                anchors{
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                    right:parent.right
                    bottomMargin: 10
                }
                verticalHeaderVisible: false
                horizonalHeaderVisible: false
                width: 240
                sourceModel: dataModel
                columnSourceModel: ListModel{
                    ListElement{
                        title: qsTr("Key")
                        dataIndex: "key"
                        width: 240
                        frozen: false
                        rowDelegate: function(){return comp_row_key}
                    }
                }
                cellBackground: Item{}
                cellForeground: Item{}
            }
            Component.onCompleted: {
                controller.loadData()
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
    }
}


