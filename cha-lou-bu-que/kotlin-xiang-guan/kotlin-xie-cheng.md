# Kotlin协程

关于 kotlin 的文档可以在这里查看 [https://developer.android.com/kotlin/coroutines?hl=zh-cn](https://developer.android.com/kotlin/coroutines?hl=zh-cn)

协程是我们在 Android 上进行异步编程的推荐解决方案

### 协程定义

kotlin 官方基于 JVM 的线程实现的一个并发任务处理框架，封装的线程 api

也就是说协程的底层，还是线程，基于线程封装了一个语法糖

* 使用方便，不使用回调实现线程切换,使用同步方式写出异步代码
* 所有的耗时任务保证一定放在后台执行
* 挂起函数执行完毕之后，协程会把它切换到原先的线程的线程。

协程的特征：异步：非阻塞

协程是运行在线程上可以被挂起的运算

### 协程优点

主要优点是代码可读性好, 不用回调函数. 代码看起来就像是同步的代码

效率比直接使用线程要高

### 协程和线程的区别

delay\(\)方法可以在不阻塞线程的情况下延迟协程

而 Thread.sleep\(\)则阻塞了当前线程.

### 协程的启动方式

启动一个新的协程, 常用的主要有以下几种方式:

* launch：可以启动新协程，但是不将结果返回给调用方。
* async：可以启动新协程，并且允许使用 await 暂停函数返回结果

### 总结

对协程的了解还是太少了，还是需要多使用才可以，一是对 kotlin 愈语法不熟，而是对协程的使用不熟，只看博客太难理解了，也没有一个好的 Demo 可以运行可以跑，害，就到这里吧。

【参考文章】

* [https://juejin.cn/post/6844904194063728647](https://juejin.cn/post/6844904194063728647)
