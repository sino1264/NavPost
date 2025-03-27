import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import FluentUI.Controls
import FluentUI.impl
import NavPost

ContentPage {


    Item{

        id:header
        width:parent.width
        height:120

        clip:true

        ListModel{
            id: tab_model
            ListElement{
                title: "First"
                accentColor: function(){
                    return colors[Math.floor(Math.random() * 8)]
                }
            }
            ListElement{
                title: "Second"
                accentColor: function(){
                    return colors[Math.floor(Math.random() * 8)]
                }
            }
            ListElement{
                title: "Third"
                accentColor: function(){
                    return colors[Math.floor(Math.random() * 8)]
                }
            }
            ListElement{
                title: "Fourth"
                accentColor: function(){
                    return colors[Math.floor(Math.random() * 8)]
                }
            }
        }

        TabBar {
            id: bar
            width: parent.width
            clip: true
            Repeater {
                model: tab_model
                TabButton {
                    id: btn_tab
                    text: model.title
                    font:Typography.body
                }
            }
        }

        Component{
            id:comp_page
            Frame{
                anchors.fill: parent
                Label{
                    font: Typography.titleLarge
                    anchors.centerIn: parent
                    text: modelData.title
                    color: modelData.accentColor().normal
                }
            }
        }

        StackLayout {
            currentIndex: bar.currentIndex
            anchors{
                left: parent.left
                right: bar.right
                top: bar.bottom
                bottom: parent.bottom
                topMargin: 0
            }
            Repeater{
                model:tab_model
                AutoLoader{
                    property var modelData: model
                    sourceComponent: comp_page
                }
            }
        }


    }


    Item{
        id:body
        anchors{
            top:header.bottom
            bottom:footer.top
        }
        width:parent.width

        SplitView {
            id:split_layout
            anchors.fill: parent
            anchors.topMargin: 60
            orientation: Qt.Horizontal
            Item {
                clip: true
                implicitWidth: 200
                implicitHeight: 200
                // SplitView.maximumWidth: 400
                // SplitView.maximumHeight: 400

                SplitView {
                    id:split_layout1
                    anchors.fill: parent
                    anchors.topMargin: 60
                    orientation: Qt.Vertical
                    Item {
                        clip: true
                        implicitWidth: 200
                        implicitHeight: 200
                        // SplitView.maximumWidth: 400
                        // SplitView.maximumHeight: 400

                    }
                    Item {
                        clip: true

                        visible:true

                        // SplitView.minimumWidth: 50
                        // SplitView.minimumHeight: 50
                        SplitView.fillWidth: true
                        SplitView.fillHeight: true
                    }
                }


            }
            Item {
                clip: true
                id: centerItem
                // SplitView.minimumWidth: 50
                // SplitView.minimumHeight: 50
                SplitView.fillWidth: true
                SplitView.fillHeight: true
                SplitView {
                    id:split_layout2
                    anchors.fill: parent
                    anchors.topMargin: 60
                    orientation: Qt.Vertical
                    Item {
                        clip: true
                        implicitWidth:500
                        implicitHeight: 400
                        // SplitView.maximumWidth: 400
                        // SplitView.maximumHeight: 400

                    }
                    Item {
                        clip: true
                        // SplitView.minimumWidth: 50
                        // SplitView.minimumHeight: 50
                        SplitView.fillWidth: true
                        SplitView.fillHeight: true
                    }
                }
            }
            Item {
                clip: true
                implicitWidth: 200
                implicitHeight: 200
                SplitView {
                    id:split_layout3
                    anchors.fill: parent
                    anchors.topMargin: 60
                    orientation: Qt.Vertical
                    Item {
                        clip: true
                        implicitWidth: 200
                        implicitHeight: 200
                        // SplitView.maximumWidth: 400
                        // SplitView.maximumHeight: 400

                    }
                    Item {
                        clip: true
                        // SplitView.minimumWidth: 50
                        // SplitView.minimumHeight: 50
                        SplitView.fillWidth: true
                        SplitView.fillHeight: true
                    }
                }
            }
        }

    }


    Item{
        id:footer

        anchors{
            bottom:parent.bottom
        }
        width:parent.width
        height:30

        Frame{
            anchors.fill:parent
        }
    }

}
