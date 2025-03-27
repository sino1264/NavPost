#include "NavCore.h"
#include <iostream>
#include <fstream>
#include <filesystem> // C++17中的文件系统库
#include <mutex>


NavCore::NavCore(/* args */)
{
    m_logger = spdlog::default_logger();
}

NavCore *NavCore::getInstance()
{
    static NavCore *instance = new NavCore();
    return instance;
}


// NavCore::~NavCore()
// {
// }

// bool NavCore::add_new_stations(json stationlist)
// {

//     // auto addStationCmd = std::make_shared<AddStationCmd>(text, ", world!");
//     // _history.executeCommand(addStationCmd);

//     return true;
// }

int NavCore::initProject(json info)
{
    SPDLOG_LOGGER_INFO(m_logger, "初始化工程...");

           // 将project_info，保存到内部
    // m_project_info = projcet_info;
    project_info(info);
    UID(info,"UID");
    project_name(info,"project_name");
    project_path(info,"project_path");
    project_work_path(project_path() + "/" + project_name());
    project_file(project_work_path() + "/" + project_name()+".nps");

    std::chrono::system_clock::time_point now = std::chrono::system_clock::now();
    std::time_t now_c = std::chrono::system_clock::to_time_t(now);
    std::chrono::seconds seconds = std::chrono::duration_cast<std::chrono::seconds>(now.time_since_epoch());
    //设置创建日期和修改日期
    project_creation_date(seconds.count());
    project_modification_date(seconds.count());

    // 执行一次save操作
    SPDLOG_LOGGER_INFO(m_logger, "在指定目录下创建工程...");

    if (!std::filesystem::exists(m_project_work_path))
    {
        SPDLOG_LOGGER_INFO(m_logger, "创建工程文件夹: {}", m_project_work_path);
        std::filesystem::create_directories(m_project_work_path); // 创建目录
    }
    else
    {
        SPDLOG_LOGGER_INFO(m_logger, "保存到指定目录: {}", m_project_work_path);
    }

           // 打开文件并写入 JSON
    std::ofstream outFile(m_project_file);
    if (!outFile)
    {
        SPDLOG_LOGGER_ERROR(m_logger, "无法打开工程文件！{}",m_project_file);
        return 1;
    }


    SPDLOG_LOGGER_INFO(m_logger, "保存工程信息...");
    outFile << m_project_info.dump(4); // 将 JSON 格式化输出到文件，4 表示缩进级别
    outFile.close();

    SPDLOG_LOGGER_INFO(m_logger, "工程已保存！");

    m_is_modified = false;

    return 0;
}

int NavCore::loadProject(std::string project_path)
{
    SPDLOG_LOGGER_DEBUG(m_logger, "载入工程：{}", project_path);
    // 打开文件并读取 JSON
    std::ifstream inFile(project_path + "/project.json");
    if (!inFile)
    {
        SPDLOG_LOGGER_ERROR(m_logger, "无法打开工程文件");
        return 1;
    }

    SPDLOG_LOGGER_DEBUG(m_logger, "解析工程文件...");
    inFile >> m_project_info; // 将文件内容解析为 JSON 对象
    inFile.close();

           // 输出解析后的 JSON 对象
    SPDLOG_LOGGER_DEBUG(m_logger, "工程解析完成！");                      // 以格式化方式输出 JSON
    SPDLOG_LOGGER_DEBUG(m_logger, "工程信息:{}", m_project_info.dump(4)); // 以格式化方式输出 JSON

           // 将配置文件中的信息读取到map中

    return 0;
}

int NavCore::saveProject(std::string project_work_path)
{
    SPDLOG_LOGGER_DEBUG(m_logger, "保存工程信息");
    // 将工程当前状态保存到指定目录（目录修改则为另存为，目录不修改则为保存）
    if (m_project_file != project_work_path)
    {
        // 执行另存为需要的初始化操作,譬如工程文件的迁移？
        project_work_path = project_work_path;
    }
    // 工程路径为打开文件时候的路径（工程文件中保留的软件生成的信息均为相对路径）

    /*
    保存的内容：
        工程基本信息：工程名、创建日期、坐标系统、时间系统等

                   已经创建的站点信息：UID-json

                      已经导入的文件信息：UID-json列表

             已经生成的基线信息：UID-json列表

                      已经处理过的结果信息：UID-json
             */

           // 将map的内容存储到json对象中
           // json station_list;
           // for(auto iter:m_station_map)
           // {
           //     station_list.push_back(iter.second);
           // }
           // json obsfile_list;
           // for(auto iter:m_obsfile_map)
           // {
           //     obsfile_list.push_back(iter.second);
           // }
           // json baseline_list;
           // for(auto iter:m_baseline_map)
           // {
           //     baseline_list.push_back(iter.second);
           // }
           // json result_list;
           // for (auto iter:m_result_map)
           // {
           //     result_list.push_back(iter.second);
           // }

    if (!std::filesystem::exists(m_project_path))
    {
        SPDLOG_LOGGER_DEBUG(m_logger, "指定目录文件不存在. 创建指定目录: {}", m_project_path);
        std::filesystem::create_directories(m_project_path); // 创建目录
    }
    else
    {
        SPDLOG_LOGGER_DEBUG(m_logger, "保存到指定目录: {}", m_project_path);
    }

           // 打开文件并写入 JSON
    std::ofstream outFile(m_project_file+".cps");
    if (!outFile)
    {
        SPDLOG_LOGGER_ERROR(m_logger, "无法打开工程文件！");
        return 1;
    }

    SPDLOG_LOGGER_DEBUG(m_logger, "保存工程信息...");
    outFile << m_project_info.dump(4); // 将 JSON 格式化输出到文件，4 表示缩进级别
    outFile.close();

    SPDLOG_LOGGER_DEBUG(m_logger, "工程已保存！");

    m_is_modified = false;

    return 0;
}

int NavCore::exitProject()
{
    // 直接clear所有的内部变量和map
    SPDLOG_LOGGER_INFO(m_logger, "工程已关闭！");

    return 0;
}

// bool NavCore::isProjectModified()
// {
//     // 每个指令执行后，都需要添加日志（指令指的是回使得内部数据改变的内容）
//     // 每写入一条日志，_isModified的状态就变成true
//     // 只有执行 save_project的时候，才会设置成false

//     return m_isModified;
// }


int NavCore::addStation(json info)
{
    SPDLOG_LOGGER_DEBUG(m_logger, ":{}", info.dump(4));
    // m_invoker.executeCommand(std::make_shared<AddStationCmd>(info));    
    //给站点添加（修改坐标）坐标，设置坐标的时候，要传递坐标的ID（默认值为default）、坐标值，坐标的框架（枚举类型）（默认WGS84)、坐标历元(默认为0）

    station obj;

    obj.UID(info,"station_UID");
    obj.station_name(info,"station_name");

    obj.station_type(info,"station_type");
    obj.is_disabled(info,"is_disabled");
    obj.is_dynamic(info,"is_dynamic");

    obj.coord_profile(info,"coord_profile");
    obj.ecef_x(info,"ecef_x");
    obj.ecef_y(info,"ecef_y");
    obj.ecef_z(info,"ecef_z");
    obj.datum(info,"datum");
    obj.epoch(info,"epoch");

    obj.antenna_profile(info,"antenna_profile");
    obj.measured_height(info,"measured_height");
    obj.offset_ARP_to_L1(info,"offset_ARP_to_L1");
    obj.applied_height(info,"applied_height");
    obj.ant_corr0(info,"ant_corr0");
    obj.ant_corr1(info,"ant_corr1");
    obj.ant_corr2(info,"ant_corr2");
    obj.ant_corr3(info,"ant_corr3");


    auto item=m_station_map.find(obj.UID());
    if(item!=m_station_map.end())
    {
        return 1;  //添加站点失败，已经存在相同的UID记录（不应当发生）
    }

    m_station_map.insert(std::pair(obj.UID(),obj));

    return 0;
}

int NavCore::setStation(json info)
{
    return 0;
}

int NavCore::delStation(json info)
{
    return 0;
}

const station NavCore::getStation(std::string UID) const {
    auto it = m_station_map.find(UID);
    if (it == m_station_map.end()) {
        return station();
        // throw std::runtime_error("ID not found");
    }
    return it->second;
}


int NavCore::addObsFile(json info)
{
    SPDLOG_LOGGER_DEBUG(m_logger, ":{}", info.dump(4));
    // m_invoker.executeCommand(std::make_shared<AddStationCmd>(info));
    //给站点添加（修改坐标）坐标，设置坐标的时候，要传递坐标的ID（默认值为default）、坐标值，坐标的框架（枚举类型）（默认WGS84)、坐标历元(默认为0）

    obsfile obj;

    obj.UID(info,"obsfile_UID");
    obj.file_name(info,"obsfile_name");
    obj.file_format(info,"obsfile_format");
    obj.file_path(info,"obsfile_path");

    obj.station_UID(info,"station_UID");

    obj.navifile_UID(info,"navifile_UID");

    auto item=m_obsfile_map.find(obj.UID());
    if(item!=m_obsfile_map.end())
    {
        return 1;  //添加站点失败，已经存在相同的UID记录（不应当发生）
    }
    m_obsfile_map.insert(std::pair(obj.UID(),obj));

    //查询站点UID是否存在，不存在则创建站点并添加
    auto station_item=m_station_map.find(obj.station_UID());
    if(station_item==m_station_map.end())
    {
        addStation(info);
    }

    //查询星历UID是否存在，不存在则创建星历并添加
    auto navfile_item=m_navfile_map.find(obj.navifile_UID());
    if(navfile_item==m_navfile_map.end())
    {
        addNavFile(info);
    }

    return 0;
}

int NavCore::setObsFile(json info)
{
    return 0;
}

int NavCore::delObsFile(json info)
{
    return 0;
}

int NavCore::addNavFile(json info)
{
    return 0;
}

int NavCore::setNavFile(json info)
{
    return 0;
}

int NavCore::delNavFile(json info)
{
    return 0;
}


int NavCore::undo()
{
    return 0;
}

int NavCore::redo()
{
    return 0;
}

std::string NavCore::addSacnTask(json info)
{
    //选择文件

    //创建一个FileDecoder

    //解析坐标
  return std::string();
}

std::string NavCore::addSppTask(json info)
{
    //创建一个单点定位模块

    //json转换成配置文件

    //添加到TaskQueue

    //返回Task的UID（索引）；

    return std::string();

}

std::string NavCore::addRtkTask(json info)
{
  return std::string();
}

int NavCore::startTask(std::string uid)
{
    return 0;
}

int NavCore::pauseTask(std::string uid)
{
 return 0;
}

int NavCore::unpauseTask(std::string uid)
{
    return 0;
}

int NavCore::stopTask(std::string uid)
{
    return 0;
}

json NavCore::getTaskStatus(std::string uid)
{
    return json();
}

void NavCore::forEachStation(const std::function<void (const std::string &, const station &)> &callback) const
{
    for (const auto &[key, st] : m_station_map)
    {
        callback(key, st);
    }
}

void NavCore::forEachObsfile(const std::function<void (const std::string &, const obsfile &)> &callback) const
{
    for (const auto &[key, st] : m_obsfile_map)
    {
        callback(key, st);
    }
}

void NavCore::forEachNavfile(const std::function<void (const std::string &, const navfile &)> &callback) const
{
    for (const auto &[key, st] : m_navfile_map)
    {
        callback(key, st);
    }
}


void NavCore::forEachBaseline(const std::function<void (const std::string &, const baseline &)> &callback) const
{
    for (const auto &[key, st] : m_baseline_map)
    {
        callback(key, st);
    }
};
