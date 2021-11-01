---
description: 自定义View生命周期
---

# 自定义View生命周期

### Q\&A

#### 1、为什么至少会有两次onMeasure和一次onLayout？

在写Demo观察生命周期的时候，发现一个普通的Button会回调两次onMeasure

![回调两次一模一样的onMeasure](<../../../.gitbook/assets/image (19).png>)

这里就是比较奇怪，为什么要回调两次一模一样的onMeasure？

这里就需要看一下View的源码了







【参考博客】

* ****[**View为什么会至少进行2次onMeasure、onLayout**](https://www.jianshu.com/p/733c7e9fb284)****
*

