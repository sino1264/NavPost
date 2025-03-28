#pragma once

#include <QObject>
#include <QFileSystemWatcher>
#include <QtQml/qqml.h>
#include "stdafx.h"

class FileWatcher : public QObject {
    Q_OBJECT
    Q_PROPERTY_AUTO(QString, path)
    QML_NAMED_ELEMENT(FileWatcher)
public:
    explicit FileWatcher(QObject *parent = nullptr);
    Q_SIGNAL void fileChanged();

private:
    void clean();
    void bindFilePath(QString path);

private:
    QFileSystemWatcher m_watcher;
};
