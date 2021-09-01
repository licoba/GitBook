---
description: 关于ThreadLocal的理解
---

# ThreadLocal原理

## SimpleDateFormat 的线程不安全

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
        for (int i = 0; i < 1000; i++) {
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

## 使用 ThreadLocal 来保证 SimpleDateFormat 的线程安全

【参考资料】

* [ThreadLocal 使用场景与原理](https://blog.csdn.net/u011212394/article/details/107028016)

