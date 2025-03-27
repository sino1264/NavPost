import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtWebEngine
import FluentUI.Controls
import FluentUI.impl
import NavPost
import "../extra"

Item {
    id:root

    anchors.fill: parent

    property string title
    property PageContext context

    Column{

        WebEngineView {
            id: webView
            width: 700
            height: 500
            // anchors.fill: parent
            backgroundColor: "transparent"

            // url: "https://www.example.com"
            url:  R.resolvedUrl("res/plot/echart_dev.html")
            // url: "qrc:/qt/qml/NavPost/res/plot/echart_dev.html"

            onLoadProgressChanged: {
                if (loadProgress == 100) {
                    // 页面加载完成后，运行JavaScript代码
                    webView.runJavaScript("document.title", function(result) { console.log(result); });
                }
            }


            FileWatcher{
                path: webView.url
                onFileChanged: {
                    webView.reload()
                }
            }
        }


        Button {
            text: "Update Chart"
            // anchors.centerIn: parent
            onClicked: {
                // 在按钮点击时调用 HTML 中的 update 函数
                webView.runJavaScript("
var dom = document.getElementById('main');

// 检查是否已有 ECharts 实例
var myChart = echarts.getInstanceByDom(dom);

// 如果没有实例，才创建新实例
if (!myChart) {
    myChart = echarts.init(dom);
}

      // 指定图表的配置项和数据
      var option = {
        title: {
          text: 'ECharts 入门示例'
        },
        tooltip: {},
        legend: {
          data: ['销量']
        },
        xAxis: {
          data: ['衬衫', '羊毛衫', '雪纺衫', '裤子', '高跟鞋', '袜子']
        },
        yAxis: {},
        series: [
          {
            name: '销量',
            type: 'bar',
            data: [66, 20, 36, 10, 10, 20]
          }
        ]
      };

      // 使用刚指定的配置项和数据显示图表。
      myChart.setOption(option);
", function(result) {
    console.log("Chart updated successfully");
});
            }

        }


        Button{
            text: "add data"

            onClicked: {
                webView.runJavaScript("setTimeout(function () {
        var newData = [15, 25, 30];
        var newLabels = ['外套', '裙子', '运动鞋'];

        var option = myChart.getOption();
        option.series[0].data = option.series[0].data.concat(newData); // 合并数据
        option.xAxis[0].data = option.xAxis[0].data.concat(newLabels); // 合并标签

        myChart.setOption(option); // 更新图表
    }, 2000);")
            }
        }


    }
}


