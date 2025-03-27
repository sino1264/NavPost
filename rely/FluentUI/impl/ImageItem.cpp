#include "ImageItem.h"

ImageItem::ImageItem(QQuickItem *parent) : QQuickPaintedItem(parent) {
    connect(this, &ImageItem::sourceChanged, this, [=]() { update(); });
}

void ImageItem::paint(QPainter *painter) {
    painter->save();
    painter->drawImage(boundingRect(), m_source);
    painter->restore();
}
