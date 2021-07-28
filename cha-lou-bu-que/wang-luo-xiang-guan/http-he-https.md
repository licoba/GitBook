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

【参考文章】

* [HTTP 和 HTTPS 的区别和常见问题](https://www.cnblogs.com/aidixie/p/11764181.html)

### HTTP 1.0、1.1、2.0 之间的区别和特性

**先说说HTTP 1.0 与 HTTP 1.1，主要是添加了一些请求头和响应头，以及新增一些状态码。**

一、HTTP 1.1相比 HTTP 1.0多了一个「**持久连接**」的功能，也就是keep-alive

* HTTP 1.0，服务器每次请求都会与服务器建立一个TCP连接，服务器响应完成之后断开TCP连接。
* HTTP 1.1，增加了一个Connection header用来说明客户端与服务器端TCP的连接方式；若connection为**close**则使用短连接，若connection为**keep-alive**则使用长连接

二、HTTP 1.1相比 HTTP 1.0多了一些状态码，例如状态码100，以决定客户端是否要继续发送请求。使用100状态码可以节约带宽，客户端可以先发一个请求去试探服务器，服务器返回100允许客户端继续发送之后，客户端再发送完整的请求。

三、添加host域：虚拟机技术使得一个IP可以对应多个主机，每一个虚拟主机对应一个host，这样请求就可以直接请求到虚拟主机

四、添加了缓存策略，来降低服务器带宽的压力。

### 为什么 HTTPS 安全？

### 对 HTTP 进行优化

### 对称加密和非对称加密



【 参考资料】

*  【知乎】[http 1.0 1.1 1.2 区别 ](https://zhuanlan.zhihu.com/p/308381209)

