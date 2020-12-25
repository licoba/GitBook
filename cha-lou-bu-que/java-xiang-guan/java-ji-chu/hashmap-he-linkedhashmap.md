# HashMap 和 LinkedHashMap

## 写在前面

`HashMap`、`LinkedHashMap`、`HashTable`、`TreeMap`，这四兄弟哦，也是搞了很久没搞懂，专门花点时间来总结一下他们的区别、

## HashMap

* hashmap 的插入顺序是随机的。也就是说，按 1、2、3 的顺序插进去，但是 print 出来的顺序可能是 1、3、2。
* 优点：根据键的 HashCode 值存储数据，存和取的速度都非常快
* HashMap 可以多个线程同时写入，所以是线程不安全的
* HashMap 的 key 可以是 null，但是由于一个键只能对应一个值，如果插入另外一个键值相同的数据，那么前一个的 value 会被覆盖掉

## HashTable

* HashTable 的键和值都不允许为 null，如果插入了一个键或者是值为 null 的数据，编译的时候会直接报错。
* HashTable 是线程安全的。也就是一个时间只能有一个线程写它，所以 HashTable 跟 HashMap 比起来的主要区别就是安全性（这里的安全性主要体现在**不允许非空的值**和**保持线程同步**）

## LinkedHashMap

* LinkedHashMap 是可以保证插入的有序性。也就是说插入的时候是什么顺序，遍历的时候就会是什么顺序。
* LinkedHashMap 采用的是双向链表实现的，正是因为实现方法的不同，所以可以保证插入的顺序性
* 链表的查询会比列表慢，这个是 LinkedHashMap 的缺点。

## TreeMap

* TreeMap 的主要优势在于默认按照了 key 的升序来排序，就是你插入值之后，内部会自动根据 key 的帮你排序好。按照 4,1,3,2 插入的顺序，遍历的结果将会是 1,2,3,4。
* TreeMap 是基于红黑数实现的。

【参考博客】

* [HashMap 与 LinkedHashMap 的区别](https://blog.csdn.net/shengqianfeng/article/details/79939414)

