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

这种方法是线程安全的，并且有几点优势：一是写法简单，二是不会因为序列化破坏类的单例属性。枚举的序列化属性是由JVM保证的

```text
public enum SingletonEnum {
    INSTANCE;
    private String name;
    public String getName(){
        return name;
    }
    public void setName(String name){
        this.name = name;
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
        if (singleton == null) { // 第一次判空
            synchronized (Singleton.class) {  // 多个线程在这里等待锁释放
                if (singleton == null) {  // 第二次判空
                    singleton = new Singleton();  
                }  
            }  
        }  
        return singleton;  
    }  
}
```

### Q&A

#### 双重校验锁为什么要两次判空？

* 第一次判空是为了判断对象是否创建，为正常的判空逻辑。
* 第二次判空是防止对象重复创建，因为可能会存在多个线程通过了第一次判断在等待锁，来创建新的实例对象。如果不在 synchronized 里判空，多线程执行的时候就有可能重复创建对象。

【参考文章】

* [https://www.runoob.com/design-pattern/singleton-pattern.html](https://www.runoob.com/design-pattern/singleton-pattern.html)

