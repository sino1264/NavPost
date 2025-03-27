#include "NavPost.h"
#include "ResourceDataController.h"
#include <random>
#include <QThreadPool>

nlohmann::json NavPost::variantToJson(const QVariant &value)
{
    if (value.type() == QVariant::Map)
    {
        // QVariantMap 转换为 JSON 对象
        QVariantMap map = value.toMap();
        nlohmann::json jsonObj;
        for (auto it = map.begin(); it != map.end(); ++it)
        {
            jsonObj[it.key().toStdString()] = variantToJson(it.value());
        }
        return jsonObj;
    }
    else if (value.type() == QVariant::List)
    {
        // QVariantList 转换为 JSON 数组
        QVariantList list = value.toList();
        nlohmann::json jsonArray = nlohmann::json::array();
        for (const auto &item : list)
        {
            jsonArray.push_back(variantToJson(item));
        }
        return jsonArray;
    }
    else if (value.type() == QVariant::String)
    {
        // QVariantString 转换为 JSON 字符串
        return value.toString().toStdString();
    }
    else if (value.type() == QVariant::Int)
    {
        // QVariantInt 转换为 JSON 整数
        return value.toInt();
    }
    else if (value.type() == QVariant::Double)
    {
        // QVariantDouble 转换为 JSON 浮动
        return value.toDouble();
    }
    else if (value.type() == QVariant::Bool)
    {
        // QVariantBool 转换为 JSON 布尔值
        return value.toBool();
    }
    else
    {
        // 默认返回 null
        return nullptr;
    }
}

nlohmann::json NavPost::variantMapToJson(const QVariantMap &map)
{
    nlohmann::json jsonObj;
    for (auto it = map.begin(); it != map.end(); ++it)
    {
        jsonObj[it.key().toStdString()] = variantToJson(it.value());
    }
    return jsonObj;
}

nlohmann::json NavPost::variantListToJson(const QList<QVariantMap> &list)
{
    nlohmann::json jsonArray = nlohmann::json::array();
    for (const QVariantMap &map : list)
    {
        jsonArray.push_back(variantMapToJson(map));
    }
    return jsonArray;
}

nlohmann::json NavPost::QStringToJson(const QString &str)
{
    return nlohmann::json(str.toStdString()); // 直接将 QString 转换为 JSON 字符串
}

QVariant NavPost::JsonToQVariant(const nlohmann::json &jsonValue)
{
    if (jsonValue.is_object())
    {
        // 对象类型，递归转换成 QVariantMap
        return QVariant::fromValue(JsonToQVariantMap(jsonValue));
    }
    else if (jsonValue.is_array())
    {
        // 数组类型，转换为 QList<QVariant>
        return QVariant::fromValue(JsonToQVariantList(jsonValue));
    }
    else if (jsonValue.is_boolean())
    {
        return QVariant(jsonValue.get<bool>());
    }
    else if (jsonValue.is_number_integer())
    {
        return QVariant(jsonValue.get<int>());
    }
    else if (jsonValue.is_number_float())
    {
        return QVariant(jsonValue.get<double>());
    }
    else if (jsonValue.is_string())
    {
        return QVariant(QString::fromStdString(jsonValue.get<std::string>()));
    }
    return QVariant(); // 默认返回空 QVariant
}

QVariantMap NavPost::JsonToQVariantMap(const nlohmann::json &jsonObj)
{
    QVariantMap map;
    for (auto it = jsonObj.begin(); it != jsonObj.end(); ++it)
    {
        map.insert(QString::fromStdString(it.key()), JsonToQVariant(it.value()));
    }
    return map;
}

QList<QVariant> NavPost::JsonToQVariantList(const nlohmann::json &jsonArray)
{
    QList<QVariant> list;
    for (const auto &item : jsonArray)
    {
        list.append(JsonToQVariant(item));
    }
    return list;
}

QString NavPost::JsonToQString(const nlohmann::json &json)
{
    return QString::fromStdString(json.get<std::string>()); // 提取 JSON 字符串并转换为 QString
}

bool NavPost::init_Project(QVariantMap project_info)
{
    SPDLOG_LOGGER_DEBUG(m_logger, "init project");

    auto info = variantMapToJson(project_info);
    if (NavCore::getInstance()->initProject(info))
    {
        return false;
    }
    else
    {
        refreshProjectInfo();
        return true;
    }


}

void NavPost::refreshProjectInfo()
{
    Q_EMIT  refreshProjectInfoStart();

    auto obj=NavCore::getInstance();

    if(obj->UID()=="")
    {
        //没有工程信息

        //如果UID信息

        return;
    }

    m_project_info={
        {"UID",obj->UID().c_str()},
        {"project_name",obj->project_name().c_str()},
        {"project_path",obj->project_path().c_str()},
        {"project_work_path",obj->project_work_path().c_str()},
        {"project_file",obj->project_file().c_str()},
        {"project_creation_date",obj->project_creation_date()},
        {"project_modification_date",obj->project_modification_date()},
        {"is_modified",obj->is_modified()}
        };

    Q_EMIT  refreshProjectInfoSuccess();
}

bool NavPost::addStation(QVariantMap info)
{
    json data = variantMapToJson(info);
    NavCore::getInstance()->addStation(data);
    ResourceDataController::getInstance()->updateStationData();
    return true;
}

bool NavPost::setStation(QVariantMap info)
{
    return true;
}

bool NavPost::delStation(QVariantMap info)
{
    return true;
}

bool NavPost::addObsFile(QVariantMap info)
{
    json data = variantMapToJson(info);
    NavCore::getInstance()->addObsFile(data);
    ResourceDataController::getInstance()->updateObsFileData();
    return true;
}

bool NavPost::setObsFile(QVariantMap info)
{
    return true;
}

bool NavPost::delObsFile(QVariantMap info)
{
    return true;
}

bool NavPost::addNavFile(QVariantMap info)
{
    return true;
}

bool NavPost::setNavFile(QVariantMap info)
{
    return true;
}

bool NavPost::delNavFile(QVariantMap info)
{
    return true;
}

QString NavPost::createSppTask(QVariantMap info)
{
    //传递表单

    //解析json字符串，

    //传递json到库中

    //返回一个任务的key，后续可以根据这个key来启动任务

    return QString();


}

// void NavPost::update_All_Datas()
// {

// }

// void NavPost::update_Station_Data()
// {
//         QThreadPool::globalInstance()->start([=, this]() {
//         Q_EMIT update_Data_Start();

//         m_station_data.clear();
//                                 // 使用回调遍历
//         NavCore::getInstance()->forEachStation(
//             [this](const std::string& key, const station& st)
//             {

//                 QVariantMap data={
//                     {"UID",st.UID().c_str()},
//                     {"station_name",st.station_name().c_str()},
//                     {"is_disabled",st.is_disabled()},
//                     {"utm_e", 0.0},
//                     {"utm_n", 0.0},
//                     {"utm_u", 0.0},
//                     {"llh_lat", 0.0},
//                     {"llh_lon", 0.0},
//                     {"llh_height", 0.0},
//                     {"ecef_x",0.0},
//                     {"ecef_y", 0.0},
//                     {"ecef_z", 0.0},
//                                      // {"height", 30},
//                                      // {"minimumHeight", 25},
//                                      // {"maximumHeight", 240}
//                 };
//                 m_station_data.append(data);
//             }
//             );

//          Q_EMIT update_Data_Success();
//           });
// }

// void NavPost::update_Obsfile_Data()
// {

// }

// void NavPost::update_Baseline_Data()
// {

// }

// void NavPost::update_Task_Data()
// {

// }

// void NavPost::update_All_Datas()
// {

//     update_Station_Data();
//     update_Obsfile_Data();
//     update_Baseline_Data();
//     update_Task_Data();
// }

// void NavPost::update_Station_Data()
// {
//     QThreadPool::globalInstance()->start([=, this]() {
//     Q_EMIT update_Data_Start();

//     m_station_data.clear();
//                             // 使用回调遍历
//     NavCore::getInstance()->forEachStation(
//         [this](const std::string& key, const station& st)
//         {

//             QVariantMap data={
//                 {"UID",st.UID().c_str()},
//                 {"station_name",st.station_name().c_str()},
//                 {"is_disabled",st.is_disabled()},
//                 {"utm_e", 0.0},
//                 {"utm_n", 0.0},
//                 {"utm_u", 0.0},
//                 {"llh_lat", 0.0},
//                 {"llh_lon", 0.0},
//                 {"llh_height", 0.0},
//                 {"ecef_x",0.0},
//                 {"ecef_y", 0.0},
//                 {"ecef_z", 0.0},
//                                  // {"height", 30},
//                                  // {"minimumHeight", 25},
//                                  // {"maximumHeight", 240}
//             };
//             m_station_data.append(data);
//         }
//         );

//      Q_EMIT update_Data_Success();
//       });
// }

// void NavPost::update_Obsfile_Data()
// {

// }

// void NavPost::update_Baseline_Data()
// {

// }

// void NavPost::update_Task_Data()
// {

// }

QString NavPost::generate_UniqueKey(int key_length)
{
    std::string new_key;

           // 持续生成新的键直到确保唯一
    do
    {
        new_key = generate_random_key(key_length);
    } while (_generated_key.find(new_key) != _generated_key.end());

           // 将新生成的键加入已使用集合
    _generated_key.insert(new_key);

           // qDebug() << new_key;

    return new_key.c_str();
}

bool NavPost::init_unique_generator()
{
    return true;
}

bool NavPost::save_unique_generator()
{
    return true;
}

std::string NavPost::generate_random_key(int length)
{
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dis(0, 15); // 生成十六进制数

           // // 获取时间戳和线程ID作为一部分
           // auto time_now = std::chrono::steady_clock::now().time_since_epoch().count();
           // auto thread_id = std::this_thread::get_id();

    std::ostringstream oss;
    // // 使用时间戳和线程ID增加唯一性
    // oss << std::hex <<thread_id << "-" <<time_now;

           // 随机生成附加的16进制字符，增加随机性
    for (size_t i = oss.str().size(); i < length; ++i)
    { // 保证生成指定长度的key
        oss << std::hex << dis(gen);
    }
    return oss.str();
}
