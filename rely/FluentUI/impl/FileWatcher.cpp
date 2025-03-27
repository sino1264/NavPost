#include "FileWatcher.h"

FileWatcher::FileWatcher(QObject *parent) : QObject{parent} {
    connect(&m_watcher, &QFileSystemWatcher::fileChanged, this, [=](const QString &path) {
        Q_EMIT fileChanged();
        clean();
        bindFilePath(m_path);
    });
    connect(this, &FileWatcher::pathChanged, this, [=]() {
        clean();
        bindFilePath(m_path);
    });
    bindFilePath(m_path);
}

void FileWatcher::bindFilePath(QString path) {
    if (!path.isEmpty() && path.startsWith("file:///")) {
        int queryIndex = path.indexOf('?');
        if (queryIndex != -1) {
            path = path.left(queryIndex);
        }
        m_watcher.addPath(path.replace("file:///", ""));
    }
}

void FileWatcher::clean() {
    for (int i = 0; i <= m_watcher.files().size() - 1; ++i) {
        auto path = m_watcher.files().at(i);
        m_watcher.removePath(path);
    }
}
