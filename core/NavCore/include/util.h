#pragma once
#include <iostream>
#include <string>
#include <type_traits>
#include <nlohmann/json.hpp>
using json = nlohmann::json;

enum class FileFormat
{
    RINEX = 0x0000,
    RTCM3 = 0x0001,
    CNB = 0x0002,
    UNKNOWN = 0x00004,
};

enum class StationType
{
    Dynamic = 0x0000,
    Static = 0x0001,
};

// 判断类型对应的 is_* 函数
template <typename T>
struct JsonTypeChecker;

template <>
struct JsonTypeChecker<std::string>
{
    static bool check(const nlohmann::json &json, const std::string &key)
    {
        return json.contains(key) && json[key].is_string();
    }
};

template <>
struct JsonTypeChecker<int>
{
    static bool check(const nlohmann::json &json, const std::string &key)
    {
        return json.contains(key) && json[key].is_number_integer();
    }
};

template <>
struct JsonTypeChecker<long long>
{
    static bool check(const nlohmann::json &json, const std::string &key)
    {
        return json.contains(key) && json[key].is_number_integer();
    }
};

template <>
struct JsonTypeChecker<double>
{
    static bool check(const nlohmann::json &json, const std::string &key)
    {
        return json.contains(key) && (json[key].is_number_float() || json[key].is_number_integer());
    }
};

template <>
struct JsonTypeChecker<bool>
{
    static bool check(const nlohmann::json &json, const std::string &key)
    {
        return json.contains(key) && json[key].is_boolean();
    }
};

template <>
struct JsonTypeChecker<nlohmann::json>
{
    static bool check(const nlohmann::json &json, const std::string &key)
    {
        return json.contains(key) && json[key].is_object();
    }
};

// 检查 JSON 是否包含指定的枚举值的工具类
/*
 *  兼容性改正：
 *  在实际调试过程中发现qml中应用的枚举值会被转换成double类型的值（typeof()得到类型为number），
 *  原因应该是在qml中，所有的数字都被描述为浮点类型，进而导致传递给json的值是float类型
 *  导致枚举如果按照int类型进行转换的时候失效，无法获取到值，
 *  该问题没有想到很好的解决方法，因为有些枚举类型传递的还是int，可能是跟这个值没有被修改有关，
 *  也可能是qml部分代码不规范导致的
 *
 *  因此在check函数中放宽了限制，支持float类型的值转换成枚举类型
 *  并在PROPERTY_ENUM从json赋值到枚举值的过程中，将json的值统一转换成double，然后使用std::round进行四舍五入
 *
 */
template <typename EnumType>
struct EnumJsonChecker
{
    static_assert(std::is_enum<EnumType>::value, "EnumType must be an enum type.");

    static bool check(const nlohmann::json &json, const std::string &key)
    {
        // return json.contains(key) && json[key].is_number_integer();
        return json.contains(key) && (json[key].is_number_integer() || json[key].is_number_float());
    }
};

// 枚举类型专用的宏
#define PROPERTY_ENUM(ENUM_TYPE, NAME)                                              \
public:                                                                             \
    bool NAME(const nlohmann::json &json, const std::string &key)                   \
    {                                                                               \
        if (EnumJsonChecker<ENUM_TYPE>::check(json, key))                           \
        {                                                                           \
            m_##NAME = static_cast<ENUM_TYPE>(std::round(json[key].get<double>())); \
            return true;                                                            \
        }                                                                           \
        else                                                                        \
        {                                                                           \
            std::cerr << "Failed to set [" #NAME "] from key: " << key << "\n";     \
            return false;                                                           \
        }                                                                           \
    }                                                                               \
    void NAME(ENUM_TYPE in_##NAME)                                                  \
    {                                                                               \
        m_##NAME = in_##NAME;                                                       \
    }                                                                               \
    ENUM_TYPE NAME() const                                                          \
    {                                                                               \
        return m_##NAME;                                                            \
    }                                                                               \
    int NAME##_as_int() const                                                       \
    {                                                                               \
        return static_cast<int>(m_##NAME);                                          \
    }                                                                               \
                                                                                    \
protected:                                                                          \
    ENUM_TYPE m_##NAME;

// 自动生成 Getter/Setter 的宏
#define PROPERTY_AUTO(TYPE, M)                                               \
public:                                                                      \
    bool M(const nlohmann::json &json, const std::string &key)               \
    {                                                                        \
        if (JsonTypeChecker<TYPE>::check(json, key))                         \
        {                                                                    \
            m_##M = json[key].get<TYPE>();                                   \
            return true;                                                     \
        }                                                                    \
        else                                                                 \
        {                                                                    \
            std::cerr << "Failed to set [" #M "] from key: " << key << "\n"; \
            return false;                                                    \
        }                                                                    \
    }                                                                        \
    void M(const TYPE &in_##M)                                               \
    {                                                                        \
        m_##M = in_##M;                                                      \
    }                                                                        \
    TYPE M() const                                                           \
    {                                                                        \
        return m_##M;                                                        \
    }                                                                        \
                                                                             \
protected:                                                                   \
    TYPE m_##M;

#define PROPERTY_AUTO_P(TYPE, M) \
public:                          \
    void M(TYPE in_##M)          \
    {                            \
        m_##M = in_##M;          \
    }                            \
    TYPE M() const               \
    {                            \
        return m_##M;            \
    }                            \
                                 \
protected:                       \
    TYPE m_##M = nullptr;

// #define PROPERTY_AUTO(TYPE, M)                                 \
// public:                                                        \
//     void M(const TYPE &in_##M)                                 \
//     {                                                          \
//         m_##M = in_##M;                                        \
//     }                                                          \
//     void M(const nlohmann::json &json, const std::string &key) \
//     {                                                          \
//         if (json.contains(key) && json[key].is_##TYPE())       \
//         {                                                      \
//             m_##M = json[key].get<TYPE>();                     \
//         }                                                      \
//     }                                                          \
//     TYPE M() const                                             \
//     {                                                          \
//         return m_##M;                                          \
//     }                                                          \
//                                                                \
// protected:                                                     \
//     TYPE m_##M;\
