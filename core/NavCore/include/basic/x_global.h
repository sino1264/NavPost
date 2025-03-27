

#define LIGHTSPEED 2.99792458e8 /* m/sec */

#define SAT_FREQU_NULL 0.0 /* Hz */

#define GPS_FREQU_L1 1575420000.0                     /* Hz */
#define GPS_FREQU_L2 1227600000.0                     /* Hz */
#define GPS_FREQU_L5 1176450000.0                     /* Hz */
#define GPS_WAVELENGTH_L1 (LIGHTSPEED / GPS_FREQU_L1) /* m */
#define GPS_WAVELENGTH_L2 (LIGHTSPEED / GPS_FREQU_L2) /* m */
#define GPS_WAVELENGTH_L5 (LIGHTSPEED / GPS_FREQU_L5) /* m */

#define GLO_FREQU_G1_BASE 1602000000.0 /* Hz */
#define GLO_FREQU_G2_BASE 1246000000.0 /* Hz */
#define GLO_FREQU_L1_STEP 562500.0     /* Hz */
#define GLO_FREQU_L2_STEP 437500.0     /* Hz */
#define GLO_FREQU_L1(a) (GLO_FREQU_L1_BASE + (a) * GLO_FREQU_L1_STEP)
#define GLO_FREQU_L2(a) (GLO_FREQU_L2_BASE + (a) * GLO_FREQU_L2_STEP)
#define GLO_FREQU_G1a 1600995000.0                          /* Hz */
#define GLO_FREQU_G2a 1248060000.0                          /* Hz */
#define GLO_FREQU_G3 1202025000.0                           /* Hz */
#define GLO_WAVELENGTH_L1(a) (LIGHTSPEED / GLO_FREQU_L1(a)) /* m */
#define GLO_WAVELENGTH_L2(a) (LIGHTSPEED / GLO_FREQU_L2(a)) /* m */
#define GLO_WAVELENGTH_L1a (LIGHTSPEED / GLO_FREQU_L1a)     /* m */
#define GLO_WAVELENGTH_L2a (LIGHTSPEED / GLO_FREQU_L2a)     /* m */
#define GLO_WAVELENGTH_L3 (LIGHTSPEED / GLO_FREQU_L3)       /* m */

#define GAL_FREQU_E1 1575420000.0                       /* Hz */
#define GAL_FREQU_E5a 1176450000.0                      /* Hz */
#define GAL_FREQU_E5b 1207140000.0                      /* Hz */
#define GAL_FREQU_E5 1191795000.0                       /* Hz E5a + E5b */
#define GAL_FREQU_E6 1278750000.0                       /* Hz */
#define GAL_WAVELENGTH_E1 (LIGHTSPEED / GAL_FREQU_E1)   /* m */
#define GAL_WAVELENGTH_E5a (LIGHTSPEED / GAL_FREQU_E5a) /* m */
#define GAL_WAVELENGTH_E5 (LIGHTSPEED / GAL_FREQU_E5)   /* m */
#define GAL_WAVELENGTH_E5b (LIGHTSPEED / GAL_FREQU_E5b) /* m */
#define GAL_WAVELENGTH_E6 (LIGHTSPEED / GAL_FREQU_E6)   /* m */

#define QZSS_FREQU_L1 1575420000.0                      /* Hz */
#define QZSS_FREQU_L2 1227600000.0                      /* Hz */
#define QZSS_FREQU_L5 1176450000.0                      /* Hz */
#define QZSS_FREQU_L6 1278750000.0                      /* Hz */
#define QZSS_WAVELENGTH_L1 (LIGHTSPEED / QZSS_FREQU_L1) /* m */
#define QZSS_WAVELENGTH_L2 (LIGHTSPEED / QZSS_FREQU_L2) /* m */
#define QZSS_WAVELENGTH_L5 (LIGHTSPEED / QZSS_FREQU_L5) /* m */
#define QZSS_WAVELENGTH_L6 (LIGHTSPEED / QZSS_FREQU_L6) /* m */

#define BDS_FREQU_B1I 1561098000.0                      /* Hz   2   3   */
#define BDS_FREQU_B1C 1575420000.0                      /* Hz       3   */
#define BDS_FREQU_B1A 1575420000.0                      /* Hz       3   */
#define BDS_FREQU_B2a 1176450000.0                      /* Hz       3   */
#define BDS_FREQU_B2I 1207140000.0                      /* Hz   2       */
#define BDS_FREQU_B2b 1207140000.0                      /* Hz       3   */
#define BDS_FREQU_B2 1191795000.0                       /* Hz       3   B2a + B2b */
#define BDS_FREQU_B3I 1268520000.0                      /* Hz   2   3   */
#define BDS_FREQU_B3A 1268520000.0                      /* Hz       3   */
#define BDS_WAVELENGTH_B1I (LIGHTSPEED / BDS_FREQU_B1I) /* m */
#define BDS_WAVELENGTH_B1C (LIGHTSPEED / BDS_FREQU_B1C) /* m */
#define BDS_WAVELENGTH_B1A (LIGHTSPEED / BDS_FREQU_B1A) /* m */
#define BDS_WAVELENGTH_B2a (LIGHTSPEED / BDS_FREQU_B2a) /* m */
#define BDS_WAVELENGTH_B2I (LIGHTSPEED / BDS_FREQU_B2I) /* m */
#define BDS_WAVELENGTH_B2b (LIGHTSPEED / BDS_FREQU_B2b) /* m */
#define BDS_WAVELENGTH_B2 (LIGHTSPEED / BDS_FREQU_B2)   /* m */
#define BDS_WAVELENGTH_B3I (LIGHTSPEED / BDS_FREQU_B3I) /* m */
#define BDS_WAVELENGTH_B3A (LIGHTSPEED / BDS_FREQU_B3A) /* m */

#define IRNSS_FREQU_L1 1575420000.0                       /* Hz */
#define IRNSS_FREQU_L5 1176450000.0                       /* Hz */
#define IRNSS_FREQU_S 2492028000.0                        /* Hz */
#define IRNSS_WAVELENGTH_L1 (LIGHTSPEED / IRNSS_FREQU_L1) /* m */
#define IRNSS_WAVELENGTH_L5 (LIGHTSPEED / IRNSS_FREQU_L5) /* m */
#define IRNSS_WAVELENGTH_S (LIGHTSPEED / IRNSS_FREQU_S)   /* m */

#define FREQU_TYPE01 // 1575420000.0 /* L1/E1/B1C */
#define FREQU_TYPE02 // 1227600000.0 /* L2 */
#define FREQU_TYPE03 // 1176450000.0 /* L5/E5a/B2a */
#define FREQU_TYPE04 // 1191795000.0 /* E5/B2 */
#define FREQU_TYPE05 // 1207140000.0 /* E5b/B2b/B2I/B2Q */
#define FREQU_TYPE06 // 1278750000.0 /* E6/L6 */
#define FREQU_TYPE07 // 1561098000.0 /* B1I/B1Q */
#define FREQU_TYPE08 // 1268520000.0 /* B3I/B3A/B3Q */
#define FREQU_TYPE09 // 1600995000.0 /* G1a */
#define FREQU_TYPE10 // 1248060000.0 /* G2a */
#define FREQU_TYPE11 // 1202025000.0 /* G3 */
#define FREQU_TYPE12 // 2492028000.0 /* S */

#define FREQU_TYPE12 // 2492028000.0 /* S */

#define R2R_PI 3.1415926535898

// 定义每颗卫星的基本信息

// GPS_SAT_INFO

// GPS系统
// 卫星的PRN号，

// 卫星的频点

//

#include <string>
#include <unordered_map>

struct Code_Info
{
    double FREQ;
    std::string CODE;
    std::string notes;
};

// 用 constexpr 来确保 map 是编译时常量

const Code_Info GPS_RINEX_DEF[] = {
    /* L1  1575.42 MHz */
    {GPS_FREQU_L1, "1C", "C/A"},
    {GPS_FREQU_L1, "1S", "L1C(D)"},
    {GPS_FREQU_L1, "1L", "L1C(P)"},
    {GPS_FREQU_L1, "1X", "L1C(D+P)"},
    {GPS_FREQU_L1, "1P", "P(AS off)"},
    {GPS_FREQU_L1, "1W", "Z-tracking and similar (AS on)"},
    {GPS_FREQU_L1, "1Y", "Y"},
    {GPS_FREQU_L1, "1M", "M"},
    {GPS_FREQU_L1, "1N", "codeless"},
    {GPS_FREQU_L1, "1R", "M(RMP antenna)"},
    /* L2  1227.60 MHz */
    {GPS_FREQU_L2, "2C", "C/A"},
    {GPS_FREQU_L2, "2D", "L1(C/A) + (P2-P1)(semi-codeless)"},
    {GPS_FREQU_L2, "2S", "L2C(M)"},
    {GPS_FREQU_L2, "2L", "L2C(L)"},
    {GPS_FREQU_L2, "2X", "L2C(M+L)"},
    {GPS_FREQU_L2, "2P", "P(AS off)"},
    {GPS_FREQU_L2, "2W", "Z-tracking and similar (AS on)"},
    {GPS_FREQU_L2, "2Y", "Y"},
    {GPS_FREQU_L2, "2M", "M"},
    {GPS_FREQU_L2, "2N", "codeless"},
    {GPS_FREQU_L2, "2R", "M(RMP antenna)"},
    /* L5  1176.45 MHz */
    {GPS_FREQU_L5, "5I", "I"},
    {GPS_FREQU_L5, "5Q", "Q"},
    {GPS_FREQU_L5, "5X", "I+Q"},
};

const Code_Info BDS_RINEX_DEF[] = {

    {BDS_FREQU_B1I, "1I", "I(B1I signal)"}, // 兼容旧版本Rinex  等同于2I 2Q 2X
    {BDS_FREQU_B1I, "1Q", "Q"},
    {BDS_FREQU_B1I, "1X", "I+Q"},

    {BDS_FREQU_B1I, "2I", "I(B1I signal)"},
    {BDS_FREQU_B1I, "2Q", "Q"},
    {BDS_FREQU_B1I, "2X", "I+Q"},

    {BDS_FREQU_B1C, "1D", "Data"},
    {BDS_FREQU_B1C, "1P", "Pilot"},
    {BDS_FREQU_B1C, "1X", "Data+Pilot"},

    {BDS_FREQU_B1A, "1S", "Data"},
    {BDS_FREQU_B1A, "1L", "Pilot"},
    {BDS_FREQU_B1A, "1Z", "Data+Pilot"},

    {BDS_FREQU_B2a, "5D", "Data"},
    {BDS_FREQU_B2a, "5P", "Pilot"},
    {BDS_FREQU_B2a, "5X", "Data+Pilot"},

    {BDS_FREQU_B2I, "7I", "I(B2I signal)"},
    {BDS_FREQU_B2I, "7Q", "Q"},
    {BDS_FREQU_B2I, "7X", "I+Q"},

    {BDS_FREQU_B2b, "7D", "Data"},
    {BDS_FREQU_B2b, "7P", "Pilot"},
    {BDS_FREQU_B2b, "7Z", "Data+Pilot"},

    {BDS_FREQU_B2, "8D", "Data"},
    {BDS_FREQU_B2, "8P", "Pilot"},
    {BDS_FREQU_B2, "8X", "Data+Pilot"},

    {BDS_FREQU_B3I, "6I", "I"},
    {BDS_FREQU_B3I, "6Q", "Q"},
    {BDS_FREQU_B3I, "6X", "I+Q"},

    {BDS_FREQU_B3A, "6D", "Data"},
    {BDS_FREQU_B3A, "6P", "Pilot"},
    {BDS_FREQU_B3A, "6Z", "Data+Pilot"},

};

const Code_Info GLO_RINEX_DEF[] = {
    {GLO_FREQU_G1_BASE, "1C"},
    {GLO_FREQU_G1_BASE, "1P"},

    {GLO_FREQU_G1a, "4A"},
    {GLO_FREQU_G1a, "4B"},
    {GLO_FREQU_G1a, "4X"},

    {GLO_FREQU_G2_BASE, "2C"},
    {GLO_FREQU_G2_BASE, "2P"},

    {GLO_FREQU_G2a, "6A"},
    {GLO_FREQU_G2a, "6B"},
    {GLO_FREQU_G2a, "6X"},

    {GLO_FREQU_G3, "3I"},
    {GLO_FREQU_G3, "3Q"},
    {GLO_FREQU_G3, "3X"},

};

const Code_Info GAL_RINEX_DEF[] = {
    {GAL_FREQU_E1, "1A"},
    {GAL_FREQU_E1, "1B"},
    {GAL_FREQU_E1, "1C"},
    {GAL_FREQU_E1, "1X"},
    {GAL_FREQU_E1, "1Z"},

    {GAL_FREQU_E5a, "5I"},
    {GAL_FREQU_E5a, "5Q"},
    {GAL_FREQU_E5a, "5X"},

    {GAL_FREQU_E5b, "7I"},
    {GAL_FREQU_E5b, "7Q"},
    {GAL_FREQU_E5b, "7X"},

    {GAL_FREQU_E5, "8I"},
    {GAL_FREQU_E5, "8Q"},
    {GAL_FREQU_E5, "8X"},

    {GAL_FREQU_E6, "6A"},
    {GAL_FREQU_E6, "6B"},
    {GAL_FREQU_E6, "6C"},
    {GAL_FREQU_E6, "6X"},
    {GAL_FREQU_E6, "6Z"},

};

const Code_Info QZS_RINEX_DEF[] = {
    /* L1  1575.42 MHz */
    {QZSS_FREQU_L1, "1C"},
    {QZSS_FREQU_L1, "1E"},
    {QZSS_FREQU_L1, "1S"},
    {QZSS_FREQU_L1, "1L"},
    {QZSS_FREQU_L1, "1X"},
    {QZSS_FREQU_L1, "1Z"},
    {QZSS_FREQU_L1, "1B"},
    /* L2  1227.60 MHz */
    {QZSS_FREQU_L2, "2S"},
    {QZSS_FREQU_L2, "2L"},
    {QZSS_FREQU_L2, "2X"},
    /* L5  1176.45 MHz */
    {QZSS_FREQU_L5, "5I"},
    {QZSS_FREQU_L5, "5Q"},
    {QZSS_FREQU_L5, "5X"},
    {QZSS_FREQU_L5, "5D"},
    {QZSS_FREQU_L5, "5P"},
    {QZSS_FREQU_L5, "5Z"},
    /* L6  1278.75 MHz */
    {QZSS_FREQU_L6, "6S"},
    {QZSS_FREQU_L6, "6L"},
    {QZSS_FREQU_L6, "6X"},
    {QZSS_FREQU_L6, "6E"},
    {QZSS_FREQU_L6, "6Z"},
};

const Code_Info IRN_RINEX_DEF[] = {
    /* L1  1575.42 MHz */
    {IRNSS_FREQU_L1, "1D"},
    {IRNSS_FREQU_L1, "1P"},
    {IRNSS_FREQU_L1, "1X"},
    /* L5  1176.45 MHz */
    {IRNSS_FREQU_L5, "5A"},
    {IRNSS_FREQU_L5, "5B"},
    {IRNSS_FREQU_L5, "5C"},
    {IRNSS_FREQU_L5, "5X"},
    /* S  2492.028 MHz */
    {IRNSS_FREQU_S, "9A"},
    {IRNSS_FREQU_S, "9B"},
    {IRNSS_FREQU_S, "9C"},
    {IRNSS_FREQU_S, "9X"},
};

const Code_Info SBS_RINEX_DEF[] = {
    /* L1  1575.42 MHz */
    {GPS_FREQU_L1, "1C"},
    /* L5  1176.45 MHz */
    {GPS_FREQU_L5, "5I"},
    {GPS_FREQU_L5, "5Q"},
    {GPS_FREQU_L5, "5X"},
};

struct RTCM_Info
{
    // double FREQ;
    int SignalID;
    std::string CODE;
    std::string notes;
};

const RTCM_Info GPS_RTCM_DEF[] = {
    {1, ""},
    {2, "1C"}, // RTCM3.4
    {3, "1P"}, // RTCM3.4
    {4, "1W"}, // RTCM3.4
    {5, "1Y"}, // *5
    {6, "1M"}, // *6
    {7, ""},
    {8, "2C"},  // RTCM3.4
    {9, "2P"},  // RTCM3.4
    {10, "2W"}, // RTCM3.4

    {11, "2Y"}, //*11
    {12, "2M"}, //*12
    {13, ""},
    {14, ""},
    {15, "2S"}, // RTCM3.4
    {16, "2L"}, // RTCM3.4
    {17, "2X"}, // RTCM3.4
    {18, ""},
    {19, ""},
    {20, ""},

    {21, ""},
    {22, "5I"}, // RTCM3.4
    {23, "5Q"}, // RTCM3.4
    {24, "5X"}, // RTCM3.4
    {25, ""},
    {26, ""},
    {27, ""},
    {28, ""},
    {29, ""},
    {30, "1S"}, // RTCM3.4

    {31, "1L"}, // RTCM3.4
    {32, "1X"}  // RTCM3.4
};

const RTCM_Info GLO_RTCM_DEF[] = {
    {1, ""},
    {2, "1C"}, // RTCM3.4
    {3, "1P"}, // RTCM3.4
    {4, ""},
    {5, ""},
    {6, ""},
    {7, ""},
    {8, "2C"}, // RTCM3.4
    {9, "2P"}, // RTCM3.4
    {10, ""},

    {11, "3I"}, // *11
    {12, "3Q"}, // *12
    {13, "3X"}, // *13
    {14, ""},
    {15, ""},
    {16, ""},
    {17, ""},
    {18, ""},
    {19, ""},
    {20, ""},

    {21, ""},
    {22, ""},
    {23, ""},
    {24, ""},
    {25, ""},
    {26, ""},
    {27, ""},
    {28, ""},
    {29, ""},
    {30, ""},

    {31, ""},
    {32, ""}};

const RTCM_Info GAL_RTCM_DEF[] = {
    {1, ""},
    {2, "1C"},
    {3, "1A"},
    {4, "1B"},
    {5, "1X"},
    {6, "1Z"},
    {7, ""},
    {8, "6C"},
    {9, "6A"},
    {10, "6B"},

    {11, "6X"},
    {12, "6Z"},
    {13, ""},
    {14, "7I"},
    {15, "7Q"},
    {16, "7X"},
    {17, ""},
    {18, "8I"},
    {19, "8Q"},
    {20, "8X"},

    {21, ""},
    {22, "5I"},
    {23, "5Q"},
    {24, "5X"},
    {25, ""},
    {26, ""},
    {27, ""},
    {28, ""},
    {29, ""},
    {30, ""},

    {31, ""},
    {32, ""}};

const RTCM_Info BDS_RTCM_DEF[] = {
    {1, ""},
    {2, "2I", "B1 I"},
    {3, "2Q", "B1 Q"},
    {4, "2X", "B1 I+Q"},
    {5, ""},
    {6, ""},
    {7, ""},
    {8, "6I", "B3 I"},
    {9, "6Q", "B3 Q"},
    {10, "6X", "B3 I+Q"},

    {11, ""},
    {12, ""},
    {13, ""},
    {14, "7I", "B2 I"},
    {15, "7Q", "B2 Q"},
    {16, "7X", "B2 I+Q"},
    {17, ""},
    {18, ""},
    {19, ""},
    {20, ""},

    {21, ""},
    {22, "5D", "B2a D"},
    {23, "5P", "B2a P"},
    {24, "5X", "B2a D+P"},
    {25, "5D", "B2a I"},
    {26, ""},
    {27, ""},
    {28, ""},
    {29, ""},
    {30, "1D", "B1C D"},

    {31, "1P", "B1C P"},
    {32, "1X", "B1C D+P"}};

const RTCM_Info SBS_RTCM_DEF[] = {
    {1, ""},
    {2, "1C"},
    {3, ""},
    {4, ""},
    {5, ""},
    {6, ""},
    {7, ""},
    {8, ""},
    {9, ""},
    {10, ""},

    {11, ""},
    {12, ""},
    {13, ""},
    {14, ""},
    {15, ""},
    {16, ""},
    {17, ""},
    {18, ""},
    {19, ""},
    {20, ""},

    {21, ""},
    {22, "5I"},
    {23, "5Q"},
    {24, "5X"},
    {25, ""},
    {26, ""},
    {27, ""},
    {28, ""},
    {29, ""},
    {30, ""},

    {31, ""},
    {32, ""}};

const RTCM_Info QZS_RTCM_DEF[] = {
    {1, ""},
    {2, "1C"},
    {3, ""},
    {4, ""},
    {5, ""},
    {6, ""},
    {7, ""},
    {8, ""},
    {9, "6S"},
    {10, "6L"},

    {11, "6X"},
    {12, ""},
    {13, ""},
    {14, ""},
    {15, "2S"},
    {16, "2L"},
    {17, "2X"},
    {18, ""},
    {19, ""},
    {20, ""},

    {21, ""},
    {22, "5I"},
    {23, "5Q"},
    {24, "5X"},
    {25, ""},
    {26, ""},
    {27, ""},
    {28, ""},
    {29, ""},
    {30, "1S"},

    {31, "1L"},
    {32, "1X"}};

const RTCM_Info IRN_RTCM_DEF[] = {
    {1, ""},
    {2, ""},
    {3, ""},
    {4, ""},
    {5, ""},
    {6, ""},
    {7, ""},
    {8, "9A"},
    {9, ""},
    {10, ""},

    {11, ""},
    {12, ""},
    {13, ""},
    {14, ""},
    {15, ""},
    {16, ""},
    {17, ""},
    {18, ""},
    {19, ""},
    {20, ""},

    {21, ""},
    {22, "5A"},
    {23, ""},
    {24, ""},
    {25, ""},
    {26, ""},
    {27, ""},
    {28, ""},
    {29, ""},
    {30, ""},

    {31, ""},
    {32, ""}};

struct SinoCNB_Info
{
    // double FREQ;
    int SignalID;
    std::string CODE;
    std::string notes;
};

const SinoCNB_Info GPS_SinoCNB_DEF[] = {
    {0, "", "L1 C/A"},
    {1, ""},
    {2, "", "L5C"},
    {3, ""},
    {4, ""},
    {5, ""},
    {6, ""},
    {7, ""},
    {8, ""},
    {9, "", "L2P"},
    {10, ""},

    {11, ""},
    {12, ""},
    {13, ""},
    {14, ""},
    {15, ""},
    {16, "", "L1B"},
    {17, "", "L2C"},
    {18, ""},
    {19, ""},
    {20, ""},

    {21, ""},
    {22, ""},
    {23, ""},
    {24, ""},
    {25, ""},
    {26, ""},
    {27, ""},
    {28, ""},
    {29, ""},
    {30, ""},

    {31, ""}};

const SinoCNB_Info GLO_SinoCNB_DEF[] = {
    {0, "", "G1C"},
    {1, ""},
    {2, ""},
    {3, ""},
    {4, ""},
    {5, "", "G2P"},
    {6, "", "G3C"},
    {7, ""},
    {8, ""},
    {9, ""},
    {10, ""},

    {11, ""},
    {12, ""},
    {13, ""},
    {14, ""},
    {15, ""},
    {16, ""},
    {17, ""},
    {18, ""},
    {19, ""},
    {20, ""},

    {21, ""},
    {22, ""},
    {23, ""},
    {24, ""},
    {25, ""},
    {26, ""},
    {27, ""},
    {28, ""},
    {29, ""},
    {30, ""},

    {31, ""}};

const SinoCNB_Info SBS_SinoCNB_DEF[] = {
    {0, "", "S1C"},
    {1, ""},
    {2, ""},
    {3, ""},
    {4, ""},
    {5, ""},
    {6, "", "S5C"},
    {7, ""},
    {8, ""},
    {9, ""},
    {10, ""},

    {11, ""},
    {12, ""},
    {13, ""},
    {14, ""},
    {15, ""},
    {16, ""},
    {17, ""},
    {18, ""},
    {19, ""},
    {20, ""},

    {21, ""},
    {22, ""},
    {23, ""},
    {24, ""},
    {25, ""},
    {26, ""},
    {27, ""},
    {28, ""},
    {29, ""},
    {30, ""},

    {31, ""}};

const SinoCNB_Info GAL_SinoCNB_DEF[] = {
    {0, ""},
    {1, ""},
    {2, "", "E1C"},
    {3, ""},
    {4, ""},
    {5, ""},
    {6, ""},
    {7, "", "E6C"},
    {8, ""},
    {9, ""},
    {10, ""},

    {11, ""},
    {12, "", "E5a"},
    {13, ""},
    {14, ""},
    {15, ""},
    {16, ""},
    {17, "", "E5b"},
    {18, ""},
    {19, ""},
    {20, "", "E5AB"},

    {21, ""},
    {22, ""},
    {23, ""},
    {24, ""},
    {25, ""},
    {26, ""},
    {27, ""},
    {28, ""},
    {29, ""},
    {30, ""},

    {31, ""}};

const SinoCNB_Info BDS_SinoCNB_DEF[] = {
    {0, "", "B1I"},
    {1, ""},
    {2, "", "B3I"},
    {3, ""},
    {4, ""},
    {5, ""},
    {6, ""},
    {7, ""},
    {8, "", "B1C"},
    {9, ""},
    {10, ""},

    {11, ""},
    {12, "", "B2a"},
    {13, ""},
    {14, ""},
    {15, ""},
    {16, ""},
    {17, "", "B2I"},
    {18, ""},
    {19, "", "B2b"},
    {20, ""},

    {21, "", "B1A"}, //*
    {22, ""},
    {23, "", "B3Q"},  //*
    {24, "", "B3A"},  //*
    {25, "", "B3AE"}, //*
    {26, ""},
    {27, ""},
    {28, ""},
    {29, ""},
    {30, ""},

    {31, ""}};

const SinoCNB_Info QZS_SinoCNB_DEF[] = {
    {0, "", "L1C"},
    {1, ""},
    {2, ""},
    {3, ""},
    {4, ""},
    {5, ""},
    {6, ""},
    {7, ""},
    {8, ""},
    {9, ""},
    {10, ""},

    {11, ""},
    {12, ""},
    {13, ""},
    {14, "", "L5C"},
    {15, ""},
    {16, ""},
    {17, "", "L2C"},
    {18, ""},
    {19, ""},
    {20, ""},

    {21, ""},
    {22, ""},
    {23, ""},
    {24, ""},
    {25, ""},
    {26, ""},
    {27, ""},
    {28, ""},
    {29, ""},
    {30, ""},

    {31, ""}};

const SinoCNB_Info IRN_SinoCNB_DEF[] = {
    {0, "", "L5"},
    {1, ""},
    {2, ""},
    {3, ""},
    {4, ""},
    {5, ""},
    {6, ""},
    {7, ""},
    {8, ""},
    {9, ""},
    {10, ""},

    {11, ""},
    {12, ""},
    {13, ""},
    {14, ""},
    {15, ""},
    {16, ""},
    {17, ""},
    {18, ""},
    {19, ""},
    {20, ""},

    {21, ""},
    {22, ""},
    {23, ""},
    {24, ""},
    {25, ""},
    {26, ""},
    {27, ""},
    {28, ""},
    {29, ""},
    {30, ""},

    {31, ""}};

const SinoCNB_Info XWS_SinoCNB_DEF[] = {
    {0, "", "XW-L"},
    {1, ""},
    {2, "", "XW-B2b"},
    {3, "", "XW-B3A"},
    {4, ""},
    {5, ""},
    {6, ""},
    {7, ""},
    {8, ""},
    {9, ""},
    {10, ""},

    {11, ""},
    {12, ""},
    {13, ""},
    {14, ""},
    {15, ""},
    {16, ""},
    {17, ""},
    {18, ""},
    {19, ""},
    {20, ""},

    {21, ""},
    {22, ""},
    {23, ""},
    {24, ""},
    {25, ""},
    {26, ""},
    {27, ""},
    {28, ""},
    {29, ""},
    {30, ""},

    {31, ""}};

struct Sat_Info
{
    int ID;   // 全局ID
    int PRN;  // 卫星的PRN号
    int SYS;  // 卫星系统
    int TYPE; // 卫星类型  MEO/IGSO/GEO
};