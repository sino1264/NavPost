#pragma once

#include "nlohmann/json.hpp"

// class Project_CPP;

enum class CommandType
{
    Unknown,
    AddStation,
    // 其他命令类型
};

class Command
{
protected:
    CommandType _commandType; // 存储命令类型

public:
    Command(CommandType type = CommandType::Unknown) : _commandType(type) {}

    virtual ~Command() = default;

    // 执行命令
    virtual void execute() = 0;

    // 撤销命令
    virtual void undo() = 0;

    // 重做命令
    virtual void redo() = 0;

    CommandType getCommandType() const { return _commandType; }
};

class AddStationCmd : public Command
{
private:
    nlohmann::json m_station_info;

public:
    AddStationCmd(nlohmann::json station_info);

    void execute() override;

    void undo() override;

    void redo() override;
};

class SetStationCmd : public Command
{
private:
    nlohmann::json m_station_info;
    nlohmann::json m_station_info_bak;

public:
    SetStationCmd(nlohmann::json station_info);

    void execute() override;

    void undo() override;

    void redo() override;
};
