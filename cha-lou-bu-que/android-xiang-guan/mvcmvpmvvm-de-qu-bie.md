---
description: MVC、MVP、MVVM三种架构的区别
---

# MVC、MVP、MVVM的区别

以下内容指的都是Android中的三种架构

### MVC分别指什么？

* Model：数据模型层，负责数据的更新
* View：视图层，负责展示Model的数据
* Controller：控制器层，负责处理业务逻辑

### MVC架构

* View：对应的是xml文件，负责页面显示
* Controller：Activity在Android中承载了Controller的作用，控制业务逻辑
* Model：定义的Model类，负责更新数据

在MVC架构中，Activity并不是一个标准的Controller，它既承担View的事件处理，又承担了Controller（逻辑处理）的角色，如果逻辑代码太多，就会造成Activity臃肿的情况。

另外MVC的耦合性也比较高：View可以直接使用Model的数据，Model、View、Controller之间相互依赖和耦合。

### MVP架构

* Model：负责数据的存取
* View：Activity现在是纯View，只负责显示数据
* Presenter：负责处理业务逻辑，并完全解耦Model和View

在MVP架构中，Model和View需要通过Presenter来交互，他们之间没有关联，所有操作都交给Presenter来完成，极大地减小了MVC模式中Activity的责任，使得Activity轻量化，同时也降低了View和Model之间的耦合性。

Presenter都是接口，逻辑清晰便于阅读，也便于团队协作

但是MVP有缺点，就是需要写大量的接口，Presenter处理了大部分任务，并且Presenter与View的耦合度比较高，View改变，Presenter就得新增很多接口。



