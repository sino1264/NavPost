#include "Resource.h"

#include <QGuiApplication>
#include <QPalette>

Resource::Resource(QObject *parent) : QObject{parent} {
    m_systemDark = getSystemDark();
    QGuiApplication::instance()->installEventFilter(this);
}

bool Resource::eventFilter(QObject *, QEvent *event) {
    if (event->type() == QEvent::ApplicationPaletteChange || event->type() == QEvent::ThemeChange) {
        bool dark = getSystemDark();
        if (m_systemDark != dark) {
            m_systemDark = dark;
            Q_EMIT systemDarkChanged();
            event->accept();
        }
        return true;
    }
    return false;
}

bool Resource::getSystemDark() {
    QPalette palette = QGuiApplication::palette();
    QColor color = palette.color(QPalette::Window).rgb();
    return color.red() * 0.2126 + color.green() * 0.7152 + color.blue() * 0.0722 <= 255.0f / 2;
}

void Resource::init(QObject *obj) {
    m_engine = qmlEngine(obj);
    m_baseUrl = m_engine->baseUrl().toString();
}

QString Resource::resolvedUrl(const QString &path) {
    if (m_engine == nullptr) {
        return path;
    }
    return m_baseUrl + path;
}
