#include <iostream>
#include "NavCore.h"


/*
    Project_CPP基本功能测试

 */


int main(int argc, char **argv)
{
    //创建单例
    auto svr=NavCore::getInstance();

    //创建输出到qt的sink
    // auto qtlogger=spdlog::


    //初始化工程


    std::string test_dir1="F:/Test/Project1";
    std::string test_dir2="F:/Test/Project2";
    json project_info;
    project_info["peoject_name"]="xxxxxxxxxxx";
    project_info["peoject_path"]=test_dir1;

    svr->initProject(project_info);


    //退出工程
    svr->exitProject();


    //读取工程
    svr->loadProject(test_dir1);

    //输出工程信息

    svr->saveProject(test_dir2);


    return 0;
}
