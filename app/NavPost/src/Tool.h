#pragma once

#include <QObject>
#include <QtQml/qqml.h>
#include "stdafx.h"


class Tool : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QList<QVariantMap>, data)

    Q_PROPERTY_READONLY_AUTO(double,R2D)
    Q_PROPERTY_READONLY_AUTO(double,D2R)

    QML_ELEMENT



private:

public:
    explicit Tool(QObject *parent = nullptr);

    Q_INVOKABLE QVariantMap convertECEFtoLLH(double x,double y ,double z);

    Q_INVOKABLE QVariantMap convertLLHtoECEF(double lon,double lat ,double height);

    Q_INVOKABLE QVariantMap convertGPSTtoUTC(int week,double seconds);

    Q_INVOKABLE QVariantMap convertUTCtoGPST(int sec,double seconds);

};


