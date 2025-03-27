#include "WatermarkImpl.h"

WatermarkImpl::WatermarkImpl(QQuickItem *parent) : QQuickPaintedItem(parent) {
    m_gap = QPoint(100, 100);
    m_offset = QPoint(m_gap.x() / 2, m_gap.y() / 2);
    m_rotate = 22;
    m_textColor = QColor(222, 222, 222, 222);
    m_textSize = 16;
    connect(this, &WatermarkImpl::textColorChanged, this, [=] { update(); });
    connect(this, &WatermarkImpl::gapChanged, this, [=] { update(); });
    connect(this, &WatermarkImpl::offsetChanged, this, [=] { update(); });
    connect(this, &WatermarkImpl::textChanged, this, [=] { update(); });
    connect(this, &WatermarkImpl::rotateChanged, this, [=] { update(); });
    connect(this, &WatermarkImpl::textSizeChanged, this, [=] { update(); });
}

void WatermarkImpl::paint(QPainter *painter) {
    QFont font;
    font.setPixelSize(m_textSize);
    painter->setFont(font);
    painter->setPen(m_textColor);
    QFontMetricsF fontMetrics(font);
    qreal fontWidth = fontMetrics.horizontalAdvance(m_text);
    qreal fontHeight = fontMetrics.height();
    int stepX = qRound(fontWidth + m_gap.x());
    int stepY = qRound(fontHeight + m_gap.y());
    int rowCount = qRound(width() / stepX + 1);
    int colCount = qRound(height() / stepY + 1);
    for (int r = 0; r < rowCount; r++) {
        for (int c = 0; c < colCount; c++) {
            qreal centerX = stepX * r + m_offset.x() + fontWidth / 2.0;
            qreal centerY = stepY * c + m_offset.y() + fontHeight / 2.0;
            painter->save();
            painter->translate(centerX, centerY);
            painter->rotate(m_rotate);
            painter->drawText(QRectF(-fontWidth / 2.0, -fontHeight / 2.0, fontWidth, fontHeight),
                              m_text);
            painter->restore();
        }
    }
}
