---
title: CS6230: HPC & Parallel Algorithms
theme: white
---

<section>
# Parallel Algorithm Analysis
</section>

<!-- ====================================== -->
<section>

<section>
# parallel thinking
</section>
  
<section>
# example

<br>

<br>

### Given $A\in\mathbb{R}^n$, compute $\sum_{i=1}^n A_i$

</section>

<section>
## example: reduction 

<br>

### Given $A\in\mathbb{R}^n$, compute $\sum_{i=1}^n A_i$

```c
// option 1
double sum1(double *A, int n) {
  double sum=0.0;
  for (i=0; i<n; ++i) 
    sum += A[i];
  return sum;
}

// option 2
double sum2(double *A, int n) {
  if (n == 1) return A[0];
  for (i=0; i<n/2; ++i)
    B[i] = A[2i] + A[2i+1];
  return sum2 (B, n/2); 
}
```

</section>  

<section>
## parallel thinking 

<br>

#### given $A\in\mathbb{R}^n$, compute $\sum_{i=1}^n A_i$

* what is the expected wall-clock time on a workstation?
* assuming you have $\infty$ cores, what is the expected wall-clock time?
* what is the best you can do?
* what is the expected wall-clock time on a large cluster?

</section>  
    

<section>
## definitions

<br>

### Speedup: $S=\frac{T_{n,1}}{T_{n,p}}$

best sequential time / time on $p$ processors 

<br>

### Efficiency:  $E=S/p$

speedup / perfect speedup 



<br>

#### our goal is to estimate $E$ theoretically and to measure and evaluate it experimentally
</section>

<section>
## parallel efficiency

<br>

<div align=left>
#### factors determining efficiency of parallel algorithm

* **load balance**: distribution of work amongst processors
* **concurrency**: processors working simultaneously
* **overhead**: additional work not present in serial computation

<br>

Efﬁciency is maximized when load imbalance is minimized,
concurrency is maximized, and overhead is minimized
</div>
</section>
  
<section>
## parallel efficiency
<img style="border:1px white" width=1000 src="/images/svg/efficiency.svg"></img>

<div align=left>
(a) perfect load balance and concurrency    
(b) good initial concurrency but poor load balance    
(c) good load balance but poor concurrency    
(d) good load balance and concurrency but additional overhead    
</div>

</section>  
  
<section>
## Amdahl's law


<br>

* let $T$ be the total wall-clock time
* let $sT$ be the sequential part $(0 \le s \le 1)$
* assume $p$ processes,

\\[
T_p = sT + (1-s)\\frac{T}{p} 
\\]

* since $S = \frac{T}{T_p}$, we get Amdahl's speedup law,

\\[
S = \\frac{1}{s+ (1-s)/p} \\rightarrow \\frac{1}{s} 
\\]

</section>  
  
<section data-transition="fade">
<img style="border:1px white" width=600 src="/images/svg/taskgraph.svg"></img>
</section>  
  
<section data-transition="fade">
<img style="border:1px white" width=600 src="/images/svg/taskgraphPath.svg"></img>
</section>  

<section>
## Gustafson's law


<br>

#### sequential part should be independent of the problem size

<br>

#### increase problem size, with increasing $p$ 
</section>  

<section>
#scalability
### with increasing $p$

<br>

* **strong** (fixed-size) scalability: keep problem size fixed
* **weak** (iso-granular) scalability: keep problem size/$p$ fixed

</section>
  
</section>

<!-- ====================================== -->

<section>

<section>
# work-depth model
</section>

<section>
## DAGS

<br>

<div align=left>
**DAG**: directed acyclic graph    
a DAG with $n$ input is a computation with no branching    
an algorithm is a family of DAGS (to include branching)  


<br>

* limited, but good for simple algorithms
* input is a node that has no incoming edges
* each operation is a node
* node with no outgoing edges is an output
</div>
</section>

<section>
## DAGS

<br>

#### the depth of a DAG is the length of the longest path between an input and an output

<br>

#### this is a lower bound on $T_{n,p}$ for all values of $p$ on any parallel machine
</section>


<section>
# examples 

### reduction
</section>

<section>
## work/depth DAGS

<br>

* $D(n)$ : **depth**, longest chain of dependencies = total time
* $W(n)$ : **work**, the total number of operations used among all processors
* **parallelism**: higher is better

\\[
P(n) = \\frac{W(n)}{D(n)}
\\]

</section>

<section>
## work/depth language model

<br>

* programs are sequence of statements
* dependent statements:
  \\[ W = \\sum_i W_i , D = \\sum_i D_i \\]
* independent statements:
  \\[ W= \\sum_i W_i , D = \\max_i D_i \\]
* `parallel for`
* recursion
* allows much more complex programs than DAGs
</section>


<section>
## example: reduction 

<br>

### Given $A\in\mathbb{R}^n$, compute $\sum_{i=1}^n A_i$

```c
// option 1
double sum1(double *A, int n) {     //    W     D
  double sum=0.0;                   //    1     1
  for (i=0; i<n; ++i) sum += A[i];  //    n     n
  return sum;                       //    1     1 
}
```
\\[
W(n) = 2 + n, \\quad D(n) = 2 + n, \\quad P(n) = \\mathcal{O}(1)
\\]

```c
// option 2
double sum2(double *A, int n) {     //    W     D
  if (n == 1) return A[0];          //    1     1
  parallel for (i=0; i<n/2; ++i)    //    n     1   
    B[i] = A[2i] + A[2i+1];
  return sum2 (B, n/2); }           //  W(n/2) D(n/2)
```
\\[
W(n) = n + W(n/2), \\quad D(n) = 1 + D(n/2), \\quad P(n) = \\mathcal{O}(?)
\\]

</section>  


<!-- ====================================== -->

<section>
##Example: Laplace's equation

```c
// initialize u_i
double u_i=0.0, u_ip1, u_im1;

if (i == 0) 
  u_im1 = alpha;
else (i == n)
  u_ip1 = beta;
  
while (err < tolerance) {
  if (i>1) send(u_i, i-1);
  if (i<n) send(u_i, i+1);
  if (i<n) recv(u_ip1, i+1);
  if (i>1) recv(u_im1, i-1);
  wait(sends to complete);
  err = u_i;
    
  u_i = (u_im1 + u_ip1)/2;
    
  err = err - u_i;  err = err*err;
  err = sum2(err); // reduce_all
}
```
  
</section>
  

<!-- ====================================== -->


<section>
## dense matrix-vector multiplication

</section>  

<section>
## dense matrix-vector multiplication

\\[
A \\in \\mathbb{C}^{n\\times n}, y_i=\\sum_{j=0}^{n-1} A_{ij}x_j, \\quad i=0,\\cdots,n-1
\\]

```c
matvec(A, x, y, n) {               //     W      D
  parallel for (i=0; i<n; ++i)     //     n      1
    z[i] = 0;
    parallel for (j=0; j<n; ++j)   //     n      1
      z[j] = A[i,j] * x[j];
    y[i] = sum2 (z);               //     n     log n
}
```

<p class="fragment">
$W(n)=n^2$
</p> <p class="fragment">
$D(n)=\log n$
</p> <p class="fragment">
$P(n) = \frac{n^2}{\log n}$
</p>
</section>  

</section>


<section>
## self test questions

<br>

* consider a divide and conquer approach to `sum`  
```c
sum3(A,n) {
  if (n == 1) return A[0];
  return sum3(A,n/2) + sum3(A+n/2, n/2);
}
```
  How do the work, depth and efficiency change? Which one would you prefer, `sum2` or `sum3`?
* how many processes do we need for the dense matriv-vector multiplication?
* how would you modify the algorithm to use $p=\mathcal{O}(n)$ processes?
* how does the parallel efficiency change?  
</section>
