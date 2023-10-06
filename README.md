# Qinee
A test project for solidity

冷启动问题：
从组织的成立角度，一般开始时都是由一个核心集团启动项目，并在运行中逐渐淡化核心的控制权，因此采用MultiOwner作为项目的开始
需要为增加，删除Owner增加一个决策方式

继承关系：
MultiOwner          WCB     CB      SFSet
    ｜
VersionController
    ｜
DataStorage

可更新能力：
可以由一个合约调用另一个合约的方法，如果被调用的方法是一个Factor方法，则可以生成对应的智能合约（结算业务）
通过将同名却不同版本的SFSet部署在不同地址，用SFSet的地址控制实际部署的结算业务