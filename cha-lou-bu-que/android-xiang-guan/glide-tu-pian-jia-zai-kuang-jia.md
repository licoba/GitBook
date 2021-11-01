---
description: Glide三级缓存、Glide会不会内存泄漏
---

# Glide图片加载框架

### Glide优势？

* 简洁方便、链式调用
* 三级缓存机制，避免重复加载

### Android的三级缓存机制

* 内存缓存，优先加载，速度最快
* 本地缓存，次优先加载，速度快
* 网络缓存，最后加载，速度慢，浪费流量

三级缓存，存在的意义就是：减少流量消耗、提高加载速度。

### Glide的缓存机制

Glide有两种缓存模式：**内存缓存 **和 **磁盘缓存**

#### **内存缓存**

```java
Glide.with(this)
     .load(url)
     .skipMemoryCache(true)//关闭内存缓存
     .into(imageView);
```

#### **磁盘缓存**

```java
Glide.with(this)
     .load(url)
     .diskCacheStrategy(DiskCacheStrategy.RESULT)
     .into(imageView)
```

其中缓存策略有4种：不缓存、缓存原始图片、缓存转换后的图片、缓存两者。GLide默认会压缩原始图片之后再做缓存。

### 缓存策略

#### LRU算法

LRU：Least Recently Used 「最少最近使用算法」

基本原则：LRU算法认为，“如果数据最近被访问过，那么将来被访问的几率也更高”，所以LRU缓存策略会优先回收最近一段时间，最少使用的那些对象。

#### LruCache

LruCache是Android提供的一个缓存工具类，给LruCache指定一大小，然后使用put和get方法，Android会自动帮我们实现Lru的效果，也就是资源的回收，使用可以避免OOM问题。

#### LruCache原理

LruCache内部维护了一个LinkedHahmap（双向链表），每次在get和put的时候，都会进行重排序，最少使用的在头部，最近使用的压入尾部，如果容量超出了限制，就会移除最近使用得最少的元素（头部元素）。

用一个双端队列理解，头部是最先进的元素，尾部是最后进的元素，get或者put的时候，都会将元素移到队尾，长此以，对头就是没有被使用过的元素。

