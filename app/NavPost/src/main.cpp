#include "AppInfo.h"
#include "Log.h"
#include "SettingsHelper.h"
#include <QGuiApplication>
#include <QProcess>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QtQml/qqmlextensionplugin.h>
#include <QFont>
#include "Version.h"
// #include "module/module.hpp"
#include "frame.hpp"
#include "NavPost.h"

// #include <QtWebEngineQuick/qtwebenginequickglobal.h>
#include <spdlog/sinks/stdout_sinks.h>
#include <spdlog/sinks/daily_file_sink.h>

#ifdef FLUENTUI_BUILD_STATIC_LIB
Q_IMPORT_QML_PLUGIN(FluentUIPlugin)
#endif

int main(int argc, char *argv[])
{
    // 初始化日志系统
    std::vector<spdlog::sink_ptr> sinks;
    // 输出到Record
    sinks.push_back(std::make_shared<RecordSink<std::mutex>>("default"));
    // 输出到控制台
    sinks.push_back(std::make_shared<spdlog::sinks::stdout_sink_mt>());
    // 输出到文件
    sinks.push_back(std::make_shared<spdlog::sinks::daily_file_sink_mt>("logs/Info_log.log", 0, 0));
    // 把所有sink放入logger
    auto logger = std::make_shared<spdlog::logger>("log", begin(sinks), end(sinks));

    spdlog::set_default_logger(logger);

    spdlog::set_level(spdlog::level::debug);
    spdlog::flush_on(spdlog::level::debug);

    // 设置环境变量
    qputenv("QT_QUICK_CONTROLS_STYLE", "FluentUI");

    // 设置程序的基本信息
    QGuiApplication::setApplicationName(EXE_APPLICATION_NAME);
    QGuiApplication::setApplicationDisplayName(EXE_APPLICATION_DISPLAY_NAME);
    QGuiApplication::setApplicationVersion(EXE_APPLICATION_VERSION);
    QGuiApplication::setOrganizationName(EXE_ORGANIZATION_NAME);
    QGuiApplication::setOrganizationDomain(EXE_ORGANIZATION_DOMAIN);

    // 初始化WebEngine
    QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts);
    // QtWebEngineQuick::initialize();

    // 初始化日志，传入可执行程序路径和应用程序名称
    Log::setup(argv, EXE_APPLICATION_DISPLAY_NAME);
    // 初始化保存设置和读取设置的实例
    SettingsHelper::getInstance()->init(argv);

    QGuiApplication app(argc, argv);

#ifdef Q_OS_WIN
    QFont font = QGuiApplication::font();
    font.setFamily("微软雅黑");
    QGuiApplication::setFont(font);
#endif
    // QGuiApplication::setWindowIcon(QIcon(":/qt/qml/Gallery/res/image/logo.png"));

    QQmlApplicationEngine engine;

    Register_qml_frame_define(engine.rootContext()); // 注册宏定义、枚举类型到qml中
    // qmlRegisterSingletonInstance("NavPost", 1, 0, "LogRecordManager", LogRecordManager::getInstance());

    engine.addImportPath(":/qt/qml");

    AppInfo::getInstance()->init(&engine);

    const QUrl url(u"qrc:/qt/qml/NavPost/qml/App.qml"_qs);

    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreated, &app,
        [url](QObject *obj, const QUrl &objUrl)
        {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);

    engine.load(url);

    const int exec = QGuiApplication::exec();

    if (exec == 931)
    {
#ifndef __EMSCRIPTEN__
        QProcess::startDetached(qApp->applicationFilePath(), qApp->arguments());
#endif
    }

    return exec;
}
