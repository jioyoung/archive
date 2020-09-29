---
layout:     post
title:      "plot"
subtitle:   "random forester of sklearn and h2o"
date:       2020-08-12 12:00:00
author:     "yang"
header-img: "img/post-bg-2015.jpg"
catalog: true
category: blog
tags:
    - Algorithm
---

# sklearn: random forester set up and fit
## load packages
```python
# load the common packages
import pandas as pd
import numpy as np
import seaborn as sns
from sklearn.metrics import auc, roc_curve, classification_report
from sklearn.metrics import confusion_matrix
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
import matplotlib.pyplot as plt
from matplotlib import rcParams
rcParams.update({'figure.autolayout': True})
%matplotlib inline
```

# hist plot arguments
```python
hist_kws={'histtype': 'bar', 'edgecolor':'black', 'alpha': 0.2}
fig, ax = plt.subplots(nrows=1, ncols=2, figsize=(18, 6))
sns.distplot(data[data['converted'] == 0]['age'], label = 'converted 0',
           ax = ax[0], hist_kws = hist_kws)
sns.distplot(data[data['converted'] == 1]['age'], label = 'converted 1', ax = ax[0], hist_kws = hist_kws, ked=True, bins=20)
ax[0].set_title('Count Plot of Age', fontsize=16)
ax[0].legend()
ax[0].set_yscale('log')
ax[1].plot(x, y, '.-')
ax[1].set_title('title', fontsize=16)
ax[1].set_xlabel('xlabel')
ax[1].set_ylabel('ylabel')
ax[1].grid(True)
plt.tight_layout()
plt.show()
```

# set arguments
```python
fig, ax = plt.subplots(figsize=(8, 6))
ax.plot(x1, y1, label='label')
ax.plot(x2, y2, label='label')
ax.set_xlabel('xlabel', fontsize=12)
ax.set_ylabel('ylabel', fontsize=12)
ax.legend(fontsize=12)
plt.show()
```
# arguments
```python
fig, ax = plt.subplots(nrows=1, ncols=2, figsize=(18, 6))
ax[0].legend()
ax[0].set_yscale('log')
ax[1].plot(x, y, '.-')
ax[1].set_title('title', fontsize=16)
ax[1].set_xlabel('xlabel')
ax[1].set_ylabel('ylabel')
```


# t test
```python
from scipy import stats
  
#t-test of test vs control for our target metric 
test = stats.ttest_ind(data[data['test'] == 1]['label'], # test
                       data[data['test'] == 0]['label'], # control
                       equal_var=False)
```

# print format
```python
print('{0:15s} {1:>15s} {2:>15s} {3:>10s}'.format(str1, str2, str3, str4))
print('{0:15s} {1:15.5f} {2:15.5f} {3:15f}'.format(value1, val2, val3, val4))
```