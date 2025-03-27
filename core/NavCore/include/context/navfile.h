#pragma once

#include "util.h"

#include "nlohmann/json.hpp"
using json = nlohmann::json;

class navfile
{
    PROPERTY_AUTO(std::string,UID)
    PROPERTY_AUTO(std::string,file_name)

private:
    /* data */
public:

};


