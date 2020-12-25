# Android四大组件

> Create Time: 2020/04/03 Author：licoba

## 一、Activity

Activity 在 Android 中可以用来显示用户界面，监听用户的点击、滑动或者输入事件，并作出响应

## 二、Service

Servic 提供在后台长时间运行的服务，没有用户界面，可以用来播放音乐、下载、进行复杂的计算等

### Service 的启动方式

启动方式有两种：**startService**和**bindService**

* startService：通过该方法启动 service，创建者与 service 之间没有关联，即使创建者退出了，service 也依然可以运行，创建者和 service 之间无法进行直接的数据交换
* bindService：通过该方法启动 service，创建者和 service 绑定在一起，创建者一旦退出，service 也就没有了，创建者和 service 之间可以进行数据交换

创建一个 Service 的步骤和创建 Activity 类似，首先需要创建一个 MyService 的类继承自 Service，然后需要在 Android.manifest 里面注册这个服务；如果要停止 service 的话用 stopService 就好了

使用 startService 启动的时候，启动的过程和 startActivity 相似，也是用过 intent 来启动的。通常只需要在 onCreate 方法和 onStartCommand 方法中定义相关的业务代码就可以了。但是因为通过这个方法启动的 service，创建者和 service 之间没有太多的关联，因此 service 和访问者之间也无法进行通信、交换数据

如果需要和 service 交换数据，就需要使用 bindService：bindService 需要三个参数，其中的第二个参数是一个 ServiceConnection 对象，需要在 Activity 里面创建；销毁的时候调用 unbind\(conn\)就可以了。另外如果多次调用 bindService，也只会走一遍 onBind 方法的

对于 Service 的 onBind 方法，可以被当成是该 service 组件所返回的代理兑现，service 允许客户端通过该 IBinder 对象来访问 Service 内部的数据，**也就是通过这个 IBinder 对象来实现与 Service 之间的通信的**

### Service 和 IntentService 的区别

* IntentService 会起一个单独的 worker 线程，来处理所有的 intent 请求
* IntentService 会起一个单独的 worker 线程来处理 onHandleIntent\(\)方法实现的代码

所以在 Service 里面如果直接执行耗时任务的话，可能会造成 ANR，但是 IntentService 就不会

## 三、ContentProvider

ContentProvider 用来在不同应用间进行数据交互和共享，也就是跨进程通信

## 四、BroadcastReceiver

BroadcastReceiver 可以监听或接收应用或系统发出的广播消息，并做出响应，在线程和进程之间都可以进行通信，也用于在 App 和系统之间进行通信

**应用场景**

1. 同一 App 内部的同一组件内的消息通信（单个或多个线程之间）
2. 同一 App 内部的不同组件之间的消息通信（单个进程）;
3. 同一 App 具有多个进程的不同组件之间的消息通信;
4. 不同 App 之间的组件之间消息通信;
5. Android 系统在特定情况下与 App 之间的消息通信，如：网络变化、电池电量、屏幕开关等。

