# ruisi_flutter

西电睿思客户端，目标是集成进 XDYou 代码库，作为其在代码层面的外挂。

**警告：仍在开发，用出问题别怪我！**

目前应该能登录（请在校园网环境下登录），简单看帖子，简单回帖。

本程序开发流程为：

[Ruisi_iOS](https://github.com/freedom10086/Ruisi_Ios) 作为模板，使用 [MiMo-V2.5-Pro
](https://platform.xiaomimimo.com/docs/zh-CN/welcome)大模型，依靠 [Cline VSCode 插件](https://cline.bot/)工具进行开发。

首先搭建一个 Flutter 模板，然后扔进去 Ruisi_iOS 的代码库，让 AI 重写。重写后运行，根据功能测试结果让 AI 继续改代码。AI 代码中，UI 代码暂时不管，但是业务代码必须审核，**要求和 Ruisi 的桌面版获取数据相符**。

感谢 [Xiaomi MiMo Orbit 百万亿 Token 创造者激励计划](https://100t.xiaomimimo.com/)赞助 Token 让我得以完成该计划。