#pragma once
#include <x_navbasic.h>
#include <list>


    class XEph
    {
    private:
        /* data */

    public:
    public:
        XEph(/* args */);
        virtual ~XEph();

        virtual x_eph_sys type() const = 0;
        virtual std::string toString(double version) const = 0;
        virtual unsigned int IOD() const = 0;
        virtual unsigned int isUnhealthy() const = 0;
        virtual int slotNum() const { return 0; }
        x_time TOC() const { return _ephTime; }
        bool isNewerThan(const XEph *eph) const { return earlierTime(eph, this); }
        void setCheckState(x_eph_checkState checkState) { _checkState = checkState; }
        x_eph_checkState checkState() const { return _checkState; }
        std::string checkStateToString()
        {
            switch (_checkState)
            {
            case unchecked:
                return "unchecked";
            case ok:
                return "ok";
            case bad:
                return "bad";
            case outdated:
                return "outdated";
            case unhealthy:
                return "unhealthy";
            default:
                return "unknown";
            }
        }
        x_eph_navType navType() const { return _navType; }
        x_rc setNavType(std::string navTypeStr);

        x_prn prn() const { return _prn; }
        x_rc getCrd(const x_time &tt, double &xc, double &vv, bool useCorr) const;
        void setOrbCorr(const x_orbCorr *orbCorr);
        void setClkCorr(const x_clkCorr *clkCorr);
        const x_time &receptDateTime() const { return _receptDateTime; }
        const std::string receptStaID() const { return _receptStaID; }
        static std::string rinexDateStr(const x_time &tt, const x_prn &prn, double version);
        static std::string rinexDateStr(const x_time &tt, const std::string &prnStr, double version);
        static std::string navTypeString(x_eph_navType navType, const x_prn &prn, double version);
        static bool earlierTime(const XEph *eph1, const XEph *eph2) { return eph1->_ephTime < eph2->_ephTime; }
        static bool prnSort(const XEph *eph1, const XEph *eph2) { return eph1->prn() < eph2->prn(); }

    protected:
        virtual x_rc position(int GPSweek, double GPSweeks, double *xc, double *vv) const = 0;
        virtual x_rc positoon(int)
        x_prn _prn;
        x_time _ephTime;
        x_time _receptDateTime;
        std::string _receptStaID;
        x_eph_checkState _checkState;
        x_eph_navType _navType; // defined in RINEX 4
        x_orbCorr *_orbCorr;
        x_clkCorr *_clkCorr;
    };

    class x_ephGPS : public XEph
    {
        friend class x_ephEncoder;
        friend class RTCM3Decoder;

    public:
        x_ephGPS()
        {
            _clock_bias = 0.0;
            _clock_drift = 0.0;
            _clock_driftrate = 0.0;
            _IODE = 0.0;
            _Crs = 0.0;
            _Delta_n = 0.0;
            _M0 = 0.0;
            _Cuc = 0.0;
            _e = 0.0;
            _Cus = 0.0;
            _sqrt_A = 0.0;
            _TOEsec = 0.0;
            _Cic = 0.0;
            _OMEGA0 = 0.0;
            _Cis = 0.0;
            _i0 = 0.0;
            _Crc = 0.0;
            _omega = 0.0;
            _OMEGADOT = 0.0;
            _IDOT = 0.0;
            _L2Codes = 0.0;
            _TOEweek = 0.0;
            _L2PFlag = 0.0;
            _ura = 0.0;
            _health = 0.0;
            _TGD = 0.0;
            _IODC = 0.0;
            _TOT = 0.0;
            _fitInterval = 0.0;
            _ADOT = 0.0;
            _top = 0.0;
            _Delta_n_dot = 0.0;
            _URAI_NED0 = 0.0;
            _URAI_NED1 = 0.0;
            _URAI_NED2 = 0.0;
            _URAI_ED = 0.0;
            _ISC_L1CA = 0.0;
            _ISC_L2C = 0.0;
            _ISC_L5I5 = 0.0;
            _ISC_L5Q5 = 0.0;
            _ISC_L1Cd = 0.0;
            _ISC_L1Cp = 0.0;
            _wnop = 0.0;
            _receptStaID = "";
        }
        x_ephGPS(double rnxVersion, std::list<std::string> &lines);
        virtual ~x_ephGPS() {}

        virtual x_eph_sys type() const
        {
            switch (_prn.system())
            {
            case 'J':
                return x_eph_sys::QZSS;
            case 'I':
                return x_eph_sys::IRNSS;
            };
            return x_eph_sys::GPS;
        }
        virtual std::string toString(double version) const;
        virtual unsigned int IOD() const { return static_cast<unsigned int>(_IODE); }
        virtual unsigned int isUnhealthy() const { return static_cast<unsigned int>(_health); }
        double TGD() const { return _TGD; } // Timing Group Delay (P1-P2 DCB)

    private:
        virtual x_rc position(int GPSweek, double GPSweeks, double *xc, double *vv) const;

        double _clock_bias;      // [s]
        double _clock_drift;     // [s/s]
        double _clock_driftrate; // [s/s^2]

        double _IODE;    // IODEC in case of IRNSS
        double _Crs;     // [m]
        double _Delta_n; // [rad/s]
        double _M0;      // [rad]

        double _Cuc;    // [rad]
        double _e;      // []
        double _Cus;    // [rad]
        double _sqrt_A; // [m^0.5]

        double _TOEsec; // [s of GPS week]
        double _Cic;    // [rad]
        double _OMEGA0; // [rad]
        double _Cis;    // [rad]

        double _i0;       // [rad]
        double _Crc;      // [m]
        double _omega;    // [rad]
        double _OMEGADOT; // [rad/s]

        double _IDOT;    // [rad/s]
        double _L2Codes; // Codes on L2 channel  (not valid for IRNSS)
        double _TOEweek; // GPS week # to go with TOE, cont. number, not mode 1024
        double _L2PFlag; // L2 P data flag (not valid for IRNSS and QZSS)

        mutable double _ura; // SV accuracy [m]
        double _health;      // SV health
        double _TGD;         // [s]
        double _IODC;        // (not valid for IRNSS)

        double _TOT;         // Transmission time
        double _fitInterval; // Fit interval in hours (not valid for IRNSS)

        double _ADOT;        // [m/s]
        double _top;         // [s]
        double _Delta_n_dot; // [rad/s^2]

        double _URAI_NED0; // []
        double _URAI_NED1; // []
        double _URAI_NED2; // []
        double _URAI_ED;   // []

        double _ISC_L1CA; // [s]
        double _ISC_L2C;  // [s]
        double _ISC_L5I5; // [s]
        double _ISC_L5Q5; // [s]
        double _ISC_L1Cd; // [s]
        double _ISC_L1Cp; // [s]

        double _wnop; // GPS continuous week number with the ambiguity resolved
    };

    class x_ephGlo : public XEph
    {
        friend class x_ephEncoder;
        friend class RTCM3Decoder;

    public:
        x_ephGlo()
        {
            // _xv.ReSize(6);
            //_xv = 0.0;
            _gps_utc = 0.0;
            _tau = 0.0;
            _gamma = 0.0;
            _tki = 0.0;
            _x_pos = 0.0;
            _x_velocity = 0.0;
            _x_acceleration = 0.0;
            _health = 0.0;
            _y_pos = 0.0;
            _y_velocity = 0.0;
            _y_acceleration = 0.0;
            _frequency_number = 0.0;
            _z_pos = 0.0;
            _z_velocity = 0.0;
            _z_acceleration = 0.0;
            _E = 0.0;
            _almanac_health = 0.0;
            _almanac_health_availablility_indicator = 0.0;
            _additional_data_availability = 0.0;
            _tauC = 0.0;
            _P1 = 0.0;
            _P2 = 0.0;
            _P3 = 0.0;
            _NA = 0.0;
            _M_P = 0.0;
            _M_l3 = 0.0;
            _M_delta_tau = 0.0;
            _M_P4 = 0.0;
            _M_FT = 0.0;
            _M_NT = 0.0;
            _M_M = 0.0;
            _M_N4 = 0.0;
            _M_tau_GPS = 0.0;
            _M_l5 = 0.0;
            _receptStaID = "";
            _flags_unknown = true;
        }
        x_ephGlo(double rnxVersion, std::list<std::string> &lines);
        virtual ~x_ephGlo() {}

        virtual x_eph_sys type() const { return x_eph_sys::GLONASS; }
        virtual std::string toString(double version) const;
        virtual unsigned int IOD() const;
        virtual unsigned int isUnhealthy() const;
        virtual int slotNum() const { return int(_frequency_number); }

    private:
        virtual x_rc position(int GPSweek, double GPSweeks, double *xc, double *vv) const;
        static double glo_deriv(double /* tt */, const double &xv, double *acc);

        mutable x_time _tt;    // time
        mutable double _xv[6]; // status vector (position, velocity) at time _tt

        double _gps_utc;
        double _tau;         // [s]
        double _gamma;       // [-]
        mutable double _tki; // message frame time

        double _x_pos;          // [km]
        double _x_velocity;     // [km/s]
        double _x_acceleration; // [km/s^2]
        double _health;         // 0 = O.K. MSB of Bn word

        double _y_pos;            // [km]
        double _y_velocity;       // [km/s]
        double _y_acceleration;   // [km/s^2]
        double _frequency_number; // ICD-GLONASS data position

        double _z_pos;          // [km]
        double _z_velocity;     // [km/s]
        double _z_acceleration; // [km/s^2]
        double _E;              // Age of Information [days]

        double _almanac_health; // Cn word
        double _almanac_health_availablility_indicator;

        double _additional_data_availability; //
        double _tauC;                         // GLONASS time scale correction to UTC(SU) time [sec]
        double _P1;                           // flag of the immediate data updating [-]
        double _P2;                           // flag of oddness or evenness of the value of tb for intervals 30 or 60 minutes [-]
        double _P3;                           // flag indicating a number of satellites for which almanac is transmitted within given frame [-]
        double _NA;                           // calendar day number within the 4-year period [days]

        double _M_P;         // control segment parameter that indicates the satellite operation mode with respect of time parameters
        double _M_l3;        // health flag
        double _M_delta_tau; // [sec]
        double _M_P4;        // flag to show that ephemeris parameters are present [-]
        double _M_FT;        // Indicator for predicted satellite User Range Accuracy (URAI) [-]
        double _M_NT;        // current date, calendar number of day within 4-year interval [days]
        double _M_M;         // type of satellite transmitting navigation signal: 0 = GLONASS, 1 = GLONASS-M satellite [-]
        double _M_N4;        // 4-year interval number starting from 1996
        double _M_tau_GPS;   // correction to GPS time relative to GLONASS time [days]
        double _M_l5;        // health flag
        bool _flags_unknown; // status and health flags are unknown (rnx version < 3.05) or known (rnx version >= 3.05)
    };

    class x_ephGal : public XEph
    {
        friend class x_ephEncoder;
        friend class RTCM3Decoder;

    public:
        x_ephGal()
        {
            _clock_bias = 0.0;
            _clock_drift = 0.0;
            _clock_driftrate = 0.0;
            _IODnav = 0.0;
            _Crs = 0.0;
            _Delta_n = 0.0;
            _M0 = 0.0;
            _Cuc = 0.0;
            _e = 0.0;
            _Cus = 0.0;
            _sqrt_A = 0.0;
            _TOEsec = 0.0;
            _Cic = 0.0;
            _OMEGA0 = 0.0;
            _Cis = 0.0;
            _i0 = 0.0;
            _Crc = 0.0;
            _omega = 0.0;
            _OMEGADOT = 0.0;
            _IDOT = 0.0;
            _TOEweek = 0.0;
            _SISA = 0.0;
            _E5aHS = 0.0;
            _E5bHS = 0.0;
            _E1_bHS = 0.0;
            _BGD_1_5A = 0.0;
            _BGD_1_5B = 0.0;
            _TOT = 0.0;
            _receptStaID = "";
        };
        x_ephGal(double rnxVersion, const std::list<std::string> &lines);
        virtual ~x_ephGal() {}

        virtual std::string toString(double version) const;
        virtual x_eph_sys type() const { return x_eph_sys::Galileo; }
        virtual unsigned int IOD() const { return static_cast<unsigned long>(_IODnav); }
        virtual unsigned int isUnhealthy() const;

    private:
        virtual x_rc position(int GPSweek, double GPSweeks, double *xc, double *vv) const;

        double _clock_bias;      //  [s]
        double _clock_drift;     //  [s/s]
        double _clock_driftrate; //  [s/s^2]

        double _IODnav;
        double _Crs;     //  [m]
        double _Delta_n; //  [rad/s]
        double _M0;      //  [rad]

        double _Cuc;    //  [rad]
        double _e;      //
        double _Cus;    //  [rad]
        double _sqrt_A; //  [m^0.5]

        double _TOEsec; //  [s]
        double _Cic;    //  [rad]
        double _OMEGA0; //  [rad]
        double _Cis;    //  [rad]

        double _i0;       //  [rad]
        double _Crc;      //  [m]
        double _omega;    //  [rad]
        double _OMEGADOT; //  [rad/s]

        double _IDOT; //  [rad/s]
        double _TOEweek;
        // spare

        mutable double _SISA; // Signal In Space Accuracy
        double _E5aHS;        //  [0..3] E5a Health Status
        double _E5bHS;        //  [0..3] E5b Health Status
        double _E1_bHS;       //  [0..3] E1-b Health Status
        double _BGD_1_5A;     //  group delay [s]
        double _BGD_1_5B;     //  group delay [s]

        double _TOT; // [s]
        /** Data comes from I/NAV when <code>true</code> */
        bool _inav;
        /** Data comes from F/NAV when <code>true</code> */
        bool _fnav;
        /** E1 Data is not valid */
        bool _e1DataInValid;
        /** E5A Data is not valid */
        bool _e5aDataInValid;
        /** E5B Data is not valid */
        bool _e5bDataInValid;
    };

    class x_ephSBAS : public XEph
    {
        friend class x_ephEncoder;
        friend class RTCM3Decoder;

    public:
        x_ephSBAS()
        {
            _IODN = 0;
            _TOT = 0.0;
            _agf0 = 0.0;
            _agf1 = 0.0;
            _x_pos = 0.0;
            _x_velocity = 0.0;
            _x_acceleration = 0.0;
            _y_pos = 0.0;
            _y_velocity = 0.0;
            _y_acceleration = 0.0;
            _z_pos = 0.0;
            _z_velocity = 0.0;
            _z_acceleration = 0.0;
            _ura = 0.0;
            _health = 0.0;
            _receptStaID = "";
        }
        x_ephSBAS(double rnxVersion, const std::list<std::string> &lines);
        virtual ~x_ephSBAS() {}

        virtual x_eph_sys type() const { return x_eph_sys::SBAS; }
        virtual unsigned int IOD() const;
        virtual unsigned int isUnhealthy() const;
        virtual std::string toString(double version) const;

    private:
        virtual x_rc position(int GPSweek, double GPSweeks, double *xc, double *vv) const;

        int _IODN;
        double _TOT;  // not used (set to  0.9999e9)
        double _agf0; // [s]    clock correction
        double _agf1; // [s/s]  clock correction drift

        double _x_pos;          // [m]
        double _x_velocity;     // [m/s]
        double _x_acceleration; // [m/s^2]

        double _y_pos;          // [m]
        double _y_velocity;     // [m/s]
        double _y_acceleration; // [m/s^2]

        double _z_pos;          // [m]
        double _z_velocity;     // [m/s]
        double _z_acceleration; // [m/s^2]

        mutable double _ura;
        double _health;
    };

    class x_ephBDS : public XEph
    {
        friend class x_ephEncoder;
        friend class RTCM3Decoder;

    public:
        x_ephBDS()
        {
            _TOT = 0.0;
            _AODE = 0;
            _AODC = 0;
            _URAI = 0;
            _URA = 0.0;
            _clock_bias = 0.0;
            _clock_drift = 0.0;
            _clock_driftrate = 0.0;
            _Crs = 0.0;
            _Delta_n = 0.0;
            _M0 = 0.0;
            _Cuc = 0.0;
            _e = 0.0;
            _Cus = 0.0;
            _sqrt_A = 0.0;
            _Cic = 0.0;
            _OMEGA0 = 0.0;
            _Cis = 0.0;
            _i0 = 0.0;
            _Crc = 0.0;
            _omega = 0.0;
            _OMEGADOT = 0.0;
            _IDOT = 0.0;
            _TOEsec = 0.0;
            _BDTweek = 0.0;
            _Delta_n_dot = 0.0;
            _satType = 0.0;
            _top = 0.0;
            _SISAI_oe = 0.0;
            _SISAI_ocb = 0.0;
            _SISAI_oc1 = 0.0;
            _SISAI_oc2 = 0.0;
            _ISC_B1Cd = 0.0;
            _ISC_B2ad = 0.0;
            _TGD1 = 0.0;
            _TGD2 = 0.0;
            _TGD_B1Cp = 0.0;
            _TGD_B2ap = 0.0;
            _TGD_B2bI = 0.0;
            _SISMAI = 0.0;
            _SatH1 = 0;
            _health = 0;
            _INTEGRITYF_B1C = 0.0;
            _INTEGRITYF_B2aB1C = 0.0;
            _INTEGRITYF_B2b = 0.0;
            _IODC = 0.0;
            _IODE = 0.0;
            _receptStaID = "";
        }
        x_ephBDS(double rnxVersion, const std::list<std::string> &lines);
        virtual ~x_ephBDS() {}

        virtual x_eph_sys type() const { return x_eph_sys::BDS; }
        virtual unsigned int IOD() const;
        virtual unsigned int isUnhealthy() const;
        virtual std::string toString(double version) const;

    private:
        virtual x_rc position(int GPSweek, double GPSweeks, double *xc, double *vv) const;

        double _TOT; // [s] of BDT week
        x_time _TOE;
        int _AODE;
        int _AODC;
        int _URAI;               // [0..15] index from RTCM stream
        mutable double _URA;     // user range accuracy [m]
        double _clock_bias;      // [s]
        double _clock_drift;     // [s/s]
        double _clock_driftrate; // [s/s^2]
        double _Crs;             // [m]
        double _Delta_n;         // [rad/s]
        double _M0;              // [rad]
        double _Cuc;             // [rad]
        double _e;               //
        double _Cus;             // [rad]
        double _sqrt_A;          // [m^0.5]
        double _Cic;             // [rad]
        double _OMEGA0;          // [rad]
        double _Cis;             // [rad]
        double _i0;              // [rad]
        double _Crc;             // [m]
        double _omega;           // [rad]
        double _OMEGADOT;        // [rad/s]
        double _IDOT;            // [rad/s]
        double _TOEsec;          // [s] of BDT week
        double _BDTweek;         // BDT week

        double _Delta_n_dot; // [rad/s^2]
        double _satType;     // 0..reserved, 1..GEO, 2..IGSO, 3..MEO
        double _top;         // [s]

        double _SISAI_oe;  // []
        double _SISAI_ocb; // []
        double _SISAI_oc1; // []
        double _SISAI_oc2; // []

        double _ISC_B1Cd; // [s]
        double _ISC_B2ad; // [s]

        double _TGD1;     // [s]
        double _TGD2;     // [s]
        double _TGD_B1Cp; // [s]
        double _TGD_B2ap; // [s]
        double _TGD_B2bI; // [s]

        double _SISMAI; // []

        int _SatH1;  //
        int _health; //

        double _INTEGRITYF_B1C;    // 3 bits word from sf 3
        double _INTEGRITYF_B2aB1C; // 6 bits word with integrity bits in msg 10-11, 30.34 or 40
        double _INTEGRITYF_B2b;    // 3 bits word from msg 10

        double _IODC; // []
        double _IODE; // [] IODE are the same as the 8 LSBs of IODC
    };
