#include "InputBackgroundImpl.h"

#include <QPainterPath>

InputBackgroundImpl::InputBackgroundImpl() {
    connect(this, &InputBackgroundImpl::defaultColorChanged, [this] { this->update(); });
    connect(this, &InputBackgroundImpl::targetActiveFocusChanged, [this] { this->update(); });
    connect(this, &InputBackgroundImpl::offsetYChanged, [this] { this->update(); });
    connect(this, &InputBackgroundImpl::endColorChanged, [this] { this->update(); });
    connect(this, &InputBackgroundImpl::borderWidthChanged, [this] { this->update(); });
    connect(this, &InputBackgroundImpl::gradientHeightChanged, [this] { this->update(); });
}

void InputBackgroundImpl::paint(QPainter *painter) {
    painter->save();
    painter->setRenderHint(QPainter::Antialiasing, true);
    QRectF rect(0, 0, width(), height());
    QLinearGradient gradient(0, height() - m_gradientHeight, 0, height());
    gradient.setColorAt(0, m_defaultColor);
    if (m_targetActiveFocus) {
        gradient.setColorAt(0.01, m_endColor);
    }
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
                     height() - 2 * m_borderWidth - m_offsetY);
    QPainterPath innerPath;
    innerPath.addRoundedRect(innerRect, outerRadius, outerRadius);
    painter->drawPath(innerPath);
    painter->restore();
}
