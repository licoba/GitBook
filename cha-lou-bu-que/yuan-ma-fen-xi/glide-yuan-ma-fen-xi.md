---
description: Android 图片请求框架--Glide源码分析
---

# Glide源码分析

看Glide的源码是因为在网上看到过太多提到Glide的图片三级缓存相关的知识了，所以今天想好好看看Glide的源码。

### Glide使用

* Glide的Github地址：[https://github.com/bumptech/glide](https://github.com/bumptech/glide)
* 简体中文文档：[https://muyangmin.github.io/glide-docs-cn/](https://muyangmin.github.io/glide-docs-cn/)
* 用法：

```java
Glide.with(fragment)
    .load(url)
    .into(imageView);
```



