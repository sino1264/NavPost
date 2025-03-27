#include "TreeDataGridController.h"

#include <QThreadPool>

TreeDataGridController::TreeDataGridController(QObject *parent) : QObject{parent}
{
}

QList<QVariantMap> TreeDataGridController::dig(const QString &path, int level)
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

void TreeDataGridController::loadData(const QString &path, int level)
{
    QThreadPool::globalInstance()->start([=]()
                                         {
        Q_EMIT loadDataStart();
        m_data.clear();
        m_data = dig(path, level);
        Q_EMIT loadDataSuccess(); });
}

QVariantMap TreeDataGridController::generateRowData()
{
    return {
        {"name", m_names.at(QRandomGenerator::global()->bounded(m_names.size()))},
        {"age", QRandomGenerator::global()->bounded(20, 60)},
        {"address", m_addresses.at(QRandomGenerator::global()->bounded(m_addresses.size()))},
        {"avatar", m_avatars.at(QRandomGenerator::global()->bounded(m_avatars.size()))},
        {"description",
         m_descriptions.at(QRandomGenerator::global()->bounded(m_descriptions.size()))},
        // {"height", 48},
        // {"minimumHeight", 40},
        // {"maximumHeight", 240},
        {"expanded", false},
    };
}
