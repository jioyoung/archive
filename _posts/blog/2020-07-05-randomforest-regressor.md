---
layout:     post
title:      "random forester regressor"
subtitle:   "random forester regressor"
date:       2020-05-16 12:00:00
author:     "yang"
header-img: "img/post-bg-2015.jpg"
catalog: true
category: blog
tags:
    - sklearn
---

#### Using Skicit-learn to split data into training and testing sets
```python
from sklearn.model_selection import train_test_split
```

#### Split the data into training and testing sets
```python
train_features, test_features, train_labels, test_labels = train_test_split(features, labels, test_size = 0.25, random_state = 42)
```


#### Import the model we are using
```python
from sklearn.ensemble import RandomForestRegressor
```
#### Instantiate model with 1000 decision trees

```python
rf = RandomForestRegressor(n_estimators = 1000, random_state = 42)
```
#### Train the model on training data
```python
rf.fit(train_features, train_labels)
```


#### Use the forest's predict method on the test data
```python
predictions = rf.predict(test_features)
```
#### Calculate the absolute errors
```python
errors = abs(predictions - test_labels)
```

#### Print out the mean absolute error (mae)
```python
print('Mean Absolute Error:', round(np.mean(errors), 2), 'degrees.')
Mean Absolute Error: 3.83 degrees.
```