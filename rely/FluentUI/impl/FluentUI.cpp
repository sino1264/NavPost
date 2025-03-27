#include "FluentUI.h"

#include <QSharedPointer>
GlobalConfig *FluentUI::config = nullptr;

static QByteArray resolveSetting(const QByteArray &env, const QSharedPointer<QSettings> &settings,
                                 const QString &name) {
    QByteArray value = qgetenv(env);

#if QT_CONFIG(settings)
    if (value.isNull() && !settings.isNull())
        value = settings->value(name).toByteArray();
#endif
    return value;
}

static QSharedPointer<QSettings> getSettings(const QString &group) {
#ifndef QT_NO_SETTINGS
    const QString filePath = qgetenv("QT_QUICK_CONTROLS_CONF");
    if (QFile::exists(filePath)) {
        QFileSelector selector;
        QSettings *settings = new QSettings(selector.select(filePath), QSettings::IniFormat);
        if (!group.isEmpty())
            settings->beginGroup(group);
        return QSharedPointer<QSettings>(settings);
    }
#endif
    Q_UNUSED(group)
    return QSharedPointer<QSettings>();
}

static void initGlobalConfig() {
    FluentUI::config = new GlobalConfig();
    QSharedPointer<QSettings> settings = getSettings(QStringLiteral("FluentUI"));
    QByteArray radiusValue =
        resolveSetting("QT_QUICK_CONTROLS_FLUENTUI_RADIUS", settings, QStringLiteral("Radius"));
    if (!radiusValue.isEmpty()) {
        FluentUI::config->radius = radiusValue.toInt();
    }
    QByteArray primaryColorValue = resolveSetting("QT_QUICK_CONTROLS_FLUENTUI_PRIMARYCOLOR",
                                                  settings, QStringLiteral("PrimaryColor"));
    if (!primaryColorValue.isEmpty()) {
        FluentUI::config->primaryColor = QString(primaryColorValue);
    }
    QByteArray highlightMoveDurationValue = resolveSetting(
        "QT_QUICK_CONTROLS_FLUENTUI_HIGHLIGHTMOVE", settings, QStringLiteral("HighlightMove"));
    if (!highlightMoveDurationValue.isEmpty()) {
        FluentUI::config->highlightMoveDuration = highlightMoveDurationValue.toInt();
    }
    QByteArray minimumHeightValue = resolveSetting("QT_QUICK_CONTROLS_FLUENTUI_MINIMUMHEIGHT",
                                                   settings, QStringLiteral("MinimumHeight"));
    if (!minimumHeightValue.isEmpty()) {
        FluentUI::config->minimumHeight = minimumHeightValue.toInt();
    }
}

void FluentUI::attachedParentChange(QQuickAttachedPropertyPropagator *newParent,
                                    QQuickAttachedPropertyPropagator *oldParent) {
    Q_UNUSED(oldParent);
    FluentUI *attached = qobject_cast<FluentUI *>(newParent);
    if (attached) {
        inheritDark(attached->dark());
        inheritPrimaryColor(attached->primaryColor());
    }
}

void FluentUI::setDark(const bool &val) {
    m_explicitDark = true;
    if (val == m_dark)
        return;
    m_dark = val;
    propagateDark();
    Q_EMIT darkChanged();
}

bool FluentUI::dark() const {
    return m_dark;
}

void FluentUI::inheritDark(const bool &val) {
    if (m_explicitDark || m_dark == val)
        return;
    m_dark = val;
    propagateDark();
    Q_EMIT darkChanged();
}

void FluentUI::resetDark() {
    if (!m_explicitDark)
        return;
    m_explicitDark = false;
    FluentUI *attached = qobject_cast<FluentUI *>(attachedParent());
    inheritDark(attached ? attached->dark() : config->dark);
}

void FluentUI::propagateDark() {
    const auto styles = attachedChildren();
    for (QQuickAttachedPropertyPropagator *child : styles) {
        FluentUI *attached = qobject_cast<FluentUI *>(child);
        if (attached) {
            attached->inheritDark(m_dark);
        }
    }
}

void FluentUI::setPrimaryColor(const QVariant &val) {
    m_explicitPrimaryColor = true;
    if (val == m_primaryColor)
        return;
    m_primaryColor = val;
    propagatePrimaryColor();
    Q_EMIT primaryColorChanged();
}

QVariant FluentUI::primaryColor() const {
    return m_primaryColor;
}

void FluentUI::inheritPrimaryColor(const QVariant &val) {
    if (m_explicitPrimaryColor || m_primaryColor == val)
        return;
    m_primaryColor = val;
    propagatePrimaryColor();
    Q_EMIT primaryColorChanged();
}

void FluentUI::resetPrimaryColor() {
    if (!m_explicitPrimaryColor)
        return;
    m_explicitPrimaryColor = false;
    FluentUI *attached = qobject_cast<FluentUI *>(attachedParent());
    inheritPrimaryColor(attached ? attached->primaryColor() : config->primaryColor);
}

void FluentUI::propagatePrimaryColor() {
    const auto styles = attachedChildren();
    for (QQuickAttachedPropertyPropagator *child : styles) {
        FluentUI *attached = qobject_cast<FluentUI *>(child);
        if (attached) {
            attached->inheritPrimaryColor(m_primaryColor);
        }
    }
}

FluentUI::FluentUI(QObject *parent) : QQuickAttachedPropertyPropagator{parent} {
    m_radius = config->radius;
    m_highlightMoveDuration = config->highlightMoveDuration;
    m_textColor = config->textColor;
    m_minimumHeight = config->minimumHeight;
    m_primaryColor = config->primaryColor;
    m_dark = config->dark;
}

FluentUI *FluentUI::qmlAttachedProperties(QObject *object) {
    if (FluentUI::config == nullptr) {
        initGlobalConfig();
    }
    return new FluentUI(object);
}
