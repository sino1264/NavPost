#pragma once

#include <functional>
#include <unordered_map>
#include <string>

#include "util.h"

#include "nlohmann/json.hpp"
using json = nlohmann::json;


struct coord_item
{
    std::string coord_profile;
    double ecef_x;
    double ecef_y;
    double ecef_z;
    int datum;
    double epoch;

    NLOHMANN_DEFINE_TYPE_INTRUSIVE(coord_item,coord_profile,ecef_x,ecef_y,ecef_z,datum,epoch);
};


class station
{  
    //站点名称
    PROPERTY_AUTO(std::string,station_name)
    PROPERTY_AUTO(std::string,UID)

    PROPERTY_ENUM(StationType,station_type)
    PROPERTY_AUTO(bool,is_dynamic)
    PROPERTY_AUTO(bool,is_disabled)

    //静态站点才有的信息(当前使用的坐标信息)
    PROPERTY_AUTO(std::string,coord_profile)
    PROPERTY_AUTO(double,ecef_x)
    PROPERTY_AUTO(double,ecef_y)
    PROPERTY_AUTO(double,ecef_z)
    PROPERTY_AUTO(int,datum)
    PROPERTY_AUTO(double,epoch)

    //天线信息
    PROPERTY_AUTO(std::string,antenna_profile)
    PROPERTY_AUTO(double,measured_height)
    PROPERTY_AUTO(double,offset_ARP_to_L1)
    PROPERTY_AUTO(double,applied_height)
    PROPERTY_AUTO(double,ant_corr0)//measured_to_ARP
    PROPERTY_AUTO(double,ant_corr1)//slant_measurement
    PROPERTY_AUTO(double,ant_corr2)//reduis_of_ground_plane
    PROPERTY_AUTO(double,ant_corr3)//offset_from_ARP_to_ground_plane

private:
    PROPERTY_AUTO(double,is_deleted);  //对象已经被删除的标志，如果执行了不可回退的指令，那么所有已经设置为删除标志的对象会被真的删除和释放


    //站点基本信息
    std::unordered_map<std::string,std::string> m_obs_map;  //站点包含的所有观测文件信息
    std::unordered_map<std::string,std::string> m_res_map;  //站点包含的所有结果信息          uid,json数据

    std::unordered_map<std::string,coord_item> m_coord_map;  //站点包含的所有坐标信息   //设置坐标  default

 
public:

    void forEachCoordItem(const std::function<void(const std::string&, const coord_item&)>& callback) const {
        for (const auto& [key, st] : m_coord_map) {
            callback(key, st);
        }
    };



};

