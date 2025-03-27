import QtQuick
import QtQuick.Controls
import FluentUI.impl

Item{
    FluentUI.theme: Theme.of(control)
    property var accentColor: FluentUI.theme.accentColor
    property int mode: TimelineType.Left
    property alias model: repeater.model
    property color lineColor: Theme.dark ? Qt.rgba(80/255,80/255,80/255,1) : Qt.rgba(210/255,210/255,210/255,1)
    id:control
    implicitWidth: 380
    implicitHeight: layout_column.height
    QtObject{
        id:d
        property bool isLeft: control.mode === TimelineType.Left
        property bool isRight: control.mode === TimelineType.Right
        property bool isAlternate: control.mode === TimelineType.Alternate
        property bool hasLable: {
            if(!model){
                return false
            }
            for(var i=0;i<model.count;i++){
                var lable = model.get(i).lable
                if(lable !== undefined && undefined !== ""){
                    return true
                }
            }
            return false
        }
        property string stateName : {
            if(hasLable){
                return "Center"
            }
            if(isRight){
                return "Right"
            }
            if(isAlternate){
                return "Center"
            }
            return "Left"
        }
    }
    Rectangle{
        id:rect_line
        color: control.lineColor
        height: {
            if(repeater.count===0){
                return parent.height
            }
            return parent.height - layout_column.children[repeater.count-1].height
        }
        width: 2
        visible: repeater.count!==0
        state: d.stateName
        states: [
            State {
                name: "Left"
                AnchorChanges {
                    target: rect_line
                    anchors.left: control.left
                }
                PropertyChanges {
                    target: rect_line
                    anchors.leftMargin: 7
                }
            },
            State {
                name: "Right"
                AnchorChanges {
                    target: rect_line
                    anchors.right: control.right
                }
                PropertyChanges {
                    target: rect_line
                    anchors.rightMargin: 7
                }
            },
            State {
                name: "Center"
                AnchorChanges {
                    target: rect_line
                    anchors.horizontalCenter: control.horizontalCenter
                }
            }
        ]
    }
    Component{
        id:com_dot
        Rectangle{
            width: 16
            height: 16
            radius: 8
            border.width: 4
            color: Theme.dark ? Qt.rgba(0,0,0,1) : Qt.rgba(1,1,1,1)
            border.color: control.accentColor.defaultBrushFor(control.FluentUI.dark)
        }
    }

    Component{
        id:com_lable
        Label{
            wrapMode: Text.WordWrap
            horizontalAlignment: isRight ? Qt.AlignRight : Qt.AlignLeft
            text: {
                if(modelData.lable){
                    return modelData.lable
                }
                return ""
            }
            color: control.accentColor.defaultBrushFor(control.FluentUI.dark)
        }
    }

    Component{
        id:com_text
        Label{
            wrapMode: Text.WordWrap
            horizontalAlignment: isRight ? Qt.AlignRight : Qt.AlignLeft
            text: modelData.text
            textFormat: Text.RichText
        }
    }

    Column{
        id:layout_column
        spacing: 30
        width: control.width
        height: repeater.count === 0 ? 1 : childrenRect.height
        Repeater{
            id:repeater
            Item{
                id:item_layout
                width: layout_column.width
                height: loader_text.height
                AutoLoader{
                    id:item_loader
                    state: d.stateName
                    states: [
                        State {
                            name: "Left"
                            AnchorChanges {
                                target: item_loader
                                anchors.left: item_layout.left
                            }
                        },
                        State {
                            name: "Right"
                            AnchorChanges {
                                target: item_loader
                                anchors.right: item_layout.right
                            }
                        },
                        State {
                            name: "Center"
                            AnchorChanges {
                                target: item_loader
                                anchors.horizontalCenter: item_layout.horizontalCenter
                            }
                        }
                    ]
                    sourceComponent: {
                        if(model.dotDelegate)
                            return model.dotDelegate()
                        return com_dot
                    }
                }

                AutoLoader{
                    property var modelData: control.model.get(index)
                    property bool isRight: state === "Right"
                    id:loader_lable
                    sourceComponent: {
                        if(!modelData){
                            return undefined
                        }
                        var lableDelegate = model.lableDelegate
                        if(lableDelegate instanceof Function && lableDelegate() instanceof Component){
                            return lableDelegate()
                        }
                        return com_lable
                    }
                    state: {
                        if(d.isRight){
                            return "Left"
                        }
                        if(d.isAlternate){
                            if(index%2===0){
                                return "Right"
                            }else{
                                return "Left"
                            }
                        }
                        return "Right"
                    }
                    states: [
                        State {
                            name: "Left"
                            AnchorChanges {
                                target: loader_lable
                                anchors.left: item_loader.right
                                anchors.right: item_layout.right
                            }
                            PropertyChanges {
                                target: loader_lable
                                anchors.leftMargin: 14
                                anchors.rightMargin: 14
                            }
                        },
                        State {
                            name: "Right"
                            AnchorChanges {
                                target: loader_lable
                                anchors.right: item_loader.left
                                anchors.left: item_layout.left
                            }
                            PropertyChanges {
                                target: loader_lable
                                anchors.leftMargin: 14
                                anchors.rightMargin: 14
                            }
                        },
                        State {
                            name: "Center"
                            AnchorChanges {
                                target: loader_lable
                                anchors.right: item_loader.left
                                anchors.left: item_layout.left
                            }
                            PropertyChanges {
                                target: loader_lable
                                anchors.leftMargin: 14
                                anchors.rightMargin: 14
                            }
                        }
                    ]
                }
                AutoLoader{
                    id:loader_text
                    property var modelData: control.model.get(index)
                    property bool isRight: state === "Right"
                    state: {
                        if(d.isRight){
                            return "Right"
                        }
                        if(d.isAlternate){
                            if(index%2===0){
                                return "Left"
                            }else{
                                return "Right"
                            }
                        }
                        return "Left"
                    }
                    sourceComponent: {
                        if(!modelData){
                            return undefined
                        }
                        var textDelegate = model.textDelegate
                        if(textDelegate instanceof Function && textDelegate() instanceof Component){
                            return textDelegate()
                        }
                        return com_text
                    }
                    states: [
                        State {
                            name: "Left"
                            AnchorChanges {
                                target: loader_text
                                anchors.left: item_loader.right
                                anchors.right: item_layout.right
                            }
                            PropertyChanges {
                                target: loader_text
                                anchors.leftMargin: 14
                                anchors.rightMargin: 14
                            }
                        },
                        State {
                            name: "Right"
                            AnchorChanges {
                                target: loader_text
                                anchors.right: item_loader.left
                                anchors.left: item_layout.left
                            }
                            PropertyChanges {
                                target: loader_text
                                anchors.leftMargin: 14
                                anchors.rightMargin: 14
                            }
                        },
                        State {
                            name: "Center"
                            AnchorChanges {
                                target: loader_text
                                anchors.right: item_loader.left
                                anchors.left: item_layout.left
                            }
                            PropertyChanges {
                                target: loader_text
                                anchors.leftMargin: 14
                                anchors.rightMargin: 14
                            }
                        }
                    ]
                }
            }
        }
    }
}
