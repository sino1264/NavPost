#include "QRCodeImpl.h"

#include "qrcode/qrencode.h"

QRCodeImpl::QRCodeImpl(QQuickItem *parent) : QQuickPaintedItem(parent) {
    m_color = QColor(0, 0, 0, 255);
    m_backgroundColor = QColor(255, 255, 255, 255);
    m_size = 100;
    setWidth(m_size);
    setHeight(m_size);
    connect(this, &QRCodeImpl::textChanged, this, [=] { update(); });
    connect(this, &QRCodeImpl::colorChanged, this, [=] { update(); });
    connect(this, &QRCodeImpl::backgroundColorChanged, this, [=] { update(); });
    connect(this, &QRCodeImpl::sizeChanged, this, [=] {
        setWidth(m_size);
        setHeight(m_size);
        update();
    });
}

void QRCodeImpl::paint(QPainter *painter) {
    if (m_text.isEmpty()) {
        return;
    }
    if (m_text.length() > 1024) {
        return;
    }
    painter->save();
    QRcode *qrcode =
        QRcode_encodeString(m_text.toUtf8().constData(), 2, QR_ECLEVEL_Q, QR_MODE_8, 1);
    auto w = qint32(width());
    auto h = qint32(height());
    qint32 qrcodeW = qrcode->width > 0 ? qrcode->width : 1;
    double scaleX = (double) w / (double) qrcodeW;
    double scaleY = (double) h / (double) qrcodeW;
    QImage image = QImage(w, h, QImage::Format_ARGB32);
    QPainter p(&image);
    p.setBrush(m_backgroundColor);
    p.setPen(Qt::NoPen);
    p.drawRect(0, 0, w, h);
    p.setBrush(m_color);
    for (qint32 y = 0; y < qrcodeW; y++) {
        for (qint32 x = 0; x < qrcodeW; x++) {
            unsigned char b = qrcode->data[y * qrcodeW + x];
            if (b & 0x01) {
                QRectF r(x * scaleX, y * scaleY, scaleX, scaleY);
                p.drawRects(&r, 1);
            }
        }
    }
    QPixmap pixmap = QPixmap::fromImage(image);
    painter->drawPixmap(QRect(0, 0, static_cast<int>(width()), static_cast<int>(height())), pixmap);
    painter->restore();
}
