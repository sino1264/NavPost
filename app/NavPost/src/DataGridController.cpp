#include "DataGridController.h"

#include <QThreadPool>

DataGridController::DataGridController(QObject *parent) : QObject{parent}
{
}

void DataGridController::loadData(int count)
{
    QThreadPool::globalInstance()->start([=]()
                                         {
        Q_EMIT loadDataStart();
        m_data.clear();
        for (int i = 0; i < count; i++) {
            m_data.append(generateRowData());
        }
        Q_EMIT loadDataSuccess(); });
}

QVariantMap DataGridController::generateRowData()
{
    return {
        {"name", m_names.at(QRandomGenerator::global()->bounded(m_names.size()))},
        {"age", QRandomGenerator::global()->bounded(20, 60)},
        {"address", m_addresses.at(QRandomGenerator::global()->bounded(m_addresses.size()))},
        {"avatar", m_avatars.at(QRandomGenerator::global()->bounded(m_avatars.size()))},
        {"description",
         m_descriptions.at(QRandomGenerator::global()->bounded(m_descriptions.size()))},
        // {"height", 25},
        // {"minimumHeight", 10},
        // {"maximumHeight", 240},
    };
}
