# Java高级特性-注解机制

### 写在前面

`注解`和`反射`对于开发人员来讲既熟悉又陌生，熟悉是因为只要你是做开发，都会用到注解（常见的@Override）；陌生是因为即使不使用注解也照常能够进行开发；注解不是必须的，但了解注解有助于我们深入理解某些第三方框架（比如 Android Support Annotations、JUnit、xUtils、ButterKnife 等）。

这两个名词听起来很高级，一直不是很懂，所以第一篇文章以注解\(反射\)作为出发点，让自己也能变得高级一点~

> 本文参考《Java 编程思想》第 20 章：反射，以及部分博客进行综合分析。

#### 注解的影子

* 从`@Override`开始说起，Android 的 Hello 项目中就可以看到注解：

```text
public class MainActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Log.e("TAG","Hello 注解");
    }
}
```

在上面的代码中，在`MainActivity.java`中复写了父类`AppCompatActivity.java`的`onCreate`方法，使用到了`@Override`注解。但即使不加上这个标记，程序也能够正常运行。那这里的`@Override`注解有什么用呢？使用它有什么好处？事实上，`@Override`是告诉编译器这个方法是一个重写方法，如果父类中不存在该方法，编译器会报错，提示该方法不是父类中的方法。如果不小心拼写错误，将`onCreate`写成了`onCreat`，而且没有使用`@Override`注解，程序依然能够编译通过，但运行结果和期望的大不相同\(相当于在`MainActivity`中定义了一个名为`onCreat`的新方法\)。从示例可以看出，注解有助于保证代码的正确性。

### 正文

#### 元注解

『元注解』是用于修饰注解的注解，通常用在注解的定义上，例如：

```text
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.SOURCE)
public @interface Override {

}
```

其中的 @Target，@Retention 两个注解就是我们所谓的『元注解』

**元注解**一般用于指定某个注解生命周期以及作用目标等信息。

JAVA 中有以下几个『元注解』：

* @Target：用于指明被修饰的注解最终可以作用的目标是谁，也就是指明，你的注解到底是用来修饰方法的？修饰类的？还是用来修饰字段属性的。你可以这样理解，当一个注解被 @Target 注解时，这个注解就被限定了运用的场景。
* @Retention：注解的生命周期，分别有三个值，源码级别（source），类文件级别（class）或者运行时级别（runtime）。
* @Documented：注解是否应当被包含在 JavaDoc 文档中
* @Inherited：是否允许子类继承该注解，但是它并不是说注解本身可以继承，而是说如果一个超类被 @Inherited 注解过的注解进行注解的话，那么如果它的子类没有被任何注解应用的话，那么这个子类就继承了超类的注解。

#### 注解的作用

**格式检查：**

```text
告诉编译器信息，比如被@Override标记的方法如果不是父类的某个方法，IDE会报错；
```

**减少配置**

```text
运行时动态处理，得到注解信息，实现代替配置文件的功能；
```

**减少重复工作**

```text
比如第三方框架xUtils，通过注解@ViewInject减少对findViewById的调用，类似的还有（JUnit、ActiveAndroid等）；
```

#### 总结

经过对注解的学习（看了两个小时，一分钟不少），想想面试中会碰到的关于注解的问题应该如何回答：

**Q：注解是什么？**

A：注解是附加在代码中的一些信息，用来修饰类、方法参数、局部变量等，它提供数据用来解释程序代码。注解可以用标签来理解，给类或者方法贴上了这个标签就代表着它们有了一些特别的属性，但是撕去这个标签并不会对原有的代码并不会对原有的代码造成直接影响。

**Q：注解的作用？/注解的应用场景？/为什么要使用注解？**

* 注解可以简化代码，减少重复的工作，保证代码的正确性，例如利用注解简化大量的 findviewbyid 操作，创建 SQL 语句，代替 xml 配置文件，@UiThread 注解保证了在主线程执行 UI 更新操作。
* 能够读懂别人写的代码（尤其是框架相关的代码）
* 可以在后期编写测试单元来测试程序的正确性。

**Q：注解的优、缺点？**

A：**优点：** 不会对程序的原有功能造成影响 **缺点：** 1、注解运用了 Java 的反射技术，反射比较慢，所以在使用注解的时候应该注意时间成本。2、会生成额外的.java 文件。3、因为是在编译器进行处理，所以会对程序的编译速度产生一定影响。

**Q：注解的原理？**

这里需要引入注解处理器（APT）这个概念，注解的本质就是一个继承了`Annotation`接口的接口，其具体实现是通过 APT 来完成的，如果没有具体实现那么注解也不回答起到作用，实现的过程中用到了 Java 的动态代理和反射技术（其实原理我已经理解不了了，涉及到源码的阅读，待我修炼到更高的层级之后再来弄懂原理）

**Q：你能手撸一个注解吗？**

A：太晚了，明天再撸吧。文中又引出了两个坑：**动态代理**和**反射**，扶我起来，我还能学！@\_@

【参考博客】

* [深入浅出 Java 注解](https://www.jianshu.com/p/5cac4cb9be54)
* [秒懂，Java 注解 （Annotation）你可以这样学](https://blog.csdn.net/briblue/article/details/73824058)
* [Java 注解的基本原理](https://juejin.im/post/5b45bd715188251b3a1db54f)
* [注解的理解、注解的使用与自定义注解](https://blog.csdn.net/ajianyingxiaoqinghan/article/details/81436118)

