#pragma once

#include <QQuickItem>
#include <QQuickPaintedItem>
#include <QPainter>
#include "stdafx.h"

class RoundRectangle : public QQuickPaintedItem {
    Q_OBJECT
    Q_PROPERTY_AUTO(QColor, color)
    Q_PROPERTY_AUTO(QList<int>, radius)
    QML_NAMED_ELEMENT(RoundRectangle)
public:
    explicit RoundRectangle(QQuickItem *parent = nullptr);
    void paint(QPainter *painter) override;
};
