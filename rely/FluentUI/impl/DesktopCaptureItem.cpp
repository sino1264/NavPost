#include "DesktopCaptureItem.h"
#include <QPainterPath>
#include <QQuickWindow>
#include "Tools.h"

DesktopCaptureItem::DesktopCaptureItem(QQuickItem *parent) : QQuickPaintedItem(parent) {
    setAcceptedMouseButtons(Qt::AllButtons);
    setAcceptHoverEvents(true);
}

void DesktopCaptureItem::paint(QPainter *painter) {
    painter->save();
    painter->drawImage(0, 0, m_desktop);
    painter->restore();
}

void DesktopCaptureItem::hoverMoveEvent(QHoverEvent *event) {
    updateTarget(event->position());
}

void DesktopCaptureItem::hoverEnterEvent(QHoverEvent *event) {
    updateTarget(event->position());
}

void DesktopCaptureItem::updateTarget(QPointF point) {
    this->position(point.toPoint());
    int x = point.x() - 20;
    int y = point.y() - 20;
    int width = 40;
    int height = 40;
    auto ratio = window()->devicePixelRatio();
    target(m_desktop.copy(x * ratio, y * ratio, width * ratio, height * ratio));
    color(m_target.pixelColor(20 * ratio, 20 * ratio));
}

void DesktopCaptureItem::capture() {
    desktop(Tools::getInstance()->captureDesktop());
    update();
}
