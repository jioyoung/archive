---
layout:     post
title:      "leetcode-003-longest-substring-without-repeating-chars"
subtitle:   "算法"
date:       2020-07-25 12:00:00
author:     "yang"
header-img: "img/post-bg-2015.jpg"
catalog: true
category: leetcode
tags:
    - leetcode
    - 力扣
---


```python
#
# @lc app=leetcode id=3 lang=python
#
# [3] Longest Substring Without Repeating Characters
#
# https://leetcode.com/problems/longest-substring-without-repeating-characters/description/
#
# algorithms
# Medium (28.66%)
# Likes:    5982
# Dislikes: 343
# Total Accepted:    1M
# Total Submissions: 3.6M
# Testcase Example:  '"abcabcbb"'
#
# Given a string, find the length of the longest substring without repeating
# characters.
# 
# 
# Example 1:
# 
# 
# Input: "abcabcbb"
# Output: 3 
# Explanation: The answer is "abc", with the length of 3. 
# 
# 
# 
# Example 2:
# 
# 
# Input: "bbbbb"
# Output: 1
# Explanation: The answer is "b", with the length of 1.
# 
# 
# 
# Example 3:
# 
# 
# Input: "pwwkew"
# Output: 3
# Explanation: The answer is "wke", with the length of 3. 
# ⁠            Note that the answer must be a substring, "pwke" is a
# subsequence and not a substring.
# 
```

# Algorithm:
1. use a dictionary to record each character and its index
2. use a variable start to record the starting index of the current substring that has no repeated chars

```python
class Solution(object):
    def lengthOfLongestSubstring(self, s):
        """
        :type s: str
        :rtype: int
        """
        start, maxLen = 0, 0
        usedChar = {}
        c = ''
        for i in range(len(s)):
            c = s[i]
            if c in usedChar and usedChar[c]>=start:
                start = usedChar[c]+1
                # no need to recalculate the max lenght since this operation will not affect 
                # the maximum length
            else:
                maxLen = max(maxLen, i-start+1)
            # update the dictionary
            usedChar[c] = i
        return maxLen
```

