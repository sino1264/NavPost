#include "ControlBackgroundImpl.h"

#include <QPainterPath>

ControlBackgroundImpl::ControlBackgroundImpl() {
    connect(this, &ControlBackgroundImpl::radiusChanged, [this] { this->update(); });
    connect(this, &ControlBackgroundImpl::defaultColorChanged, [this] { this->update(); });
    connect(this, &ControlBackgroundImpl::secondaryColorChanged, [this] { this->update(); });
    connect(this, &ControlBackgroundImpl::endColorChanged, [this] { this->update(); });
    connect(this, &ControlBackgroundImpl::borderWidthChanged, [this] { this->update(); });
}

void ControlBackgroundImpl::paint(QPainter *painter) {
    painter->save();
    painter->setRenderHint(QPainter::Antialiasing, true);
    QRectF rect(0, 0, width(), height());
    QLinearGradient gradient(0, height() - 3, 0, height());
    gradient.setColorAt(0, m_defaultColor);
    gradient.setColorAt(1, m_endColor);
    painter->setBrush(gradient);
    painter->setPen(Qt::NoPen);
    QPainterPath path;
    path.addRoundedRect(rect, m_radius, m_radius);
    painter->drawPath(path);
    int outerRadius =
        static_cast<int>((1.0 - static_cast<double>(m_borderWidth) / height()) * m_radius);
    painter->setCompositionMode(QPainter::CompositionMode_DestinationOut);
    painter->setBrush(Qt::black);
    QRectF innerRect(m_borderWidth, m_borderWidth, width() - 2 * m_borderWidth,
                     height() - 2 * m_borderWidth);
    QPainterPath innerPath;
    innerPath.addRoundedRect(innerRect, outerRadius, outerRadius);
    painter->drawPath(innerPath);
    painter->restore();
}
