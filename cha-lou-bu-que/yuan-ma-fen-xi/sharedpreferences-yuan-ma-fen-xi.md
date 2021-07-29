# SharedPreferences源码分析

### 基本使用

```text
SharedPreferences sharedPreferences = getSharedPreferences("licoba", Context.MODE_PRIVATE);
SharedPreferences.Editor edit = sharedPreferences.edit();
edit.putString("licoba","123456");
edit.apply(); // 保存数据 // 或者 edit.commit() 
sharedPreferences.getString("licoba",""); //读取数据        
```

首先从第一行代码开始分析：

`SharedPreferences sp = getSharedPreferences("data",MODE_PRIVATE);`

在Android studio里面点击源码，会跳转到`Context`类的同名抽象方法

```text
public abstract SharedPreferences getSharedPreferences(String name, @PreferencesMode int mode);
```

由于这是一个抽象方法，所以得要找到他的实现类，**Context**类对应的实现类是**ContextImpl**

下面是**ContextImpl**类的`getSharedPreferences`部分代码

* ContextImpl.class

  ```text
    @Override
    public SharedPreferences getSharedPreferences(String name, int mode) {
        // At least one application in the world actually passes in a null
        // name.  This happened to work because when we generated the file name
        // we would stringify it to "null.xml".  Nice.
        if (mPackageInfo.getApplicationInfo().targetSdkVersion <
                Build.VERSION_CODES.KITKAT) {
            if (name == null) {
                name = "null";
            }
        }

        File file;
        synchronized (ContextImpl.class) {
            if (mSharedPrefsPaths == null) {
                mSharedPrefsPaths = new ArrayMap<>();
            }
        // 根据name取文件
            file = mSharedPrefsPaths.get(name);
            if (file == null) {
        // 没有取到文件，新建文件
                file = getSharedPreferencesPath(name);
                mSharedPrefsPaths.put(name, file);
            }
        }
        return getSharedPreferences(file, mode);
    }
  ```

可以看明显的看到最后还是调用了`public SharedPreferences getSharedPreferences(File file, int mode)`方法去实现，也就是我们常用的name作为形参的方法，实际上只是提供了一个方便访问file的快捷方法。

首先看`synchronized (ContextImpl.class)`这句话，说实话这个写法我还真没怎么用过。参考 [Synchronized的四种用法](https://blog.csdn.net/luoweifu/article/details/46613015)

synchronized修饰类的时候，synchronized作用于类T，是给这个类T加锁，T的所有对象用的是同一把锁。也就是方法体内，对对象的方法调用，同一时间只能有一个对象拿到锁，去执行操作。其实效果和synchronized修饰静态方法是一样的，因为我们知道：静态方法是属于类的而不属于对象的。同样的，synchronized修饰的静态方法锁定的是这个类的所有对象。

【参考文章】

* [SharedPreferences 源码解析：自带的轻量级 K-V 存储库](https://juejin.im/post/6844904036714430472)

