#pragma once

#include <QtCore/qstring.h>
#include <QObject>
#include <QtQml/qqml.h>

#include <spdlog/spdlog.h>
#include <spdlog/sinks/basic_file_sink.h>
#include <spdlog/sinks/stdout_color_sinks.h>
#include <QDebug>

#include "stdafx.h"

#include <unordered_map>

namespace Log
{
    QString prettyProductInfoWrapper();
    void setup(char *argv[], const QString &app, int level = 4);
}

enum class LogLevel
{
    Debug,
    Info,
    Warning,
    Error,
    Critical
};

class LogRecord
{
public:
    LogRecord() {};

public:
    int addLog(const spdlog::details::log_msg &msg)
    {

        // 1. 提取日志的级别
        spdlog::level::level_enum level = msg.level;

        // 2. 提取日志内容
        std::string message(msg.payload.data(), msg.payload.size());

        // 3. 提取日志的源信息（文件名、行号、函数名）
        const spdlog::source_loc &source = msg.source;
        std::string filename = source.filename;      // 文件名
        int line_number = source.line;               // 行号
        std::string function_name = source.funcname; // 函数名

        // 4. 提取记录器名称
        std::string logger_name(msg.logger_name.data(), msg.logger_name.size());

        // 5. 提取时间戳
        auto timestamp = msg.time.time_since_epoch().count(); // 纳秒精度

        //        // 打印日志信息
        // std::cout << "Logger Name: " << logger_name << "\n";
        // std::cout << "Timestamp: " << timestamp << "\n";
        // std::cout << "Level: " << spdlog::level::to_string_view(level) << "\n";
        // std::cout << "File: " << filename << " Line: " << line_number << "\n";
        // std::cout << "Function: " << function_name << "\n";
        // std::cout << "Message: " << message << "\n";

        while (_history_logs.size() >= _maxLogCount)
        {
            _history_logs.removeFirst(); // 移除最早的日志
        }

        QVariantMap item;
        item["time"] = timestamp;
        item["level"] = spdlog::level::to_string_view(level).data();
        item["file"] = filename.c_str();
        item["line"] = line_number;
        item["func"] = function_name.c_str();
        item["msg"] = message.c_str();

        _logs.append(item);

        if (_history_logs.size() >= _maxLogCount)
        {
            _history_logs.removeFirst(); // 移除最早的日志
        }

        return _logs.count();
    }

    QList<QVariantMap> getCurrentLogs()
    {

        auto logs = _logs;
        _history_logs.append(_logs);
        _logs.clear(); // 清空当前日志

        while (_history_logs.size() >= _maxLogCount)
        {
            _history_logs.removeFirst(); // 移除最早的日志
        }

        return logs;
    }

    // 获取历史日志
    QList<QVariantMap> getHistoryLogs()
    {

        _history_logs.append(_logs);
        _logs.clear(); // 清空当前日志

        while (_history_logs.size() >= _maxLogCount)
        {
            _history_logs.removeFirst(); // 移除最早的日志
        }

        return _history_logs;
    }

private:
    int _maxLogCount = 5000; // 日志最大条数
    QList<QVariantMap> _logs;
    QList<QVariantMap> _history_logs;
};

class LogRecordManager : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_ELEMENT
private:
    explicit LogRecordManager(QObject *parent = nullptr);

public:
    SINGLETON(LogRecordManager)
    static LogRecordManager *create(QQmlEngine *, QJSEngine *)
    {
        return getInstance();
    }
    ~LogRecordManager() override;

    Q_INVOKABLE QList<QVariantMap> get_new_logs(QString UID)
    {
        auto item = _record_map.find(UID.toStdString());
        if (item == _record_map.end())
        {
            return QList<QVariantMap>();
        }
        else
        {
            return item->second->getCurrentLogs();
        }
    };

    Q_INVOKABLE QList<QVariantMap> get_all_logs(QString UID)
    {
        auto item = _record_map.find(UID.toStdString());
        if (item == _record_map.end())
        {
            return QList<QVariantMap>();
        }
        else
        {
            return item->second->getHistoryLogs();
        }
    };

    Q_INVOKABLE int addLog(std::string UID, const spdlog::details::log_msg &msg)
    {
        auto item = _record_map.find(UID);
        if (item == _record_map.end())
        {
            auto newitem = new LogRecord();

            _record_map.insert(std::pair(UID, newitem));
        }

        return _record_map.find(UID)->second->addLog(msg);
    };

private:
    std::unordered_map<std::string, LogRecord *> _record_map; // 日志记录表
};

template <typename Mutex>
class RecordSink : public spdlog::sinks::base_sink<Mutex>
{

public:
    explicit RecordSink(std::string UID) { _UID = UID; }

private:
    std::string _UID;

protected:
    // 处理日志的具体实现
    void sink_it_(const spdlog::details::log_msg &msg) override
    {
        LogRecordManager::getInstance()->addLog(_UID, msg);
    }

    // 刷新缓冲区
    void flush_() override
    {
        // Qt 的日志接口无需额外处理刷新逻辑
    }
};
