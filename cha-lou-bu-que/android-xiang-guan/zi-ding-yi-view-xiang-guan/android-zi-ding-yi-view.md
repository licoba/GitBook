# Android自定义View

## View的构成

Activity 的 View 的构成如下：

![View&#x7684;&#x6784;&#x6210;](https://pic.downk.cc/item/5e90962c504f4bcb04d929ba.jpg)

## View 的绘制流程

简单的来说就是以下三个步骤：

> **OnMeasure\(\)** —&gt; **OnLayout\(\)** —&gt; **OnDraw\(\)**

分别是`测量`、`布局`、`绘制`

**measure：测量 View 的宽高**

自上而下遍历，DecorView 根据 window.size 和 window.LayoutParams 这两个参数先确定自身的 MeasureSpec。同时作一个父 View 它会根据自身的 MeasureSpec 和子 View 的 LayoutParams 获取 ChildView 的 MeasureSpec，回调 ChildView.measure 方法，最终调用 setMeasuredDimension 得到 ChildView 的尺寸：mMeasuredWidth 和 mMeasuredHeight

**layout：确定 View 在父容器的位置**

自上而下遍历，根据 Measure 过程中得到的每个 View 的 mMeasuredWidth 和 mMeasuredHeight 与计算得到的每个 ChildView 的 ChildLeft,ChildTop 进行布局：child.layout\(left,top,left + width,top + height\);

**draw：将 View 绘制到屏幕上**

自上而下遍历，父 View 除了绘制自身外，还需要将整个绘制过程传递给自己的子元素。

## 整体流程概括

绘制会从根视图 ViewRoot 的 performTraversals\(\)方法开始，从上到下遍历整个视图树，每个 View 控件负责绘制自己，而 ViewGroup 还需要负责通知自己的子 View 进行绘制操作。

【参考文章】

* [面试题之 View 的绘制流程](https://www.jianshu.com/p/8a71cbf7622d)
* [深入理解 Android 之 View 的绘制流程](https://www.jianshu.com/p/060b5f68da79)

