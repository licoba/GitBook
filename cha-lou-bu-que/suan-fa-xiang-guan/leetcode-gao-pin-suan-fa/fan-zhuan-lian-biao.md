---
description: 反转链表（递归和迭代两种方式）
---

# 反转链表

* \*\*\*\*[**LeetCode - 206. 反转链表**](https://leetcode-cn.com/problems/reverse-linked-list/)

> 给你单链表的头节点 `head` ，请你反转链表，并返回反转后的链表。

### 递归解法

> 中心思想是把node.next 当做是已经反转好了的链表，然后将反转后的链表指向node

```java
class Solution {
  	public ListNode reverseList(ListNode head) {
    		if(head == null || head.next == null)
            return head;
        ListNode cur = reverseList(head.next); //已经反转好了的链表的头结点
        head.next.next = head; // 将已经反转好的链表的最后一个元素，指向head
        head.next = null; // head 指向null、
        return cur; // 返回新链表的头结点
  	}
}
```

### 循环解法

```java
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode(int x) { val = x; }
 * }
 */
class Solution {
    // 注意到题目里面的尾部节点，是NULL节点
    // 所以pre首先应该申请为null
    // 这个是迭代的写法，「迭代」：重复执行某一个操作，直到满足某个条件为止
    // 迭代是用「循环」实现的，在算法里面说得比较多
	// public ListNode reverseList(ListNode head) {
    //     ListNode pre = null;
    //     ListNode cur = head;
    //     ListNode temp = null;
    //     while(cur != null){
    //         temp = cur.next;
    //         cur.next = pre;
    //         pre = cur;
    //         cur = temp;
    //     }
    //     return pre;
	// }


	public ListNode reverseList(ListNode head) {
		if(head == null || head.next == null)
            return head;
        ListNode cur = reverseList(head.next);
        head.next.next = head;
        head.next = null;
        return cur;
	}

}
```

