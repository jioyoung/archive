---
layout:     post
title:      "random forester of sklearn and h2o"
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

```python

# use get_dummies to convert categories into columns one hot encode
data_dummy = pd.get_dummies(data, drop_first=True)

#split into train and test to avoid overfitting
np.random.seed(4684)
train, test = train_test_split(data_dummy, test_size = 0.34)
# test size is a fraction of the test sample

# set random forester classifier
# build the model
rf = RandomForestClassifier(n_estimators=100, max_features=3, oob_score=True)
rf.fit(train.drop('label column', axis=1), train['label column'])
```

# random forester output
## out of bag: confusion matrix, accuracy
### rf.oob_decision_function_ (an array that has shape nsample * nlabel_category)
```python
# out of bag accuracy
# if 0 and 1 label, rf.oob_decision_function_[:,1].round() can be used to have a 0.5 threshold
print(
"OOB accuracy is", 
rf.oob_score_, "\n", 
"OOB Confusion Matrix", "\n",
pd.DataFrame(confusion_matrix(train['label column'], rf.oob_decision_function_[:,1].round(), labels=[0, 1]))
)
```

## test: confusion matrix, accuracy
```python
print(
"Test accuracy is", rf.score(test.drop('label col', axis=1),test['label col']), "\n", 
"Test Set Confusion Matrix", "\n",
pd.DataFrame(confusion_matrix(test['label col'], rf.predict(test.drop('label col', axis=1)), labels=[0, 1]))
)
```

## feature importance plot
```python
feat_importances = pd.Series(rf.feature_importances_, index=train.drop('label col', axis=1).columns)
feat_importances.sort_values().plot(kind='barh')
plt.show()
```

## partial dependence plot
### category feature: cat0, cat1, cat2....
### cat0 is dropped already if drop_first = true
```python
from pdpbox import pdp, info_plots
# category feature: cat0, cat1, cat2....
# cat0 is dropped already if drop_first = true
pdp_iso = pdp.pdp_isolate(model=rf, 
                          dataset=train.drop(['label col'], axis=1),      
                          model_features=list(train.drop(['label col'], axis=1)), 
                          feature=['cat1', 'cat2', 'cat3'....], 
                          num_grid_points=50)
pdp_dataset = pd.Series(pdp_iso.pdp, index=pdp_iso.display_columns)
pdp_dataset.sort_values(ascending=False).plot(kind='bar', title='category feature xxx')
plt.show()
```


### continutous feature
```python
pdp_iso = pdp.pdp_isolate( model=rf, 
                          dataset=train.drop(['label col and unnecessary cols'], axis=1),      
                          model_features=list(train.drop(['label col and unnecessary cols'], axis=1)), 
                          feature='continuous feature', 
                          num_grid_points=50)
pdp_dataset = pandas.Series(pdp_iso.pdp, index=pdp_iso.feature_grids)
pdp_dataset.plot(title='continuous feature')
plt.show()
```

## build a simple decision tree and check the 2 or 3 most important segments
```python
import graphviz
from sklearn.tree import DecisionTreeClassifier
from sklearn.tree import export_graphviz
from graphviz import Source
  
tree = DecisionTreeClassifier( max_depth=2,class_weight={0:1, 1:10}, min_impurity_decrease = 0.001)
tree.fit(train.drop(['label col and unnecessary cols'], axis=1), train['label col'])
  
#visualize it
export_graphviz(tree, out_file="tree_conversion.dot", feature_names=train.drop(['label col and unnecessary cols'], axis=1).columns, proportion=True, rotate=True)
with open("tree_conversion.dot") as f:
    dot_graph = f.read()
  
s = Source.from_file("tree_conversion.dot")
s.view()
```

# h2o: random forester set up and fit

## packages
```python

from sklearn.metrics import auc, roc_curve, classification_report

import h2o
from h2o.frame import H2OFrame
from h2o.estimators.random_forest import H2ORandomForestEstimator
from h2o.grid.grid_search import H2OGridSearch

%matplotlib inline

```

## Initialize H2O cluster
```python
h2o.init()
h2o.remove_all()
```


## Transform to H2O Frame, and make sure the target variable is categorical
```python
h2o_df = H2OFrame(data)

h2o_df['col1'] = h2o_df['col1'].asfactor()
...
h2o_df['label col'] = h2o_df['label col'].asfactor()

h2o_df.summary()
```

## Split into training and test dataset
```python
strat_split = h2o_df['label'].stratified_split(test_frac=value btw 0 and 1, seed=42)

train = h2o_df[strat_split == 'train']
test = h2o_df[strat_split == 'test']

feature = ['col1', 'col2', 'col3'.....]
target = 'label col'
```

## Build random forest model
```python
model = H2ORandomForestEstimator(balance_classes=True, ntrees=100, max_depth=20, 
                                 mtries=-1, seed=42, score_each_iteration=True)
model.train(x=feature, y=target, training_frame=train)
```

## feature importance
```python
# Feature importance
importance = model.varimp(use_pandas=True)

fig, ax = plt.subplots(figsize=(10, 8))
sns.barplot(x='scaled_importance', y='variable', data=importance)
plt.show()
```

or 

```python
model.varimp_plot()
```

## make predictions
```python
# Make predictions
train_true = train.as_data_frame()['label'].values
test_true = test.as_data_frame()['label'].values
# 'p0', 'p1', ... 'pn' if multiple categories of label col
train_pred = model.predict(train).as_data_frame()['p1'].values
test_pred = model.predict(test).as_data_frame()['p1'].values

train_fpr, train_tpr, _ = roc_curve(train_true, train_pred)
test_fpr, test_tpr, _ = roc_curve(test_true, test_pred)
train_auc = np.round(auc(train_fpr, train_tpr), 3)
test_auc = np.round(auc(test_fpr, test_tpr), 3)
```

## Classification report, set the threshold here
```python
print(classification_report(y_true=test_true, y_pred=(test_pred > 0.5).astype(int)))
```

## ROC AUC
```python
fig, ax = plt.subplots(figsize=(8, 6))
ax.plot(train_fpr, train_tpr, label='Train AUC: ' + str(train_auc))
ax.plot(test_fpr, test_tpr, label='Test AUC: ' + str(test_auc))
ax.set_xlabel('False Positive Rate', fontsize=12)
ax.set_ylabel('True Positive Rate', fontsize=12)
ax.legend(fontsize=12)
plt.show()
```

## partial dependance plot
```python
_ = model.partial_plot(train, cols=feature, figsize=(8, 15))
```



## shot down h2o
# Shutdown h2o instance
```python
h2o.cluster().shutdown()
```