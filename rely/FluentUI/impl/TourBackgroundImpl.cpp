#include "TourBackgroundImpl.h"

#include <QPainterPath>

TourBackgroundImpl::TourBackgroundImpl() {
    m_color = QColor(0, 0, 0, 0.3 * 255);
    connect(this, &TourBackgroundImpl::targetXChanged, [this] { this->update(); });
    connect(this, &TourBackgroundImpl::targetYChanged, [this] { this->update(); });
    connect(this, &TourBackgroundImpl::targetWidthChanged, [this] { this->update(); });
    connect(this, &TourBackgroundImpl::targetHeightChanged, [this] { this->update(); });
}

void TourBackgroundImpl::paint(QPainter *painter) {
    painter->save();
    painter->setRenderHint(QPainter::Antialiasing, true);
    painter->fillRect(boundingRect(), m_color);
    painter->setCompositionMode(QPainter::CompositionMode_Clear);
    QRect targetRect(m_targetX, m_targetY, m_targetWidth, m_targetHeight);
    drawRoundedRect(painter, targetRect, 4);
    painter->restore();
}

void TourBackgroundImpl::drawRoundedRect(QPainter *painter, const QRect &rect, int radius) {
    QPainterPath path;
    path.moveTo(rect.bottomRight() - QPointF(0, radius));
    path.lineTo(rect.topRight() + QPointF(0, radius));
    path.arcTo(
        QRectF(QPointF(rect.topRight() - QPointF(radius * 2, 0)), QSize(radius * 2, radius * 2)), 0,
        90);
    path.lineTo(rect.topLeft() + QPointF(radius, 0));
    path.arcTo(QRectF(QPointF(rect.topLeft()), QSize(radius * 2, radius * 2)), 90, 90);
    path.lineTo(rect.bottomLeft() - QPointF(0, radius));
    path.arcTo(
        QRectF(QPointF(rect.bottomLeft() - QPointF(0, radius * 2)), QSize(radius * 2, radius * 2)),
        180, 90);
    path.lineTo(rect.bottomRight() - QPointF(radius, 0));
    path.arcTo(QRectF(QPointF(rect.bottomRight() - QPointF(radius * 2, radius * 2)),
                      QSize(radius * 2, radius * 2)),
               270, 90);
    painter->fillPath(path, Qt::black);
}
