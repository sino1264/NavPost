#include "TreeDataGridModel.h"

TreeNode::TreeNode(QObject *parent) : QObject{parent} {
    m_depth = 0;
    m_expanded = true;
    m_nodeParent = nullptr;
}

bool TreeNode::hasChildren() {
    if (m_rowData.contains("children")) {
        return !m_rowData.value("children").toList().isEmpty();
    }
    return false;
}

void TreeNode::appendChildren(QSharedPointer<TreeNode> node) {
    m_nodeChildren.append(node);
}

void TreeNode::removeChildren(TreeNode *node) {
    m_nodeChildren.removeOne(node);
}

bool TreeNode::visible() {
    auto p = m_nodeParent;
    while (p) {
        if (!p->expanded()) {
            return false;
        }
        p = p->m_nodeParent;
    }
    return true;
}

TreeDataGridModel::TreeDataGridModel(QObject *parent) : QAbstractListModel{parent} {
    connect(this, &TreeDataGridModel::displayDataChanged, this, [=] {
        if (!m_displayData.isEmpty()) {
            updateValues(m_displayData.at(0)->rowData());
        }
        beginResetModel();
        endResetModel();
        emit countChanged();
    });
    connect(this, &TreeDataGridModel::sourceDataChanged, this, [=] { handleSourceData(); });
}

int TreeDataGridModel::rowCount(const QModelIndex &parent) const {
    return m_displayData.count();
}

int TreeDataGridModel::count() const {
    return m_displayData.count();
}

QVariant TreeDataGridModel::data(const QModelIndex &index, int role) const {
    QVariant v;
    if (index.row() >= count() || index.row() < 0)
        return v;
    const auto roleName = m_roles[role];
    auto node = m_displayData[index.row()];
    if (roleName == "depth") {
        return node->depth();
    } else if (roleName == "expanded") {
        return node->expanded();
    } else if (roleName == "hasChildren") {
        return node->hasChildren();
    } else {
        v = node->rowData().value(roleName);
    }
    return v;
}

bool TreeDataGridModel::setData(const QModelIndex &index, const QVariant &value, int role) {
    const int row = index.row();
    if (row >= count() || row < 0)
        return false;
    const auto roleName = m_roles[role];
    auto node = m_displayData[row];
    QMap<QString, QVariant> map = node->rowData();
    map[roleName] = value;
    m_displayData[row]->rowData(map);
    emitItemsChanged(row, 1, QVector<int>(1, role));
    return true;
}

void TreeDataGridModel::emitItemsChanged(int index, int count, const QVector<int> &roles) {
    if (count <= 0)
        return;
    emit dataChanged(this->index(index), this->index(index + count - 1), roles);
}

QHash<int, QByteArray> TreeDataGridModel::roleNames() const {
    QHash<int, QByteArray> roleNames;
    for (int i = 0; i < m_roles.size(); ++i)
        roleNames.insert(i, m_roles.at(i).toUtf8());
    return roleNames;
}

void TreeDataGridModel::clear() {
    beginResetModel();
    m_displayData.clear();
    endResetModel();
}

void TreeDataGridModel::insertRole(const QString &name) {
    int roleIndex = m_roles.indexOf(name);
    if (roleIndex == -1) {
        m_roles.append(name);
    }
}

void TreeDataGridModel::updateValues(const QVariant &val) {
    m_roles.clear();
    insertRole("height");
    insertRole("minimumHeight");
    insertRole("maximumHeight");
    insertRole("hasChildren");
    insertRole("depth");
    insertRole("expanded");
    auto object = val.toMap();
    for (auto it = object.cbegin(), end = object.cend(); it != end; ++it) {
        insertRole(it.key());
    }
}

QVariant TreeDataGridModel::get(int index) {
    if (index < 0 || index > count() || count() <= 0) {
        return {};
    }
    return m_displayData[index]->rowData();
}

QList<QVariant> TreeDataGridModel::reverseList(const QList<QVariant> &originalList) {
    QList<QVariant> reversedList;
    for (int i = originalList.size() - 1; i >= 0; --i) {
        reversedList.append(originalList.at(i));
    }
    return reversedList;
}

void TreeDataGridModel::handleSourceData() {
    if (m_sourceData.isEmpty()) {
        clear();
        return;
    }
    m_treeRoot = QSharedPointer<TreeNode>(new TreeNode());
    QList<QSharedPointer<TreeNode>> treeData;
    QList<QVariant> reverseData = reverseList(sourceData());
    while (reverseData.count() > 0) {
        auto data = reverseData.at(reverseData.count() - 1).toMap();
        reverseData.pop_back();
        auto node = QSharedPointer<TreeNode>(new TreeNode(this));
        node->rowData(data);
        node->expanded(data.value("expanded").toBool());
        node->nodeParent(data.value("__parent").value<TreeNode *>());
        node->depth(data.value("__depth").toInt(0));
        if (node->nodeParent()) {
            node->nodeParent()->appendChildren(node);
        } else {
            node->nodeParent(m_treeRoot.get());
            m_treeRoot->appendChildren(node);
        }
        if (data.contains("children")) {
            QList<QVariant> children = data.value("children").toList();
            if (!children.isEmpty()) {
                QList<QVariant> reverseChildren = reverseList(children);
                for (int i = 0; i <= reverseChildren.count() - 1; ++i) {
                    auto child = reverseChildren.at(i).toMap();
                    child.insert("__depth", data.value("__depth").toInt(0) + 1);
                    child.insert("__parent", QVariant::fromValue(node.get()));
                    reverseData.append(child);
                }
            }
        }
        if (node->nodeParent()->expanded()) {
            treeData.append(node);
        }
    }
    clear();
    displayData(treeData);
}

void TreeDataGridModel::collapse(int rowIndex) {
    auto data = m_displayData.at(rowIndex);
    if (!data->expanded()) {
        return;
    }
    data->expanded(false);
    Q_EMIT dataChanged(index(rowIndex, 0), index(rowIndex, 0));
    int removeCount = 0;
    for (int i = rowIndex + 1; i < m_displayData.count(); i++) {
        auto obj = m_displayData[i];
        if (obj->depth() <= data->depth()) {
            break;
        }
        removeCount = removeCount + 1;
    }
    __removeRows(rowIndex + 1, removeCount);
}

void TreeDataGridModel::expand(int rowIndex) {
    auto data = m_displayData.at(rowIndex);
    if (data->expanded()) {
        return;
    }
    data->expanded(true);
    Q_EMIT dataChanged(index(rowIndex, 0), index(rowIndex, 0));
    QList<QSharedPointer<TreeNode>> nodeData;
    QList<QSharedPointer<TreeNode>> stack = data->nodeChildren();
    std::reverse(stack.begin(), stack.end());
    while (stack.count() > 0) {
        auto node = stack.at(stack.count() - 1);
        stack.pop_back();
        if (node->visible()) {
            nodeData.append(node);
        }
        QList<QSharedPointer<TreeNode>> children = node->nodeChildren();
        if (!children.isEmpty()) {
            std::reverse(children.begin(), children.end());
            foreach (auto c, children) {
                stack.append(c);
            }
        }
    }
    __insertRows(rowIndex + 1, nodeData);
}


void TreeDataGridModel::__removeRows(int rowIndex, int count) {
    if (rowIndex < 0 || rowIndex + count > m_displayData.size() || count == 0)
        return;
    beginRemoveRows(QModelIndex(), rowIndex, rowIndex + count - 1);
    QList<QSharedPointer<TreeNode>> firstPart = m_displayData.mid(0, rowIndex);
    QList<QSharedPointer<TreeNode>> secondPart = m_displayData.mid(rowIndex + count);
    m_displayData.clear();
    m_displayData.append(firstPart);
    m_displayData.append(secondPart);
    endRemoveRows();
}

void TreeDataGridModel::__insertRows(int rowIndex, QList<QSharedPointer<TreeNode>> data) {
    if (rowIndex < 0 || rowIndex > m_displayData.size() || data.empty())
        return;
    beginInsertRows(QModelIndex(), rowIndex, rowIndex + data.size() - 1);
    QList<QSharedPointer<TreeNode>> firstPart = m_displayData.mid(0, rowIndex);
    QList<QSharedPointer<TreeNode>> secondPart = m_displayData.mid(rowIndex);
    m_displayData.clear();
    m_displayData.append(firstPart);
    m_displayData.append(data);
    m_displayData.append(secondPart);
    endInsertRows();
}

void TreeDataGridModel::selectRange(QItemSelectionModel *selectionModel, int startRow, int endRow) {
    if (!selectionModel) {
        return;
    }
    QModelIndex topLeft = index(startRow, 0);
    QModelIndex bottomRight = index(endRow, 0);
    QItemSelection selection(topLeft, bottomRight);
    selectionModel->select(selection, QItemSelectionModel::Select | QItemSelectionModel::Rows);
}
