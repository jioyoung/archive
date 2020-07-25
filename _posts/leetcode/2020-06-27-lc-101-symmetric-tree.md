
@lc app=leetcode id=101 lang=python

[101] Symmetric Tree

https://leetcode.com/problems/symmetric-tree/description/

algorithms
Easy (44.51%)
Likes:    2716
Dislikes: 60
Total Accepted:    475.4K
Total Submissions: 1.1M
Testcase Example:  '[1,2,2,3,4,4,3]'

Given a binary tree, check whether it is a mirror of itself (ie, symmetric
around its center).

For example, this binary tree [1,2,2,3,4,4,3] is symmetric:


⁠   1
⁠  / \
⁠ 2   2
⁠/ \ / \
3  4 4  3




But the following [1,2,2,null,3,null,3] is not:


⁠   1
⁠  / \
⁠ 2   2
⁠  \   \
⁠  3    3




Note:
Bonus points if you could solve it both recursively and iteratively.



@lc code=start
Definition for a binary tree node.
class TreeNode(object):
    def __init__(self, x):
        self.val = x
        self.left = None
        self.right = None

```python
class Solution(object):
    def isSymmetric(self, root):
        """
        :type root: TreeNode
        :rtype: bool
        """
        # solution 1: recursion
        if root is None:
            return True
        return self.isSymmetricHelper(root.left, root.right)
    
    def isSymmetricHelper(self, leftTree, rightTree):
        if (leftTree is None) != (rightTree is None):
            return False
        if (leftTree is None) and (rightTree is None):
            return True
        if leftTree.val != rightTree.val:
            return False
        else:
            return self.isSymmetricHelper(leftTree.left, rightTree.right) \
                    and self.isSymmetricHelper(leftTree.right, rightTree.left)
```




```python 
class Solution(object):
    def isSymmetric(self, root):
        """
        :type root: TreeNode
        :rtype: bool
        """
        # solution 2: use stack, left tree has opposite order 
        # left tree: left root right
        # right tree: right root left
        if root is None:
            return True
        curLeft = root.left
        curRight = root.right
        stackLeft = []
        stackRight = []
        while curLeft or curRight or stackLeft or stackRight:
            while curLeft:
                stackLeft.append(curLeft)
                curLeft = curLeft.left
            while curRight:
                stackRight.append(curRight)
                curRight = curRight.right
            if len(stackLeft) != len(stackRight):
                return False
            curLeft = stackLeft.pop()
            curRight = stackRight.pop()
            if curLeft.val != curRight.val:
                return False
            curLeft = curLeft.right
            curRight = curRight.left
        return True
```