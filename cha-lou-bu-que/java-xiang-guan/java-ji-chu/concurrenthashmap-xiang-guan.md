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

