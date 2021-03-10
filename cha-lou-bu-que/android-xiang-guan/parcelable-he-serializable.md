---
description: 序列化：Parcelable和Serializable的区别
---

# Parcelable和Serializable

这两个都是Android中序列化用到的类，首先就要问了：

#### 为什么Activity之间传递对象需要序列化？

确实是个好问题，为什么不能像js那样，直接传递Object类型的数据呢？

在activity之间是通过intent.putExtra传递数据的，这个方法可以传递基本数据类型，以及序列化的对象，支持且仅支持这两种类型的数据传递。

![20210310-105927-8fwEQD](https://raw.githubusercontent.com/licoba/images/master/20210310-105927-8fwEQD.jpg?token=AETOTFNG6IORQFPNJK7CZH3AJA3E2)

仔细看看intent.putExtra方法，实际上，里面是new了一个Bundle，然后基于bundle进行数据传输，也就是要看bundle.putExtra方法，发现支持的数据类型与上面是一致的。

![20210310-110631-qEJfQY](https://raw.githubusercontent.com/licoba/images/master/20210310-110631-qEJfQY.jpg?token=AETOTFLTEQDQDKD3FYCZPZLAJA37I)

所以要想在Activity之间传递对象，对象必须要实现两个序列化的接口，然后放在bundle中，才能够传递。



### 区别

| 区别 | **Serializable** | Parcelable |
| :--- | :--- | :--- |
| 平台 | Java自带 | Android特有 |
| 效率 | 比较慢，在序列化的过程中使用了反射，这种机制会创建许多的临时对象，容易触发垃圾回收。频繁的GC会浪费比较多的时间 | 比较快，原理是将一个完整的对象进行分解，而分解后的每一部分都是Intent所支持的数据类型 |
| 使用 | 简单易用，只用多写一个ID | 代码比较多，使用起来比较繁琐 |
| 场景      | 使用在需要将对象持久化，或者在网络之间进行传输 | 适用于在内存之间传递数据（短暂的场景） |



