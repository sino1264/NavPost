pragma Singleton

import QtQuick
import QtQuick.Controls
import FluentUI.Controls
import FluentUI.impl
import NavPost

/*
   QML中通用的JavaScript函数
*/

QtObject {
    
    function toAbsolutePath(fileUrl) {
        var path = fileUrl;

        // Remove the "file://" prefix
        if (fileUrl.startsWith("file://")) {
            path = fileUrl.replace("file://", "");

            // Windows-specific adjustment
            if (Qt.platform.os === "windows") {
                // On Windows, paths after "file://" may start with a drive letter (e.g., "C:/")
                // In this case, an additional slash might be present (e.g., "file:///C:/path")
                if (path.length > 3 && path.charAt(2) === ':') {
                    path = path.substring(1); // Remove the leading slash before "C:/"
                }
            }
        }
        return path;
    }

    function safeStringify(obj, space = 2) {
        const seen = new WeakSet();

        return JSON.stringify(obj, (key, value) => {
                                  if (typeof value === 'object' && value !== null) {
                                      // 检查循环引用
                                      if (seen.has(value)) {
                                          return; // 返回 undefined 会跳过该属性
                                      }
                                      seen.add(value);
                                  }
                                  return value;
                              }, space);
    }

}
