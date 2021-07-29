# SharedPreferences源码分析

### 

## SharedPreferences 源码分析

#### 基本使用

```text
SharedPreferences sharedPreferences = getSharedPreferences("licoba", Context.MODE_PRIVATE);
SharedPreferences.Editor edit = sharedPreferences.edit();
edit.putString("licoba","123456");
edit.apply(); // 保存数据 // 或者 edit.commit()
sharedPreferences.getString("licoba",""); //读取数据
```

首先从第一行代码开始分析：

`SharedPreferences sp = getSharedPreferences("data",MODE_PRIVATE);`

在 Android studio 里面点击源码，会跳转到`Context`类的同名抽象方法

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

可以看明显的看到最后还是调用了`public SharedPreferences getSharedPreferences(File file, int mode)`方法去实现，也就是我们常用的 name 作为形参的方法，实际上只是提供了一个方便访问 file 的快捷方法。

首先看`synchronized (ContextImpl.class)`这句话，说实话这个写法我还真没怎么用过。参考 [Synchronized 的四种用法](https://blog.csdn.net/luoweifu/article/details/46613015)

> synchronized 修饰类的时候，synchronized 作用于类 T，是给这个类 T 加锁，T 的所有对象用的是同一把锁。也就是方法体内，对对象的方法调用，同一时间只能有一个对象拿到锁，去执行操作。

#### 根据 spName 获取 File 对象

```text
    public File getSharedPreferencesPath(String name) {
        return makeFilename(getPreferencesDir(), name + ".xml");
    }
```

作用也就是在本地新建了一个 xml 对象，结合上一段代码，也就是 mSharedPrefsPaths 列表里面有的话，直接从列表里面获取，没有的话就新建一个 xml 文件。

#### 根据 File 获取真正的 SP 对象

看到最后一行的 `return getSharedPreferences(file, mode);`

```text
    @Override
    public SharedPreferences getSharedPreferences(File file, int mode) {
        SharedPreferencesImpl sp;
        synchronized (ContextImpl.class) {
            final ArrayMap<File, SharedPreferencesImpl> cache = getSharedPreferencesCacheLocked();
            sp = cache.get(file);
            if (sp == null) {
                checkMode(mode);
                ...
                sp = new SharedPreferencesImpl(file, mode);
                cache.put(file, sp);
                return sp;
            }
        }
        if ((mode & Context.MODE_MULTI_PROCESS) != 0 ||
            getApplicationInfo().targetSdkVersion < android.os.Build.VERSION_CODES.HONEYCOMB) {
            sp.startReloadIfChangedUnexpectedly();
        }
        return sp;
    }
```

首先是 getSharedPreferencesCacheLocked 从缓存获取 SharedPreferencesImpl 的 map，如果有直接返回，如果没有就 `new SharedPreferencesImpl(file, mode)`直接新建一个，所有这里返回的的不是 SharedPreferences，而是 SharedPreferences 的一个实现类 SharedPreferencesImpl（后面简称为 SPI），如果我们点进 SharedPreferences 看一下，可以看到 **SharedPreferences 实际上只是一个接口** 也就是说 SharedPreferencesImpl 才真正完成了 edit、getString 等操作

#### SharedPreferencesImpl 分析

**getString 方法**

```text
   public String getString(String key, @Nullable String defValue) {
        synchronized (mLock) {
            awaitLoadedLocked(); // //阻塞等待sp将xml读取到内存
            String v = (String)mMap.get(key);
            return v != null ? v : defValue;
        }
    }
```

这里可以看到使用了一把锁 mLock， `private final Object mLock = new Object();` 需要等 SP load 完成之后才能 get 到值，所以 SP 只适合轻量化的存储，如果数据量太大，awaitLoadedLocked 没有执行完毕，这时候如果在主线程调用 getString 方法，就是会阻塞主线程造成 ANR。

顺带看看 awaitLoadedLocked 方法

```text
private void awaitLoadedLocked() {
    if (!mLoaded) {
        BlockGuard.getThreadPolicy().onReadFromDisk();
    }
    while (!mLoaded) {
        try {
            mLock.wait();
        } catch (InterruptedException unused) {
        }
    }
    if (mThrowable != null) {
        throw new IllegalStateException(mThrowable);
    }
}
```

可以看到 mLoaded 如果不为 true，mLock 就会一直等待，顺着追踪`mLoaded = true`的代码

在 `loadFromDisk`方法里面可以找到

```text
private void loadFromDisk() {
        synchronized (mLock) {
            //是否读取过
            if (mLoaded) {
                return;
            }
            //如果备份文件存在，删除mFile，将备份文件重命名给mFile
            if (mBackupFile.exists()) {
                mFile.delete();
                mBackupFile.renameTo(mFile);
            }
        }

        Map map = null;
        StructStat stat = null;
        try {
            stat = Os.stat(mFile.getPath());
            if (mFile.canRead()) {
                BufferedInputStream str = null;
                try {
                    str = new BufferedInputStream(
                            new FileInputStream(mFile), 16*1024);
                    //将xml文件转成map
                    map = XmlUtils.readMapXml(str);
                } catch (Exception e) {
                    Log.w(TAG, "Cannot read " + mFile.getAbsolutePath(), e);
                } finally {
                    IoUtils.closeQuietly(str);
                }
            }
        } catch (ErrnoException e) {
            /* ignore */
        }

        synchronized (mLock) {
            //表示已经读取过，下次调用getSharedPreferences不会再从磁盘读取
            mLoaded = true;
            if (map != null) {
                //赋值给成员变量mMap
                mMap = map;
                mStatTimestamp = stat.st_mtim;
                mStatSize = stat.st_size;
            } else {
                mMap = new HashMap<>();
            }
            //释放锁
            mLock.notifyAll();
        }
    }
```

使用 FileInputStream 从文件里面读取之后，转换成 map 对象，转换完成之后，先将 mLoaded 置为 true，然后 `mLock.notifyAll();`释放锁，所以`awaitLoadedLocked`方法才能跳出循环并返回，这是一个很经典的使用锁的方式。

顺带说一句，loadFromDisk 方法在 SharedPreferencesImpl 的构造函数里面就被调用了，也就是在 getSP 的时候，去完成从硬盘读取文件的这个操作

**edit 对象**

从使用方式上来看，在获取到 SPL 之后，就需要获取 edit 对象来开启编辑，那么 edit 到底做了什么事情呢？为什么要先调用 edit 方法？

* SharedPreferencesImpl - edit 方法

```text
@Override
public Editor edit() {

    synchronized (mLock) {
        awaitLoadedLocked();
    }

    return new EditorImpl();
}
```

看到就是 new 并返回了一个 edit 的实现类 EditorImpl

首先看一下各种 put 方法，以及 clear、remove 方法

```text
public final class EditorImpl implements Editor {
    private final Object mEditorLock = new Object();

    @GuardedBy("mEditorLock")
    private final Map<String, Object> mModified = new HashMap<>();

    @GuardedBy("mEditorLock")
    private boolean mClear = false;

    @Override
    public Editor putString(String key, @Nullable String value) {
        synchronized (mEditorLock) {
            mModified.put(key, value);
            return this;
        }
    }
    ... // 各种put方法
    @Override
    public Editor remove(String key) {
        synchronized (mEditorLock) {
            mModified.put(key, this);
            return this;
        }
    }

    @Override
    public Editor clear() {
        synchronized (mEditorLock) {
            mClear = true;
            return this;
        }
    }
}
```

可以看到 各种 put 方法实际上都是在操作 edit 内部的 mModified 对象，也就是 editor 先用 mModified 将所有的修改保存起来。这也就是为什么我们如果不调用 apply 和 commit，就没办法修改值的原因。

**Edit 的 apply 和 commit 方法**

我们在 structure 里面查看 EditorImpl 类，可以看到两个方法：apply 和 commit，为什么提交改动需要提供两个方法？

* apply 方法

```text
public void apply() {
    final long startTime = System.currentTimeMillis();

    final MemoryCommitResult mcr = commitToMemory();  // 先调用了commitToMemory方法
    final Runnable awaitCommit = new Runnable() {
            @Override
            public void run() {
                try {
                    mcr.writtenToDiskLatch.await();
                } catch (InterruptedException ignored) {
                }

                if (DEBUG && mcr.wasWritten) {
                    Log.d(TAG, mFile.getName() + ":" + mcr.memoryStateGeneration
                            + " applied after " + (System.currentTimeMillis() - startTime)
                            + " ms");
                }
            }
        };

    QueuedWork.addFinisher(awaitCommit);

    Runnable postWriteRunnable = new Runnable() {
            @Override
            public void run() {
                awaitCommit.run();
                QueuedWork.removeFinisher(awaitCommit);
            }
        };

    SharedPreferencesImpl.this.enqueueDiskWrite(mcr, postWriteRunnable);


    notifyListeners(mcr);
}
```

可以看到 apply 先调用了 commitToMemory 方法，然后创建了一个任务，这个任务的职责就是等待写入硬盘数据完成 ，apply 创建了这个任务，然后将他放到了任务队列 QueuedWork，然后使用 listener 来查看写入操作是否完成。

在 enqueueDiskWrite 方法中可以看到注释，一次只会执行一个写入任务，多个任务会按照顺序排队执行

看看 commitToMemory 做了什么

```text
private MemoryCommitResult commitToMemory() {
    long memoryStateGeneration;
    boolean keysCleared = false;
    List<String> keysModified = null;
    Set<OnSharedPreferenceChangeListener> listeners = null;
    Map<String, Object> mapToWriteToDisk;

    synchronized (SharedPreferencesImpl.this.mLock) {
        if (mDiskWritesInFlight > 0) {
            mMap = new HashMap<String, Object>(mMap);
        }
        mapToWriteToDisk = mMap;
        mDiskWritesInFlight++;

        boolean hasListeners = mListeners.size() > 0;
        if (hasListeners) {
            keysModified = new ArrayList<String>();
            listeners = new HashSet<OnSharedPreferenceChangeListener>(mListeners.keySet());
        }

        synchronized (mEditorLock) {
            boolean changesMade = false;
            ...
            for (Map.Entry<String, Object> e : mModified.entrySet()) {
                String k = e.getKey();
                Object v = e.getValue();
                if (v == this || v == null) {
                    if (!mapToWriteToDisk.containsKey(k)) {
                        continue;
                    }
                    mapToWriteToDisk.remove(k);
                } else {
                    if (mapToWriteToDisk.containsKey(k)) {
                        Object existingValue = mapToWriteToDisk.get(k);
                        if (existingValue != null && existingValue.equals(v)) {
                            continue;
                        }
                    }
                    mapToWriteToDisk.put(k, v);
                }
                changesMade = true;
                if (hasListeners) {
                    keysModified.add(k);
                }
            }

            mModified.clear();

            if (changesMade) {
                mCurrentMemoryStateGeneration++;
            }

            memoryStateGeneration = mCurrentMemoryStateGeneration;
        }
    }
    return new MemoryCommitResult(memoryStateGeneration, keysCleared, keysModified,
            listeners, mapToWriteToDisk);
}
```

可以看到主要就是将 Editor 的 mModified 集合中的数据拷贝到 mMap 集合中，然后再返回包含 mapToWriteToDisk 的 MemoryCommitResult，因为这里可能调用多次，所以要在每次合并之后都进行 clear。

* commit 方法

```text
@Override
public boolean commit() {
    long startTime = 0;

    MemoryCommitResult mcr = commitToMemory();

    SharedPreferencesImpl.this.enqueueDiskWrite(
        mcr, null /* sync write on this thread okay */);
    try {
        mcr.writtenToDiskLatch.await();
    } catch (InterruptedException e) {
        return false;
    } finally {
        if (DEBUG) {
            Log.d(TAG, mFile.getName() + ":" + mcr.memoryStateGeneration
                    + " committed after " + (System.currentTimeMillis() - startTime)
                    + " ms");
        }
    }
    notifyListeners(mcr);
    return mcr.writeToDiskResult;
}
```

区别可以看出来了：commit 是直接 enqueueDiskWrite，写入磁盘；apply 是先写入内存，然后再开启一个异步任务写入内存。

同时，commit 返回的是`mcr.writeToDiskResult` 也就是将写入成功与否的结果直接返回。而单纯调用 apply 是没有写入结果返回的，只有调用 SPI 的 registerOnSharedPreferenceChangeListener 方法，去注册一个监听器，才能得到 apply 的返回结果

### 总结

* apply 是异步写入，先写入内存，然后再异步写入磁盘；commit 直接写入磁盘，并且是阻塞的，会返回结果。
* 尽可能早地调用 getSharedPreferences 去初始化 SP 对象，因为再初始化的时候，会先等待从磁盘读取完成，尽早读取，就可以在 get 和 put 的时候不用再等待。
* SP 只适用于少量数据读取，因为写入数据是一次性的，并且是全量写入，所以在读写大量数据的时候性能会比较低，甚至可能会造成卡顿和 ANR。
* apply 和 commit 只用调用一次，尽量在 edit 操作全部完成之后再调用。
* SP 的本质就是磁盘上一个 xml 文件的读写操作

### 相关问题

#### 一、SharedPreferences 是线程安全的吗？

是的，从源码里面可以看到使用了大量的 synchronized 来保证线程安全，对 class 对象加锁，所以客户端内的所有 SP 对象是同一个 SP 对象

#### 二、SharedPreferences 在哪些情况下可能会导致 ANR？

* Sp.Edit.apply\(\)方法可能会导致 ANR，主要是因为 Activity 在 onPause、onStop 时会调用 QueuedWork.waitToFinish，waitToFinish 是在 ActivityThread，也就是在主线程中的，如果 IO 速率不够或者文件过大，就可能会造成 ANR
* 在主线程获取某个值 sp.getString\(XXXX\)：主线程读取阻塞，是因为虽然 SharedPreferences 读取 Map（loadFromDisk）这个操作虽然在子线程，但是其 getX\(key\) 系列方法想要调用的前提是 SharedPreferences 子线程已经读取完成，也就是 loadFromDisk 完成，否则就会阻塞，所以 SharedPreferences 中如果存储太大内容或者太多内容导致 XML 解析等变慢就会导致后面的 getX\(key\) 阻塞主线程，从而导致主线程卡顿。

#### 三、SharedPreferences 的性能优化？

【参考文章】

* [SharedPreferences 源码解析：自带的轻量级 K-V 存储库](https://juejin.im/post/6844904036714430472)

