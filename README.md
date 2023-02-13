# Lab 1: A Simple Evolutionary Algorithm

The main task of this lab is to implement a simple evolutionary algorithm (EA) and understand how important the control parameters are. 
This lab work is very helpful to your Assignment 1. :grinning:

## Before starting

### Programming language
Any programming language that you prefer, however, the sample code in this repository is written in Matlab.

*Useful links for Matlab users:*
* [Download Matlab](https://lib.sustech.edu.cn/gjyrj_116/list.htm)
* [Tutorial](https://ww2.mathworks.cn/support/learn-with-matlab-tutorials.html)
* [Examples](https://ww2.mathworks.cn/help/examples.html)

**We use use Matlab a lot in the future labs and assignments! Please learn to use Matlab.**

### Prepare your repository
* Each student will need to create a GitHub account and clone this repository [Lab1](https://github.com/SUSTech-EC2022). If you use other programming language, there is no need to clone the repository, you can create a new one.
* The url of the cloned repository should be sent to me via Blackboard or [github classroom](https://classroom.github.com/a/uy9DGWKq).

## Maximising a simple objective function in discrete domain
This simple objective function is implemented in this repository and it is named as *objFunc*, shown as follows:
```matlab
function [y]=objFunc(x)
y = x.^2;
end
```

**Question:** How to represent a solution for this problem?

## Implement a simple EA
**Exercise:** Implement the simple EA introduced in the illustrative example of Lecture 1.
Please refer to the slides entitled *How Does a Simple EA Work* (slides 15--22) for more details.

**Structure of this simple EA:** Highlights are given below:
* Binary representation of individuals.
* Roulette-wheel selection.
* One point crossover.
* Bit-flipping mutation.
* We consider a very simple setting: the current population will be replaced by the new population of same size.

**Question:** Considering the structure of the EA detailed above, what are the control parameters in this simple EA? Could you please list them?

**Question:** When testing your EA, what are the results that you will need to record for understand the behabior and performance of your EA?

**Question:** After answering the two questions above, do you know what are the input arguments and the output of your simple EA?

```matlab
function [output]=simpleEA( ...  % name of your simple EA function
    fitFunc, ... % name of objective/fitness function
    T, ... % total number of evaluations
    input) % replace it by your input arguments
end
```

## Test your EA!
Now please test your EA on the given objective function by varying the population size (mu = 4, 10).

## Visualise the results
Please the figures described as follows for all the parameter combinations.
* **Figure 1** *x-axis:* current generation number. *y-axis:* best-so-far fitness value.
* **Figure 2** *x-axis:* current generation number. *y-axis:* fitness value of the best individual of current population.

**Question:** What is a "generation number" and a "fitness evaluation number"?

**Question:**  Differences between best-so-far fitness value and the fitness value of the best individual of current population.
