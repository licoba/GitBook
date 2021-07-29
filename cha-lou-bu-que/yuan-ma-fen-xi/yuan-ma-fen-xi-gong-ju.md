---
description: 一些源码分析工具
---

# 源码分析工具

### 在线看源码

* [https://cs.android.com/](https://cs.android.com/)

### 本地看源码

#### Mac系统

* scitool understand: [https://www.scitools.com/](https://www.scitools.com/) （收费）
* symbols: [https://cymbols.io/](https://cymbols.io/) \(收费，不建议\)
* vscode: [https://code.visualstudio.com/](https://code.visualstudio.com/)（需要配置一下）
* Sourcetrail: [https://www.sourcetrail.com/](https://www.sourcetrail.com/)
* IntelliJ IDEA
* 
#### Windows系统 

* source insight

### 问题

#### Q：Android源码仓库太大了怎么办？

Android源码仓库有四五十个G，下载太慢了，可以参考这篇文章：[https://github.com/foxleezh/AOSP/issues/1](https://github.com/foxleezh/AOSP/issues/1)

我们也用不上Android的全部源代码，只需要下载部分就可以了，如果GitHub访问速度太慢，还可以访问国内的镜像网站。

对于大部分人来说，我们只需要阅读 **frameworks/base**, frameworks/native, system/core 源码就可以了。

例如下载`framework/base`下的内容，执行命令：`git clone https://android.googlesource.com/platform/frameworks/base`

或者国内的命令（建议用国内的清华镜像源）：`git clone https://mirrors.ustc.edu.cn/aosp/platform/frameworks/base.git/`

base目录差不多是3GB的大小，十几分钟就可以下载好。

![](../../.gitbook/assets/image%20%2823%29.png)

【参考文章】

* [https://jekton.github.io/2018/05/11/how-to-read-android-source-code/](https://jekton.github.io/2018/05/11/how-to-read-android-source-code/)

