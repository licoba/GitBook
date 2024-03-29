---
description: 5个阶段：加载、验证、准备、解析、初始化
---

# JVM的类加载过程

> 按照惯例，先上图，下面是 JVM 的类加载过程：

![&#x7C7B;&#x52A0;&#x8F7D;&#x7684;&#x8FC7;&#x7A0B;](https://pic4.zhimg.com/80/v2-ecf6c3d0f5146029e9693d6223d23afb_720w.jpg)

![&#x7C7B;&#x52A0;&#x8F7D;&#x8111;&#x56FE;](../../../.gitbook/assets/image%20%282%29.png)

## 前言

一个 Java 文件从编码完成到最终执行，主要包括两个过程：`编译`和`运行`

* 编译：java 文件到 class 文件。把我们写好的 java 文件，通过 javac 命令编译成字节码，也就是我们常说的.class 文件。
* 运行：把编译生成的.class 文件交给 Java 虚拟机\(JVM\)执行。

而我们所说的类加载过程即是指 **JVM 虚拟机把.class 文件中类信息加载进内存，并进行解析生成对应的 class 对象的过程。**

## 类加载的过程

类加载的过程可以分为三个阶段：

* 加载
* 链接（包括验证、准备、解析）
* 初始化

### 一、加载

> 简单来说，加载指的是把 class 字节码文件从各个来源通过类加载器装载入内存中。

加载主要是将.class 文件中的二进制字节流加载到 JVM 中。 在加载阶段，JVM 需要完成 3 件事：  
1）通过类的全限定名获取该类的二进制字节流；  
2）将字节流所代表的静态存储结构转化为方法区的运行时数据结构；  
3）在内存中生成一个该类的 java.lang.Class 对象，作为方法区这个类的各种数据的访问入口。

* 字节码来源：字节码可以来源于本地编译好的 class 文件、jar 包中的 class 文件、

  以及远程的 class 文件等

* 类加载器：也就是 ClassLoader，包括:`启动类加载器`，`扩展类加载器`，`应用类加载器`，以及用户的`自定义类加载器`。

### 二、链接

链接分为三个阶段：包括验证、准备、解析

#### **1. 验证**

> 验证，主要验证字节流是否符合 Class 文件格式的规范，确保能被JVM执行。

验证阶段会完成以下 4 个阶段的检验动作：  
1）文件格式验证（检查文件的格式是否符合规范）  
2）元数据验证\(是否符合 Java 语言规范\)  
3）字节码验证（确定程序语义合法，符合逻辑）  
4）符号引用验证（确保下一步的解析能正常执行）

#### **2. 准备**

> 准备，主要为静态变量在方法区分配内存，并设置默认初始值。

（特别需要注意，初值，不是代码中具体写的初始化的值，而是 Java 虚拟机根据不同变量类型的默认初始值）

* 8 种基本类型的初值，默认为 0；
* 引用类型的初值则为 null；
* 常量的初值即为代码中设置的值，final static tmp = 456， 那么该阶段 tmp 的初值就是 456

#### **3. 解析**

> 解析，是虚拟机将常量池内的符号引用替换为直接引用的过程。

**符号引用：** 类名，方法名，字段名这些就是符号引用。  
**直接引用：** 可以理解为一个内存地址，或者一个偏移量。比如类方法，类变量的直接引用是指向方法区的指针；而实例方法，实例变量的直接引用则是从实例的头指针开始算起到这个实例变量位置的偏移量 举个例子来说，现在调用方法 hello\(\)，这个方法的地址是 1234，那么 hello 就是符号引用，1234 就是直接引用。

1）类或接口的解析  
2）字段解析  
3）方法解析  
4）接口方法解析

### 三、初始化

> 初始化，主要是对类变量初始化，执行类构造器的过程。

这个阶段主要是对 static 变量和 static 代码块进行初始化。

初始化的顺序：

* 如果初始化一个类的时候，其父类尚未初始化，则优先初始化其父类。
* 如果同时包含多个静态变量和静态代码块，则按照自上而下的顺序依次执行。

## 补充

### 双亲委派机制

双亲委派机制：如果一个类加载器在接到加载类的请求时，它首先不会自己尝试去加载这个类，而是把这个请求任务委托给父类加载器去完成，依次递归，如果父类加载器可以完成类加载任务，就成功返回；只有父类加载器无法完成此加载任务时，才自己去加载。

优点：**保持了类的唯一性**，无论哪一个类加载器要加载这个类，最终都是委派给处于模型最顶端的启动类加载器进行加载，因此 Object 在各种类加载环境中都是同一个类。

## Q&A？

### Q: 什么是类加载？

把 class 字节码文件通过类加载器 ClassLoader 装载到 JVM 中，这个过程叫做类加载。

### Q: 什么时候进行类初始化？

1. new 对象的时候
2. 调用类的static方法的时候
3. 对类进行反射调用的时候
4. 初始化父类
5. 包含main方法的那个类
6. default接口的子类被初始化



【参考文章】

* [面试官：请你谈谈 Java 的类加载过程](https://zhuanlan.zhihu.com/p/33509426)
* [一道面试题搞懂 JVM 类加载机制](https://blog.csdn.net/noaman_wgs/article/details/74489549)
* [JVM 类加载机制深入浅出](https://www.jianshu.com/p/3cab74a189de)

