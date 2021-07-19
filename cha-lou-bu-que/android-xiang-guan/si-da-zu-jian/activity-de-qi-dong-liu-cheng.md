---
description: 源码分析Activity的启动流程
---

# Activity的启动流程

## 从Activity开始分析

首先创建一个空工程，来到 MainActivity

```text
public class MainActivity extends AppCompatActivity
```

点进去查看 AppCompatActivity 的代码，会发现 有 MainActivity -&gt; AppCompatActivity -&gt; ... -&gt; Activity -&gt; ContextThemeWrapper

### ActivityThread

Activity 是怎么来的？就是 ActivityThread 创建的，ActivityThread 的 main 方法也可以理解为 APP 的真正入口。

要看 ActivityThread 的代码，来到它的 main 函数，贴几个关键的地方

```text
    public static void main(String[] args) {

        // 在这里会调用 prepareMainLooper 开启一个主线程的looper
        // Looper的作用？不断地从MessageQueue中抽取Message执行，完成后再回调，就是一个无休止的消息处理器
        Looper.prepareMainLooper();

        // 开启一个ActivityThread线程
        ActivityThread thread = new ActivityThread();
        // 这里可以看到一个attach函数，这个attach函数实际上是将应用程序与AMS绑定在一起，这样AMS就能够控制App的四大组件的执行
        thread.attach(false, startSeq);

        // 初始化main线程的handler，这里和handler机制类似
        if (sMainThreadHandler == null) {
            sMainThreadHandler = thread.getHandler();
        }

        // 开启消息循环，这样Looper才有作用
        Looper.loop();

    }
```

所以 main 代码块主要做了三件事:

1. 启动了一个主线程的 Looper
2. attach 到了 AMS
3. 创建了一个 ActivityThread ,也就是主线程对象

那这三件事是哪一件做了，才可以唤醒和吊起一个 Activity 呢？猜测是`new ActivityThread();`

我们看一下 ActivityThread 的构造方法，发现这个类是没有构造方法的，这里就很奇怪。所以怀疑创建 Activity 不是在方法里面，找一下 ActivityThread 的成员变量，会发现有一个比较重要的成员变量：

```text
final ApplicationThread mAppThread = new ApplicationThread();
```

所以我们知道了：**在 ActivityThread 初始化的时候，也会去创建一个 ApplicationThread** ，从源码里面可以看到 ApplicationThread 是 ActivityThread 的一个内部类

 ![fIQbDFl](https://i.imgur.com/fIQbDFl.jpg)

```text
private class ApplicationThread extends IApplicationThread.Stub {
```

ApplicationThread 继承自 IApplicationThread

