# hashCode 和 equals 方法

## 前言

面试里面有好几次都被问到了 hashCode 方法，一般提问的形式像这样：怎么比较两个对象是否一样？

我一般回答是用 hashCode 方法来比较两个对象是否一致，因为每个对象的 hashCode 都是唯一的。感觉回答得不是很好，所以专开一篇来记录一下。

当然我想面试官这里主要考的是 equals\(\)方法和 hashCode\(\)方法的区别^\_^，因为这两个都是属于 Object 类的方法

### equals 方法

equals 方法一般的调用方法像这样：`obj1.equals(obj2)`

我们知道 String、Integer、Double 类都可以使用这个方法来比较两个值是否一样，是因为这些类在封装的时候已经重写了 object 类的 equals 方法。

比如在 String 类中的 equals 方法在重写了之后，就变成了比较两个对象的内容是否一样。

但是，默认的类是没有重写 equals 方法的。若某个类没有覆盖 equals\(\)方法，当它的通过 equals\(\)比较两个对象时，实际上是比较两个对象是不是同一个对象。这时，等价于通过`==`去比较这两个对象。

> 对于`==`的理解：`==`可以理解为：比较的两个对象是否是同一个对象？也可以理解为：两个对象的地址是否是一样的？

### hashCode 方法

> hashCode\(\) 的作用是获取哈希码，也称为散列码；它实际上是返回一个 int 整数。这个哈希码的作用是确定该对象在哈希表中的索引位置。

这里有两个需要注意的地方：

* 1、如果两个对象相等，那么它们的 hashCode\(\)值一定要相同；
* 2、如果两个对象 hashCode\(\)相等，它们并不一定相等。

但是，如果只重写了 equals 方法，在将两个值相同的元素添加到 hashSet（带有去重功能）的时候，hashSet 的 size 会是 2，这个不符合我们的预期，因为 hashSet 发现他们的 hashCode 不一样，会判定为是两个不同的元素。

## 总结

（1）如果两个对象相等，那么他们必定有相同的 hashcode

（2）如果两个对象的 hashcode 相等，他们不一定相等

（3）重写 equasl 方法时，一定要记得重写 hashcode 方法，尤其用在 hash 类的数据结构中。

## Q&A？

* Q：equals\(\)和 hashCode\(\)有什么区别？

  A：equals 方法是严格判断一个对象是否相等的方法，hashCode 值是根据内存地址换算出来的一个值。

* Q：怎么比较两个对象是否真正相等？

  A：重写 `equals` 和 `hashCode` 两个方法才行。

【参考文章】

* [Java 提高篇——equals\(\)与 hashCode\(\)方法详解](https://www.cnblogs.com/qian123/p/5703507.html)
* [Java hashCode\(\) 和 equals\(\)的若干问题解答](https://www.cnblogs.com/skywang12345/p/3324958.html)
* [java 中 hashCode 和 equals 的使用](https://www.jianshu.com/p/7557b98e785d)
* [细说 equals 方法和 hashCode 方法](https://juejin.im/post/5a17edd9f265da4310481269)

