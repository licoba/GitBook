# TCP和UDP协议



### TCP和UDP协议

老规矩，还是先上图

![](https://pic.downk.cc/item/5f8e94811cd1bbb86bdc712b.jpg)

#### 关键词

* SYN：全称Synchronize，翻译：同步，在三次握手里面，表示的是同步序列号
* ACK：全称Acknowledgment，翻译：承认、确认，在三次握手里面，表示的是确认序列号

#### 三次握手理解

SYN是同步的缩写，是发送到另一台计算机的TCP数据包，请求在它们之间建立连接。如果第二台计算机接收到SYN，则将SYN / ACK发送回SYN请求的地址。最后，如果原始计算机收到SYN / ACK，则发送最终ACK。

【参考资料】

* [TCP 为什么三次握手而不是两次握手（正解版）](https://blog.csdn.net/lengxiao1993/article/details/82771768)
* [两张动图-彻底明白TCP的三次握手与四次挥手](https://blog.csdn.net/qzcsu/article/details/72861891)
* [https://blog.csdn.net/qq\_38950316/article/details/81087809?utm\_medium=distribute.pc\_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-2.nonecase&depth\_1-utm\_source=distribute.pc\_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-2.nonecase](https://blog.csdn.net/qq_38950316/article/details/81087809?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-2.nonecase&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-2.nonecase)

