import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import FluentUI.Controls
import FluentUI.impl
import NavPost
import QtPositioning
import QtLocation

// ContentPage
Item{
    id:root

    anchors.fill: parent

    property string title
    property PageContext context

    property double realCenterX: 0 // 中心点实际坐标
    property double realCenterY: 0 // 中心点实际坐标
    property double cScale:0.01    //长度和像素的比，单位像素表示的长度

    // 缩放范围
    property double cGridPixMin: 60 // 当前格网的最小像素数
    property real minScale: 0.00001
    property real maxScale: 5000

    property alias cHeight: canvas.height // canvas控件的高
    property alias cWidth: canvas.width // canvas控件的宽

    //绘制比例尺用到的参数
    property double cGridRealLength // 当前格网的实际代表的长度
    property double cGridPixLength // 当前格网的实际像素数

    //鼠标事件使用的变量
    property point cRealMouse
    property point cPixMouse
    // 鼠标拖动偏移量
    property real offsetX: 0 // 水平方向偏移量
    property real offsetY: 0 // 垂直方向偏移量
    // 记录拖动状态
    property bool dragging: false
    property real initialX: 0
    property real initialY: 0


    //一些开关设置
    property bool draw_grid:Global.mapPageOption_Draw_Grid

    onDraw_gridChanged: {
        canvas.requestPaint()
    }

    // Connections{
    //     target: Global

    //     function onMapPageOption_Draw_GridChanged(){

    //     }

    // }



    Frame{
        id:map_main

        anchors{
            fill:parent
            margins: 1
            bottomMargin: 20
            // bottom:map_footer.top
            // left: parent.left
            // right: parent.right
        }

        Canvas {
            id: canvas   //有个bug，在Canvas里面定义的函数必须要有(ctx)参数，不然就会导致canvas不能绘制
            height: parent.height
            width:parent.width

            // 鼠标事件处理（包括拖动和缩放）
            MouseArea{
                id: dragArea
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                hoverEnabled: true // 允许捕获悬停事件

                onWheel:(wheel)=> {
                            var delta = wheel.angleDelta.y / 120; // 每次滚轮滚动的级别
                            //console.log("delta",delta)
                            if(delta>0)
                            {
                                root.cScale=cScale*Math.pow(1 / 2, 1 / 10)
                            }
                            else
                            {
                                root.cScale=cScale*Math.pow(2, 1 / 10)
                            }
                            canvas.requestPaint(); // 请求重绘
                        }

                onPressed:  (mouse)=>{
                                dragging = true;
                                initialX = mouse.x;
                                initialY = mouse.y;
                            }

                onReleased: {
                    dragging = false;
                }

                onPositionChanged: (mouse)=>{
                                       if (dragging) {
                                           var deltaX = mouse.x - initialX;
                                           var deltaY = mouse.y - initialY;
                                           offsetX += deltaX;
                                           offsetY += deltaY;
                                           initialX = mouse.x;
                                           initialY = mouse.y;

                                           //console.log("deltaX",deltaX)
                                           //console.log("deltaY",deltaY)

                                           root.realCenterX-=deltaX*root.cScale
                                           root.realCenterY+=deltaY*root.cScale

                                           canvas.requestPaint(); // 请求重绘
                                       }
                                       else
                                       {
                                           cPixMouse.x=mouse.x.toFixed(3);
                                           cPixMouse.y=mouse.y.toFixed(3);
                                           cRealMouse.x=((root.cPixMouse.x-root.cWidth/2)*root.cScale+root.realCenterX).toFixed(3)
                                           cRealMouse.y=((root.cHeight/2- root.cPixMouse.y)*root.cScale+root.realCenterX).toFixed(3)
                                       }
                                   }
            }

            onPaint: {
                var ctx = canvas.getContext("2d");

                // 清除画布
                ctx.clearRect(0, 0, canvas.width, canvas.height);

                // // 绘制格网线
                if(root.draw_grid)
                {
                    drawGridLine(ctx)
                }



                // 绘制中心十字
                drawCenter(ctx)

                // 绘制比例尺
                drawScale(ctx);

                //绘制坐标点
                drawPoint(ctx)

            }

            //绘制格网
            function drawGridLine(ctx) {

                ctx.strokeStyle = "#808080";
                ctx.lineWidth = 1;
                // ctx.setLineDash([10, 5]); // 虚线：线段长度10px，间隔5px

                var Scale = root.cScale; // 缩放比例
                var GridPixMin = root.cGridPixMin; // 格网最小像素
                var Xcenter = root.realCenterX; // 中心点真实坐标
                var Ycenter = root.realCenterY;
                var Width = root.cWidth; // canvas的宽和高
                var Height = root.cHeight;

                var baseUnits = [1, 2, 5];
                var unitIndex = 0;
                var scaleExponent = -3;

                for(var i=0;i<40;i++)
                {
                    // console.log("i="+i)
                    var GridRealLength = baseUnits[unitIndex] * Math.pow(10, scaleExponent);
                    if(Scale==0)
                    {
                        console.log("error:Scale=0")
                        return
                    }
                    var GridPixelLength = GridRealLength / Scale;

                    if (GridPixelLength >= GridPixMin) {
                        //console.log("i="+i)
                        break;
                    }

                    unitIndex++;
                    if (unitIndex >= baseUnits.length) {
                        unitIndex = 0;
                        scaleExponent++;
                    }
                }


                root.cGridPixLength=GridPixelLength
                root.cGridRealLength=GridRealLength

                //console.log("GridRealLength",GridRealLength,"GridPixelLength"+GridPixelLength,"GridPixelLength",GridPixelLength,"Scale",Scale)

                var Left = Xcenter - Scale * Width / 2;
                var Right = Xcenter + Scale * Width / 2;
                var Top = Ycenter + Scale * Height / 2;
                var Bottom = Ycenter - Scale * Height / 2;

                //console.log("Left",Left,"Right",Right,"Top",Top,"Bottom",Bottom)

                var horizonGird = [];
                var verticalGrid = [];


                let leftRemainder = (Xcenter % GridRealLength + GridRealLength) % GridRealLength;
                //console.log("leftRemainder",leftRemainder)
                for (var i = 0; (Xcenter + i * GridRealLength) < (Right+GridRealLength); i++) {
                    // verticalGrid.push((leftRemainder + i * GridRealLength) / Scale+Width/2);
                    // verticalGrid.push((leftRemainder - i * GridRealLength) / Scale+Width/2);
                    verticalGrid.push(Width-((leftRemainder + i * GridRealLength) / Scale+Width/2));
                    verticalGrid.push(Width-((leftRemainder - i * GridRealLength) / Scale+Width/2));
                }
                //console.log("verticalGrid",verticalGrid)

                let bottomRemainder = (Ycenter % GridRealLength + GridRealLength) % GridRealLength;
                //console.log("bottomRemainder",bottomRemainder,"Bottom",Bottom,"Top",Top)
                for (var j = 0; (Ycenter + j * GridRealLength) < (Top+GridRealLength); j++) {
                    // horizonGird.push(Height - ((bottomRemainder + j * GridRealLength) / Scale+Height/2));
                    // horizonGird.push(Height - ((bottomRemainder - j * GridRealLength) / Scale+Height/2));
                    horizonGird.push(((bottomRemainder + j * GridRealLength) / Scale+Height/2));
                    horizonGird.push(((bottomRemainder - j * GridRealLength) / Scale+Height/2));
                }
                //console.log("horizonGird",horizonGird)


                // console.log(root.cHorizonGird.length)

                for (var i = 0; i < horizonGird.length; i++) {
                    var line =horizonGird[i];
                    ctx.beginPath();
                    ctx.moveTo(0, line);
                    ctx.lineTo(Width, line);
                    ctx.stroke();
                }

                for (var i = 0; i < verticalGrid.length; i++) {
                    var line = verticalGrid[i];
                    ctx.beginPath();
                    ctx.moveTo(line, 0);
                    ctx.lineTo(line, Height);
                    ctx.stroke();
                }
            }


            function drawCenter(ctx){
                ctx.strokeStyle = "#FF0000";  // 坐标轴颜色
                ctx.lineWidth = 2;

                // 绘制 X 轴
                ctx.beginPath();
                ctx.moveTo(width/2-10, height/2);
                ctx.lineTo(width/2+10, height/2);
                ctx.stroke();


                // 绘制 X 轴
                ctx.beginPath();
                ctx.moveTo(width/2, height/2-10);
                ctx.lineTo(width/2, height/2+10);
                ctx.stroke();

            }


            function drawScale(ctx) {
                // 动态调整比例尺长度
                var scaleLength = root.cGridPixLength
                var scaleUnit = root.cGridRealLength

                // 设置比例尺颜色
                ctx.strokeStyle = "#0000FF";
                ctx.lineWidth = 2;

                // 比例尺的固定位置
                var scaleX = canvas.width - 100;  // 比例尺起始的 X 坐标（固定）
                var scaleY = canvas.height - 30;  // 比例尺的 Y 坐标（固定）

                // 画比例尺线段
                ctx.beginPath();
                ctx.moveTo(scaleX + scaleLength/2, scaleY);
                ctx.lineTo(scaleX - scaleLength/2, scaleY);
                ctx.stroke();

                // 标记比例尺的起始点和结束点
                ctx.beginPath();
                ctx.moveTo(scaleX - scaleLength/2, scaleY - 5); // 起始点小标记
                ctx.lineTo(scaleX - scaleLength/2, scaleY + 5);
                ctx.moveTo(scaleX + scaleLength/2, scaleY - 5); // 结束点小标记
                ctx.lineTo(scaleX + scaleLength/2, scaleY + 5);
                ctx.stroke();

                // 绘制比例尺的刻度标记
                var scaleDivisionCount = 5; // 比例尺上显示的刻度数
                var divisionSpacing = scaleLength / scaleDivisionCount;

                // 标注比例尺的单位（如果需要）
                ctx.font = "14px Arial";
                ctx.fillStyle = "#0000FF";
                ctx.textAlign = "center"; // 水平居中
                ctx.textBaseline = "middle"; // 垂直居中
                ctx.fillText(scaleUnit + " m", scaleX, scaleY -15);
            }

            function drawPoint(ctx)
            {
                // 绘制坐标点
                ctx.fillStyle = "blue";
                for (let i = 0; i < simulatedData.length; i++) {
                    const point = simulatedData[i];
                    const pixpoint=  point2pix(point)
                    ctx.beginPath();
                    ctx.arc(pixpoint.x, pixpoint.y, 5, 0, Math.PI * 2); // 圆形点
                    ctx.fill();
                }
            }
        }
    }

    Item{
        id:map_footer
        height: 20

        anchors{
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        Row{
            anchors.right: parent.right

            spacing: 10

            Label{
                text: "中心点坐标"
            }
            Label{
                text: root.realCenterX.toFixed(3)
            }

            Label{
                text: root.realCenterY.toFixed(3)
            }

            Label{
                text: "鼠标点坐标"
            }
            Label{
                text:root.cRealMouse.x.toFixed(3)
            }
            Label{
                text:root.cRealMouse.y.toFixed(3)
            }
            Label{
                text: "鼠标点像素"
            }
            Label{
                text:root.cPixMouse.x.toFixed(3)
            }

            Label{
                text:root.cPixMouse.y.toFixed(3)
            }

        }

    }



    // 信息弹窗
    Rectangle {
        id: infoPopup
        width: 160
        height: 40
        color: "#333333"
        radius: 5
        visible: false
        opacity: 0.8
        border.color: "white"
        border.width: 1

        Text {
            id: infoText
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: 12
            text: ""
        }
    }


    property var simulatedData: []

    Component.onCompleted: {

        for (let i = 0; i < 100; i++) {
            simulatedData.push({
                                   x: Math.random() * 100000,  // 随机 x 坐标
                                   y: Math.random() * 100000 // 随机 y 坐标
                               });
        }

        timer.start()  // 启动定时器  用定时器是为了解决页面执行到这一行的时候，长宽还没有指定
    }

    Timer {
        id: timer
        interval: 100  // 0.1秒 = 100毫秒
        repeat: false  // 不重复执行
        onTriggered: {
            resizeCanvas()
            canvas.requestPaint(); // 请求重绘
            // panel_loading.visible = false
        }
    }


    // Pane{
    //     id: panel_loading
    //     anchors.fill: parent
    //     ProgressRing{
    //         anchors.centerIn: parent
    //         indeterminate: true
    //     }
    //     background: Rectangle{
    //         color: Theme.res.solidBackgroundFillColorBase
    //     }
    // }


    // onCWidthChanged: {
    //     resizeCanvas()
    //     // canvas.requestPaint();
    // }
    // onCHeightChanged: {
    //     resizeCanvas()
    //     // canvas.requestPaint();
    // }

    property int pointRadius: 5 // 点的半径
    onCRealMouseChanged: {
        // 查找最近的点
        let closestPoint = null;
        let minDistance = Infinity;
        let closestDistance = Infinity;
        for (let i = 0; i < root.simulatedData.length; i++) {
            const point = root.simulatedData[i];
            const pixpoint=  point2pix(point)
            const dx = pixpoint.x  - root.cPixMouse.x;
            const dy = pixpoint.y - root.cPixMouse.y;
            const distance = Math.sqrt(dx * dx + dy * dy);
            // 记录距离最小的点
            if (distance < minDistance) {
                minDistance = distance;
                closestPoint = point;
                closestDistance=distance
            }
        }

        // // 如果最近点在检测范围内，显示弹窗
        if(closestDistance<10)
        {
            infoPopup.visible = true;
            infoPopup.x =  root.cPixMouse.x + 10; // 弹窗偏移位置
            infoPopup.y = root.cPixMouse.y + 10; //
            infoText.text = `X: ${closestPoint.x.toFixed(2)}, Y: ${closestPoint.y.toFixed(2)}`;
        }
        else{
            infoPopup.visible = false
        }
    }


    function generateRandomPoint(minX, maxX, minY, maxY) {
        var x = minX + Math.random() * (maxX - minX);
        var y = minY + Math.random() * (maxY - minY);
        return {x: x, y: y};
    }

    //重置canvas视图
    function resizeCanvas()
    {
        const  bounds = getBounds(simulatedData);
        root.realCenterX=(bounds.maxX+bounds.minX)/2
        root.realCenterY=(bounds.maxY+bounds.minY)/2
        root.cScale=Math.max((bounds.maxX-bounds.minX)/(root.cWidth-30),(bounds.maxY-bounds.minY)/(root.cHeight-30))
    }

    function getBounds(data) {
        if (data.length === 0) return null; // 如果数据为空，返回 null

        // 初始化最大最小值
        let minX = data[0].x;
        let maxX = data[0].x;
        let minY = data[0].y;
        let maxY = data[0].y;

        // 遍历数组，更新最大最小值
        for (let i = 1; i < data.length; i++) {
            const point = data[i];
            if (point.x < minX) minX = point.x;
            if (point.x > maxX) maxX = point.x;
            if (point.y < minY) minY = point.y;
            if (point.y > maxY) maxY = point.y;
        }

        // 返回结果
        return { minX, maxX, minY, maxY };
    }

    function point2pix(point)
    {
        var PointX=point.x
        var PointY=point.y
        var PixX
        var PixY

        var Scale = root.cScale; // 缩放比例
        var CenterX = root.realCenterX; // 中心点真实坐标
        var CenterY = root.realCenterY;
        var Width = root.cWidth; // canvas的宽和高
        var Height = root.cHeight;

        //根据中心点的坐标，缩放因子，计算像素坐标

        PixX=Width/2+(PointX-CenterX)/Scale;
        PixY=Height-((PointY-CenterY)/Scale+Height/2)

        // console.log("real:",PointX,PointY,"convert pix:",PixX,PixY)

        return {x:PixX,y:PixY}

    }

    function pix2point(pix)
    {
        var PointX
        var PointY
        var PixX=pix.x
        var PixY=pix.y

        var Scale = root.cScale; // 缩放比例
        var CenterX = root.realCenterX; // 中心点真实坐标
        var CenterY = root.realCenterY;
        var Width = root.cWidth; // canvas的宽和高
        var Height = root.cHeight;


        PointX=(PixX-Width/2)*Scale+CenterX
        PointY=(Height/2-PixY)*Scale+CenterY

        // console.log("pix:",PixX,PixY,"convert real:",PointX,PointY)

        return {x:PointX,y:PointY}
    }


}



