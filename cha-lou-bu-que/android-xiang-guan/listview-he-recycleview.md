# ListView 和 RecycleView

## 一、ListView 的优化

### 值得优化的地方

* 每次滑动显示 item 的时候，都会走到 getView 方法里面去，如果每次 getView 都需要用 View.inflate 方法去获取一个新的 view，会引起内存上的增加，并且 View.inflate 方法是将 xml 文件解析成为 View 对象，如果 item 的构成比较复杂的话，这个步骤将是一个非常耗内存的操作。
* findViewById 这个操作也是比较耗时的，因为这个方法要找到指定的布局文件，进行不断地解析每个节点：从最顶端的节点进行一层一层的解析查询，找到后在一层一层的返回，如果在左边没找到，就会接着解析右边，并进行相应的查询，直到找到位置。

### 优化方法

* 复用 getView 方法中的 convertView 在 getView 方法中，ListView 为我们提供了一个 convertView 对象，这个对象就是 ListView 的历史缓存对象，我们可以在 convertView 不为空的时候去复用他，而不用去 new 一个对象，这样可以减少内存上的损耗。
* 使用 ViewHolder 减少 findViewById 的使用

ViewHolder 可以设置成为一个静态类，ViewHolder 里面只用存储需要 findViewById 的对象；通过 converview 的 setTag 和 getTag 方法将 view 与相应的 holder 对象绑定在一起，避免不必要的 findviewbyid 操作

* item 的布局层次尽量不要做太深，避免 View 的过度绘制
* 避免在 getView 方法中做耗时的操作，比如图片加载，可以用异步加载来完成，等待滑动完毕之后再去加载图片，这里可以用 Glide 来实现。在用户过度滑动 ListView 时停止加载 item 里面的图片。因为从用户的角度来讲，用户在快速滑动的时候不需要非常看清楚 item 里面的图片，并且加载图片是一个比较耗时的操作，特别是从网络加载图片的时候.
* 图片加载的三级缓存优化
* 内存缓存 优先加载，速度最快
* 本地缓存 次优先加载 速度稍快
* 网络缓存 最后加载 速度由网络速度决定  也就是优先加载内存中的图片，其次再考虑将重复的图片缓存到本地，避免加载时的网络请求，最后才考虑加载网络上缓存的图片
* 可以使用 RecycleView 来代替 ListView，listView 每次数据有变化都会调用 notifyDataSetChanged 来刷新整个列表，使用 RecycleView 可以实现 item 的局部刷新
* 分页加载 当数据量过大的时候，可以考虑做分页加载，来减少列表过长的时候容易出现的卡顿现象。

### 总结

* 复用 convertView
* 使用 ViewHolder 来代替 findViewById
* 异步加载图片
* 图片三级缓存
* 使用 RecycleView 局部刷新 item
* 分页加载

## 二、ListView 和 RecycleView 的区别

或者说 RecycleView 相比 ListView 起来有什么优势？

1. RecyclerView 的 Adapter 里面已经封装好了 ViewHolder，不用自己写了
2. RecycleView 可以提供局部刷新的方法
3. RecycleView 使用了四级缓存，ListView 使用了两极缓存
4. RecycleView 相比起 ListView 起来更灵活丰富，例如动画效果、拖动效果等
5. RecycleView 在嵌套滚动方面支持比较足，例如 RecycleView 向上滑动的时候能收起其它 layout

![ListView&#x53EF;&#x4EE5;&#x76F4;&#x63A5;&#x6DFB;&#x52A0;headerView&#x548C;footerView](https://raw.githubusercontent.com/licoba/images/master/20201225-152032-NMrxRj.jpg?token=AETOTFKS7RCGEC6RMA6LV6C74WJP6)

