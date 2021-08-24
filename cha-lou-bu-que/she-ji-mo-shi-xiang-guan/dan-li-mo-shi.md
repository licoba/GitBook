---
description: 饿汉式、懒汉式、线程安全的单例
---

# 单例模式

### 懒汉式

也就是在获取单例对象的时候再去初始化，这种是线程不安全的。

```text
public class Singleton {  
    private static Singleton instance;  
    private Singleton (){}  
  
    public static Singleton getInstance() {  
    if (instance == null) {  
        instance = new Singleton();  // 为空的时候再去new对象
    }  
    return instance;  
    }  
}
```

### 饿汉式

这种是在类加载的时候就创建了一个对象，因为static对象属于类class，所以是线程安全的。

但是缺点是：容易产生垃圾对象

```text
public class MySingleton {  
    private static MySingleton instance = new MySingleton();
    
    private MySingleton(){}
    
    public static MySingleton getInstance() {
        return instance;
    }
}
```

### 线程安全的懒汉式

使用synchronized来对get方法进行加锁，保证单例，缺点是getInstance如果频繁调用就容易出问题。

```text
public class Singleton {  
    private static Singleton instance;  
    private Singleton (){}  
    public static synchronized Singleton getInstance() {  
        if (instance == null) {  
            instance = new Singleton();  
        }  
        return instance;  
    }  
}
```

### 枚举单例

这种方法是线程安全的，但是在初始化时不能带入复杂的初始化代码。

```text
public enum Singleton {  
    INSTANCE;  
    public void whateverMethod() {  
    }  
}

```

### 静态内部类单例

这种方式的特性是利用了类加载的特性，Singleton只会加载一次，也可以实现延迟加载，因为没有调用getInstance方法时，并不会初始化Singleton的实例。只有在加载内部类SingleHolder的时候才会执行创建SingleTon的方法。

```java
public class Singleton {  
    private static class SingletonHolder {  
        private static final Singleton INSTANCE = new Singleton();  
    }  
    private Singleton (){}  
    public static final Singleton getInstance() {  
        return SingletonHolder.INSTANCE;  
    }  
}
```

### 双重校验锁单例

```java
public class Singleton {  
    private volatile static Singleton singleton;  
    private Singleton (){}  
    public static Singleton getSingleton() {  
    if (singleton == null) {  
        synchronized (Singleton.class) {  
            if (singleton == null) {  
                singleton = new Singleton();  
            }  
        }  
    }  
    return singleton;  
    }  
}
```

【参考文章】

* [https://www.runoob.com/design-pattern/singleton-pattern.html](https://www.runoob.com/design-pattern/singleton-pattern.html)

