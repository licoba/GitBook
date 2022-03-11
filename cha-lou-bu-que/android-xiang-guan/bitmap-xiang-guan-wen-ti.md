# Bitmap相关问题

来历：不能直接new，需要由BitmapFactory.fromfile或者from字节数组，或者from图片，都可以生成Biamap对象。也就是decodeFromXXXX

Decode时的Options：后面细说

常用方法：**compress**  可以压缩到指定质量（0-100）0是最低画质

recycle：回收位图，释放bitmap的内存空间



#### Bitmap的内存溢出问题OutOfMemory，也即是OOM

为什么会有OOM问题：因为Android系统的APP每个进程或者Dalvik虚拟机有最大内存限制，一旦超过这个限制系统就会抛出OOM错误。跟手机剩余内存是否充足没有多少关系。

Bitmap如果在加载很大的图片时，比如说1G，那么就超过了这个最大内存限制，就会产生OOM现象，没有加Try Catch就会导致程序崩溃。

#### 如何避免OOM问题

* 采用编码质量更低的编码方式：默认的是ARGB_8888  可以改成ARGB\__4444
* 及时回收对象，不使用的对象，要及时调用recycle方法释放掉
* 缩放：缩放图片的大小，例如长宽都调整为原来的1/2
* 缓存可以重复使用的Bitmap，不用每次都从decode创建对象

#### Bitmap怎么压缩

问题也就是怎么计算压缩比

Bitmap所占用的内存 = 图片长度 x 图片宽度 x 一个像素点占用的字节数。

压缩比是 inSampleSize  问题变成怎么计算insamplesize

* 步骤

首先设置inJustDecodeBounds为true，然后加载图片，这时图片并不会被真正地加载到内存中

然后从options中取得宽高信息

根据图片得宽高以及View得宽高，计算缩放比

然后再将inJustDecodeBounds置为false，再options里面加入inSimpleSize，真正加载Bitmap到内存中

官方计算缩放比的方式为2分法，也就是如果图片的宽高大于View的宽高，inSimpleSize就一直 \*2，指数增长





【参考文章】

* [https://zhuanlan.zhihu.com/p/47129811](https://zhuanlan.zhihu.com/p/47129811)
