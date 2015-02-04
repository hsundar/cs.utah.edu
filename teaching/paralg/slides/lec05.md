---
title:  CS6230: Parallel Algorithms & HPC
theme: white
---

<section>
# Scan, Search, Ranking
</section>

<!-- ====================================== -->
<section>

<section>
# scan
</section>

<section>
## scan, prefix sum

<br>

* Given an array, $[4, 2, 1, 8]$
* Compute, $[4, 4+2, 4+2+1, 4+2+1+8]$
* $[4, 6, 7, 15]$

<br>

#### obvious sequential algorithm

\\[
D_s(n) = \mathcal{O}(n)
\\]

<br>

#### not parallelizable, need to change algorithm 

</section>

<section>
## scan

<br>

* a good example of a computation that seems inherently sequential, but for which there is an efficient parallel algorithm
* prefix-sums can be used to convert certain sequential computations into equivalent, but **parallel**, computations

</section>

<section>
## scan

<br>

<div align=left>
#### Given a binary associative operator $\bigoplus$ with identity $I$, and an array of $n$ elements, $[a_0,a_1,\cdots,a_{n-1}]$, compute:

\\[
\\left [ I, a_0, (a_0\\oplus a_1),\\cdots,(a_0\\oplus a_1 \\oplus \\cdots \\oplus a_{n-2}) \\right ]
\\]

<br>

#### the exclusive scan or the inclusive scan,

\\[
\\left [ a_0, (a_0\\oplus a_1),\\cdots,(a_0\\oplus a_1 \\oplus \\cdots \\oplus a_{n-1}) \\right ]
\\]
</div>
</section>

<section>
## sequential scan

<br>

```c
// exclusive 
out[0] = 0;  
for (k=1; k<n; ++k)  
  out[k] = in[k-1] + out[k-1]; 
```

<br>

\\[
T_1(n) = \\mathcal{O}(n)
\\]

</section>

<section>
## parallel scan

<br>

* binary tree (like sum)
* two tree traversals
    * *up-sweep* bottom-up --- reduce phase
    * *down-sweep* top-down
* Work/Depth
    * $W(n) = \mathcal{O}(n)$
    * $D(n)=\mathcal{O}(\log n)$
* recursive & iterative implementations  
</section>

<section>
## scan up-sweep

<br>

<img style="border:1px white" width=1000 src="/images/svg/scan_upsweep.svg"></img>
</section>

<section>
## scan down-sweep

<br>

<img style="border:1px white" width=1000 src="/images/svg/scan_downsweep.svg"></img>
</section>

<section>
## simple use case

<br>

### parallel select

</section>

<section>
## parallel select

<br>

* consider a shared memory machine (PRAM)
* given an array $A$, we wish to select all entries of $A$ satisfying some condition
* say, we are implementing quicksort and would like to compute,
* all values less than a given pivot.
</section>

<section>
## parallel select for a[i] < pv

<br>

```c
(l,m) = select_lower(a, n, pv) {
  // t = t[0,...,n-1]
  parallel for (i=0; i<n; ++i)
    t[i] = a[i] < pv;
  s = scan(t);
  m = s(n-1);
  // allocate l
  parallel for (i=0; i<n; ++i)
    if (t[i])
      l[s[i]-1] = a[i];
}
```

$$W=\mathcal{O}(n), D=W=\mathcal{O}(\log n)$$

</section>

<section>
### parallel thinking

think about whether parallel `scan` can be used for any of the problems in [assignment 1](/teaching/paralg/assignment1.html) 
</section>


</section>
<!-- ====================================== -->

<section>

<section>
# search
</section>

<section>
## parallel search

<br>

<div align=left>
#### problem description

* given a sorted list $X$ of size $n$ and an element $y$
* find the index $i$, such that $x_i \leq y < x_{i+1}$


#### sequential 

* use binary search
* $\mathcal{O}(\log n)$ time


#### work / depth

```c
parallel for (i) 
  if (x[i] <= y < x[i+1]) return i; // no duplicates
```


#### PRAM

* $\mathcal{O}(\log n/ \log p)$ using $p$ processors

</div>
</section>

<section>
## parallel search

<br>

* split $X$ into $(p+1)$ segments
* compare $y$ with the $p$ splitters (boundary elements)
* we will find, $i$ such that,
    1. $X_i = y$, or
    2. $X_{ni/(p+1)} < y < X_{n(i+1)/(p+1)}$ --- bucket
* if case 1, **stop**
* if case 2, and size of bucket is $\sim p$
    * do $p$ comparisons in parallel
* else **recurse**
</section>

<section>
## parallel search

<br>

### example
</section>

<section>
## parallel search

<br>

* $p$ processes
* $\mathcal{O}(p)$ work per step, $\mathcal{O}(1)$ depth
* $p^k = n \Rightarrow k = \log_p n \Rightarrow \frac{\log_2 n}{\log_2 p} $
* Work optimal ?
* <p class="fragment">no parallelism if we insist on work optimality</p>
 
</section>

</section>

<!-- ====================================== -->

<section>
<section>
# ranking
</section>

<section>
## ranking

<br>

* given ordered lists, $A,B$ of lengths $n, m$
* **define:**
    
    rank$(z:A) \leftarrow $ number of elements $a_i|a_i\leq z$
    
* **define:**
    
    rank$(B:A) := (r_1,r_2,\cdots,r_t)$    
    $r_i\leftarrow $ rank$(b_i:A)$ 

</section>

<section>
## parallel ranking

<br>

* A = [7, 13, 25,  26, 31, 54]
* B = [1, 8, 13,  27]
* Rank(B:A) = (0, 1, 2, 4) 
* Rank(A:B) = (1,3,3,3,4,4,4)
</section>

<section>
## algorithm for Rank(b:A)

<br>

* ranking one element in an array A 
* use a binary search algorithm 
* Depth 
    * sequential search $\mathcal{O}( \log(n) )$ 
    * parallel search $\mathcal{O}( \log(n)/\log(p) )$ 

</section>

</section>

<!-- ====================================== -->

<section>
<section>
# merge sort
</section>

<section>
## divide & conquer mergesort

* divide $X$ into $X_1$ and $X_2$
* sort $X_1$ and $X_2$
* merge $X_1$ and $X_2$
* uses a binary tree 
    * bottom-up approach
    * start with the leaves
    * climb to the root
    * merge the branches
* requires parallel **merge**
</section>

<section>
## mergesort - example

<img style="border:1px white" width=1000 src="/images/svg/mergesort.svg"></img>
</section>

<section>
## mergesort

<br>

```c
b = Merge_Sort(a,n)
  if n < 100 
    return seqSort(a, n);
  b1 = Merge_Sort(a[0,…,n/2-1], n/2);
  b2 = Merge_Sort(a[n/2,…,n-1], n/2);
  return Merge (b1, b2);
```
</section>

<section>
# parallel merge
</section>

<section>
## merging two sorted lists 

<br>

* best sequential time --- $\mathcal{O}(n)$

<br>

#### parallel merge

tradeoffs between
  
  * depth-optimal
  * work-optimal
</section>

<section>
## merging using ranking

<br>

* Assume elements in $A$ and $B$ are distinct
* Let $C$ be the merged result. Given, $x \in C$ and rank$(x:C)=i$
    * $c_i=x$
* rank$(x:C) = $rank$(x:A)+$rank$(x:B)$
* Solution to the merging problem,
    * find rank$(x:A)$ and rank$(x:B)$
    * <p class="fragment"> **parallel searches** using $p=nm, D=\mathcal{O}(1)$ but $W=\mathcal{O}(n^2)$ </p>
    * <p class="fragment"> Concurrent **binary searches**,  $D=\mathcal{O}(\log n)$ and $W=\mathcal{O}(n \log n)$ </p> 
* <p class="fragment"> **Goal**: Parallelize with optimal work </p>

</section>

<section>
# work-optimal merge
</section>

<section>
## work-optimal parallel merge

<br>

<img style="border:1px white" width=1000 src="/images/svg/optimal_merge0.svg"></img>

</section>

<section>
## work-optimal parallel merge

<br>

<img style="border:1px white" width=1000 src="/images/svg/optimal_merge1.svg"></img>

#### partition $B$ into blocks with $\log m$ elements

</section>

<section>
## work-optimal parallel merge

<br>

<img style="border:1px white" width=1000 src="/images/svg/optimal_merge2.svg"></img>

#### rank splitters of $B$ in $A$
</section>

<section>
## work-optimal parallel merge

<br>

<img style="border:1px white" width=1000 src="/images/svg/optimal_merge2.svg"></img>

#### partition $A$ accordingly
</section>

<section>
## work-optimal parallel merge

<br>

<img style="border:1px white" width=1000 src="/images/svg/optimal_merge2.svg"></img>

#### merge blocks $B_i$ and $A_i$ sequentially
</section>


<section>
## work-optimal parallel merge

<br>

* partition $B$ into $m/\log m$ blocks, each with $\log m$ elements
* parallel for $i=1:m/\log m$
    * $r_i = $`seq_rank`$(b_{iK}: A)$
* partition $A$ accordingly
    * block $A_i: (a_{r_{i-1}+1},\cdots,a_{r_i})$
* merge blocks of $A$ and $B$ sequentially in $\mathcal{O}(\log n)$ time 
* **but**, if $|A_i|\gg|B_i|=\log m$ then `par_merge`$(B_i, A_i)$

</section>

<section>
## work-optimal parallel merge

<br>

<div align=left>
#### assuming $m=\mathcal{O}(n)$, 

$$W=\mathcal{O}(n)$$ 

and,

$$D=\mathcal{O}(\log n)$$
</div>

</section>

</section>

<!-- ====================================== -->

<section>
## next time ...

<br>

* bitonic sort
* sample sort
</section>

<section>
## self-test questions

<br>

* design a work-optimal ranking algorithm
    * similar to parallel merge
* what are the challenges of implementing the parallel merge in a shared memory framework? how about using message passing?
* can you implement a parallel mergesort using the algorithms discussed today? What will its time complexity be? 
</section>
