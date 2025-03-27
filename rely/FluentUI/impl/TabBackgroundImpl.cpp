#include "TabBackgroundImpl.h"

#include <QPainterPath>

TabBackgroundImpl::TabBackgroundImpl() {
    setClip(false);
    connect(this, &TabBackgroundImpl::colorChanged, [this] { this->update(); });
    connect(this, &TabBackgroundImpl::strokeColorChanged, [this] { this->update(); });
    connect(this, &TabBackgroundImpl::radiusChanged, [this] { this->update(); });
    m_radius = 8;
}

void TabBackgroundImpl::paint(QPainter *painter) {
    painter->save();
    painter->setRenderHint(QPainter::Antialiasing);
    QPen pen(m_strokeColor);
    pen.setWidth(1);
    painter->setPen(pen);
    painter->setBrush(m_color);
    QPainterPath path;
    path.moveTo(m_radius, m_radius);
    path.arcTo(QRectF(m_radius, 0, 2 * m_radius, 2 * m_radius), 180, -90);
    path.lineTo(width() - m_radius * 2, 0);
    path.arcTo(QRectF(width() - 3 * m_radius, 0, 2 * m_radius, 2 * m_radius), 90, -90);
    path.lineTo(width() - m_radius, height() - m_radius);
    path.arcTo(QRectF(width() - m_radius, height() - 2 * m_radius, 2 * m_radius, 2 * m_radius), 180,
               90);
    path.lineTo(0, height());
    path.arcTo(QRectF(-m_radius, height() - 2 * m_radius, 2 * m_radius, 2 * m_radius), -90, 90);
    path.closeSubpath();
    painter->drawPath(path);
    pen.setColor(m_color);
    pen.setWidth(2);
    painter->setPen(pen);
    painter->drawLine(QLine(5, height(), width() - 5, height()));
    painter->restore();
}
