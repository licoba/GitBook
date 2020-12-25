# Handler 和 Looper 相关知识

## Handler 的工作原理

Handler 提供了一种机制，这种机制可以让我们在子线程中处理耗时的任务，在主线程中来更新 UI

Handler 工作流程包括 Handler、Looper、Message、MessageQueue 四个部分

1. Message：Message 是在线程之间传递的消息，它可以在内部携带少量的数据，用于线程之间交换数据
2. Handler：它主要用于发送和处理消息的发送消息一般使用 sendMessage\(\)方法
3. MessageQueue：消息队列，它主要用于存放所有通过 Handler 发送的消息，这部分的消息会一直存在于消息队列中，等待被处理
4. Looper：每个线程通过 Handler 发送的消息都保存在 MessageQueue 中，每当 Looper 发现 Message Queue 中存在一条消息，就会调用 looper\(\)方法将它取出，并传递到 Handler 的 handleMessage\(\)方法中。

## 一个线程可以有多少个 handler，多少个 looper？

* 一个线程只能有一个 looper 与之绑定，looper 持有 messagequeue，所以也只能有一个 messagequeue
* 一个线程可以创建多个 handler

## 怎么在子线程创建 handler？

可以在子线程创建 handler 的。

1. 首先需要在子线程里先调用 Looper.prepare\(\)
2. new 一个 Handler
3. 在最后调用 Looper.loop\(\)方法

另外，在主线程可以直接使用 Handler 是因为 ActivityThread 帮我们自动初始化了 looper，并在最后调用了 Looper.loop 方法

## 既然一个 looper 可以对应多个 handler，那么 looper 是怎么进行区分不同的 handler 的？

handler 在 sendmessage 的时候，会指定 message31 的 target，也就是将当前的 handler 赋值给 message 对象，这样在 handlermessage 的时候，就可以根据不同的 target 来区分不同的 handler。+

