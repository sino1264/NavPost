#pragma once

#include <stack>
#include <memory>
#include <iostream>
#include <exception>
#include "Command.h"

class Transaction
{
private:
    std::vector<std::shared_ptr<Command>> commands;         // 当前事务中的命令
    std::vector<std::shared_ptr<Command>> executedCommands; // 已经执行的命令（用于撤销时回滚）

public:
    // 添加命令到事务中
    void addCommand(std::shared_ptr<Command> command)
    {
        commands.push_back(command);
    }

    // 执行事务中所有命令，确保原子性
    void execute()
    {
        try
        {
            for (auto &command : commands)
            {
                command->execute();
                executedCommands.push_back(command); // 记录已经执行的命令
            }
        }
        catch (const std::exception &e)
        {
            std::cerr << "Error during transaction execution: " << e.what() << std::endl;
            rollback(); // 发生错误时回滚所有命令
            throw;      // 重新抛出异常
        }
    }

    // 撤销事务中所有命令，逆序撤销已执行的命令
    void undo()
    {
        try
        {
            for (auto it = executedCommands.rbegin(); it != executedCommands.rend(); ++it)
            {
                (*it)->undo();
            }
        }
        catch (const std::exception &e)
        {
            std::cerr << "Error during undo: " << e.what() << std::endl;
            // 可以选择继续撤销或者其他处理
            throw; // 重抛异常
        }
    }

    // 重做事务中所有命令
    void redo()
    {
        try
        {
            for (auto &command : executedCommands)
            {
                command->redo();
            }
        }
        catch (const std::exception &e)
        {
            std::cerr << "Error during redo: " << e.what() << std::endl;
            // 可以选择继续重做或者其他处理
            throw; // 重抛异常
        }
    }

    // 回滚已执行的命令（如果事务失败时进行回滚）
    void rollback()
    {
        std::cerr << "Rolling back the transaction..." << std::endl;
        for (auto it = executedCommands.rbegin(); it != executedCommands.rend(); ++it)
        {
            try
            {
                (*it)->undo(); // 撤销已执行的命令
            }
            catch (const std::exception &e)
            {
                std::cerr << "Error during rollback: " << e.what() << std::endl;
                // 可以选择继续撤销其他命令，或者停止回滚
            }
        }
        executedCommands.clear(); // 清空已执行的命令
    }
};

class Invoker
{
private:
    std::vector<std::shared_ptr<Transaction>> transactionHistory; // 历史事务
    std::stack<std::shared_ptr<Transaction>> redoStack;           // 重做栈
    std::shared_ptr<Transaction> currentTransaction = nullptr;    // 当前事务

public:
    // 开始一个事务
    void beginTransaction()
    {
        currentTransaction = std::make_shared<Transaction>();
    }

    // 提交当前事务
    void commitTransaction()
    {
        if (currentTransaction)
        {
            currentTransaction->execute();                    // 执行当前事务
            transactionHistory.push_back(currentTransaction); // 存入历史
            currentTransaction = nullptr;
            while (!redoStack.empty())
                redoStack.pop(); // 清空重做栈
        }
    }

    // 撤销最后一个事务
    void undo()
    {
        if (!transactionHistory.empty())
        {
            auto lastTransaction = transactionHistory.back();
            transactionHistory.pop_back();
            lastTransaction->undo();         // 撤销事务
            redoStack.push(lastTransaction); // 存入重做栈
        }
    }

    // 重做最后一个撤销的事务
    void redo()
    {
        if (!redoStack.empty())
        {
            auto transaction = redoStack.top();
            redoStack.pop();
            transaction->redo();                       // 重做事务
            transactionHistory.push_back(transaction); // 存回历史
        }
    }

    // 向当前事务添加命令
    void addCommand(std::shared_ptr<Command> command)
    {
        if (currentTransaction)
        {
            currentTransaction->addCommand(command);
        }
    }

    // 执行单个命令（通过临时事务实现）
    void executeCommand(std::shared_ptr<Command> command)
    {
        beginTransaction();  // 开始临时事务
        addCommand(command); // 添加命令
        commitTransaction(); // 提交事务并执行
    }
};
