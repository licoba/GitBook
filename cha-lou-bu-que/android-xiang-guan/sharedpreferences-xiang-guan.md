---
description: SharedPreferences相关知识、SharedPreferences性能问题、SharedPreferences优化
---

# SharedPreferences相关

源码分析可以参考Book内的「源码分析」-「[SharedPreferences源码分析](https://licoba.gitbook.io/androidbook/cha-lou-bu-que/yuan-ma-fen-xi/sharedpreferences-yuan-ma-fen-xi)」

这里主要说一下SharedPreferences的**问题**和**优化**方案

### 问题

* 大数据存储的性能问题
* 读写锁效率问题
* 大数据的ANR问题
* 进程间共享问题

### 优化

* **提前初始化：**SP的初始化最好是放在Application里面，随着应用的启动去加载，尽量减少在getString的时候还没有将xml文件读取到内存的情况。
* **避免存储大量数据**：可以拆分成多个SP对象进行存储，尽量不要在一个文件内存储大量的数据。
* **多次操作，一次提交：**使用Edit来操作，必要时候甚至可以缓存Editor
* **不要存JSON和HTML类型的数据：**这类数据往往带有特殊符号，会调用比较大的符号解析库，耗时
* **使用腾讯的MMKV：**原理也就是利用内存映射（mmap）直接读写内存，至于内存与文件的同步，由操作系统选择合适的时机来完成，效率会大大高于SP的直接IO





【参考文章】

* [https://www.jianshu.com/p/c4fa942d8153](https://www.jianshu.com/p/c4fa942d8153)







