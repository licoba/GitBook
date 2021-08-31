# 谈一谈HashCode

### 强烈建议

看一看这篇文章：[https://www.cnblogs.com/qian123/p/5703507.html](https://www.cnblogs.com/qian123/p/5703507.html) 写的非常好！

首先说明hashCode在Java源码里的方法注释中有写：

* 一个对象多次调用它的hashCode方法，应当返回相同的integer（哈希值）。
* 两个对象如果通过equals方法判定为相等，那么就应当返回相同integer。
* 两个地址值不相等的对象调用hashCode方法不要求返回不相等的integer，但是要求拥有两个- 不相等integer的对象必须是不同对象。

以上是对hashCode方法的定义，也可以免去很多疑问

### 疑问

#### 为什么重写equals\(\)方法，也要重写hashCode\(\)方法？

因为我们重写equals方法一般都是，重写去判断他的value是否相等了。 但是Java里面对hashCode有一个定义：「相同对象的hashCode必须相同」 所以如果new两个值相同的对象，然后重写的equal返回true，那这个时候（没重写hashCode的时候），hashCode必定是不想等的，所以我们需要重写hashCode方法来保证他的hashCode，一定相等，归根到底，是为了遵循「必须保证重写后的equals方法认定相同的两个对象拥有相同的哈希值」这个定律（Java里面对hashCode的规定）。

### 总结（考点）

> 记住equals\(\)方法是可靠的，hashCode\(\)不可靠
>
> * equals方法在Object类里的实现，是通过==方法进行比较，也就是说：在equals没有被重写的情况下，equals方法和==方法完全等同
> * 两个对象的equals\(\)方法返回true，那他们的hashCode一定相等
> * 两个对象的hashCode\(\)方法返回true，那这两个对象有可能相等也有可能不相等。（需要再通过equals来判断）

### 参考资料

* [https://zhuanlan.zhihu.com/p/50206657](https://zhuanlan.zhihu.com/p/50206657)

