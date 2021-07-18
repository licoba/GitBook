---
description: 纸上得来终觉浅，绝知此事要躬行。
---

# View源码解析

#### GridView

我们可以先看看GridView的源码，GridView是一个ViewGroup，先看ViewGroup再看View

打开网址 [https://cs.android.com/android/platform/superproject/+/master:frameworks/base/core/java/android/widget/GridLayout.java](https://cs.android.com/android/platform/superproject/+/master:frameworks/base/core/java/android/widget/GridLayout.java)  可以看到GridLayout的源码。

![](../../../.gitbook/assets/image%20%2821%29.png)

首先从onMeasure开始看，onMeasure也就是测量布局的大小，里面的大部分代码都是在获取参数，

最主要的有两个方式一个是measureChildrenWithMaigins，这个方法大致瞅一眼，就知道是在递归调用去测量children的宽高，因为自己的children可能还有children，所以需要递归地调用。

![](../../../.gitbook/assets/image%20%2820%29.png)

还有setMeasureDimension方法，点进这个方法看看。

setMeasureDimension是View的方法（因为ViewGroup是继承自View的）

> public class [GridLayout](https://cs.android.com/android/platform/superproject/+/master:frameworks/base/core/java/android/widget/GridLayout.java;bpv=1;bpt=1;l=173?q=class%20gridlayout%20%7B&ss=android%2Fplatform%2Fsuperproject&gsn=GridLayout&gs=kythe%3A%2F%2Fandroid.googlesource.com%2Fplatform%2Fsuperproject%3Flang%3Djava%3Fpath%3Dandroid.widget.GridLayout%2354d1273e18240abf59929d8f729143dc3df33f393f868380d8db68fd179fbdeb) extends [ViewGroup](https://cs.android.com/android/platform/superproject/+/master:frameworks/base/core/java/android/view/ViewGroup.java;drc=master;l=130) extends [View](https://cs.android.com/android/platform/superproject/+/master:frameworks/base/core/java/android/view/View.java;drc=master;l=810)

![](../../../.gitbook/assets/image%20%2823%29.png)







