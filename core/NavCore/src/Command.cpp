#pragma once
#include "Command.h"
#include "NavCore.h"

AddStationCmd::AddStationCmd(nlohmann::json data)
    : Command(CommandType::AddStation)
{
  // 在此构造函数中，你可以使用传入的 JSON 数据进行初始化
}

void AddStationCmd::execute()
{
    // 获取ststion_info的IDC

           // 查找_station_map_ptr是否有IDC记录
    auto svr = NavCore::getInstance();

           // 插入这条记录

           // text += addedText;
           // std::cout << "Text after execute: " << text << std::endl;
}

void AddStationCmd::undo()
{
  // 获取ststion_info的IDC

           // 查找_station_map_ptr是否有IDC记录

           // 删除这条记录
}

void AddStationCmd::redo()
{
    execute();
}
