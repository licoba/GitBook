# Android内存泄露检测

## 内存泄露的检测方法

* Android Studio 自带的`Android Profiler`
* 第三方库`LeakCanary`

## 常见的内存泄露原因

* Handler 造成内存泄露

  在 Activity 销毁的时候 handler 仍然有未发送的消息，这个时候需要调用`removeCallbacksAndMessages`方法来移除当前 handler 发送的请求

* 广播注册后未取消注册、观察者订阅后未取消订阅
* Thread 线程任务未执行完，仍然持有 Activity 的引用
* 资源未关闭，例如 io 流、数据库使用后未及时关闭，这些资源在进行读写操作时通常都使用了缓冲，如果及时不关闭，这些缓冲对象就会一直被占用而得不到释放，以致发生内存泄露。

【参考文章】

* [Android Profiler 官方文档](https://developer.android.com/studio/profile/memory-profiler?hl=zh-cn)
* [利用 Android Profiler 测量应用性能](https://juejin.im/post/5b7cbf6f518825430810bcc6)
* [安卓内存泄露几种常见形式及解决方案](https://blog.csdn.net/jinfulin/article/details/72053920)

