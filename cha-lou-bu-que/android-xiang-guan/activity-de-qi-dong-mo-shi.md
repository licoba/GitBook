---
description: 重点：Activity的四种启动模式以及区别
---

# Activity的启动模式

### 启动模式的不同

* **standard**：普通的 Activity 启动就是采用的这种模式，采用标准模式启动的 Activity，无论栈里面是有这个 Activity，都会去新建一个 Activity 对象，然后压入栈里。
* **singleTop**：这里分两种情况：如果在栈里发现了相同的实例，那么会重用这个实例，不会新建 Activity；如果在栈顶没有发现这个实例，那么就会新建一个实例，压入栈内（不管底部是否有 Activity 的实例，只看栈顶）
* **singleTask**：这个启动模式会在整个栈里面去寻找 Activity 实例，如果找到了，就终止它上面的所有 Activity 实例然后将它们移出栈；如果没找到，就新建一个实例然后压入栈里。
* **singleInstance**：这个模式比较特殊，会另起一个栈存放这个 Activity，无论在哪里调用都是重用这个 Activity，并让多个应用共享该栈中的 Activity 实例。

### 不同模式的应用场景

* **standard**：普通的 Activity 启动。
* **singleTop**：1、适合接收通知启动的内容显示页面。这里怎么理解：因为如果从状态栏点击通知，通常会有几个连续的通知，每次都要去新建一个不行，如果用 singleTop 就会达到可以复用的效果。2、适合自己启动自己的页面，这个时候也可以复用。
* **singleTask**：适合程序的主 Activity，因为主 Activity 只会有一个，所以不管从哪里启动主 Activity 的时候都应该移除栈顶的所有方法。
* **singleInstance**：适合多 App 使用的界面，比如说闹钟。日历，从哪个应用启动都是这个界面

### Q&A？

* **怎么记这 4 个启动模式？**

  主要要理解 single 后面跟的不同的模式的含义，这里的 task、top、instance 都是指“面向”，比如说：面向 top，就是在 top 上去查找；面向 task，就是在栈里面去查找；面向 instance，这个可以理解成为“单例”，就是在全局都只会有一个这个 instance

* **复用 Activity，启动的时候会调用 Activity 的什么方法？**

  以 singleTask 为例，如果是栈内有实例了，那么不会走 OnCreate，而是走： `onNewInstance->onRestart->onStart->onResume`

> PS：今天的面试里面这个简单的东西都没答上来，很惭愧，特意来补充一下

【参考文章】

* [Android Activity 的 Launch Mode](https://hit-alibaba.github.io/interview/Android/basic/Android-LaunchMode.html)
* [Activity 的四种启动模式](https://www.jianshu.com/p/02fa2877a496)

