---
description: ConcurrentHashMap为什么线程安全？怎么保证线程安全？
---

# ConcurrentHashMap相关

说起线程安全的 ConcurrentHashMap，就不得不提一下线程不安全的Hashmap了。

### Hashmap为什么线程不安全？

分析过程可以参考这篇文章：[https://juejin.cn/post/6844904149616705543](https://juejin.cn/post/6844904149616705543)

* 在resize的时候可能会发生死锁
* 可能会造成put的值丢失

先说一下**死锁**的问题：**JDK 1.7**中，扩容的时候会调用transfer方法，关键方法体如下：

```text
//数据迁移的方法，头插法添加元素
void transfer(Entry[] newTable, boolean rehash) {
    int newCapacity = newTable.length;
　　 //for循环中的代码，逐个遍历链表，重新计算索引位置，将老数组数据复制到新数组中去（数组不存储实际数据，所以仅仅是拷贝引用而已）
    for (Entry<K,V> e : table) {
        while(null != e) {
            // 找到e的下一个节点
            Entry<K,V> next = e.next;
            if (rehash) {
                e.hash = null == e.key ? 0 : hash(e.key);
            }
            // 获取每个Entry在新map中的下标
            int i = indexFor(e.hash, newCapacity);
            //以下三行是线程不安全的关键，头插法
            e.next = newTable[i]; // 将e插入到新链表的前面
            newTable[i] = e; 
            e = next; // e等于下一个节点
        }
    }
}
```

上面的代码的意思是：在transfer的时候，会遍历每个链表节点，然后计算节点在新map中的下标，然后使用头插法插入到新表。头插法会导致链表反转，这个时候另一个线程如果也在插入的时候触发了rehash，就会发生死锁。



再说一下**数据丢失**的问题：在链表反转的过程中，如果有多线程同时在resize，在造成死锁的过程中就会产生数据丢失的情况。

在JDK 1.8中没有反转链表，直接使用尾插法插入，但是也有可能有问题：多线程插入的时候，如果那个位置刚好为空，并且线程A和线程B插入数据key的hash值落到了同一个桶上，当两个线程同时同时执行到put段代码时，就会同时执行e.value = xxA 、e.value = xxB，这个时候线程A或者线程B的数据就会被覆盖。

#### 总结

首先 HashMap 是**线程不安全**的，其主要体现：

1. 在 jdk1.7 中，在多线程环境下，扩容时会造成环形链表或数据丢失。
2. 在 jdk1.8 中，在多线程环境下，会发生数据覆盖的情况。



### JDK 1.7中的ConcurrentHashmap

JDK 1.7中的ConcurrentHashmap有一个重要的概念：就是**Segment。**

Segment就是一个数组，存放数据时首先需要定位到具体的 Segment 中。

原理：ConcurrentHashMap 采用了**分段锁**技术，其中 Segment 继承于 ReentrantLock（可重入锁）。不会像 HashTable 那样不管是 put 还是 get 操作都需要做同步处理。同一个Segment可以同时被写和读，不需要加锁；不同Segment之间互不影响，可以被多个线程同时写入。

在get和put的时候，都需要先通过hash值获取在segment数组中的下标，然后通过hash值定位到具体位置。在put的时候，需要先获取到segment的可重入锁，然后定位到segment，然后定位到具体问题，覆盖或者直接写入，最后释放锁。get不需要加锁，因为使用了volidate声明Entry，每次都是从主存读取最新值

如果当一个线程插入的时候，同时又有一个线程在读取ConcurrentHashmap的size，那怎么保证size总是正确的？答：首先会将每个segment的元素个数相加，然后还会计算ConcurrentHashmap被修改的次数，如果修改次数和统计开始之前相同，那么就是准确的；如果不同，则表示ConcurrentHashmap被修改过，就重新统计个数，并且统计次数加一，如果统计次数超过了阈值，也就表示统计的时候ConcurrentHashmap一直在被修改，那么直接给ConcurrentHashmap加锁，获取到准确个数了之后再释放锁（先乐观再悲观）

### JDK 1.8中的ConcurrentHashmap

