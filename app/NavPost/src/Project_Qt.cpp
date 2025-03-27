#include "Project_Qt.h"

#include <random>

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

void NavPost::test()
{
    SPDLOG_LOGGER_INFO(m_logger, "test");
}

bool NavPost::init_Project(QVariantMap project_info)
{
    SPDLOG_LOGGER_DEBUG(m_logger, "init project");

    auto info = variantMapToJson(project_info);
    if (NavCore::getInstance()->initProject(info))
    {
    }
    else
    {
    }

    return true;
}

bool NavPost::add_Station(QVariantMap info)
{

    // 添加站点分为以下几个步骤：

    // 创建一个站点对象

    // 给站点添加（修改坐标）坐标，设置坐标的时候，要传递坐标的ID（默认值为default）、坐标值，坐标的框架（枚举类型）（默认WGS84)、坐标历元(默认为0）
    //

    // 给站点设置天线参数，参数：天线文件、天线类型、天线测量高、ARP2L1、改正天线高

    return true;
}

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
