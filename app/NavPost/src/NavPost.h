#pragma once
#include <QObject>
#include <QtQml/qqml.h>
#include "stdafx.h"
#include "NavCore.h"
#include <set>

class NavPost : public QObject
{
    Q_OBJECT

    Q_PROPERTY_AUTO(QVariantMap, project_info)   // 站点信息


    QML_SINGLETON
    QML_ELEMENT
private:
    explicit NavPost(QObject *parent = nullptr) : QObject(parent) { m_logger = spdlog::default_logger(); }

public:
    SINGLETON(NavPost)
    static NavPost *create(QQmlEngine *, QJSEngine *)
    {
        return getInstance();
    }

    inline nlohmann::json variantToJson(const QVariant &value);
    inline nlohmann::json variantMapToJson(const QVariantMap &map);
    inline nlohmann::json variantListToJson(const QList<QVariantMap> &list);
    inline nlohmann::json QStringToJson(const QString &str);

    inline QVariant JsonToQVariant(const nlohmann::json &jsonValue);
    inline QVariantMap JsonToQVariantMap(const nlohmann::json &jsonObj);
    inline QList<QVariant> JsonToQVariantList(const nlohmann::json &jsonArray);
    inline QString JsonToQString(const nlohmann::json &json);

public:
    //------------------------------创建、打开、保持工程相关操作及属性---------------------------------
    //        //创建工程，在指定的dir，写入工程信息
    Q_INVOKABLE bool init_Project(QVariantMap project_info);
    // Q_INVOKABLE bool init_Project(QVariantMap project_info);

    //        //载入工程，读取指定文件信息，根据信息，读取数据等内容
    // Q_INVOKABLE bool load_Project(QString project_file);

    //        //保存工程，保存到指定的路径下，如果为空，那就是当前路径
    // Q_INVOKABLE bool save_Project(QString project_dir="");

    //        //关闭工程
    // Q_INVOKABLE QString exitProject();

    //更新工程信息
    Q_SIGNAL void refreshProjectInfoStart();
    Q_SIGNAL void refreshProjectInfoSuccess();
    Q_INVOKABLE void refreshProjectInfo();


    // Q_INVOKABLE QString generate_UniqueKey2(int key_length=4){return generate_UniqueKey(key_length);};

    //        //工程是否已经保存
    // Q_INVOKABLE bool project_is_Saved();

    // 添加新的站点
    Q_INVOKABLE bool addStation(QVariantMap info);

    // 修改站点信息
    Q_INVOKABLE bool setStation(QVariantMap info);

    // 删除站点信息
    Q_INVOKABLE bool delStation(QVariantMap info);

    // 添加观测文件
    Q_INVOKABLE bool addObsFile(QVariantMap info);

    // 修改观测文件
    Q_INVOKABLE bool setObsFile(QVariantMap info);

    // 删除观测文件
    Q_INVOKABLE bool delObsFile(QVariantMap info);

    // 添加星历文件
    Q_INVOKABLE bool addNavFile(QVariantMap info);

    // 修改星历文件
    Q_INVOKABLE bool setNavFile(QVariantMap info);

    // 删除星历文件
    Q_INVOKABLE bool delNavFile(QVariantMap info);


    //创建单点定位任务
    Q_INVOKABLE QString createSppTask(QVariantMap info);



    // public:
    //         //-------------------------------------历史工程---------------------------------
    //     Q_PROPERTY_AUTO(QList<QVariantMap>, project_list) //历史打开的工程信息 （工程名,工程路径，最后修改时间）

    //            //打开历史信息记录文件（）
    //     Q_INVOKABLE bool Load_History_Project_List();

    //            //保存历史信息记录文件（）
    //     Q_INVOKABLE bool Save_History_Project_List();

public:
    //--------------------------------数据集-------------------------------------------
    // //资源页面展示的信息
    // Q_PROPERTY_AUTO(QList<QVariantMap>, station_data)
    // Q_PROPERTY_AUTO(QList<QVariantMap>, obsfile_data)
    // Q_PROPERTY_AUTO(QList<QVariantMap>, baseline_data)
    // Q_PROPERTY_AUTO(QList<QVariantMap>, task_data)
    //                                                //     Q_PROPERTY_AUTO(QList<QVariantMap>, relation_db)
    //                                                //     Q_PROPERTY_AUTO(QList<QVariantMap>, baseline_map)
    //                                                //     Q_PROPERTY_AUTO(QList<QVariantMap>, result_map)
    //                                                //     Q_PROPERTY_AUTO(QList<QVariantMap>, task_map)
    // Q_SIGNAL void update_Data_Start();
    // Q_SIGNAL void update_Data_Success();
    // Q_INVOKABLE void update_All_Datas();
    // Q_INVOKABLE void update_Station_Data();
    // Q_INVOKABLE void update_Obsfile_Data();
    // Q_INVOKABLE void update_Baseline_Data();
    // Q_INVOKABLE void update_Task_Data();

private:
    // public:
    //     //-----------------------------------站点------------------------------------------------

    //     Q_PROPERTY_AUTO(QList<QVariantMap>, station_map)

    //            //批量创建新的站点  (站点名称，站点类型，站点坐标（可选输入）
    //     Q_INVOKABLE bool Add_New_Stations(QList<QVariantMap> stationlist);

    // public:
    //     //-----------------------------------文件------------------------------------------

    //     Q_PROPERTY_AUTO(QList<QVariantMap>, obsfile_map)

    //            //批量导入广播星历,广播星历导入后，皆为全局可用
    //     Q_INVOKABLE bool Load_Nav_Files(QList<QVariantMap> navlist);

    //            //批量导入obs观测文件，同时也会导入广播星历，如果是归属于新站点，那么也会创建站点
    //     Q_INVOKABLE bool Load_Obs_Files(QList<QVariantMap> obslist);

public:
    //-------------随机键值生成器，用于给每个文件、测站、基线、结果生成唯一的key值-------------------
    Q_INVOKABLE QString generate_UniqueKey(int key_length = 8);

private:
    bool init_unique_generator(); // 从文件中读取已经生成的键值，保证唯一性
    bool save_unique_generator(); // 将键值保存到文件中
    std::string generate_random_key(int length);
    std::set<std::string> _generated_key; // 已经生成过的唯一key值

    std::shared_ptr<spdlog::logger> m_logger; // 模块日志器
};
