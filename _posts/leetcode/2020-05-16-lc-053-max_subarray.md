---
layout:     post
title:      "算法题之leetcode-53-maximum-subarray"
subtitle:   "算法"
date:       2020-05-16 12:00:00
author:     "Yang"
header-img: "img/post-bg-2015.jpg"
catalog: leetcode
tags:
    - 力扣
---

@lc app=leetcode id=53 lang=python

[53] Maximum Subarray

https://leetcode.com/problems/maximum-subarray/description/

algorithms
Easy (44.15%)
Likes:    4735
Dislikes: 176
Total Accepted:    584.4K
Total Submissions: 1.3M
Testcase Example:  '[-2,1,-3,4,-1,2,1,-5,4]'

Given an integer array nums, find the contiguous subarray (containing at
least one number) which has the largest sum and return its sum.

Example:


Input: [-2,1,-3,4,-1,2,1,-5,4],
Output: 6
Explanation: [4,-1,2,1] has the largest sum = 6.


Follow up:

If you have figured out the O(n) solution, try coding another solution using
the divide and conquer approach, which is more subtle.

思路：两个变量，一个存总体的max subarray，一个存当下的。如果当下的max subarray小于0， 那么当下的max的和就等于当前的element;反之，当下的max subarray的和要加上当前的element。 遍历一次即可


```python
class Solution(object):
    def maxSubArray(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """

        cur_max = all_max = nums[0]
        for i in range(1,len(nums)):
            if cur_max < 0:
                cur_max = nums[i]
            else:
                cur_max += nums[i]
            all_max = max(cur_max, all_max)
        return all_max
```
