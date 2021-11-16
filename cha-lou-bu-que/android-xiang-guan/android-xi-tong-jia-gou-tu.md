---
description: Android系统架构图
---

# Android系统架构图

可以参考官方文档：[https://developer.android.com/guide/platform?hl=zh-cn](https://developer.android.com/guide/platform?hl=zh-cn)

用下面这张图比较直观

![](<../../.gitbook/assets/image (14).png>)

### Linux内核层

用来进程间通信的Binder，就是在Linux内核层，在最底层，前面提到的Linux进程间通信的方式，管道、共享内存等，都有缺点，所以Android又在Linux内核层单独弄了一个Binder用来进程间通信，优点是指用拷贝一次，并且还很安全。

### 硬件抽象层
