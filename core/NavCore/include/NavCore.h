#pragma once

#include <unordered_map>
#include <string>
#include <list>
#include "Command.h"
#include "Command_Pattern.h"
// #include "TaskBase.h"
// #include "TaskQueue.h"
#include "context/navfile.h"
#include "context/baseline.h"
#include "context/obsfile.h"
#include "context/station.h"
#include "spdlog/spdlog.h"

using json = nlohmann::json;

// 标准CPP类，提供工程的所有方法，且完全不依赖Qt,保证后端可以脱离Qt运行
class NavCore
{
public:
    NavCore(/* args */);
    virtual ~NavCore() {} // 虚析构函数，确保多态性,只要基类有一个虚函数，就能使用 dynamic_pointer_cast，将g_project转换成派生类

           // 返回单例实例
    static NavCore *getInstance();

public:
    /// @brief
    /// @param externalLogger
    void setLogger(const std::shared_ptr<spdlog::logger> &externalLogger) { m_logger = externalLogger; };

           /// @brief
           /// @param projcet_info
           /// @return
    int initProject(json projcet_info); // 初始化一个工程

           /// @brief
           /// @param project_file
           /// @return
    int loadProject(std::string project_file); // 从文件载入一个工程

           /// @brief
           /// @param work_dir
           /// @return
    int saveProject(std::string work_dir);

           /// @brief
           /// @return
    int exitProject();

           /// @brief  工程是否已经保存（执行除保存、另存之外的任何指令，_isModified都会设置为true）
           /// @return
    bool isProjectModified();

    int addStation(json info);

    int setStation(json info);

    int delStation(json info);

    const station getStation(std::string UID) const;

    int addObsFile(json info);

    int setObsFile(json info);

    int delObsFile(json info);

    int addNavFile(json info);

    int setNavFile(json info);

    int delNavFile(json info);

    // 撤销执行命令
    int undo();
    // 重新执行命令
    int redo();

public:
    //任务队列相关指令，耗时，需要后台处理的任务

    std::string addSacnTask(json info); //创建预解析文件任务，添加文件后，解析文件的基本信息

    std::string addSppTask(json info);  //创建一个单点定位任务

    std::string addRtkTask(json info);  //创建一个RTK处理任务

    int startTask(std::string uid);
    int pauseTask(std::string uid);
    int unpauseTask(std::string uid);
    int stopTask(std::string uid);

    //获取指定任务的状态
    json getTaskStatus(std::string uid);


    //操作指令直接


public:
    // 内部成员遍历函数

           // 站点遍历回调函数
    void forEachStation(const std::function<void(const std::string &, const station &)> &callback) const;

           // 观测文件遍历回调函数
    void forEachObsfile(const std::function<void(const std::string &, const obsfile &)> &callback) const;

           // 星历文件遍历回调函数
    void forEachNavfile(const std::function<void(const std::string &, const navfile &)> &callback) const;

           // 静态基线遍历回调函数
    void forEachBaseline(const std::function<void(const std::string &, const baseline &)> &callback) const;

           // // 使用回调遍历
           // manager.forEachStation([](const std::string& key, const station& st) {
           //     std::cout << "Key: " << key << ", ID: " << st.id << ", Name: " << st.name << std::endl;
           // });

private:
    /* data */
    // json m_project_info;
    PROPERTY_AUTO(nlohmann::json, project_info) // 工程的基本信息

    PROPERTY_AUTO(std::string,UID)
    PROPERTY_AUTO(std::string, project_name)        // 工程名称
    PROPERTY_AUTO(std::string, project_path)        // 工程文件夹所在的文件夹
    PROPERTY_AUTO(std::string, project_work_path)   // 工程文件夹所在的文件夹
    PROPERTY_AUTO(std::string, project_file)        // 保存的工程文件
    PROPERTY_AUTO(time_t,project_creation_date);    //工程创建日期
    PROPERTY_AUTO(time_t,project_modification_date);//工程修改日期

    std::unordered_map<std::string, station> m_station_map;    // key,对象，站点的基本信息
    std::unordered_map<std::string, obsfile> m_obsfile_map;    // key，对象，文件的基本信息，文件的路径
    std::unordered_map<std::string, navfile> m_navfile_map;    // key，对象，文件的基本信息，文件的路径
    std::unordered_map<std::string, baseline> m_baseline_map;  // key，对象（基站，移动站）
    std::unordered_map<std::string, std::string> m_result_map; // key,结果文件的基本信息，结果文件路径
    // TaskQueue m_task_queue;                          // 任务列表

    std::unordered_map<std::string, json> m_static_process_templates;
    std::unordered_map<std::string, json> m_dynamic_process_templates;

private:
    PROPERTY_AUTO(bool, is_modified);

    Invoker m_invoker; // 命令队列

    std::shared_ptr<spdlog::logger> m_logger; // 模块日志器

private:
    // 可执行和回退的操作
    //  friend class Command;
    friend class AddStationCmd; // 添加站点
    friend class DelStationCmd; // 删除站点
    friend class SetStationCmd; // 设置站点

    friend class AddObsFileCmd; // 添加OBS文件
    friend class DelObsFileCmd; // 添加OBS文件
    friend class SetObsFileCmd; // 设置OBS文件

    friend class AddNavFileCmd; // 添加星历文件
    friend class DelNavFileCmd; // 删除星历文件

    friend class AddBaselineCmd; // 添加基线
    friend class DelBaselineCmd; // 删除基线
    friend class SetBaselineCmd; // 设置基线

    friend class AddProcessTaskCmd; // 添加处理任务到任务队列
    friend class DelProcessTaskCmd; // 删除处理任务到任务队列

    friend class AddProcessTemplateCmd; // 添加解算模板
    friend class DelProcessTemplateCmd; // 添加解算模板
    friend class SetProcessTemplateCmd; // 设置解算模板
};
