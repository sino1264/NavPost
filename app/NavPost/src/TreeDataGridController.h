#pragma once

#include <QObject>
#include <QtQml/qqml.h>
#include <QRandomGenerator>
#include "stdafx.h"

class TreeDataGridController : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QList<QVariantMap>, data)
    QML_ELEMENT
public:
    explicit TreeDataGridController(QObject *parent = nullptr);
    Q_SIGNAL void loadDataStart();
    Q_SIGNAL void loadDataSuccess();
    Q_INVOKABLE void loadData(const QString &path = "0", int level = 4);
    Q_INVOKABLE QVariantMap generateRowData();

private:
    QList<QVariantMap> dig(const QString &path, int level);

private:
    QStringList m_names = {tr("John"), tr("Alice"), tr("Michael"), tr("Sophia"), tr("David"),
                           tr("Emma"), tr("Chris"), tr("Olivia"), tr("Daniel"), tr("Isabella")};
    QStringList m_addresses = {tr("123 Main St"), tr("456 Oak Ave"), tr("789 Pine Rd"),
                               tr("321 Maple Dr"), tr("654 Birch Ln")};
    QStringList m_avatars = {"qrc:/qt/qml/Gallery/res/image/avatar_1.svg",
                             "qrc:/qt/qml/Gallery/res/image/avatar_2.svg",
                             "qrc:/qt/qml/Gallery/res/image/avatar_3.svg",
                             "qrc:/qt/qml/Gallery/res/image/avatar_4.svg",
                             "qrc:/qt/qml/Gallery/res/image/avatar_5.svg",
                             "qrc:/qt/qml/Gallery/res/image/avatar_6.svg",
                             "qrc:/qt/qml/Gallery/res/image/avatar_7.svg",
                             "qrc:/qt/qml/Gallery/res/image/avatar_8.svg",
                             "qrc:/qt/qml/Gallery/res/image/avatar_9.svg",
                             "qrc:/qt/qml/Gallery/res/image/avatar_10.svg",
                             "qrc:/qt/qml/Gallery/res/image/avatar_11.svg",
                             "qrc:/qt/qml/Gallery/res/image/avatar_12.svg"};
    QStringList m_descriptions = {tr("A software engineer with a passion for coding."),
                                  tr("Loves outdoor activities and traveling."),
                                  tr("An artist who enjoys painting and sculpting."),
                                  tr("A teacher dedicated to inspiring students."),
                                  tr("A chef with a love for culinary experiments.")};
};
