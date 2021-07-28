---
description: HTTP和HTTPS的区别
---

# HTTP和HTTPS

### HTTP

HTTP：超文本传输协议（HyperText Transfer Protocol）

### HTTPS

HTTPS：**安全**的超文本传输协议（Hypertext Transfer Protocol Secure）

> HTTPS = HTTP + SSL/TLS

### SSL/TLS 协议



### HTTP 1.0、1.1、2.0 之间的区别和特性

**先说说HTTP 1.0 与 HTTP 1.1，主要是添加了一些请求头和响应头，以及新增一些状态码。**

一、HTTP 1.1相比 HTTP 1.0多了一个「**持久连接**」的功能，也就是keep-alive

* HTTP 1.0，服务器每次请求都会与服务器建立一个TCP连接，服务器响应完成之后断开TCP连接。
* HTTP 1.1，增加了一个Connection header用来说明客户端与服务器端TCP的连接方式；若connection为**close**则使用短连接，若connection为**keep-alive**则使用长连接

二、HTTP 1.1相比 HTTP 1.0多了一些状态码，例如状态码100，以决定客户端是否要继续发送请求。使用100状态码可以节约带宽，客户端可以先发一个请求去试探服务器，服务器返回100允许客户端继续发送之后，客户端再发送完整的请求。

三、添加host域：虚拟机技术使得一个IP可以对应多个主机，每一个虚拟主机对应一个host，这样请求就可以直接请求到虚拟主机

四、添加了缓存策略，来降低服务器带宽的压力。

**再说说HTTP 1.1 和 HTTP 2.0 的区别**

一、多路复用

HTTP 1.1在一个TCP连接内，虽然可以发起多个HTTP请求，但是是以FIFO的形式去执行的（串行）一个请求如果特别耗时，就会影响到后面的请求，效率也不够高；HTTP 2.0 的多个HTTP请求是以并行的方式来执行的，多个HTTP请求不会互相影响，提高了效率。

二、头部压缩

压缩了HTTP 1.1的请求头，节省带宽。

三、服务器推送

服务器会主动推送相关资源到客户端，不用客户端再发起请求。



### 为什么 HTTPS 安全？

### 对 HTTP 进行优化

### 对称加密和非对称加密



【 参考资料】

* 【知乎】[http 1.0 1.1 1.2 区别 ](https://zhuanlan.zhihu.com/p/308381209)
* 【掘金】[HTTP1.0、HTTP1.1 和 HTTP2.0 的区别](https://juejin.cn/post/6844903489596833800)
* [HTTP 和 HTTPS 的区别和常见问题](https://www.cnblogs.com/aidixie/p/11764181.html)

