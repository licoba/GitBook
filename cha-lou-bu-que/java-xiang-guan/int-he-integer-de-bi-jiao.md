# int和Integer的比较

## 区别比较

| 维度 | int | Integer |
| :--- | :--- | :--- |
| 类型 | int 是基本数据类型 | Integer 是 int 的包装类型 |
| 存储位置 | 方法内的 int 存储在栈中，方法执行完毕之后，栈帧销毁，int 也被销毁；class 内的 int，存储在堆中，生命周期和对象绑定 | Integer 对象的引用存放在栈里，对象的实例存储在堆中。 |
| 使用方式 | 不需要初始化，就可以使用，默认值为 0 | 是一个类，所以需要创建对象后再使用，默认值为 null |

## int 和 Integer 的值比较

```text
// 比较int 和integer是否相等

public class TestIntAndInteger {

    // 基于JDK 1.8
    public static void main(String[] args) {
        int i = 0;
        Integer integer = 0;
        System.out.println("相同值的 int 和 Integer 比较==：" + (i == integer));
        // int 和 Integer比较，integer会自动拆箱

        Integer integer1 = 100;// 等同于 Integer integer1 = Integer.valueOf(100);
        Integer integer2 = 100;// 等同于 Integer integer1 = Integer.valueOf(100);
        System.out.println("相同值(-128到127内)的Integer比较==：" + (integer1 == integer2));// true

        Integer integer3 = 200;// 等同于 Integer integer1 = Integer.valueOf(200);
        Integer integer4 = 200;// 等同于 Integer integer1 = Integer.valueOf(200);
        System.out.println("相同值(不在-128~127范围内)的Integer比较==：" + (integer3 == integer4));// true
        System.out.println("相同值的Integer比较equals：" + (integer3.equals(integer4)));// true

        //上面两个比较需要注意：== 比较的是地址，也就是，比较==左右两边，是否为同一个对象，而在 -128~127范围内，
        // Integer的valueOf函数会将对象进行缓存，所以对象就是是同一个对象
        // integer3 == integer4  <==> Integer.valueOf(200) == Integer.valueOf(200) 两句是等价的

        System.out.println("相同值的Integer.valueOf比较100==：" + (Integer.valueOf(100) == Integer.valueOf(100)));// true
        System.out.println("相同值的Integer.valueOf比较200==：" + (Integer.valueOf(200) == Integer.valueOf(200)));// false

    }
}
```

## 装箱和拆箱

**概念**

* 装箱是指将基本类型 转化成 包装器类型，对应的方法，就是 `Integer.valueOf(int v)`方法
* 拆箱是指将包装器类型 转化成 基本数据类型，对应的方法，就是 `Integer.intValue()`方法

### 什么时候触发自动装箱和拆箱？

#### 一、自动装箱

将基本数据类型 赋值给 包装类型的时候，会触发自动装箱，例如：

```text
Integer integer = 110;
```

