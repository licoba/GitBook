---
description: HashMap源码分析、hash扩容、put方法
---

# HashMap源码分析

主要是分析put方法的源码，也是一个主要使用的方法

### Put方法

#### JDK 1.7

在JDK 1.7没有什么好说的，就是链表头插法。

#### JDK 1.8

* 用法

```java
hashMap.put(1, "This is a test");
```

* put 方法

```java
public V put(K key, V value) {
    return putVal(hash(key), key, value, false, true);
}
```

* putVal方法

```java
/**
 * Implements Map.put and related methods
 *
 * @param hash hash for key
 * @param key the key
 * @param value the value to put
 * @param onlyIfAbsent if true, don't change existing value
 * @param evict if false, the table is in creation mode.
 * @return previous value, or null if none
 */
final V putVal(int hash, K key, V value, boolean onlyIfAbsent,
               boolean evict) {
    Node<K,V>[] tab; // 存放头节点的数组
    Node<K,V> p; // 头节点
    int n, i;
    if ((tab = table) == null || (n = tab.length) == 0)
        n = (tab = resize()).length; // resize函数，对应扩容，初始容量16
    if ((p = tab[i = (n - 1) & hash]) == null) // 对应的下标头节点为空
        tab[i] = newNode(hash, key, value, null); // 就放入新节点
    else { // 产生了Hash冲突
        Node<K,V> e; K k;
        if (p.hash == hash &&
            ((k = p.key) == key || (key != null && key.equals(k))))
            e = p; // key相等，替换元素
        else if (p instanceof TreeNode)
            e = ((TreeNode<K,V>)p).putTreeVal(this, tab, hash, key, value); // 插入红黑树节点
        else {
            for (int binCount = 0; ; ++binCount) {
                if ((e = p.next) == null) {
                    p.next = newNode(hash, key, value, null);
                    if (binCount >= TREEIFY_THRESHOLD - 1) // -1 for 1st
                        treeifyBin(tab, hash); // 桶长度 >=8 转化成红黑树，treeifyBin函数内部，需要数组长度大于64才会转化，不然只是进行扩容。
                    break;
                }
                if (e.hash == hash &&
                    ((k = e.key) == key || (key != null && key.equals(k))))
                    break;
                p = e;
            }
        }
        if (e != null) { // existing mapping for key
            V oldValue = e.value;
            if (!onlyIfAbsent || oldValue == null)
                e.value = value;
            afterNodeAccess(e);
            return oldValue;
        }
    }
    ++modCount;
    if (++size > threshold)
        resize();
    afterNodeInsertion(evict);
    return null;
}
```



* 红黑树转化函数 `treefyBin`

```java
/**
 * Replaces all linked nodes in bin at index for given hash unless
 * table is too small, in which case resizes instead.
 * 
 */
static final int MIN_TREEIFY_CAPACITY = 64; // 大于这个树，才会转化

final void treeifyBin(Node<K,V>[] tab, int hash) {
    int n, index; Node<K,V> e;
    if (tab == null || (n = tab.length) < MIN_TREEIFY_CAPACITY)
        resize(); // 数组长度必须要从16扩容到64，才会发生链表到红黑树的转化，否则只是扩容
    else if ((e = tab[index = (n - 1) & hash]) != null) {
        TreeNode<K,V> hd = null, tl = null;
        do {
            TreeNode<K,V> p = replacementTreeNode(e, null);
            if (tl == null)
                hd = p;
            else {
                p.prev = tl;
                tl.next = p;
            }
            tl = p;
        } while ((e = e.next) != null);
        if ((tab[index] = hd) != null)
            hd.treeify(tab);
    }
}
```

 

