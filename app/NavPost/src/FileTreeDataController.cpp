#include "FileTreeDataController.h"

#include <QThreadPool>

FileTreeDataController::FileTreeDataController(QObject *parent) : QObject{parent}
{
}

QList<QVariantMap> FileTreeDataController::dig(const QString &path, int level)
{
    QList<QVariantMap> list;
    for (int i = 0; i < 5; ++i)
    {
        QString key = path + "-" + QString::number(i);
        auto rowData = generateRowData();
        rowData.insert("key", key);
        if (level > 0)
        {
            rowData.insert("children", QVariant::fromValue(dig(key, level - 1)));
        }
        list.append(rowData);
    }
    return list;
}

void FileTreeDataController::loadData(const QString &path, int level)
{
    QThreadPool::globalInstance()->start([=]()
                                         {
        Q_EMIT loadDataStart();
        m_data.clear();
        m_data = dig(path, level);
        Q_EMIT loadDataSuccess(); });
}

QVariantMap FileTreeDataController::generateRowData()
{
    return {
        {"height", 36},
        {"minimumHeight", 36},
        {"maximumHeight", 36},
        {"expanded", true},
    };
}
