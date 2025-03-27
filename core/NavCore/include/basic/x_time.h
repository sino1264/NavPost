#pragma once
#include <chrono>
#include <string>
#include <vector>
#include <algorithm>
#include <map>

// 时间系统
enum class TimeSystem
{
    NIL, // 非标准时间，算术时间
    UTC,
    GPS,
    BDS,
    Galileo,
    GLONASS,
    TimeZone // 用于处理时区
};

enum class TimeStrFormat
{
    UTC_SEC,
    YMD_HMS,
    DAY_SEC,
    WEEK_SEC
};

enum class DayOfWeek
{
    Sunday = 0,
    Monday,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Saturday,
    Invalid // 用于处理无效值
};

// 定义从1980年到现在的闰秒（假设数据是准确的）
std::vector<time_t> leapSeconds = {
    46828800,   // 1981-06-30
    78364801,   // 1982-06-30
    109900802,  // 1983-06-30
    173059203,  // 1985-06-30
    252028804,  // 1987-12-31
    315187205,  // 1989-12-31
    346723206,  // 1990-12-31
    393984007,  // 1992-06-30
    425520008,  // 1993-06-30
    457056009,  // 1994-06-30
    504489610,  // 1995-12-31
    551750411,  // 1997-06-30
    599184012,  // 1998-12-31
    820108813,  // 2005-12-31
    914803214,  // 2008-12-31
    1025136015, // 2012-06-30
    1119744016, // 2015-06-30
    1167264017  // 2016-12-31
};

time_t date2time(int year, int month, int day, int hour, int minute, int second)
{
    struct tm timeInfo;
    timeInfo.tm_year = year - 1900; // 年份从 1900 年开始计算
    timeInfo.tm_mon = month - 1;    // 月份从 0 开始计算
    timeInfo.tm_mday = day;
    timeInfo.tm_hour = hour;
    timeInfo.tm_min = minute;
    timeInfo.tm_sec = second;
    timeInfo.tm_isdst = 0; // 不考虑夏令时
#if defined(_WIN32)
    // 在 Windows 上的 UTC 转换
    return _mkgmtime(&timeInfo);
#else
    // 在 Linux 上直接使用 timegm
    return timegm(&timeInfo);
#endif
    // return timegm(&timeInfo); // 将时间结构转换为 UTC 时间的秒数
}

const int totalLeapSeconds = leapSeconds.size(); // 总闰秒数
static const time_t lastLeapSecond = 1167264017; // 最后一次闰秒的时间

// 各个时间系统相对于UTC的时间偏移量（秒）
const std::map<TimeSystem, time_t> timeOffsets = {
    {TimeSystem::GPS, 315964800},     // GPS时间相对于UTC时间的偏移量（秒）
    {TimeSystem::BDS, 1356000000},    // BDS时间相对于UTC时间的偏移量（秒）
    {TimeSystem::Galileo, 315964800}, // Galileo时间相对于UTC时间的偏移量（秒）
    {TimeSystem::GLONASS, 10800}      // GLONASS时间相对于UTC时间的偏移量（秒）
};

// 计算给定时间点前的闰秒总数
int calculateLeapSeconds(time_t time)
{
    if (time > lastLeapSecond)
    {
        return totalLeapSeconds;
    }

    return std::count_if(leapSeconds.begin(), leapSeconds.end(), [time](time_t leapSecond)
                         { return leapSecond <= time; });
}

// 将不同时间系统或时区的时间转换为UTC时间
time_t time2utc(time_t inputTime, TimeSystem system, int timeZoneOffset = 0)
{
    if (timeOffsets.find(system) != timeOffsets.end()) // GNSS导航系统的转换
    {
        time_t utcTime = inputTime + timeOffsets.at(system);
        int leapSeconds = calculateLeapSeconds(utcTime);
        return utcTime - leapSeconds;
    }
    else if (system == TimeSystem::TimeZone)
    {
        return inputTime - timeZoneOffset * 3600;
    }
    else // TimeSystem::UTC   TimeSystem::NIL
    {
        return inputTime;
    }
}

// 将UTC时间转换为不同时区或不同时间系统的时间
time_t utc2time(time_t utcTime, TimeSystem system, int timeZoneOffset = 0)
{
    if (timeOffsets.find(system) != timeOffsets.end()) // GNSS导航系统的转换
    {
        int leapSeconds = calculateLeapSeconds(utcTime);
        time_t systemTime = utcTime - timeOffsets.at(system) + leapSeconds;
        return systemTime;
    }
    else if (system == TimeSystem::TimeZone)
    {
        return utcTime + timeZoneOffset * 3600;
    }
    else // TimeSystem::UTC   TimeSystem::NIL
    {
        return utcTime;
    }
}

// 时间基准
struct x_time // 完整数据格式
{
    TimeSystem type = TimeSystem::NIL;
    time_t time = 0;
    double sec = 0.0;

    // 重载小于运算符
    bool operator<(const x_time &other) const
    {
        return false;
    }
};

struct x_time_value // 简略数据格式
{
    time_t time;
    double sec;
};

struct x_time_date
{
    int year;
    int month;
    int day;
    int hour;
    int min;
    double sec;
};

struct x_time_week
{
    int week;      // GPS周
    double sec;    // 周内秒
    DayOfWeek day; // 星期几
};

struct x_time_day
{
    int day;        // 日
    double sec;     // 日内秒
    double percent; // 日内百分比
};

// 获取当前的UTC时间
x_time now_time()
{
    auto now = std::chrono::system_clock::now();

    // 转换为time_t以获取秒级时间戳
    std::time_t now_c = std::chrono::system_clock::to_time_t(now);

    // 获取纳秒部分
    auto duration = now.time_since_epoch();
    auto nanoseconds = std::chrono::duration_cast<std::chrono::nanoseconds>(duration).count() % 1000000000;

    // 填充结构体
    x_time time;
    time.type = TimeSystem::UTC;
    time.time = now_c;
    time.sec = nanoseconds / 1e9; // 将纳秒转换为小数秒

    return time;
};

class XTime
{
private:
    time_t _utc_time; // UTC秒
    double _utc_sec;  // UTC不足一秒的部分
    bool _invalid;    // 数据无效标识（在构造函数的时候，时间系统不明确，因此无法进行时间系统转换）

public:
    // 初始化时间
    XTime(x_time time)
    {
        _utc_time = time2utc(time.time, time.type);
        _utc_sec = time.sec;
        _invalid = time.type == TimeSystem::NIL ? true : false;
    };
    // 初始化时间
    XTime(x_time_value time, TimeSystem tim_sys = TimeSystem::NIL)
    {
        _utc_time = time2utc(time.time, tim_sys);
        _utc_sec = time.sec;
        _invalid = tim_sys == TimeSystem::NIL ? true : false;
    };
    // 初始化时间
    XTime(time_t time, double sec, TimeSystem tim_sys = TimeSystem::NIL)
    {
        _utc_time = time2utc(time, tim_sys);
        _utc_sec = sec;
        _invalid = tim_sys == TimeSystem::NIL ? true : false;
    };
    // 初始化时间
    XTime(double time_sec, TimeSystem tim_sys = TimeSystem::NIL)
    {
        time_t time = static_cast<time_t>(time_sec);
        double sec = time_sec - time;
        _utc_time = time2utc(time, tim_sys);
        _utc_sec = sec;
        _invalid = tim_sys == TimeSystem::NIL ? true : false;
    };

    // // 初始化时间
    // XTime(x_time_date date, TimeSystem tim_sys = TimeSystem::UTC);
    // // 初始化时间
    // XTime(x_time_week week, TimeSystem tim_sys = TimeSystem::GPS);

    ~XTime() {};

    bool Valid()
    {
        return !_invalid;
    };

    // 快速格式化输出
    std::string Str(TimeStrFormat tim_fmt = TimeStrFormat::UTC_SEC)
    {
        return std::string();
    };

    // 获取UTC时间
    x_time UTC()
    {
        if (_invalid)
        {
            return x_time();
        }
        x_time time;
        time.time = _utc_time;
        time.sec = _utc_sec;
        time.type = TimeSystem::UTC;
        return time;
    };
    // 获取GPS时间
    x_time GNSS(TimeSystem tim_sys = TimeSystem::GPS)
    {
        if (_invalid)
        {
            return x_time();
        }
        return x_time{TimeSystem::UTC, utc2time(_utc_time, tim_sys), _utc_sec};
    };
    // 获取时间值
    x_time_value Value()
    {
        return x_time_value{_utc_time, _utc_sec};
    };
    // 获取UTC年月日时分秒
    x_time_date Date()
    {
        if (_invalid)
        {
            return x_time_date();
        }

        x_time_date date;

        // 转换为时间点
        std::chrono::system_clock::time_point tp = std::chrono::system_clock::from_time_t(_utc_time);

        // 转换为std::tm结构
        std::time_t time = std::chrono::system_clock::to_time_t(tp);
        std::tm *gmt_time = std::gmtime(&time);

        // 填充DateTime结构体
        date.year = gmt_time->tm_year + 1900;
        date.month = gmt_time->tm_mon + 1;
        date.day = gmt_time->tm_mday;
        date.hour = gmt_time->tm_hour;
        date.min = gmt_time->tm_min;
        date.sec = gmt_time->tm_sec + _utc_sec;

        return date;
    };
    // // GPS周和秒
    x_time_week Week()
    {
        if (_invalid)
        {
            return x_time_week();
        }
        auto gpstime = utc2time(_utc_time, TimeSystem::GPS);

        x_time_week time;
        time.week = static_cast<int>(gpstime / (86400 * 7));
        time.sec = gpstime - time.week * 86400 * 7;
        int dayOfWeek = time.sec / 86400;
        if (dayOfWeek < 0 || dayOfWeek > 6)
        {
            time.day = DayOfWeek::Invalid; // 处理无效的输入
        }
        else
        {
            time.day = static_cast<DayOfWeek>(dayOfWeek);
        }
        return time;
    };
    // // 获取年积日
    // x_time_day Doy();
    // // 获取儒略日
    // x_time_day JD();
    // // 获取约化儒略日
    // x_time_day MJD();

private:
};
