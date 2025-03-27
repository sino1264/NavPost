#pragma once
#include "x_constexpr.h"

/*
    内部编号和卫星号互转
*/
class x_prn
{
private:
    /* data */
    char _system;

public:
    x_prn(/* args */);
    ~x_prn();

    char system() const
    {
        return _system;
    }

    bool operator<(const x_prn &other) const
    {
        return true;
    };
    bool operator>(const x_prn &other) const
    {
        return true;
    };
    bool operator==(const x_prn &other) const
    {
        return true;
    };
    bool operator!=(const x_prn &other) const
    {
        return true;
    };
};

x_prn::x_prn(/* args */)
{
}

x_prn::~x_prn()
{
}
