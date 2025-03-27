import QtQuick
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick.Controls
import FluentUI.Controls
import FluentUI.impl
import NavPost

Item{
    property string title
    property PageContext context


    Component.onCompleted: {
        contentDialog.open()
    }

    //导入文件配置的Dialog  用来配置导入文件的详细选项
    Dialog {
        id: contentDialog
        x: Math.ceil((parent.width - width) / 2)
        y: Math.ceil((parent.height - height) / 2)
        width: 1000//Math.ceil(parent.width / 2)
        // contentHeight: 400
        parent: Overlay.overlay
        modal: true
        title: qsTr("新建静态处理任务")
        standardButtons: Dialog.Ok | Dialog.Cancel

        Column{
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter
            Row{
                Label{
                    text: qsTr("选择要处理的站点（静态站点下拉框）")
                }
            }
            Row{
                Label{
                    text: qsTr("选择要处理的站点的观测文件（选中的站点的观测文件下拉框）")
                }
            }
            Row{
                Label{
                    text: qsTr("↓ 下一项↓")
                }
            }
            Row{
                Label{
                    text: qsTr("选择处理模式")
                }
            }
            Row{
                Label{
                    text: qsTr("选择要使用的星历（与文件导入时候选中的星历一致）")
                }
            }

            Row{
                Label{
                    text: qsTr("配置使用频点：")
                }
            }


            Row{

                spacing: 15

                Column{

                    Label{
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "GPS"
                    }

                    ListView{
                        width: 60
                        height: 300
                        model: gps_model
                        // orientation: Qt.Horizontal
                        delegate:freq_delegate
                    }
                }

                Column{
                    Label{
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "GLO"
                    }

                    ListView{
                        width: 60
                        height: 300
                        model: glo_model
                        // orientation: Qt.Horizontal
                        delegate:freq_delegate
                    }
                }
                Column{
                    Label{
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "GAL"
                    }

                    ListView{
                        width: 60
                        height: 300
                        model: gal_model
                        // orientation: Qt.Horizontal
                        delegate:freq_delegate
                    }
                }

                Column{
                    Label{
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "QZS"
                    }

                    ListView{
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 60
                        height: 300
                        model: qzs_model
                        // orientation: Qt.Horizontal
                        delegate:freq_delegate
                    }
                }

                Column{
                    Label{
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "BDS-2"
                    }

                    ListView{
                        width: 60
                        height: 300
                        model: bd2_model
                        // orientation: Qt.Horizontal
                        delegate:freq_delegate
                    }
                }

                Column{
                    Label{
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "BDS-3"
                    }

                    ListView{
                        width: 60
                        height: 300
                        model: bd3_model
                        // orientation: Qt.Horizontal
                        delegate:freq_delegate
                    }
                }

                Column{
                    Label{
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "NavIC"
                    }

                    ListView{
                        width: 60
                        height: 300
                        model: irn_model
                        // orientation: Qt.Horizontal
                        delegate:freq_delegate
                    }
                }

                Column{
                    Label{
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "SBAS"
                    }

                    ListView{
                        width: 60
                        height: 300
                        model: sbas_model
                        // orientation: Qt.Horizontal
                        delegate:freq_delegate
                    }
                }


                Column{
                    Label{
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "XW"
                    }

                    ListView{
                        width: 60
                        height: 300
                        model: xw_model
                        // orientation: Qt.Horizontal
                        delegate:freq_delegate
                    }
                }


            }

        }
    }


    Component{
        id:freq_delegate
        CheckBox{
            text: model.band
            ToolTip.visible: hovered
            ToolTip.delay: 500
            ToolTip.text: "Freq:" + model.freq +" MHz\n"
                        + "Code:" + model.ch
        }
    }

    ListModel{
        id:gps_model
        ListElement{  band: "L1";      freq: "1575.42";    obs: 1;     ch: "1C/1S/1L/1X/1P/1W/1Y/1M/1N" }
        ListElement{  band: "L2";      freq: "1227.60";    obs: 2;     ch: "2C/2D/2S/2L/2X/2P/2W/2Y/2M/2N" }
        ListElement{  band: "L5";      freq: "1176.45";    obs: 5;     ch: "5I/5Q/5X"  }
    }
    ListModel{
        id:glo_model
        ListElement{  band: "G1";      freq: "1602";       obs: 21;    ch: "1C/1P"  }
        ListElement{  band: "G1a";     freq: "1600.995";   obs: 24;    ch: "4A/4B/4X"  }
        ListElement{  band: "G2";      freq: "1246";       obs: 22;    ch: "2C/2P"  }
        ListElement{  band: "G2a";     freq: "1248.06";    obs: 26;    ch: "6A/6B/6X"  }
        ListElement{  band: "G3";      freq: "1202.025";   obs: 23;    ch: "3I/3Q/3X"  }
    }
    ListModel{
        id:gal_model
        ListElement{  band: "E1";      freq: "1575.42";    obs: 1;     ch: "1A/1B/1C/1X/1Z"  }
        ListElement{  band: "E5a";     freq: "1176.45";    obs: 5;     ch: "5I/5Q/5X"   }
        ListElement{  band: "E5b";     freq: "1207.140";   obs: 7;     ch: "7I/7Q/7X"  }
        ListElement{  band: "E5(a+b)"; freq: "1191.795";   obs: 8;     ch: "8I/8Q/8X"  }
        ListElement{  band: "E6";      freq: "1278.75";    obs: 6;     ch: "6A/6B/6C/6X/6Z" }
    }
    ListModel{
        id:qzs_model
        ListElement{  band: "L1";      freq: "1575.42";    obs: 1;     ch: "1C/1E/1S/1L/1X/1Z/1B" }
        ListElement{  band: "L2";      freq: "1227.60";    obs: 2;     ch: "2S/2L/2X" }
        ListElement{  band: "L5";      freq: "1176.45";    obs: 5;     ch: "5I/5Q/5X/5D/5P/5Z"  }
        ListElement{  band: "L6";      freq: "1278.75";    obs: 6;     ch: "6S/6L/6X/6E/6Z"  }
    }
    ListModel{
        id:bd2_model
        ListElement{  band: "B1(B1I)"; freq: "1561.098";   obs:12;     ch: "2I/2Q/2X"  }
        ListElement{  band: "B2(B2I)"; freq: "1207.140";   obs: 7;     ch: "7I/7Q/7X"  }
        ListElement{  band: "B3";      freq: "1268.52";    obs:16;     ch: "6I/6Q/6X"  }
    }
    ListModel{
        id:bd3_model
        ListElement{  band: "B1C";     freq: "1575.42";    obs: 1;     ch: "1D/1P/1X"  }
        ListElement{  band: "B1A";     freq: "1575.42";    obs: 1;     ch: "1S/1L/1Z"  }
        ListElement{  band: "B2a";     freq: "1176.45";    obs: 5;     ch: "5D/5P/5X"  }
        ListElement{  band: "B2b";     freq: "1207.140";   obs: 7;     ch: "7D/7P/7Z"  }
        ListElement{  band: "B2(a+b)"; freq: "1191.795";   obs: 8;     ch: "8D/8P/8X"  }
        ListElement{  band: "B1(B1I)"; freq: "1561.098";   obs:12;     ch: "2I/2Q/2X"  }
        ListElement{  band: "B3";      freq: "1268.52";    obs:16;     ch: "6I/6Q/6X"  }
        ListElement{  band: "B3A";     freq: "1268.52";    obs:16;     ch: "6D/6P/6Z"  }
    }
    ListModel{
        id:irn_model
        ListElement{  band: "L5";      freq: "1176.45";   obs: 5;     ch: "5A/5B/5C/5X"  }
        ListElement{  band: "S";       freq: "2492.028";  obs: 9;     ch: "9A/9B/9C/9X"  }
    }
    ListModel{
        id:sbas_model
        ListElement{  band: "L1";      freq: "1575.42";    obs: 1;     ch: "1C" }
        ListElement{  band: "L5";      freq: "1176.45";    obs: 5;     ch: "5I/5Q/5X"  }
    }
    ListModel{
        id:xw_model
        ListElement{  band: "SPT_L";   freq: "1518.1875";   obs: 33;     ch: "3I/3Q/3IX" }
        ListElement{  band: "FPPP_L";  freq: "0000.000";    obs: 31;     ch: "1F"  }
        ListElement{  band: "FPPP_B2b";freq: "0000.000";    obs: 37;     ch: "7F" }
        ListElement{  band: "B3AL";    freq: "0000.000";    obs: 36;     ch: "6B"  }
    }



}


// ListModel{
//     id:freq_model

//     ListElement{
//         system: "GPS";
//         type:[
//             {  band: "L1",      freq: "1575.42",    obs: 1,     ch: ["1C","1S","1L","1X","1P","1W","1Y","1M","1N"] };
//             {  band: "L2",      freq: "1227.60",    obs: 2,     ch: ["2C","2D","2S","2L","2X","2P","2W","2Y","2M","2N"] },
//             {  band: "L5",      freq: "1176.45",    obs: 5,     ch: ["5I","5Q","5X"]  }
//         ]
//     }
//     ListElement{
//         system: "GLONASS";
//         type:[
//             {  band: "G1",      freq: "1602",       obs: 21,    ch: ["1C","1P"]  },
//             {  band: "G1a",     freq: "1600.995",   obs: 24,    ch: ["4A","4B","4X"]  },
//             {  band: "G2",      freq: "1246",       obs: 22,    ch: ["2C","2P"]  },
//             {  band: "G2a",     freq: "1248.06",    obs: 26,    ch: ["6A","6B","6X"]  },
//             {  band: "G3",      freq: "1202.025",   obs: 23,    ch: ["3I","3Q","3X"]  }
//         ]
//     }
//     ListElement{
//         system: "Galileo";
//         type:[
//             {  band: "E1",      freq: "1575.42",    obs: 1,     ch: ["1A","1B","1C","1X","1Z"]  },
//             {  band: "E5a",     freq: "1176.45",    obs: 5,     ch: ["5I","5Q","5X"]   },
//             {  band: "E5b",     freq: "1207.140",   obs: 7,     ch: ["7I","7Q","7X"]  },
//             {  band: "E5(a+b)", freq: "1191.795",   obs: 8,     ch: ["8I","8Q","8X"]  },
//             {  band: "E6",      freq: "1278.75",    obs: 6,     ch: ["6A","6B","6C","6X","6Z"] }
//         ]
//     }
//     ListElement{
//         system: "QZSS";
//         type:[
//             {  band: "L1",      freq: "1575.42",    obs: 1,     ch: ["1C","1E","1S","1L","1X","1Z","1B"] },
//             {  band: "L2",      freq: "1227.60",    obs: 2,     ch: ["2S","2L","2X"] },
//             {  band: "L5",      freq: "1176.45",    obs: 5,     ch: ["5I","5Q","5X","5D","5P","5Z"]  },
//             {  band: "L6",      freq: "1278.75",    obs: 6,     ch: ["6S","6L","6X","6E","6Z"]  }
//         ]
//     }
//     ListElement{
//         system: "BDS-2";
//         type:[
//             {  band: "B1(B1I)", freq: "1561.098",   obs:12,     ch: ["2I","2Q","2X"]  },
//             {  band: "B2(B2I)", freq: "1207.140",   obs: 7,     ch: ["7I","7Q","7X"]  },
//             {  band: "B3",      freq: "1268.52",    obs:16,     ch: ["6I","6Q","6X"]  }
//         ]
//         //或者说，只有选择B1和B3组合的时候，北斗二和北斗三才会同时参与解算
//     }
//     ListElement{
//         system: "BDS-3";
//         type:[
//             {  band: "B1C",     freq: "1575.42",    obs: 1,     ch: ["1D","1P","1X"]  },
//             {  band: "B1A",     freq: "1575.42",    obs: 1,     ch: ["1S","1L","1Z"]  },
//             {  band: "B2a",     freq: "1176.45",    obs: 5,     ch: ["5D","5P","5X"]  },
//             {  band: "B2b",     freq: "1207.140",   obs: 7,     ch: ["7D","7P","7Z"]  },
//             {  band: "B2(a+b)", freq: "1191.795",   obs: 8,     ch: ["8D","8P","8X"]  },
//             {  band: "B1(B1I)", freq: "1561.098",   obs:12,     ch: ["2I","2Q","2X"]  },
//             {  band: "B3",      freq: "1268.52",    obs:16,     ch: ["6I","6Q","6X"]  },
//             {  band: "B3A",     freq: "1268.52",    obs:16,     ch: ["6D","6P","6Z"]  }
//         ]
//     }
//     ListElement{
//         system: "IRNSS";
//         type:[
//             {  band: "L5",      freq: "1176.45",   obs: 5,     ch: ["5A","5B","5C","5X"]  },
//             {  band: "S",       freq: "2492.028",  obs: 9,     ch: ["9A","9B","9C","9X"]  },
//         ]
//     }
//     ListElement{
//         system: "SBAS";
//         type:[
//             {  band: "L1",      freq: "1575.42",    obs: 1,     ch: ["1C"] },
//             {  band: "L5",      freq: "1176.45",    obs: 5,     ch: ["5I","5Q","5X"]  }
//         ]
//     }
// }
