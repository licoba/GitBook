# Android的事件分发

废话不多说先上图

![](https://pic.downk.cc/item/5e8c93f9504f4bcb044ce72c.jpg)

![](https://pic.downk.cc/item/5e8c940f504f4bcb044cf916.jpg)

### 认识三个最主要的方法

* public boolean dispatchTouchEvent\(MotionEvent ev\)
* public boolean onTouchEvent\(MotionEvent event\)
* public boolean onInterceptTouchEvent\(MotionEvent event\)

三个方法分别用于：**事件分发**、**事件处理**、**事件拦截**

其中前两个是 View 和 ViewGroup 都有的方法，第三个方法是 ViewGroup 独有的方法，在 View 是没有这个方法的。

**这三个方法的返回值都是 boolean**

在 Android 中，所有的事件都是从开始经过传递到完成事件的消费，这些方法的返回值就决定了某一事件是否是继续往下传，还是被拦截了，或是被消费了。

> * dispatchTouchEvent 方法用于事件的分发，Android 中所有的事件都必须经过这个方法的分发，然后决定是自身消费当前事件还是继续往下分发给子控件处理。返回 true 表示不继续分发。返回 false 则继续往下分发，如果是 ViewGroup 则分发给 onInterceptTouchEvent 进行判断是否拦截该事件。
> * onTouchEvent 方法用于事件的处理，返回 true 表示消费处理当前事件，返回 false 则不处理，交给子控件进行继续分发。
> * onInterceptTouchEvent 是 ViewGroup 中才有的方法，View 中没有，它的作用是负责事件的拦截，返回 true 的时候表示拦截当前事件，不继续往下分发，交给自身的 onTouchEvent 进行处理。返回 false 则不拦截，继续往下传。这是 ViewGroup 特有的方法，因为 ViewGroup 中可能还有子 View，而在 Android 中 View 中是不能再包含子 View 的（iOS 可以）。

### Demo 程序 1

这里的 Demo 主要用来测试单布局的事件传递，也就是从 Activity 传递到 Button

首先在 MainActivity 里面重写前两个方法，然后新建一个 MyButton 的类继承自 button，并重写这两个方法打印 log，将 mybutton 放到 activity\_main 中，最后在 MainActivity 里面给 myButton 设置 onClick 和 onTouch 的监听

点击按钮可以看到如下的事件分发和处理过程 ![](https://pic.downk.cc/item/5e8878b0504f4bcb04eb879e.jpg)

这里需要提到的是，myButton 的`onTouchListener`是在`super.dispatchTouchEvent(ev);`里面执行的，`onClickListener`是在`super.onTouchEvent(event);`里面执行的

整个事件的传递流程如下：

![](https://pic.downk.cc/item/5e888257504f4bcb04f53350.png)

### Demo 程序 2

新建一个 MyLayout 继承自 LinearLayout，重写文章开头所提到的三个方法，然后在 xml 中在 MyButton 的外层使用 MyLayout 包裹住。

然后点击 button，可以看到事件是从 Activity-&gt;MyLayout-&gt;MyButton 这样传递的

而`onInterceptTouchEvent`是在`super.dispatchTouchEvent(ev);`方法里面调用的，`onInterceptTouchEvent`默认直接返回了 false，也就是不进行拦截，将事件传递给 MyButton

### Case 分类

* 如果在 Activity 的 dispatchTouchEvent 方法里面直接返回了 true 或者 false，而不调用 super 的方法，那么事件就被直接消费掉了，不会向下传递，任何其它方法也都不会调用
* Activity 在分发事件的时候正常调用 super 方法，接着事件会被传递到 ViewGroup。这时候有 3 个情况：一、如果是直接返回 true ，代表事件被 ViewGroup 消耗掉了；**二、如果是返回 false，会走到上一个 View 的 onTouchEvent 方法，也就是 Activity 的 onTouchEvent 方法**，三、如果调用 super 方法，会走到 ViewGroup 的拦截方法。
* 按照正常的步骤进入 ViewGroup 的拦截方法里面以后，这里有两个出路：一、调用 super 或者返回 false，表示不拦截，这个时候就会走到 View 的 dispatchTouchEvent 方法里面去； 二、如果是返回了 true，代表事件被 ViewGroup 拦截了，这里的被拦截的事件，会交给 ViewGroup 自己处理，也就是会走到自己的 OnTouchEvent 方法里面去，如果自己处理掉，返回 true，则事件消耗结束；如果是返回了 false 或者是调用了 super 方法，那么会走到 Activity 的事件处理方法里面去。

### 总结

* dispatchTouchEvent 和 onTouchEvent 一旦 return true,事件就停止传递了（没有谁能再收到这个事件）。
* dispatchTouchEvent 和 onTouchEvent 在 return false 的时候事件都回传给父控件的 onTouchEvent 处理。
* 对于 dispatchTouchEvent 返回 false 的含义应该是：事件停止往子 View 传递和分发同时开始往父控件回溯（父控件的 onTouchEvent 开始从下往上回传直到某个 onTouchEvent return true），事件分发机制就像递归，return false 的意义就是**递归停止然后开始回溯**。
* 对于 onTouchEvent 的 return false，它就是不消费事件，并让事件继续往父控件的方向从下往上流动。（对比 dispatchTouchEvent 的 returnfalse，少了一个事件传递）
* View 没有拦截器，为了让 View 可以把事件分发给自己的 onTouchEvent，View 的 dispatchTouchEvent 默认实现（super）就是把事件分发给自己的 onTouchEvent。
* Android 中事件传递按照从上到下进行层级传递，事件处理从 Activity 开始到 ViewGroup 再到 View。
* 事件传递方法包括 dispatchTouchEvent、onTouchEvent、onInterceptTouchEvent，其中前两个是 View 和 ViewGroup 都有的，最后一个是只有 ViewGroup 才有的方法。这三个方法的作用分别是负责事件分发、事件处理、事件拦截。
* onTouch 事件要先于 onClick 事件执行，onTouch 在事件分发方法 dispatchTouchEvent 中调用，而 onClick 在事件处理方法 onTouchEvent 中被调用，onTouchEvent 要后于 dispatchTouchEvent 方法的调用。

【参考文章】

* [图解 Android 事件分发机制](https://www.jianshu.com/p/e99b5e8bd67b)
* [Android View 事件分发测试 Demo](https://www.zybuluo.com/linux1s1s/note/119018)

