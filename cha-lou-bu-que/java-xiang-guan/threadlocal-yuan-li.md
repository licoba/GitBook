---
description: 关于ThreadLocal的理解
---

# ThreadLocal原理

### ThreadLocal介绍

ThreadLocal，线程本地存储，可以在线程内创建变量或者对象的副本，最大的作用是**线程隔离** ，只有本线程可以访问到，其它线程不能访问，约等于线程的局部变量。

### SimpleDateFormat 的线程不安全

看一段 Demo：

```text
public class ThreadNotSafeDemo {

    private static ExecutorService threadPool = Executors.newFixedThreadPool(16);
    static SimpleDateFormat dateFormat = new SimpleDateFormat("mm:ss");

    public String date(int seconds) {
        // 创建不同的date
        Date date = new Date(1000 * seconds);
        return dateFormat.format(date);
    }

    public static void main(String[] args) {
        for (int i = 0; i < 100; i++) {
            int finalI = i;
            threadPool.submit(() -> {
                String date = new ThreadNotSafeDemo().date(finalI);
                System.out.println("finalI"date);
            });
        }
        threadPool.shutdown();
    }
}
```

这段 Demo 里面的 main 函数，循环创建 1000 个线程去调用 ThreadNotSafeDemo 的 date 方法，注意：每次都是`new ThreadNotSafeDemo`，其中的 dateFormat 是 static 变量，也就是所有线程共享这个`dateFormat`，再查看打印结果，发现不同的 finalI，dateFormat 解析出来的结果竟然是一样，说明产生了线程安全问题，也就是`SimpleDateFormat`是线程不安全的。

```text
finalI:0 date:00:05
finalI:7 date:00:07
finalI:4 date:00:05 // 重复
finalI:5 date:00:05 // 重复
finalI:2 date:00:05 // 重复
finalI:3 date:00:05 // 重复
finalI:1 date:00:05 // 重复
finalI:10 date:00:10
finalI:6 date:00:06
finalI:9 date:00:09
finalI:8 date:00:08
```

### 使用 ThreadLocal 来保证 SimpleDateFormat 的线程安全

ThreadLocal一般用static声明，在线程内没有时去创建一个

```text
public class ThreadNotSafeDemo {
    static ExecutorService threadPool = Executors.newFixedThreadPool(16);
    static ThreadLocal<SimpleDateFormat> threadLocal = new ThreadLocal<>();

    public String date(int seconds) {
        // 创建不同的date
        Date date = new Date(1000 * seconds);
        if (threadLocal.get() == null) {
            threadLocal.set(new SimpleDateFormat("mm:ss"));
        }
        return threadLocal.get().format(date);
    }

    public static void main(String[] args) {
        for (int i = 0; i < 1000; i++) {
            int finalI = i;
            threadPool.submit(() -> {
                String date = new ThreadNotSafeDemo().date(finalI);
                System.out.println("finalI:" + finalI + " date:" + date);
            });
        }
        threadPool.shutdown();
    }
}
```

运行结果为顺序打印，没有相同的值，所以是线程安全的。

### 相关问题

#### ThreadLocal原理

首先看一下ThreadLocal的get和set方法，可以看到里面都有一个ThreadLocalMap对象，也就是threadLocal的set和get方法，实际上都是通过内部的ThreadLocalMap来进行存取。

* set方法

```text
  public void set(T value) {
      Thread t = Thread.currentThread();
      ThreadLocalMap map = getMap(t);
      if (map != null)
          map.set(this, value); // 使用当前线程对象作为key
      else
          createMap(t, value);
  }
```

* get方法

```text
  public T get() {
      Thread t = Thread.currentThread();
      ThreadLocalMap map = getMap(t);
      if (map != null) {
          ThreadLocalMap.Entry e = map.getEntry(this);
          if (e != null) {
              @SuppressWarnings("unchecked")
              T result = (T)e.value;
              return result;
          }
      }
      return setInitialValue();
  }
```

#### ThreadLocal和Synchronized的区别？

* ThreadLocal是为了线程隔离数据，Synchronized是为了线程间共享数据。
* ThreadLocal等于是用空间换时间，每个线程都有一个新副本；Synchronized等于是用时间换空间，要等一个线程释放锁之后，另一个线程才能访问。

#### ThreadLocal内存泄漏？

**内存泄漏的原因？**

上面有说ThreadLocal里面维护了一个ThreadLocalMap对象，ThreadLocalMap是ThreadLocal的一个内部类

* ThreadLocalMap

```java
static class ThreadLocalMap {

    static class Entry extends WeakReference<ThreadLocal<?>> {
        Object value;

        Entry(ThreadLocal<?> k, Object v) {
            super(k);
            value = v;
        }
    }

    private static final int INITIAL_CAPACITY = 16;
    // ...
}
```

可以看到Entry是一个弱引用，弱引用的Entry的key是ThreadLocal对象，当ThreadLocal对象被置为空的时候，下一次GC的时候就可能被回收掉，这时候就存在一个Key为null，但是值仍然存在在堆里面的情对象。垃圾回收的可达性分析算法没有办法访问到这个值，所以永远没有办法回收到，造成内存泄漏。

**内存泄漏的解决办法**

* 在每次使用完ThreadLocal之后，都调用它的remove\(\)方法清除数据
* JDK 1.8做了改进，对于key为null的对象，被称为脏数据，会自动回收。

【参考资料】

* [ThreadLocal 使用场景与原理](https://blog.csdn.net/u011212394/article/details/107028016)

