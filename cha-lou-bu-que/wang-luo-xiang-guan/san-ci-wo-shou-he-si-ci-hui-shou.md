# 三次握手和四次挥手

### 使用WireShark抓包来查看

* 查看网站：[https://www.zhangqinblog.com/aboutMe/](https://www.zhangqinblog.com/aboutMe/)
* 筛选条件：`ip.addr == 39.107.75.243`

![](../../.gitbook/assets/image%20%2826%29.png)

### 标志位的作用



| SYN | 表示请求建立连接 |
| :--- | :--- |
| FIN | 表示请求断开连接 |
| Seq | 表示曾经发送过数据的字节数+1，0表示**之前**没有发送过数据 |
| Len | 本次收到的数据字节大小，0表示**本次**没有收到数据 |
| ACK | 表示对对方过来的请求的确认 |
| Ack | 表示期待下次对方发送过来的**Seq指令**的值 |

【参考文章】

* \*\*\*\*[**wireshark工具使用详解以及Tcp三次握手抓包解析**](https://blog.csdn.net/Andy_93/article/details/78220656)\*\*\*\*

