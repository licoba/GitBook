# 快速排序算法

可以参考这篇文章：[小灰的快速排序算法](https://mp.weixin.qq.com/s?\_\_biz=MzIxMjE5MTE1Nw==\&mid=2653195042\&idx=1\&sn=2b0915cd2298be9f2163cc90a3d464da\&chksm=8c99f9f8bbee70eef627d0f5e5b80a604221abb3a1b5617b397fa178582dcb063c9fb6f904b3\&scene=21#wechat\_redirect) 写的很好

快速排序算法在最好的情况下，时间复杂度为O(n\*logn)，最坏的情况下(每次都选择到了最大/最小值)

有两种排序算法：挖坑法和指针交换法。这里采用指针交换法，找到基准元素（一般是第一位），然后交换left和right，最后交换基准元素和left与right重合的下标。

代码可以参考我的GitHub [https://github.com/licoba/SortProject/blob/main/src/KuaiSu/](https://github.com/licoba/SortProject/blob/main/src/KuaiSu/KuaiSuSort.java)



#### 注意点

* 下标搜索时一定要是j先减，不然最后交换固定元素与重合下标时会有问题。
