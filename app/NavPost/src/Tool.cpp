#include "Tool.h"


Tool::Tool(QObject *parent) : QObject{parent}
{
    double PI = 3.1415926535897932;
    m_R2D= (180.0 / PI);
    m_D2R=(PI / 180.0);
}

QVariantMap Tool::convertECEFtoLLH(double x, double y, double z)
{
    return {
        {"lat",35.11555115178},
        {"lon",120.1154822144},
        {"height",55.2158}
    };
}

QVariantMap Tool::convertLLHtoECEF(double lon, double lat, double height)
{
    return {
        {"x",25154979.1185},
        {"y",50115423.1544},
        {"z",35224485.5211}
    };
}

QVariantMap Tool::convertGPSTtoUTC(int week, double seconds)
{
    return {
        {"utc",1752215499812}
    };
}

QVariantMap Tool::convertUTCtoGPST(int sec, double seconds)
{
    return {
        {"week",10000},
        {"sec",5.115}
    };
}
