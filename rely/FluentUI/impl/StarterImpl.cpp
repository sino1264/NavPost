#include "StarterImpl.h"

#include <QGuiApplication>
#include <QBuffer>
#include <QDebug>
#include <QDateTime>
#include <QJsonDocument>
#include <QJSEngine>
#include "Resource.h"

StarterImpl::StarterImpl(QObject *parent) : QObject{parent} {
}

void StarterImpl::timerEvent(QTimerEvent *event) {
    handleData();
}

void StarterImpl::init(QLocale locale) {
    Resource::getInstance()->init(this);
    if (m_translator.load(QString::fromStdString("%1/%2_%3.qm")
                              .arg(":/qt/qml/FluentUI", "FluentUI", locale.name()))) {
        QGuiApplication::installTranslator(&m_translator);
    }
}

void StarterImpl::checkApplication(const QString &appId) {
    m_sharedMemory.setKey(appId);
    if (m_sharedMemory.create(1024)) {
        writeData();
        startTimer(500);
    } else {
        writeData();
        std::exit(0);
    }
}

void StarterImpl::handleData() {
    lock();
    auto pSharedMemoryData = static_cast<char *>(m_sharedMemory.data());
    unlock();
    auto data = QJsonDocument::fromJson(pSharedMemoryData).toVariant().toMap();
    if (data["timestamp"] != m_data["timestamp"]) {
        Q_EMIT handleDataChanged(data["args"].toString());
        m_data = data;
    }
}

void StarterImpl::writeData() {
    m_sharedMemory.attach();
    lock();
    QMap<QString, QVariant> data;
    data["timestamp"] = QString::number(QDateTime::currentMSecsSinceEpoch());
    data["args"] = QGuiApplication::arguments().join("&");
    if (m_data.isEmpty()) {
        m_data = data;
    }
    auto byteArray = QJsonDocument::fromVariant(data).toJson(QJsonDocument::Compact);
    if (byteArray.size() > 1024) {
        qCritical() << "Data size is" << byteArray.size()
                    << "bytes, which exceeds the limit of 1024 bytes.";
        return;
    }
    auto pSharedMemoryData = static_cast<char *>(m_sharedMemory.data());
    memset(pSharedMemoryData, 0, m_sharedMemory.size());
    memcpy(pSharedMemoryData, byteArray.constData(), byteArray.size());
    unlock();
}

void StarterImpl::lock() {
#ifndef __EMSCRIPTEN__
    m_sharedMemory.lock();
#endif
}

void StarterImpl::unlock() {
#ifndef __EMSCRIPTEN__
    m_sharedMemory.unlock();
#endif
}
