#include "LineNumberModel.h"

#include <QQmlInfo>
#include <QTextBlock>

LineNumberModel::LineNumberModel(QObject *parent) : QAbstractListModel(parent) {
}

int LineNumberModel::lineCount() const {
    return m_lineCount;
}

void LineNumberModel::setLineCount(int lineCount) {
    if (lineCount < 0) {
        qmlWarning(this) << "lineCount must be greater than zero";
        return;
    }
    if (m_lineCount == lineCount)
        return;
    if (m_lineCount < lineCount) {
        beginInsertRows(QModelIndex(), m_lineCount, lineCount - 1);
        m_lineCount = lineCount;
        endInsertRows();
    } else if (m_lineCount > lineCount) {
        beginRemoveRows(QModelIndex(), lineCount, m_lineCount - 1);
        m_lineCount = lineCount;
        endRemoveRows();
    }
    emit lineCountChanged();
}

int LineNumberModel::rowCount(const QModelIndex &) const {
    return m_lineCount;
}

QVariant LineNumberModel::data(const QModelIndex &index, int role) const {
    if (!checkIndex(index) || role != Qt::DisplayRole)
        return {};
    return index.row();
}

int LineNumberModel::currentLineNumber(QQuickTextDocument *textDocument, int cursorPosition) {
    if (QTextDocument *td = textDocument->textDocument()) {
        QTextBlock tb = td->findBlock(cursorPosition);
        return tb.blockNumber();
    }
    return -1;
}
