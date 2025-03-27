#pragma once

#include "util.h"

#include "nlohmann/json.hpp"
using json = nlohmann::json;

class obsfile
{
    PROPERTY_AUTO(std::string,UID)
    PROPERTY_AUTO(std::string,file_name)
    PROPERTY_ENUM(FileFormat,file_format)
    PROPERTY_AUTO(std::string,file_path)

    PROPERTY_AUTO(std::string,station_UID) //归属站点
    // PROPERTY_AUTO(std::string,station_name)

    PROPERTY_AUTO(std::string,navifile_UID) //使用星历

private:
    /* data */
public:

};


