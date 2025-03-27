#pragma once

#include "x_constexpr.h"
// #include "x_status.h"

#include "x_time.h"
#include "x_coord.h"
#include "x_prn.h"
#include <vector>
#include <list>

// #include <atomic>
// std::atomic<int> value(0);

#define NFREQ 3 /* number of carrier frequencies */

namespace NavX
{



    struct x_eph
    {
        x_prn _prn;
        x_time _ephTime;
        x_time _receptDateTime;
        std::string _receptStaID;
        x_eph_checkState _checkState;
        x_eph_navType _navType; // defined in RINEX 4
        // x_orbCorr *_orbCorr;
        // x_clkCorr *_clkCorr;
    };

    struct x_eph_GPS : x_eph
    {
        double clock_bias;      // [s]
        double clock_drift;     // [s/s]
        double clock_driftrate; // [s/s^2]

        double IODE;    // IODEC in case of IRNSS
        double Crs;     // [m]
        double Delta_n; // [rad/s]
        double M0;      // [rad]

        double Cuc;    // [rad]
        double e;      // []
        double Cus;    // [rad]
        double sqrt_A; // [m^0.5]

        double TOEsec; // [s of GPS week]
        double Cic;    // [rad]
        double OMEGA0; // [rad]
        double Cis;    // [rad]

        double i0;       // [rad]
        double Crc;      // [m]
        double omega;    // [rad]
        double OMEGADOT; // [rad/s]

        double IDOT;    // [rad/s]
        double L2Codes; // Codes on L2 channel  (not valid for IRNSS)
        double TOEweek; // GPS week # to go with TOE, cont. number, not mode 1024
        double L2PFlag; // L2 P data flag (not valid for IRNSS and QZSS)

        mutable double ura; // SV accuracy [m]
        double health;      // SV health
        double TGD;         // [s]
        double IODC;        // (not valid for IRNSS)

        double TOT;         // Transmission time
        double fitInterval; // Fit interval in hours (not valid for IRNSS)

        double ADOT;        // [m/s]
        double top;         // [s]
        double Delta_n_dot; // [rad/s^2]

        double URAI_NED0; // []
        double URAI_NED1; // []
        double URAI_NED2; // []
        double URAI_ED;   // []

        double ISC_L1CA; // [s]
        double ISC_L2C;  // [s]
        double ISC_L5I5; // [s]
        double ISC_L5Q5; // [s]
        double ISC_L1Cd; // [s]
        double ISC_L1Cp; // [s]

        double _wnop; // GPS continuous week number with the ambiguity resolved
    };

    struct x_eph_Glo : x_eph
    {
        mutable x_time _tt;    // time
        mutable double _xv[6]; // status vector (position, velocity) at time _tt

        double gps_utc;
        double tau;         // [s]
        double gamma;       // [-]
        mutable double tki; // message frame time

        double x_pos;          // [km]
        double x_velocity;     // [km/s]
        double x_acceleration; // [km/s^2]
        double health;         // 0 = O.K. MSB of Bn word

        double y_pos;            // [km]
        double y_velocity;       // [km/s]
        double y_acceleration;   // [km/s^2]
        double frequency_number; // ICD-GLONASS data position

        double z_pos;          // [km]
        double z_velocity;     // [km/s]
        double z_acceleration; // [km/s^2]
        double E;              // Age of Information [days]

        double almanac_health; // Cn word
        double almanac_health_availablility_indicator;

        double additional_data_availability; //
        double tauC;                         // GLONASS time scale correction to UTC(SU) time [sec]
        double P1;                           // flag of the immediate data updating [-]
        double P2;                           // flag of oddness or evenness of the value of tb for intervals 30 or 60 minutes [-]
        double P3;                           // flag indicating a number of satellites for which almanac is transmitted within given frame [-]
        double NA;                           // calendar day number within the 4-year period [days]

        double M_P;         // control segment parameter that indicates the satellite operation mode with respect of time parameters
        double M_l3;        // health flag
        double M_delta_tau; // [sec]
        double M_P4;        // flag to show that ephemeris parameters are present [-]
        double M_FT;        // Indicator for predicted satellite User Range Accuracy (URAI) [-]
        double M_NT;        // current date, calendar number of day within 4-year interval [days]
        double M_M;         // type of satellite transmitting navigation signal: 0 = GLONASS, 1 = GLONASS-M satellite [-]
        double M_N4;        // 4-year interval number starting from 1996
        double M_tau_GPS;   // correction to GPS time relative to GLONASS time [days]
        double M_l5;        // health flag
        bool flags_unknown; // status and health flags are unknown (rnx version < 3.05) or known (rnx version >= 3.05)
    };

    struct x_eph_Gal : x_eph
    {
        double clock_bias;      //  [s]
        double clock_drift;     //  [s/s]
        double clock_driftrate; //  [s/s^2]

        double IODnav;
        double Crs;     //  [m]
        double Delta_n; //  [rad/s]
        double M0;      //  [rad]

        double Cuc;    //  [rad]
        double e;      //
        double Cus;    //  [rad]
        double sqrt_A; //  [m^0.5]

        double TOEsec; //  [s]
        double Cic;    //  [rad]
        double OMEGA0; //  [rad]
        double Cis;    //  [rad]

        double i0;       //  [rad]
        double Crc;      //  [m]
        double omega;    //  [rad]
        double OMEGADOT; //  [rad/s]

        double IDOT; //  [rad/s]
        double TOEweek;
        // spare

        mutable double SISA; // Signal In Space Accuracy
        double E5aHS;        //  [0..3] E5a Health Status
        double E5bHS;        //  [0..3] E5b Health Status
        double E1_bHS;       //  [0..3] E1-b Health Status
        double BGD_1_5A;     //  group delay [s]
        double BGD_1_5B;     //  group delay [s]

        double TOT; // [s]
        /** Data comes from I/NAV when <code>true</code> */
        bool inav;
        /** Data comes from F/NAV when <code>true</code> */
        bool fnav;
        /** E1 Data is not valid */
        bool e1DataInValid;
        /** E5A Data is not valid */
        bool e5aDataInValid;
        /** E5B Data is not valid */
        bool e5bDataInValid;
    };

    struct x_eph_SBAS : x_eph
    {
        int IODN;
        double TOT;  // not used (set to  0.9999e9)
        double agf0; // [s]    clock correction
        double agf1; // [s/s]  clock correction drift

        double x_pos;          // [m]
        double x_velocity;     // [m/s]
        double x_acceleration; // [m/s^2]

        double y_pos;          // [m]
        double y_velocity;     // [m/s]
        double y_acceleration; // [m/s^2]

        double z_pos;          // [m]
        double z_velocity;     // [m/s]
        double z_acceleration; // [m/s^2]

        mutable double ura;
        double health;
    };

    struct x_eph_BDS : x_eph
    {
        double TOT; // [s] of BDT week
        x_time TOE;
        int AODE;
        int AODC;
        int URAI;               // [0..15] index from RTCM stream
        mutable double URA;     // user range accuracy [m]
        double clock_bias;      // [s]
        double clock_drift;     // [s/s]
        double clock_driftrate; // [s/s^2]
        double Crs;             // [m]
        double Delta_n;         // [rad/s]
        double M0;              // [rad]
        double Cuc;             // [rad]
        double e;               //
        double Cus;             // [rad]
        double sqrt_A;          // [m^0.5]
        double Cic;             // [rad]
        double OMEGA0;          // [rad]
        double Cis;             // [rad]
        double i0;              // [rad]
        double Crc;             // [m]
        double omega;           // [rad]
        double OMEGADOT;        // [rad/s]
        double IDOT;            // [rad/s]
        double TOEsec;          // [s] of BDT week
        double BDTweek;         // BDT week

        double Delta_n_dot; // [rad/s^2]
        double satType;     // 0..reserved, 1..GEO, 2..IGSO, 3..MEO
        double top;         // [s]

        double SISAI_oe;  // []
        double SISAI_ocb; // []
        double SISAI_oc1; // []
        double SISAI_oc2; // []

        double ISC_B1Cd; // [s]
        double ISC_B2ad; // [s]

        double TGD1;     // [s]
        double TGD2;     // [s]
        double TGD_B1Cp; // [s]
        double TGD_B2ap; // [s]
        double TGD_B2bI; // [s]

        double SISMAI; // []

        int SatH1;  //
        int health; //

        double INTEGRITYF_B1C;    // 3 bits word from sf 3
        double INTEGRITYF_B2aB1C; // 6 bits word with integrity bits in msg 10-11, 30.34 or 40
        double INTEGRITYF_B2b;    // 3 bits word from msg 10

        double IODC; // []
        double IODE; // [] IODE are the same as the 8 LSBs of IODC
    };

    // 单颗卫星的星历序列
    struct x_BDS_eph_series
    {
        /* data */
        x_eph_BDS _eph;
        // 根据时刻选择合适的卫星星历计算坐标
    };

    // 单个系统的星历序列
    struct x_BDS_eph_sys
    {
        x_BDS_eph_series _eph;
        // 根据PRN号、时刻计算指定卫星的坐标
    };

    // 所有系统的星历序列
    struct x_GNSS_ephs
    {
        std::list<x_eph_BDS> _bds_eph;
        std::list<x_eph_GPS> _gps_eph;
        x_BDS_eph_sys _eph;
        // 根据系统和PRN号、时刻计算指定卫星的坐标坐标
    };

    struct x_frqObs
    {
        std::string _rnxType2ch;
        double _code;
        bool _codeValid;
        double _phase;
        bool _phaseValid;
        double _doppler;
        bool _dopplerValid;
        double _snr;
        bool _snrValid;
        double _lockTime;
        bool _lockTimeValid;
        bool _slip;             // RINEX
        int _slipCounter;       // RTCM2 or converted from RTCM3
        int _lockTimeIndicator; // RTCM3
        int _biasJumpCounter;   // ??
    };

    struct x_satObs
    {
        std::string _staID;
        x_prn _prn;
        x_time _time;
        int _type;
        std::vector<x_frqObs> _obs;
    };

    struct x_epochObs
    {
        x_time _time;

        double ecef_x;
        double ecef_x;
        double ecef_z;
        double ecef_valid;

        std::vector<x_satObs> _obss;
    };

    // 所有系统的观测文件时间序列
    class x_GNSS_epochs
    {

        std::list<x_obs_epoch> _obs; // 观测数据序列

        // 根据时刻，返回指定历元的观测数据
    };

    struct x_orbCorr
    {
        std::string _staID;
        x_prn _prn;
        unsigned int _iod;
        x_time _time;
        unsigned int _updateInt;
        char _system;
        double _xr[3];
        double _dotXr[3];
    };

    struct x_clkCorr
    {
        std::string _staID;
        x_prn _prn;
        unsigned int _iod;
        x_time _time;
        unsigned int _updateInt;
        double _dClk;
        double _dotDClk;
        double _dotDotDClk;
    };

    struct x_URA
    {
        std::string _staID;
        x_prn _prn;
        unsigned int _iod;
        x_time _time;
        unsigned int _updateInt;
        double _ura;
    };

    struct x_frqCodeBias
    {
        std::string _rnxType2ch;
        double _value;
    };

    struct x_satCodeBias
    {
    public:
        std::string _staID;
        x_prn _prn;
        x_time _time;
        unsigned int _updateInt;
        std::vector<x_frqCodeBias> _bias;
    };

    struct x_frqPhaseBias
    {
        std::string _rnxType2ch;
        double _value;
        int _fixIndicator;
        int _fixWideLaneIndicator;
        int _jumpCounter;
    };

    struct t_satPhaseBias
    {
        std::string _staID;
        x_prn _prn;
        x_time _time;
        unsigned int _updateInt;           // not satellite specific
        unsigned int _dispBiasConstistInd; // not satellite specific
        unsigned int _MWConsistInd;        // not satellite specific
        double _yaw;
        double _yawRate;
        std::vector<x_frqPhaseBias> _bias;
    };

    // class t_corrSSR
    // {
    // public:
    //     enum e_type
    //     {
    //         clkCorr,
    //         orbCorr,
    //         codeBias,
    //         phaseBias,
    //         vTec,
    //         URA,
    //         unknown
    //     };
    //     static e_type readEpoLine(const std::string &line, x_time &epoTime,
    //                               unsigned int &updateInt, int &numEntries, std::string &staID);
    // };

    struct x_eph_pvt
    {
        x_time t;
        x_coord_xyz p;
        x_coord_xyz v;
        x_time_value dt;
    };

} // namespace NavX