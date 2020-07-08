# Logistic Regression
> Logistic regression is named for the function used at the core of the method, the logistic function. It's an S-shaped curve that can take any real-valued number and map it into a value between 0 and 1, but never exactly at those limits. 

The logistic function is defined by $$y=\frac{1}{1+\exp(-z)} = \frac{\exp(z)}{1+\exp(z)}$$ 
It is a common example of a sigmoid function (S shape function).

## Properties of the Logistic Function
Define $\sigma(z)=\frac{1}{1+\exp(-z)}$. We have the following properties: 
1. $\sigma(z)+\sigma(-z) = 1$
2. $\sigma(z) = \exp(z)\sigma(-z)$
3. $\frac{d \sigma(z)}{d z} = \sigma(z)(1-\sigma(z))=\sigma(z)\sigma(-z)$, $\frac{d \sigma(z)}{d z} = \frac{d \sigma(-z)}{d z}$
4. $\int\sigma(z)dz = \int \frac{\exp(z)}{1+\exp(z)}dz=\ln(1+\exp(z))+C$
## Binary Classification
There are two outputs for the binary classification problem: 0 and 1. Define $\mathbf{\beta} \equiv (\mathbf{w};b)$ and $\widehat{\mathbf{x}} \equiv (\mathbf{x};1)$. We have $\mathbf{w}^T\mathbf{x}+b = \beta^T \widehat{\mathbf{x}}$  The logistic model for the binary classification can be stated as 
$$ \ln \frac{p(y=1|\mathbf{x})}{p(y=0|\mathbf{x})} = \mathbf{w}^T\mathbf{x}+b = \beta^T \widehat{\mathbf{x}}. $$
where $ \frac{p(y=1|\mathbf{x})}{p(y=0|\mathbf{x})} $ is the odds of the default class. Odds, which often appear in the gambling game, are calculated as a ratio of the probability of the event divided by the probability of not the event. $ \ln \frac{p(y=1|\mathbf{x})}{p(y=0|\mathbf{x})} $ is referred as log odds or logit.

Since the sum of $p(y=1\vert\mathbf{x})$ and $p(y=0\vert\mathbf{x})$ is 1, then we have 
$$ p(y=1\vert\mathbf{x}) = \frac{\exp(\mathbf{w}^T\mathbf{x}+b)}{1+\exp(\mathbf{w}^T\mathbf{x}+b)} = \frac{\exp(  \beta^T \widehat{\mathbf{x}}  )}{1+\exp(\beta^T \widehat{\mathbf{x}})}, $$ 

$$ p(y=0\vert\mathbf{x}) = \frac{1}{1+\exp(\mathbf{w}^T\mathbf{x}+b)}  = \frac{1}{1+\exp( \beta^T \widehat{\mathbf{x}} )}.$$

### Learning the Logistic Model
The coefficients of the logistic regression algorithm must be estimated from your training data. This is done using maximum-likelihood estimation. 

#### Is it possible to use ordinary least-square regression to learn the logistic model?
I think it is possible but it might fail at most cases due to the non-convexity of the cost function which is defined as
 $$  E_{(\beta)} = \sum_{i=1}^n \big(y_i - \frac{1}{1+\exp(- \beta^T \widehat{\mathbf{x}}_i )} \big)^2.$$

___Proposition___: $E_{(\beta)}$ is not a convex function of $\beta$.
Proof: the loss for squared residual is 
$$ e(y,\widehat{\mathbf{x}};\beta) = (y - \frac{1}{1+\exp(- \beta^T \widehat{\mathbf{x}} )})^2. $$ We can show the sigmoid function $\sigma(\beta^T\widehat{\mathbf{x}}) = \frac{1}{1+\exp(- \beta^T \widehat{\mathbf{x}} )}$ is not convex. Firstly, the first derivative of $\sigma(\beta^T\widehat{\mathbf{x}})$ is $$\frac{\partial \sigma}{\partial \beta} = \sigma(\beta^T\widehat{\mathbf{x}})\sigma(-\beta^T\widehat{\mathbf{x}})\widehat{\mathbf{x}}^T.$$ Therefore, the second derivative of $\sigma(\beta^T\widehat{\mathbf{x}})$ is 
$$\begin{aligned} \frac{\partial ^2  \sigma}{\partial \beta \partial \beta^T} & = \sigma(\beta^T\widehat{\mathbf{x}})\sigma(-\beta^T\widehat{\mathbf{x}})\widehat{\mathbf{x}}\sigma(-\beta^T\widehat{\mathbf{x}})\widehat{\mathbf{x}}^T - \sigma(\beta^T\widehat{\mathbf{x}}) \sigma(\beta^T\widehat{\mathbf{x}})\sigma(-\beta^T\widehat{\mathbf{x}})\widehat{\mathbf{x}}\widehat{\mathbf{x}}^T \\
& = (\sigma(-\beta^T\widehat{\mathbf{x}})-\sigma(\beta^T\widehat{\mathbf{x}})) \sigma(\beta^T\widehat{\mathbf{x}})\sigma(-\beta^T\widehat{\mathbf{x}})\widehat{\mathbf{x}}\widehat{\mathbf{x}}^T \end{aligned}$$

where $\widehat{\mathbf{x}}\widehat{\mathbf{x}}^T$ is always positive semidefinite (positive definite if $\widehat{\mathbf{x}}$ is not a zero vector). 

When $\beta^T\widehat{\mathbf{x}} > 0$, $\sigma(-\beta^T\widehat{\mathbf{x}})-\sigma(\beta^T\widehat{\mathbf{x}})<0$, $\frac{\partial ^2  \sigma}{\partial \beta \partial \beta^T}$ is negative semidefinite;
When $\beta^T\widehat{\mathbf{x}} < 0$, $\sigma(-\beta^T\widehat{\mathbf{x}})-\sigma(\beta^T\widehat{\mathbf{x}})>0$, $\frac{\partial ^2  \sigma}{\partial \beta \partial \beta^T}$ is positive semidefinite;

Thus, the sigmoid function can be convex or concave; that is, the gradient descent or analytical solution may be a local optimum rather than a global one.

#### How about the Maximum Likelihood Method?
The negative log-likelihood for the dataset is 
$$ \sum_{i=1}^n -\ln \big(  p(y_i=1\vert\mathbf{x}_i)^{y_i} p(y_i=0\vert\mathbf{x}_i)^{1-y_i} \big) $$

For each component, the loss of likelihood is 
$$ \begin{aligned} l (y, \widehat{\mathbf{x}};\beta) & = -y \ln p(y=1\vert\mathbf{x}_i) + (y-1)\ln(y=0\vert\mathbf{x}_i) \\
& = -y \ln(\exp(\beta^T \widehat{\mathbf{x}}) \sigma( -\beta^T \widehat{\mathbf{x}}  )) + (y-1)\ln(\sigma( -\beta^T \widehat{\mathbf{x}})) \\
& = -y \beta^T \widehat{\mathbf{x}}-y\ln (\sigma( -\beta^T \widehat{\mathbf{x}}  )) + (y-1)\ln(\sigma( -\beta^T \widehat{\mathbf{x}}))\\
& = -y \beta^T \widehat{\mathbf{x}}-\ln(\sigma( -\beta^T \widehat{\mathbf{x}})) \\
& =  -y \beta^T \widehat{\mathbf{x}} + \ln(1+\exp(\beta^T\widehat{\mathbf{x}}))
\end{aligned}$$

We have $\frac{\partial l}{\partial \beta} = -y \widehat{\mathbf{x}}^T+ \sigma(\beta^T \widehat{\mathbf{x}} )\widehat{\mathbf{x}}^T  $ and  $\frac{\partial^2 l}{\partial \beta \partial \beta^T} = \sigma(\beta^T\widehat{\mathbf{x}})\sigma(-\beta^T\widehat{\mathbf{x}})\widehat{\mathbf{x}}\widehat{\mathbf{x}}^T$ which is positive semidefinite (positive definite when $\widehat{\mathbf{x}} $ is not a zero vector). Thus, $l$ is a convex function of $\beta$.


<!--
```python {cmd=true matplotlib=true}
import matplotlib.pyplot as plt
plt.plot([1,2,3,4])
plt.show() # show figure
```
```python {cmd=true}
print("asdfasdf")
```
```math
c^2 + a^2
```
-->

