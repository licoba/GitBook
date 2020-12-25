# JVM 和 DVM 相关知识

## 1、JVM 和 DVM 介绍

### JVM

JVM 是 `Java Virtual Machine` 的简称，翻译成中文是 Java 虚拟机。

JVM 是用来做什么的呢？众所周知 JVM 是一个用来运行 java 应用程序的一个平台，本质上来说还是一个软件，正是 JVM 支持起了 java 跨平台的特性，所有的 java 程序都是运行在 jvm 上的，jvm 是运行在系统上的。

这里可以补充说一下 C 语言的编译运行步骤：C 语言编译之后，会直接产生汇编语言，汇编语言是可以直接在硬件上跑的

但是 Java 编译后生成的是.class 字节码文件，字节码文件没有办法想汇编语言那样，直接就在硬件上跑，class 字节码是在 jvm 上跑的，需要 jvm 把.class 字节码翻译成机器指令，机器指令运行在硬件上，这样 java 程序才能跑起来

前面说了 C 和 java 编译和运行之间的差别，总结起来也就发现 java 运行的时候会多一个步骤：

1、C 语言-&gt;汇编语言-&gt;在硬件上运行  
2、Java 语言-&gt;.class 字节码文件-&gt;jvm 翻译为机器指令-&gt;在硬件上运行

所以，JVM 的作用是：**将平台无关的.class 字节码翻译成平台相关的机器码**，来实现跨平台

JVM 基于栈来设计的，这里的栈，指的是虚拟机栈，是 JVM 内存中的一块区域

> JVM 中的内存划分

JVM 分为五个区域（主要记住两个栈和一个堆），虚拟机栈、本地方法栈、程序计数器、方法区和堆

其中前面三个是线程私有的，左边两个是线程共享的

### DVM

DVM 是`Dalvik Virtual Machine`的简称，dalvik 是一种虚拟技术，翻译过来就是 Android 虚拟机，Android 上的所有程序都是运行在 DVM 上的，每个 Android 应用进程对应着一个独立的 Dalvik 虚拟机实例并在其解释下执行。

每一个 VM 实例在 linux 中又是一个单独的进程，所以可以认为是同一个概念。运行在自己的 DVM 进程之中，不同的 app 不会相互干扰，且不会因为一个 DVM 的崩溃导致所有的 app 进程都崩溃。

DVM 不是执行.class 字节码文件，而是执行.dex 文件，.dex（Dalvik Executable），也就是 Dalvik 可执行文件，可以在 DVM 上跑的一种格式

.class 文件存在很多的冗余信息，DVM 里面有一块区域（dex 工具）专门负责.class 文件的冗余东西，并将所有.class 文件打包成 dex 文件，用与在 DVM 上执行 对比起 java 的执行步骤： 1、Java 语言-&gt;.class 字节码文件-&gt;jvm 翻译为机器指令-&gt;在硬件上运行  
2、Java 语言-&gt;.class 字节码文件-&gt;将 class 文件打包.dex 文件-&gt;DVM 执行 dex 文件

## 总结 Q&A

**1、什么是 JVM？**

Java Virtual Machine，Java 虚拟机，是一个运行在系统层上的虚拟计算机，负责翻译 Java 编译好的.class 字节码文件，Java 程序都是运行在 JVM 上的

**2、JVM 的作用？**

jvm 把.class 字节码翻译成机器指令，硬件可以识别机器指令，这样 java 程序才能跑起来；正是有了 JVM，才有了 java 的跨平台特性。

**3、JVM 的类加载过程？**

**4、什么是 DVM？**

DVM 是`Dalvik Virtual Machine`的简称，dalvik 是一种虚拟技术，翻译过来就是 Android 虚拟机，Android 上的所有程序都是运行在 DVM 上的，DVM 运行的是.dex 文件

**5、DVM 有什么作用？**

DVM 执行.class 文件打包而成的.dex 文件

**6、DVM 的类加载？**

**7、JVM 和 DVM 的区别？**

* JVM 是基于栈的虚拟机\(Stack-based\)，DVM 是基于寄存器架构，寄存器是一块内存中的独立区域，这样 DVM 的速度就会领先于 JVM，更适合移动设备
* JVM 机运行 java 字节码\(.class 文件\)，DVM 运行的是其专有的文件格式.Dex 文件

**8、为什么 JVM 设计基于栈架构，DVM 基于寄存器架构？**

> 为什么 JVM 设计基于栈架构

a.基于栈架构的指令集更容易生成  
b.可移植性。考虑到 JVM 使用的场合大多是 pc 和服务器，栈架构可以自由分配实际的寄存器，这样的可移植性比较高，也符合 java 的设计理念\(一次编写，处处运行\)。

> DVM 为什么基于寄存器：

**a.移动端的处理器绝大部分都是基于寄存器架构的。**  
b.栈架构中有更多的指令分派和访问内存，这些比较耗时，相对来认为 dvm 的执行效率更高一些。  
c.DVM 就是为 android 运行而设计的，无需考虑其他平台的通用。

【参考文章】

* [JVM、DVM（dalvik）和 ART 之间的区别](https://www.jianshu.com/p/5601678b7a2e)

