#pragma once
#include <cstdint>

// 根据启动的卫星系统，来决定卫星系统的内部编号

// 在CMAKE中添加定义  add_definitions(-DFEATURE_ENABLED)
#define ENAGLO
#define ENAGAL
#define ENAQZS
#define ENABD2
#define ENABDS
#define ENAIRN
#define ENALEO

namespace NavX
{
    enum x_eph_sys
    {
        unknown,
        GPS,
        QZSS,
        GLONASS,
        Galileo,
        SBAS,
        BDS,
        IRNSS
    };
    enum x_eph_checkState
    {
        unchecked,
        ok,
        bad,
        outdated,
        unhealthy
    };
    enum x_eph_navType
    {
        undefined,
        LNAV,
        FDMA,
        FNAV,
        INAF,
        D1,
        D2,
        SBASL1,
        CNAV,
        CNV1,
        CNV2,
        CNV3
    };

    constexpr double PI = 3.1415926535897932;
    constexpr double D2R = (PI / 180.0);       /* deg to rad */
    constexpr double R2D = (180.0 / PI);       /* rad to deg */
    constexpr double CLIGHT = 299792458.0;     /* speed of light (m/s) */
    constexpr double SC2RAD = 3.1415926535898; /* semi-circle to radian (IS-GPS) */
    constexpr double AU = 149597870691.0;      /* 1 AU (m) */
    constexpr double AS2R = (D2R / 3600.0);    /* arc sec to radian */

    constexpr double OMGE = 7.2921151467E-5; /* earth angular velocity (IS-GPS) (rad/s) */

    const double RE_AVERAGE = 6370000.000;
    constexpr double RE_WGS84 = 6378137.0;             /* earth semimajor axis (WGS84) (m) */
    constexpr double FE_WGS84 = (1.0 / 298.257223563); /* earth flattening (WGS84) */
    constexpr double HION = 350000.0;                  /* ionosphere height (m) */

    constexpr int MAXFREQ = 7; /* max NFREQ */

    constexpr double FREQ1 = 1.57542E9;       /* L1/E1/B1C  frequency (Hz) */
    constexpr double FREQ2 = 1.22760E9;       /* L2         frequency (Hz) */
    constexpr double FREQ5 = 1.17645E9;       /* L5/E5a/B2a frequency (Hz) */
    constexpr double FREQ6 = 1.27875E9;       /* E6/L6  frequency (Hz) */
    constexpr double FREQ7 = 1.20714E9;       /* E5b    frequency (Hz) */
    constexpr double FREQ8 = 1.191795E9;      /* E5a+b  frequency (Hz) */
    constexpr double FREQ9 = 2.492028E9;      /* S      frequency (Hz) */
    constexpr double FREQ1_GLO = 1.60200E9;   /* GLONASS G1 base frequency (Hz) */
    constexpr double DFRQ1_GLO = 0.56250E6;   /* GLONASS G1 bias frequency (Hz/n) */
    constexpr double FREQ2_GLO = 1.24600E9;   /* GLONASS G2 base frequency (Hz) */
    constexpr double DFRQ2_GLO = 0.43750E6;   /* GLONASS G2 bias frequency (Hz/n) */
    constexpr double FREQ3_GLO = 1.202025E9;  /* GLONASS G3 frequency (Hz) */
    constexpr double FREQ1a_GLO = 1.600995E9; /* GLONASS G1a frequency (Hz) */
    constexpr double FREQ2a_GLO = 1.248060E9; /* GLONASS G2a frequency (Hz) */
    constexpr double FREQ1_BDS = 1.561098E9;  /* BDS B1I     frequency (Hz) */
    constexpr double FREQ2_BDS = 1.20714E9;   /* BDS B2I/B2b frequency (Hz) */
    constexpr double FREQ3_BDS = 1.26852E9;   /* BDS B3      frequency (Hz) */

    // 不同系统的误差因子
    constexpr double EFACT_GPS = 1.0; /* error factor: GPS */
    constexpr double EFACT_GLO = 1.5; /* error factor: GLONASS */
    constexpr double EFACT_GAL = 1.0; /* error factor: Galileo */
    constexpr double EFACT_QZS = 1.0; /* error factor: QZSS */
    constexpr double EFACT_BDS = 1.0; /* error factor: BeiDou */
    constexpr double EFACT_IRN = 1.5; /* error factor: IRNSS */
    constexpr double EFACT_SBS = 3.0; /* error factor: SBAS */

    constexpr double MINPRNGPS = 1;                         /* min satellite PRN number of GPS */
    constexpr double MAXPRNGPS = 32;                        /* max satellite PRN number of GPS */
    constexpr double NSATGPS = (MAXPRNGPS - MINPRNGPS + 1); /* number of GPS satellites */
    constexpr double NSYSGPS = 1;

#ifdef ENAGLO
    constexpr double MINPRNGLO = 1;                         /* min satellite slot number of GLONASS */
    constexpr double MAXPRNGLO = 27;                        /* max satellite slot number of GLONASS */
    constexpr double NSATGLO = (MAXPRNGLO - MINPRNGLO + 1); /* number of GLONASS satellites */
    constexpr double NSYSGLO = 1;
#else
    constexpr double MINPRNGLO = 0;
    constexpr double MAXPRNGLO = 0;
    constexpr double NSATGLO = 0;
    constexpr double NSYSGLO = 0;
#endif
#ifdef ENAGAL
    constexpr double MINPRNGAL = 1;                         /* min satellite PRN number of Galileo */
    constexpr double MAXPRNGAL = 36;                        /* max satellite PRN number of Galileo */
    constexpr double NSATGAL = (MAXPRNGAL - MINPRNGAL + 1); /* number of Galileo satellites */
    constexpr double NSYSGAL = 1;
#else
    constexpr double MINPRNGAL = 0;
    constexpr double MAXPRNGAL = 0;
    constexpr double NSATGAL = 0;
    constexpr double NSYSGAL = 0;
#endif
#ifdef ENAQZS
    constexpr double MINPRNQZS = 193;                       /* min satellite PRN number of QZSS */
    constexpr double MAXPRNQZS = 202;                       /* max satellite PRN number of QZSS */
    constexpr double MINPRNQZS_S = 183;                     /* min satellite PRN number of QZSS L1S */
    constexpr double MAXPRNQZS_S = 191;                     /* max satellite PRN number of QZSS L1S */
    constexpr double NSATQZS = (MAXPRNQZS - MINPRNQZS + 1); /* number of QZSS satellites */
    constexpr double NSYSQZS = 1;
#else
    constexpr double MINPRNQZS = 0;
    constexpr double MAXPRNQZS = 0;
    constexpr double MINPRNQZS_S = 0;
    constexpr double MAXPRNQZS_S = 0;
    constexpr double NSATQZS = 0;
    constexpr double NSYSQZS = 0;
#endif
#ifdef ENABD2
    constexpr double MINPRNBD2 = 1;                         /* min satellite sat number of BeiDou */
    constexpr double MAXPRNBD2 = 18;                        /* max satellite sat number of BeiDou */
    constexpr double NSATBD2 = (MAXPRNBD2 - MINPRNBD2 + 1); /* number of BeiDou satellites */
    constexpr double NSYSBD2 = 1;
#else
    constexpr double MINPRNBDS = 0;
    constexpr double MAXPRNBDS = 0;
    constexpr double NSATBDS = 0;
    constexpr double NSYSBDS = 0;
#endif
#ifdef ENABDS
    constexpr double MINPRNBDS = 19;                        /* min satellite sat number of BeiDou */
    constexpr double MAXPRNBDS = 63;                        /* max satellite sat number of BeiDou */
    constexpr double NSATBDS = (MAXPRNBDS - MINPRNBDS + 1); /* number of BeiDou satellites */
    constexpr double NSYSBDS = 1;
#else
    constexpr double MINPRNBDS = 0;
    constexpr double MAXPRNBDS = 0;
    constexpr double NSATBDS = 0;
    constexpr double NSYSBDS = 0;
#endif
#ifdef ENAIRN
    constexpr double MINPRNIRN = 1;                         /* min satellite sat number of IRNSS */
    constexpr double MAXPRNIRN = 14;                        /* max satellite sat number of IRNSS */
    constexpr double NSATIRN = (MAXPRNIRN - MINPRNIRN + 1); /* number of IRNSS satellites */
    constexpr double NSYSIRN = 1;
#else
    constexpr double MINPRNIRN = 0;
    constexpr double MAXPRNIRN = 0;
    constexpr double NSATIRN = 0;
    constexpr double NSYSIRN = 0;
#endif
#ifdef ENALEO
    constexpr double MINPRNLEO = 1;                         /* min satellite sat number of LEO */
    constexpr double MAXPRNLEO = 10;                        /* max satellite sat number of LEO */
    constexpr double NSATLEO = (MAXPRNLEO - MINPRNLEO + 1); /* number of LEO satellites */
    constexpr double NSYSLEO = 1;
#else
    constexpr double MINPRNLEO = 0;
    constexpr double MAXPRNLEO = 0;
    constexpr double NSATLEO = 0;
    constexpr double NSYSLEO = 0;
#endif
    constexpr double NSYS = (NSYSGPS + NSYSGLO + NSYSGAL + NSYSQZS + NSYSBDS + NSYSIRN + NSYSLEO); /* number of systems */

    constexpr double MINPRNSBS = 120;                       /* min satellite PRN number of SBAS */
    constexpr double MAXPRNSBS = 158;                       /* max satellite PRN number of SBAS */
    constexpr double NSATSBS = (MAXPRNSBS - MINPRNSBS + 1); /* number of SBAS satellites */

    constexpr double MAXSAT = (NSATGPS + NSATGLO + NSATGAL + NSATQZS + NSATBDS + NSATIRN + NSATSBS + NSATLEO);
    /* max satellite number (1 to MAXSAT) */
    constexpr double MAXSTA = 255;

    using Nav_SYS = uint8_t;
    enum class NavSystem : Nav_SYS
    {
        NONE = 0x00, // Navigation system: none
        GPS = 0x01,  // Navigation system: GPS
        SBS = 0x02,  // Navigation system: SBAS
        GLO = 0x04,  // Navigation system: GLONASS
        GAL = 0x08,  // Navigation system: Galileo
        QZS = 0x10,  // Navigation system: QZSS
        BDS = 0x20,  // Navigation system: BeiDou
        IRN = 0x40,  // Navigation system: IRNS
        LEO = 0x80,  // Navigation system: LEO
        ALL = 0xFF   // Navigation system: all
    };

    // Check if a system is enabled
    bool isSystemEnabled(Nav_SYS currentSystems, NavSystem system)
    {
        return (currentSystems & static_cast<int>(system)) != 0;
    }

    // Enable a system
    Nav_SYS enableNavSystem(Nav_SYS currentSystems, NavSystem system)
    {
        return currentSystems | static_cast<int>(system);
    }

    // Disable a system
    Nav_SYS disableSystem(Nav_SYS currentSystems, NavSystem system)
    {
        return currentSystems & ~static_cast<int>(system);
    }

} // namespace NavX
