#pragma once
// #include "x_constexpr.h"
#include "math.h"

enum CoordSystem
{
    NIL,  // 未知坐标系
    ECEF, // 地心地固坐标系
    LLH,  // 大地坐标系
    ENU,  // 站心坐标系
    NEU,  // 载体坐标系
    RAD   // 大地坐标系（弧度制）
};

struct x_coord
{
    CoordSystem type;
    double p[3];
};

struct x_coord_value
{
    double p[3];
};

struct x_coord_xyz
{
    double x;
    double y;
    double z;
};

struct x_coord_llh_dms
{
    int lat_deg;
    int lat_min;
    double lat_sec;

    int lon_deg;
    int lon_min;
    int lon_sec;

    double height;
};

struct x_coord_llh
{
    double lat = 0.0;
    double lon = 0.0;
    double height = 0.0;

    x_coord_llh()
    {
        lat = 0.0;
        lon = 0.0;
        height = 0.0;
    }

    x_coord_llh(double b, double l, double h)
    {
        lat = b;
        lon = l;
        height = h;
    };
};

struct x_coord_utm
{
    double n;
    double e;
    double d;
};

struct x_coord_enu
{
    double e;
    double n;
    double u;
    double xb;
    double yb;
    double zb;
};

x_coord_enu xyz2neu(x_coord_llh base, x_coord_xyz coord);

x_coord_llh_dms llh2dms(x_coord_llh coord);

class XCoord
{
private:
    double _ecef_x;
    double _ecef_y;
    double _ecef_z;
    bool _invalid; // 数据无效标识（在构造函数的时候，坐标系统不明确或者不支持，因此无法进行坐标系统转换）

public:
    // 初始化坐标变量
    XCoord(x_coord coord) {};
    // 初始化坐标变量
    XCoord(x_coord_value, CoordSystem crd_sys = CoordSystem::NIL) {};

    XCoord(x_coord_xyz, CoordSystem crd_sys = CoordSystem::NIL) {};
    // 初始化坐标变量
    XCoord(double p1, double p2, double p3, CoordSystem crd_sys = CoordSystem::NIL) {};

    ~XCoord() {};

    bool Valid()
    {
        return !_invalid;
    };

    x_coord_xyz ECEF() { return x_coord_xyz(); };

    x_coord_llh Geoc() { return x_coord_llh(); };

    x_coord_llh Ell() { return x_coord_llh(); };

    x_coord_enu NEU(x_coord base) { return x_coord_enu(); };

    // x_coord_llh LLH_DEG();
    // x_coord_llh LLH_RAD();
    // x_coord_llh_dms LLH_DMS();
};

// Rectangular Coordinates -> Ellipsoidal Coordinates
x_coord_llh xyz2ell(x_coord_xyz XYZ)
{
    double x = XYZ.x, y = XYZ.y, z = XYZ.z, b, l, h;

    const double bell = RE_WGS84 * (1.0 - FE_WGS84);
    const double e2 = (RE_WGS84 * RE_WGS84 - bell * bell) / (RE_WGS84 * RE_WGS84);
    const double e2c = (RE_WGS84 * RE_WGS84 - bell * bell) / (bell * bell);

    double nn, ss, zps, hOld, phiOld, theta, sin3, cos3;

    ss = sqrt(x * x + y * y);
    zps = z / ss;
    theta = atan((z * RE_WGS84) / (ss * bell));
    sin3 = sin(theta) * sin(theta) * sin(theta);
    cos3 = cos(theta) * cos(theta) * cos(theta);

    // Closed formula
    b = atan((z + e2c * bell * sin3) / (ss - e2 * RE_WGS84 * cos3));
    l = atan2(y, x);
    nn = RE_WGS84 / sqrt(1.0 - e2 * sin(b) * sin(b));
    h = ss / cos(b) - nn;

    const int MAXITER = 100;
    for (int ii = 1; ii <= MAXITER; ii++)
    {
        nn = RE_WGS84 / sqrt(1.0 - e2 * sin(b) * sin(b));
        hOld = h;
        phiOld = b;
        h = ss / cos(b) - nn;
        b = atan(zps / (1.0 - e2 * nn / (nn + h)));
        if (fabs(phiOld - b) <= 1.0e-11 && fabs(hOld - h) <= 1.0e-5)
        {
            return x_coord_llh(b, l, h);
        }
    }

    return x_coord_llh();
}

// Rectangular Coordinates -> Geocentric Coordinates
x_coord_llh xyz2geoc(x_coord_xyz XYZ)
{
    const double bell = RE_WGS84 * (1.0 - FE_WGS84);
    const double e2 = (RE_WGS84 * RE_WGS84 - bell * bell) / (RE_WGS84 * RE_WGS84);

    auto Ell = xyz2ell(XYZ);

    double x = XYZ.x, y = XYZ.y, z = XYZ.z, b = Ell.lat, l = Ell.lon, h = Ell.height;

    double rho = sqrt(x * x + y * y + z * z);
    double Rn = RE_WGS84 / sqrt(1 - e2 * pow(sin(b), 2));

    return x_coord_llh(atan((1 - e2 * Rn / (Rn + h)) * tan(b)), l, rho - RE_AVERAGE);
}

x_coord_enu xyz2neu(x_coord_llh base, x_coord_xyz coord)
{
    double sinPhi = sin(base.lat);
    double cosPhi = cos(base.lat);
    double sinLam = sin(base.lon);
    double cosLam = cos(base.lon);

    double n = -sinPhi * cosLam * coord.x - sinPhi * sinLam * coord.y + cosPhi * coord.z;
    double e = -sinLam * coord.x + cosLam * coord.y;
    double u = +cosPhi * cosLam * coord.x + cosPhi * sinLam * coord.y + sinPhi * coord.z;

    return x_coord_enu();
}
