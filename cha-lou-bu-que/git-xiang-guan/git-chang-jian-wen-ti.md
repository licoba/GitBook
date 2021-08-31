# Git常见问题

### 为什么 Git 的 add 和 submit 要分开？

这个问题也可以理解为 Git 为什么要设计暂存区。

暂存区也可以理解为 Git 相比于 SVN 的一个特有优势。

`git add`命令只是将文件添加到了暂存区， 可以**避免了多次琐碎的 commit 提交**。最主要的优势是可以**分阶段提交。**比如需要造一个车子，那么就可以在造好了轮子 add 一次，造好了架子 add 一次，造好了发动机 add 一次，最后当所有东西都造好之后，**一次性 commit。**如果没有 add 命令，那就会是**：**造好了轮子 commit 一次，造好了发动机 commit 一次……会造成很多琐碎的 commit。

这里最好的例子是拿购物车和订单作比较，add 就是添加商品到购物车，commit 就是提交订单。

### revert 和 reset 的区别？

* revert会生成一个新的commit，这个commit的内容与要revert的那个提交内容刚好相反。在commit1上revert一次，生成一个commit2，如果在commit2上面再revert一次，那么现在代码就等于没有做任何改动，但是多了两个commit提交。
* reset是将head指向某个commit，并且删除之前的commit，如果不需要保留这些commit的代码，就使用`--hard`参数，推送到远程仓库还需要使用 -f 强制推送。

