#pragma once

#include <QObject>
#include <QtQml/qqml.h>
#include <QRandomGenerator>
#include "stdafx.h"

class FileTreeDataController : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QList<QVariantMap>, data)
    QML_ELEMENT
public:
    explicit FileTreeDataController(QObject *parent = nullptr);
    Q_SIGNAL void loadDataStart();
    Q_SIGNAL void loadDataSuccess();
    Q_INVOKABLE void loadData(const QString &path = "0", int level = 4);
    Q_INVOKABLE QVariantMap generateRowData();

private:
    QList<QVariantMap> dig(const QString &path, int level);
};
