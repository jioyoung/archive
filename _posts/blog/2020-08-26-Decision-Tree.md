---
layout:     post
title:      "Decision Tree"
subtitle:   "Decision Tree"
date:       2020-08-12 12:00:00
author:     "yang"
header-img: "img/post-bg-2015.jpg"
catalog: true
category: blog
tags:
    - ML
---

# Basic Tree
## 1. ID3 
1. Select features based on the information gain 
$D$: current sample set
$K$: the number of categories of the classification
$p_k$: the ration of $k$-th sample in the sample set $D$
$A$: arribute sample
The information entropy of the current sample set is defined as $$ Ent(D) = -\sum_{k=1}^{K} p_k \log_2^k $$

The smaller $Ent(D)$ is, the purer $D$ is.

Suppose the discrete arribute $a$ has $V$ possible values $\{a^1, a^2, \ldots, a^V \}$. The conditional entropy on $a$ is defined by $$ Ent(D|a) = \sum_{v=1}^V \big(\frac{|D^v|}{|D|}Ent(D^v) \big) $$ where $D^v$ denotes the subset of $D$ that has value $a^v$ in the attribute $a$. The information gain for the arribute $a$ is defined by
$$  Gain(D, a) = Ent(D) - Ent(D|a)$$. The attribute by which the branch will be split is $$ a_* = \underset{a \in A}{\operatorname{argmax}} Gain(D, a)$$

2. The ID3 algorithm is listed as follows:
    1. Initialize the attribute and sample set
    2. Calcuate the information entropy of the sample set and the conditional entropy of all the attributes. Select the attribute that has the largest information gain asthe decision node. 
    3. Update the sample set and the attribute set on each node. 
    4. Repeat step 2 and 3 until the sample set in one node has only one kind of the output category or the sample set has same values on the arribute set. 

3. Drawbacks:
    1. no prune; overfit
    2. information gain rule prefers the attribute that has more category values
    3. can only be used for discrete attributes 
    4. does not consider the missing values

