#include "RoundRectangle.h"
#include <QPainterPath>

RoundRectangle::RoundRectangle(QQuickItem *parent) : QQuickPaintedItem(parent) {
    color(QColor(255, 255, 255, 255));
    radius({0, 0, 0, 0});
    connect(this, &RoundRectangle::colorChanged, this, [=] { update(); });
    connect(this, &RoundRectangle::radiusChanged, this, [=] { update(); });
}

void RoundRectangle::paint(QPainter *painter) {
    painter->save();
    painter->setRenderHint(QPainter::Antialiasing, true);
    QPainterPath path;
    QRectF rect = boundingRect();
    path.moveTo(rect.bottomRight() - QPointF(0, m_radius[2]));
    path.lineTo(rect.topRight() + QPointF(0, m_radius[1]));
    path.arcTo(QRectF(QPointF(rect.topRight() - QPointF(m_radius[1] * 2, 0)),
                      QSize(m_radius[1] * 2, m_radius[1] * 2)),
               0, 90);
    path.lineTo(rect.topLeft() + QPointF(m_radius[0], 0));
    path.arcTo(QRectF(QPointF(rect.topLeft()), QSize(m_radius[0] * 2, m_radius[0] * 2)), 90, 90);
    path.lineTo(rect.bottomLeft() - QPointF(0, m_radius[3]));
    path.arcTo(QRectF(QPointF(rect.bottomLeft() - QPointF(0, m_radius[3] * 2)),
                      QSize(m_radius[3] * 2, m_radius[3] * 2)),
               180, 90);
    path.lineTo(rect.bottomRight() - QPointF(m_radius[2], 0));
    path.arcTo(QRectF(QPointF(rect.bottomRight() - QPointF(m_radius[2] * 2, m_radius[2] * 2)),
                      QSize(m_radius[2] * 2, m_radius[2] * 2)),
               270, 90);
    painter->fillPath(path, m_color);
    painter->restore();
}
