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
                text:qsTr("目标属性栏")
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


        Item{
            anchors.fill: parent
            anchors.topMargin: 30

            PageRouter{
                id: property_router
                routes: {
                    "/sidepage/property/blank": R.resolvedUrl("qml/component/SidePage_Blank.qml"),
                    "/sidepage/property/obsfile":  {url:R.resolvedUrl("qml/component/SidePage_Property_Obsfile.qml"),singleton:true},
                    "/sidepage/property/baseline":  {url:R.resolvedUrl("qml/component/SidePage_Property_Baseline.qml"),singleton:true},
                    "/sidepage/property/station":  {url:R.resolvedUrl("qml/component/SidePage_Property_Station.qml"),singleton:true}
                }
            }

            PageRouterView{
                id: property_panne
                anchors.fill: parent
                router: property_router
                clip: true

                Component.onCompleted: {
                    property_router.go(Global.displayPropertyPage)
                }
            }

            Connections{
                target:Global
                function onDisplayPropertyPageChanged(){
                    property_router.go(Global.displayPropertyPage)
                }
            }
        }
    }

}
