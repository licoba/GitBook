# SharedPreferences源码分析

这是第一篇源码分析文章，希望能开个好头。

之前不知道去哪里查看源码，查了一下资料，可以在 [https://cs.android.com/](https://cs.android.com/) 去搜索Android的源码

从`SharedPreferences sp = getSharedPreferences("data",MODE_PRIVATE);`开始分析

在Android studio里面点击源码，会跳转到Context类的同名抽象方法

```text
public abstract SharedPreferences getSharedPreferences(String name, @PreferencesMode int mode);
```

由于这是一个抽象方法，所以得要找到他的实现类

在cs.android.com里搜索`public abstract class Context`,也就是Context类，来到了`frameworks/base/core/java/android/content/Context.java`

然后搜索`getSharedPreferences`方法，在左侧可以看到筛选出来的结果 

![](https://pic.downk.cc/item/5fa261041cd1bbb86b167801.jpg)

按住control，顺着点击方法，可以在下面的「覆盖来源」部分，看到抽象类的具体实现，Context的具体实现类就是ContextImpl，点进去就是我们想要看的源码了。

 

![](https://pic.downk.cc/item/5fa366611cd1bbb86b476fb3.jpg)

上代码

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

