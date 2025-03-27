cmake_minimum_required(VERSION 3.21)

project(NavCore)

#版本14以下可能会导致abseil不支持
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 设置 Abseil 的选项
set(ABSL_PROPAGATE_CXX_STD ON CACHE INTERNAL "")

option(FLUENTUI_BUILD_STATIC_LIB "Build FluentUI static library." ON)
option(FLUENTUI_UNIVERSAL_BUILD_MACOS "Universal build FluentUI for macOS." ON)

# # 启用全程序优化和链接时间代码生成
# if(MSVC)
#     add_compile_options(/GL)  # 编译时启用全程序优化
#     add_link_options(/LTCG)   # 链接时启用链接时间代码生成
# endif()



#包含的源文件和头文件
include_directories(${PROJECT_NAME} ${CMAKE_CURRENT_LIST_DIR}/include)
include_directories(${PROJECT_NAME} ${CMAKE_CURRENT_LIST_DIR}/src)
include_directories(${PROJECT_NAME} ${CMAKE_CURRENT_LIST_DIR}/src/context)
include_directories(${PROJECT_NAME}  ${SPDLOG_INCLUDE_PATH})
include_directories(${PROJECT_NAME}  ${JSON_INCLUDE_PATH})

#静态库
set(CORE_SOURCES
   include/NavCore.h src/NavCore.cpp
   include/Command.h src/Command.cpp
   include/Command_Pattern.h
   include/util.h
   include/context/baseline.h
   include/context/navfile.h
   include/context/obsfile.h
   include/context/station.h
   include/basic/x_coord.h
   include/basic/x_time.h

   src/processer/dynamic_proc.h src/processer/dynamic_proc.cpp

)
add_library(${PROJECT_NAME} STATIC ${CORE_SOURCES})
target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

# target_link_libraries(${PROJECT_NAME}
#     base
#     task
#     decode
#     post
# )



#测试工程

set(TEST_SOURCES
   test/proejct_demo.cpp
)

add_executable(NavCore_demo ${TEST_SOURCES})
target_link_libraries(NavCore_demo ${PROJECT_NAME})
include_directories(NavCore_demo ${SPDLOG_INCLUDE_PATH})


message(STATUS "CMAKE_CXX_FLAGS_DEBUG   : ${CMAKE_CXX_FLAGS_DEBUG}")
message(STATUS "CMAKE_CXX_FLAGS_RELEASE : ${CMAKE_CXX_FLAGS_RELEASE}")
message(STATUS "CMAKE_BUILD_TYPE        : ${CMAKE_BUILD_TYPE}")
 

