#include "DataGridModel.h"

DataGridModel::DataGridModel(QObject *parent) : QAbstractListModel{parent} {
    connect(this, &DataGridModel::sourceDataChanged, this, [=] {
        if (!m_sourceData.isEmpty()) {
            updateValues(m_sourceData.at(0));
        }
        beginResetModel();
        endResetModel();
        emit countChanged();
    });
}

int DataGridModel::rowCount(const QModelIndex &parent) const {
    return m_sourceData.count();
}

int DataGridModel::count() const {
    return m_sourceData.count();
}

QVariant DataGridModel::data(const QModelIndex &index, int role) const {
    QVariant v;
    if (index.row() >= count() || index.row() < 0)
        return v;
    v = m_sourceData[index.row()].toMap().value(m_roles[role]);
    return v;
}

bool DataGridModel::move(int from, int to, int n) {
    if (from < 0 || from >= count() || to < 0 || to >= count() || n <= 0 || (from + n) > count()) {
        return false;
    }
    beginMoveRows(QModelIndex(), from, from + n - 1, QModelIndex(), to > from ? to + n : to);
    if (from > to) {
        int tfrom = from;
        int tto = to;
        from = tto;
        to = tto + n;
        n = tfrom - tto;
    }
    QList<QVariant> store;
    for (int i = 0; i < (to - from); ++i)
        store.append(m_sourceData[from + n + i]);
    for (int i = 0; i < n; ++i)
        store.append(m_sourceData[from + i]);
    for (int i = 0; i < store.count(); ++i)
        m_sourceData[from + i] = store[i];
    endMoveRows();
    return true;
}

bool DataGridModel::remove(int index, int count) {
    if (index < 0 || index > this->count() || this->count() <= 0) {
        return false;
    }
    beginRemoveRows(QModelIndex(), index, index + count - 1);
    m_sourceData = m_sourceData.mid(0, index) + m_sourceData.mid(index + count);
    endRemoveRows();
    return true;
}

bool DataGridModel::setData(const QModelIndex &index, const QVariant &value, int role) {
    const int row = index.row();
    if (row >= count() || row < 0)
        return false;
    const QByteArray property = m_roles.at(role).toUtf8();
    QMap<QString, QVariant> map = m_sourceData[row].toMap();
    map[property] = value;
    m_sourceData[row] = map;
    emitItemsChanged(row, 1, QVector<int>(1, role));
    return true;
}

void DataGridModel::emitItemsChanged(int index, int count, const QVector<int> &roles) {
    if (count <= 0)
        return;
    emit dataChanged(this->index(index), this->index(index + count - 1), roles);
}

QHash<int, QByteArray> DataGridModel::roleNames() const {
    QHash<int, QByteArray> roleNames;
    for (int i = 0; i < m_roles.size(); ++i) {
        roleNames.insert(i, m_roles.at(i).toUtf8());
    }
    return roleNames;
}

void DataGridModel::clear() {
    beginResetModel();
    m_sourceData.clear();
    endResetModel();
}

void DataGridModel::insertRole(const QString &name) {
    int roleIndex = m_roles.indexOf(name);
    if (roleIndex == -1) {
        m_roles.append(name);
    }
}

void DataGridModel::updateValues(const QVariant &val) {
    m_roles.clear();
    insertRole("height");
    insertRole("minimumHeight");
    insertRole("maximumHeight");
    auto object = val.toMap();
    for (auto it = object.cbegin(), end = object.cend(); it != end; ++it) {
        insertRole(it.key());
    }
}

void DataGridModel::append(QJSValue data) {
    if (data.isArray()) {
        auto list = data.toVariant().toList();
        if (!list.isEmpty()) {
            updateValues(list.at(0));
            beginInsertRows(QModelIndex(), count(), count() + list.count() - 1);
            m_sourceData.append(list);
            endInsertRows();
            emit countChanged();
        }
    } else {
        insert(rowCount(), data);
    }
}

bool DataGridModel::insert(int index, QJSValue data) {
    if (index < 0 || index > count()) {
        return false;
    }
    auto object = data.toVariant();
    updateValues(object);
    beginInsertRows(QModelIndex(), index, index);
    m_sourceData.insert(index, object);
    endInsertRows();
    emit countChanged();
    return true;
}

QVariant DataGridModel::get(int index) {
    if (index < 0 || index > count() || count() <= 0) {
        return {};
    }
    return m_sourceData[index];
}

bool DataGridModel::set(int index, QJSValue data) {
    if (index < 0 || index > count() || count() <= 0) {
        return false;
    }
    auto object = data.toVariant();
    m_sourceData[index] = object;
    emit dataChanged(createIndex(index, 0), createIndex(index, 0));
    return true;
}

void DataGridModel::removeItems(const QModelIndexList &list) {
    QModelIndexList sortedList = list;
    std::sort(sortedList.begin(), sortedList.end(),
              [](const QModelIndex &a, const QModelIndex &b) { return a.row() > b.row(); });
    if (sortedList.length() > 50) {
        beginResetModel();
        for (const QModelIndex &index : sortedList) {
            int row = index.row();
            m_sourceData.removeAt(row);
        }
        endResetModel();
    } else {
        for (const QModelIndex &index : sortedList) {
            int row = index.row();
            beginRemoveRows(QModelIndex(), row, row);
            m_sourceData.removeAt(row);
            endRemoveRows();
        }
    }
}

void DataGridModel::selectRange(QItemSelectionModel *selectionModel, int startRow, int endRow) {
    if (!selectionModel) {
        return;
    }
    QModelIndex topLeft = index(startRow, 0);
    QModelIndex bottomRight = index(endRow, 0);
    QItemSelection selection(topLeft, bottomRight);
    selectionModel->select(selection, QItemSelectionModel::Select | QItemSelectionModel::Rows);
}
