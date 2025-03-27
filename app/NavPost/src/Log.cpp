#include "Log.h"
#include "Version.h"
#include <QtCore/qdebug.h>
#include <QtCore/qfile.h>
#include <QtCore/qtextstream.h>
#include <QGuiApplication>
#include <iostream>
#include <QDateTime>
#include <QStandardPaths>
#include <QDir>
#include <QThread>
#include <QSettings>
#include <QRegularExpression>
#ifdef WIN32
#include <process.h>
#else
#include <unistd.h>
#endif
#ifndef QT_ENDL
#if (QT_VERSION >= QT_VERSION_CHECK(5, 14, 0))
#define QT_ENDL Qt::endl
#else
#define QT_ENDL endl
#endif
#endif

static QString g_app = {};
static QString g_file_path = {};
static bool g_logError = false;

static std::unique_ptr<QFile> g_logFile = nullptr;
static std::unique_ptr<QTextStream> g_logStream = nullptr;

static int g_logLevel = 4;

std::map<QtMsgType, int> logLevelMap = {
    {QtFatalMsg, 0},
    {QtCriticalMsg, 1},
    {QtWarningMsg, 2},
    {QtInfoMsg, 3},
    {QtDebugMsg, 4}};

QString Log::prettyProductInfoWrapper()
{
    auto productName = QSysInfo::prettyProductName();
#if QT_VERSION < QT_VERSION_CHECK(6, 5, 0)
#if defined(Q_OS_MACOS)
    auto macosVersionFile =
        QString::fromUtf8("/System/Library/CoreServices/.SystemVersionPlatform.plist");
    auto fi = QFileInfo(macosVersionFile);
    if (fi.exists() && fi.isReadable())
    {
        auto plistFile = QFile(macosVersionFile);
        plistFile.open(QIODevice::ReadOnly);
        while (!plistFile.atEnd())
        {
            auto line = plistFile.readLine();
            if (line.contains("ProductUserVisibleVersion"))
            {
                auto nextLine = plistFile.readLine();
                if (nextLine.contains("<string>"))
                {
                    QRegularExpression re(QString::fromUtf8("\\s*<string>(.*)</string>"));
                    auto matches = re.match(QString::fromUtf8(nextLine));
                    if (matches.hasMatch())
                    {
                        productName = QString::fromUtf8("macOS ") + matches.captured(1);
                        break;
                    }
                }
            }
        }
    }
#endif
#endif
#if defined(Q_OS_WIN)
    QSettings regKey{
        QString::fromUtf8(R"(HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion)"),
        QSettings::NativeFormat};
    if (regKey.contains(QString::fromUtf8("CurrentBuildNumber")))
    {
        auto buildNumber = regKey.value(QString::fromUtf8("CurrentBuildNumber")).toInt();
        if (buildNumber > 0)
        {
            if (buildNumber < 9200)
            {
                productName = QString::fromUtf8("Windows 7 build %1").arg(buildNumber);
            }
            else if (buildNumber < 10240)
            {
                productName = QString::fromUtf8("Windows 8 build %1").arg(buildNumber);
            }
            else if (buildNumber < 22000)
            {
                productName = QString::fromUtf8("Windows 10 build %1").arg(buildNumber);
            }
            else
            {
                productName = QString::fromUtf8("Windows 11 build %1").arg(buildNumber);
            }
        }
    }
#endif
    return productName;
}

static inline void messageHandler(const QtMsgType type, const QMessageLogContext &context,
                                  const QString &message)
{

    // 提取文件名、函数名和行号
    const char *file = context.file ? context.file : "unknown_file";
    const char *function = context.function ? context.function : "unknown_function";
    int line = context.line;

    // QString fileAndLineLogStr;
    // if (context.file) {
    //     std::string strFileTmp = context.file;
    //     const char *ptr = strrchr(strFileTmp.c_str(), '/');
    //     if (nullptr != ptr) {
    //         char fn[512] = {0};
    //         sprintf(fn, "%s", ptr + 1);
    //         strFileTmp = fn;
    //     }
    //     const char *ptrTmp = strrchr(strFileTmp.c_str(), '\\');
    //     if (nullptr != ptrTmp) {
    //         char fn[512] = {0};
    //         sprintf(fn, "%s", ptrTmp + 1);
    //         strFileTmp = fn;
    //     }
    //     fileAndLineLogStr = QString::fromStdString("[%1:%2]").arg(
    //         QString::fromStdString(strFileTmp), QString::number(context.line));
    // }

    // 转换 Qt 日志等级为 spdlog 日志等级
    spdlog::level::level_enum spdlogLevel;
    switch (type)
    {
    case QtDebugMsg:
        spdlogLevel = spdlog::level::debug;
        break;
    case QtInfoMsg:
        spdlogLevel = spdlog::level::info;
        break;
    case QtWarningMsg:
        spdlogLevel = spdlog::level::warn;
        break;
    case QtCriticalMsg:
        spdlogLevel = spdlog::level::err;
        break;
    case QtFatalMsg:
        spdlogLevel = spdlog::level::critical;
        break;
    default:
        spdlogLevel = spdlog::level::info;
    }

    auto m_logger = spdlog::default_logger();

    // 使用 spdlog 输出日志，带有文件、行号和函数名信息
    m_logger->log(spdlog::source_loc{file, line, function}, spdlogLevel, message.toStdString());

    // 如果是 fatal 消息，强制退出程序
    if (type == QtFatalMsg)
    {
        abort();
    }

    // if (message == "Could not get the INetworkConnection instance for the adapter GUID.") {
    //     return;
    // }
    // if (message == "Retrying to obtain clipboard.") {
    //     return;
    // }
    // if (logLevelMap[type] > g_logLevel) {
    //     return;
    // }

    //        // std::string strFileTmp = context.file;
    //        // QString fileAndLineLogStr = QString::fromStdString("[%1:%2]").arg(
    //        //     QString::fromStdString(strFileTmp), QString::number(context.line));

    // if (!message.isEmpty()) {
    //     QString levelName;
    //     switch (type) {
    //         case QtDebugMsg:
    //             m_logger->debug("{} {}",fileAndLineLogStr.toStdString(),message.toStdString());
    //             break;
    //         case QtInfoMsg:
    //             m_logger->info("{} {}",fileAndLineLogStr.toStdString(),message.toStdString());
    //             break;
    //         case QtWarningMsg:
    //             m_logger->warn("{} {}",fileAndLineLogStr.toStdString(),message.toStdString());
    //             break;
    //         case QtCriticalMsg:
    //             m_logger->critical("{} {}",fileAndLineLogStr.toStdString(),message.toStdString());
    //             break;
    //         case QtFatalMsg:
    //             m_logger->error("{} {}",fileAndLineLogStr.toStdString(),message.toStdString());
    //             break;
    //     }
    // }
}

void Log::setup(char *argv[], const QString &app, int level)
{
    Q_ASSERT(!app.isEmpty());
    if (app.isEmpty())
    {
        return;
    }
    g_logLevel = level;
    static bool once = false;
    if (once)
    {
        return;
    }
    QString applicationPath = QString::fromStdString(argv[0]);
    once = true;
    g_app = app;
    const QString logFileName =
        QString("%1_%2.log").arg(g_app, QDateTime::currentDateTime().toString("yyyyMMdd"));
    const QString logDirPath =
        QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation) + "/log";
    const QDir logDir(logDirPath);
    if (!logDir.exists())
    {
        logDir.mkpath(logDirPath);
    }
    g_file_path = logDir.filePath(logFileName);
    qInstallMessageHandler(messageHandler);
    qDebug() << "===================================================";
    qDebug() << "[AppName]" << g_app;
    qDebug() << "[AppVersion]" << PROJECT_TAG_VERSION;
    qDebug() << "[AppPath]" << applicationPath;
    qDebug() << "[QtVersion]" << QT_VERSION_STR;
#ifdef WIN32
    qDebug() << "[ProcessId]" << QString::number(_getpid());
#else
    qDebug() << "[ProcessId]" << QString::number(getpid());
#endif
    qDebug() << "[DeviceInfo]";
    qDebug() << "  [DeviceId]" << QSysInfo::machineUniqueId();
    qDebug() << "  [Manufacturer]" << prettyProductInfoWrapper();
    qDebug() << "  [CPU_ABI]" << QSysInfo::currentCpuArchitecture();
    // qDebug() << "[LOG_LEVEL]" << g_logLevel;
    // qDebug() << "[LOG_PATH]" << g_file_path;
    qDebug() << "===================================================";
}

LogRecordManager::LogRecordManager(QObject *parent) : QObject(parent)
{
}

LogRecordManager::~LogRecordManager() = default;
