import QtQuick
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick.Controls
import FluentUI.Controls
import FluentUI.impl
import NavPost

Item{
    id:root

    property string title
    property PageContext context

    property int default_height:28
    property int default_label_width:60

    // property alias name:station_name_textbox.text

    //站点基本信息 名称、是否禁用
    property alias station_name:station_name_textbox.text
    property alias is_disabled:is_disabled_checkbox.checked

    //站点页面属性(只有静态才需要填充和设置，动态统一设置为0）
    property bool is_dynamic:false
    property string coord_profile
    property double coord_lat
    property double coord_lon
    property double coord_height
    property int coord_datum
    property double coord_epoch

    //站点天线信息
    property string antenna_profile
    property double measured_height
    property double offset_ARP_to_L1
    property double applied_height
    property double ant_corr0
    property double ant_corr1
    property double ant_corr2
    property double ant_corr3


    // Binding {root.station_name: station_name_textbox.text}

    // Binding {
    //     target: this
    //     property: station_name
    //     value:  station_name_textbox.text
    //     bidirectional: true
    // }

    //获取所有的站点名称，可以根据站点名称查询所有的站点信息，以及编辑站点信息

    //如果是静态站，那还需要获取站点不同处理的坐标



    Component.onCompleted: {
        contentDialog.open()
    }

    //导入文件配置的Dialog  用来配置导入文件的详细选项
    Dialog {
        id: contentDialog
        x: Math.ceil((parent.width - width) / 2)
        y: Math.ceil((parent.height - height) / 2)
        width: 550//Math.ceil(parent.width / 2)
        // contentHeight: 400
        parent: Overlay.overlay
        modal: true
        title: qsTr("编辑站点")
        standardButtons: Dialog.Ok | Dialog.Cancel

        Column{
            anchors.horizontalCenter: parent.horizontalCenter

            Frame{
                width:500
                height:590
                Column{
                    spacing: 5
                    anchors.horizontalCenter: parent.horizontalCenter

                    Item{
                        width:500
                        height:60

                        Column{
                            anchors.horizontalCenter:parent.horizontalCenter
                            spacing:5
                            Label{
                                text: qsTr("站点信息")
                            }

                            Row{
                                spacing:5
                                ComboBox{
                                    width:180
                                    height:default_height
                                    model: ["选择要编辑的站点","station1","station2"]
                                    // enabled:false
                                }
                                Label{
                                    text: qsTr("站点名称:")
                                    anchors.verticalCenter:parent.verticalCenter
                                }
                                TextBox{
                                    id:station_name_textbox
                                    height:default_height
                                    width:140
                                }
                                CheckBox {
                                    id:is_disabled_checkbox
                                    text:  qsTr("禁用站点")
                                    checked: false
                                }
                            }
                        }
                    }

                    Frame{
                        width:500
                        height:60

                        Column{
                            anchors.horizontalCenter:parent.horizontalCenter
                            spacing:5
                            Label{
                                text: qsTr("站点类型：")
                            }
                            Row{
                                spacing:5
                                SegmentedControl {
                                    id: bar
                                    clip: true
                                    Repeater {
                                        model:ListModel{
                                            id: tab_model
                                            ListElement{
                                                title: qsTr("静态站点")
                                                dynamic:false
                                            }
                                            ListElement{
                                                title:  qsTr("动态站点")
                                                dynamic:false
                                            }
                                        }
                                        SegmentedButton {
                                            id: btn_tab
                                            width:240
                                            text: model.title
                                        }
                                    }
                                    onCurrentIndexChanged: {
                                        is_dynamic=currentIndex
                                    }
                                }
                            }
                        }
                    }

                    Frame{
                        width: 500
                        height: 230

                        visible:!is_dynamic

                        Column{
                            anchors.horizontalCenter:parent.horizontalCenter
                            spacing:5
                            Row{
                                Label{
                                    text: qsTr("坐标信息")
                                }
                            }

                            Row{
                                spacing:5
                                Label{
                                    text: qsTr("坐标来源:")
                                    width:default_label_width
                                    anchors.verticalCenter:parent.verticalCenter
                                }

                                ComboBox{
                                    // id:coord_profile
                                    width:370
                                    height:default_height
                                    model: ["手动设置",
                                            "解析坐标：文件[HBJM01202412020000.rtcm3]",
                                            "单点定位：文件[HBJM01202412020000.rtcm3]",
                                            "平差坐标：秩亏自由网平差",
                                            "平差坐标：约束平差（参考点[HBJM01]）",
                                            "保存坐标：XXXXX（坐标备注）"]
                                    // enabled:false
                                }

                                Button{
                                    text:qsTr("...")

                                    ToolTip.visible: hovered
                                    ToolTip.delay: 500
                                    ToolTip.text: qsTr("查看和编辑已存储的站点坐标")
                                }
                            }

                            Row{
                                spacing:5
                                Label{
                                    text:qsTr("纬度：")
                                    width:default_label_width
                                    anchors.verticalCenter:parent.verticalCenter
                                    //horizontalAlignment: Text.AlignRight
                                }
                                ComboBox{
                                    width:80
                                    height:default_height
                                    model: ["北纬", "南纬"]
                                }
                                TextBox{
                                    height:default_height
                                    width:40
                                    placeholderText:"00"
                                }
                                Label{
                                    text: "°"
                                }
                                TextBox{
                                    height:default_height
                                    width:40
                                    placeholderText:"00"
                                }
                                Label{
                                    text: "′"
                                }
                                TextBox{
                                    height:default_height
                                    width:100

                                    placeholderText:"00.000000"
                                }
                                Label{
                                    text: "″"
                                }

                                Button{
                                    text:qsTr("坐标配置选项")

                                    onClicked:{
                                        set_coord_menu.popup()
                                    }


                                    Menu {
                                        id:set_coord_menu
                                        width: 150
                                        title: qsTr("配置坐标")
                                        MenuItem{
                                            text: qsTr("输入其他坐标系坐标")
                                            onTriggered: {
                                                // Global.open_dialog("/dialog/station/add_new")
                                            }
                                        }
                                        MenuItem{
                                            text: qsTr("从已保存坐标点中选取")
                                            onTriggered: {
                                                // Global.open_dialog("/dialog/station/add_new")
                                            }
                                        }
                                    }
                                }
                            }
                            Row{
                                spacing:5
                                Label{
                                    text: qsTr("经度：")
                                    width:default_label_width
                                    anchors.verticalCenter:parent.verticalCenter
                                }
                                ComboBox{
                                    width:80
                                    height:default_height
                                    model: ["东经", "西经"]
                                }
                                TextBox{
                                    height:default_height
                                    width:40
                                    placeholderText:"00"
                                }
                                Label{
                                    text: "°"
                                }
                                TextBox{
                                    height:default_height
                                    width:40
                                    placeholderText:"00"
                                }
                                Label{
                                    text: "′"
                                }
                                TextBox{
                                    height:default_height
                                    width:100
                                    placeholderText:"00.000000"
                                }
                                Label{
                                    text: "″"
                                }

                                Button{
                                    text:qsTr("保存站点坐标")
                                }
                            }

                            Row{
                                spacing:5
                                Label{
                                    text:qsTr("椭球高:") //Ellipsoidal Height
                                    width:default_label_width
                                    anchors.verticalCenter:parent.verticalCenter
                                }
                                Item {
                                    height:1
                                    width: 80 // 设置这两个元素之间的间距
                                }
                                TextBox{
                                    height:default_height
                                    width:100
                                    placeholderText:"0.0000"
                                }
                                Label{
                                    text: "m"
                                    anchors.verticalCenter:parent.verticalCenter
                                }
                            }

                            Row{
                                spacing:5
                                Label{
                                    text:qsTr("坐标框架:")
                                    width:default_label_width
                                    anchors.verticalCenter:parent.verticalCenter
                                }

                                ComboBox{
                                    width:185
                                    height:default_height
                                    model: ["WGS84", "CGCS2000", "ITRF2014"]
                                }

                                Label{
                                    text:qsTr(" 处理框架:")
                                    // width:default_label_width
                                    anchors.verticalCenter:parent.verticalCenter
                                }
                                TextBox{
                                    height:default_height
                                    width:150
                                    placeholderText:"WGS84"
                                    enabled:false
                                }
                            }

                            Row{
                                spacing:5
                                Label{
                                    text:qsTr("历元:")
                                    width:default_label_width
                                    anchors.verticalCenter:parent.verticalCenter
                                }
                                TextBox{
                                    height:default_height
                                    width:75
                                    placeholderText:"2025"
                                }
                                Label{
                                    text:qsTr("年")
                                    // width:default_label_width
                                    anchors.verticalCenter:parent.verticalCenter
                                }

                                CalendarPicker {
                                    height:default_height
                                }
                            }
                        }
                    }

                    Frame{
                        width: 500
                        height: 100

                        Column{
                            anchors.horizontalCenter:parent.horizontalCenter
                            spacing:5
                            Row{
                                Label{
                                    text: qsTr("天线信息")
                                }
                            }

                            Row{
                                spacing:5
                                Label{
                                    text: qsTr("天线文件:")
                                    width:default_label_width
                                    anchors.verticalCenter:parent.verticalCenter
                                }
                                TextBox{
                                    height:default_height
                                    width:310
                                    placeholderText:"N/A"
                                    enabled:false
                                }

                                Button{
                                    text:qsTr("选择天线文件")
                                    // enabled:false
                                }
                            }

                            Row{
                                spacing:5
                                Label{
                                    text:qsTr("天线类型:")
                                    width:default_label_width
                                    anchors.verticalCenter:parent.verticalCenter
                                }

                                ComboBox{
                                    width:310
                                    height:default_height
                                    model: ["Generic"]
                                }

                                Button{
                                    width:95
                                    text:qsTr("天线信息")
                                    enabled:false
                                }
                            }
                        }
                    }

                    Frame{
                        width: 500
                        height: 120

                        Column{
                            anchors.horizontalCenter:parent.horizontalCenter
                            spacing:5
                            anchors.verticalCenter:parent.verticalCenter

                            Row{
                                spacing:5
                                Label{
                                    text:qsTr("天线测量高:")
                                    width:default_label_width
                                    anchors.verticalCenter:parent.verticalCenter
                                }
                                Item {
                                    height:1
                                    width: 80 // 设置这两个元素之间的间距
                                }
                                TextBox{
                                    height:default_height
                                    width:100
                                    placeholderText:"0.000"
                                }
                                Label{
                                    text: "m"
                                    anchors.verticalCenter:parent.verticalCenter
                                }
                                Item {
                                    height:1
                                    width: 200 // 设置这两个元素之间的间距
                                }
                            }
                            Row{
                                spacing:5
                                Label{
                                    text:qsTr("ARP到L1相位中心偏移:")
                                    width:default_label_width
                                    anchors.verticalCenter:parent.verticalCenter
                                }
                                Item {
                                    height:1
                                    width: 80 // 设置这两个元素之间的间距
                                }
                                TextBox{
                                    height:default_height
                                    width:100
                                    enabled:false
                                    placeholderText:"0.000"
                                }
                                Label{
                                    text: "m"
                                    anchors.verticalCenter:parent.verticalCenter
                                }
                            }
                            Row{
                                spacing:5
                                Label{
                                    text:qsTr("改正天线高:")
                                    width:default_label_width
                                    anchors.verticalCenter:parent.verticalCenter
                                }
                                Item {
                                    height:1
                                    width: 80 // 设置这两个元素之间的间距
                                }
                                TextBox{
                                    height:default_height
                                    width:100
                                    enabled:false
                                    placeholderText:"0.000"
                                }
                                Label{
                                    text: "m"
                                    anchors.verticalCenter:parent.verticalCenter
                                }
                            }
                        }

                        Frame{
                            anchors{
                                right:parent.right
                                // bottom:parent.bottom
                            }
                            width: 160
                            height: 120


                            Column{
                                spacing:5
                                Label{
                                    text: "测量归算点"
                                    // anchors.verticalCenter:parent.verticalCenter
                                }

                                ButtonGroup {
                                    buttons: column.children
                                }
                                Column {
                                    id: column
                                    RadioButton {
                                        height:default_height
                                        checked: true
                                        text: qsTr("ARP")
                                    }
                                    RadioButton {
                                        height:default_height
                                        text: qsTr("L1相位中心")
                                    }
                                }
                                Button{
                                    text:qsTr("倾斜测量高度计算")
                                }
                            }
                        }

                    }
                }
            }
        }

        onAccepted:{

            var ecef_x=0.0;
            var ecef_y=0.0;
            var ecef_z=0.0;

            var UID=NavPost.generate_UniqueKey()
            var item={
                UID:UID,
                station_name: root.station_name,

                is_disabled: root.is_disabled,
                is_dynamic: root.is_dynamic,

                coord_profile: root.coord_profile,
                ecef_x: ecef_x,
                ecef_y: ecef_y,
                ecef_z: ecef_z,
                datum:root.coord_datum,
                epoch:root.coord_epoch,

                antenna_profile: root.antenna_profile,
                measured_height: root.measured_height,
                offset_ARP_to_L1: root.offset_ARP_to_L1,
                applied_height: root.applied_height,
                ant_corr0: root.ant_corr0,
                ant_corr1: root.ant_corr1,
                ant_corr2: root.ant_corr2,
                ant_corr3: root.ant_corr3
            }


            console.log("Add Station:\n",JSON.stringify(item, null, 2));

            NavPost.add_Station(item)

        }

    }


}
