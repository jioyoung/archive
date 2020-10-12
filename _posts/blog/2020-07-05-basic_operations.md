---
layout:     post
title:      "Basic Operations"
subtitle:   "LR"
date:       2020-05-16 12:00:00
author:     "yang"
header-img: "img/post-bg-2015.jpg"
catalog: true
category: blog
tags:
    - 力扣
---

# qcut
## 等分cdf，q=4是quartile： 0~25pertentile, 25~50 percentile....
```python
data['newCol'] = pd.qcut(data['column'], 4, labels=False)
data['newCol'] = pd.qcut(data['column'], [0, .25, .5, .75, 1.], labels=False)
# Number of quantiles. 10 for deciles, 4 for quartiles, etc. 
# Alternately array of quantiles, e.g. [0, .25, .5, .75, 1.] for quartiles.
```

# cut 
## 等分距离， 每个interval大小相同
```python
data['newCol'] = pd.cut(data['column'], bins=4, labels=False)
```

