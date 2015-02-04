---
title: CS6230: HPC & Parallel Algorithms
theme: white
---

<section>
# sorting
</section>

<!-- ====================================== -->

<section>

<section>
# mergesort
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

</section>

<!-- ====================================== -->

<section>
<section>
# basics
</section>

<section>
## background

<br>

* input specification
    * each process has $n/p$ elements
    * an ordering of the processes is specified
* output specification
    * each process will get $n/p$ consecutive elements of
    the final sorted array
    * which *chunk* is determined by the process ordering
</section>

<section>
## basic operation
### compare-split

<br>

<img style="border:1px white" width=1000 src="/images/svg/compare_split.svg"></img>
</section>

<section>
## basic operation
### compare-split

<br>

<img style="border:1px white" width=1000 src="/images/svg/compare_split_mult.svg"></img>
</section>

<section>
## sorting networks

<br>

* sorting is one of the fundamental problems in Computer Science
* for a long time researchers have focused on the  problem of “how fast can we sort $n$ elements”?
* serial
    * $\mathcal{O}(n\log n)$ lower-bound for comparison-based sorting
* parallel
    * $\mathcal{O}(1), \mathcal{O}(\log n), \mathcal{O}(???)$ 
* sorting networks
    * custom-made hardware for sorting!
        * hardware & algorithm
        * mostly of theoretical interest but fun to study!

</section>

<section>
## elements of sorting networks

<br>

#### key idea
perform many comparisons in parallel 

<br>

#### key elements
comparators and network topology 

<img style="border:1px white" width=300 src="/images/svg/comparator.svg"></img>

</section>

<section>
## elements of sorting networks

<img style="border:1px white" width=1000 src="/images/svg/sorting_nw.svg"></img>
</section>

</section>
<!-- ====================================== -->
<section>

<section>
# bitonic sort

<br>

#### a sorting network with $\mathcal{O}(\log^2n)$ columns

</section>

<section>
## bitonic sequence 

<br>

<div align=left>
a bitonic sequence is a sequence of elements $(a_0,a_1,\ldots,a_{n-1})$ with the property that either (1) there exists an index $i, 0\leq i\leq n-1$, such that $(a_0,\ldots,a_i)$ is monotonically increasing and $(a_{i+1},\ldots,a_{n-1})$ is monotonically decreasing, or (2) there exists a cyclic shift of indices so that (1) is satisfied.
</div>


<img style="border:1px white" width=400 src="/images/svg/bitonic_seq.svg"></img>
</section>

<section>
## why bitonic sequences?

<br>

<div align=left>
#### a bitonic sequence can be *easily* sorted in increasing/decreasing order

<br>

Let $s=(a_0,\ldots,a_{n-1})$ be a bitonic sequence such that 
$$a_0\leq a_1 \leq \cdots \leq a_{n/2-1}$$ 
and
$$a_{n/2}\geq a_{n/2+1} \geq \cdots \geq a_{n-1}.$$ 
Consider the following subsequences of $s$:     
  
$$s_1 \leftarrow ( \min(a_0, a_{n/2}), \min(a_1, a_{n/2+1}), \ldots, \min(a_{n/2-1}, a_{n-1}) ) $$

$$s_2 \leftarrow ( \max(a_0, a_{n/2}), \max(a_1, a_{n/2+1}), \ldots, \max(a_{n/2-1}, a_{n-1}) ) $$

</div>

</section>

<section>
## why bitonic sequences?

<img style="border:1px white" width=1000 src="/images/svg/bitonic_split.svg"></img>

<br>

* every element of $s_1$ will be $\leq$ every element of $s_2$
* both $s_1$ and $s_2$ are bitonic sequences
* so how can we sort bitonic sequences?

</section>

<section>
<img style="border:0px white" width=1000 src="/images/svg/bitonic_ex_0.svg"></img>
<img class="fragment" style="border:0px white" width=1000 src="/images/svg/bitonic_ex_1.svg"></img>
<img class="fragment" style="border:0px white" width=1000 src="/images/svg/bitonic_ex_2.svg"></img> 
<img class="fragment" style="border:0px white" width=1000 src="/images/svg/bitonic_ex_3.svg"></img> 
<img class="fragment" style="border:0px white" width=1000 src="/images/svg/bitonic_ex_4.svg"></img> 
</section>

<section>
## bitonic merging network
a comparator network that takes as an input a bitonic sequence and performs a sequence of bitonic splits to sort it
<img style="border:1px white" width=800 src="/images/svg/BitonicMerge.svg"></img>

#### +BM[16] (increasing)

</section>

<section>
## are we done?

<br>

* given a set of elements, how do we re-arrange them into a bitonic sequence?
* <p class="fragment"> **key idea** </p>
    * <p class="fragment"> use successively larger bitonic networks to transform the set into a bitonic sequence</p>
    
<img class="fragment" style="border:1px white" width=800 src="/images/svg/bitonic_stages.svg"></img>
</section>

<section>
## are we done?

<br>

* given a set of elements, how do we re-arrange them into a bitonic sequence?
* **key idea** </p>
    * use successively larger bitonic networks to transform the set into a bitonic sequence</p>

<img style="border:1px white" width=1000 src="/images/svg/BitonicSort1.svg"></img>
</section>

<section>
## make bitonic

<img style="border:1px white" width=1000 src="/images/svg/make_bitonic.svg"></img>
</section>

<section>
## complexity

<br>

#### how many columns of comparators are required to sort $n=2^k$ elements?

in other words the depth $d(n)$ of the network?

<img style="border:1px white" width=1000 src="/images/svg/BitonicSort1.svg"></img>

<p class="fragment">
$$ d(n) = d(n/2) + \log n = \mathcal{O}(\log^2 n)$$
</p>

<!-- p class="fragment"> 
$$d(n) = \sum_{i=1}^{\log n} i = (\log^2 n + \log n)/2 = \mathcal{O}(\log^2 n)$$ </p -->
</section>

<section>
## bitonic sort

```c
bitonic [b1, b2] = split (bitonic b) {
  n = length(b);
  for (i=0; i<n/2; ++i) {
    b1[i] = min( b[i], b[i+n/2] );
    b2[i] = max( b[i], b[i+n/2] );
  }
}

bitonic [b1, b2] = reverse_split (bitonic b) {
  [b2, b1] = split(b);
}

sequence s = sort_bitonic(bitonic b) {
  [b1, b2] = split(b);
  s = [sort_bitonic(b1), sort_bitonic(b2)];
}

sequence s = reverse_sort_bitonic(bitonic b) {
  [b1, b2] = reverse_split(b);
  s = [reverse_sort_bitonic(b1), reverse_sort_bitonic(b2)];
}

```
</section>

<section>
## bitonic sort

```c
bitonic b = make_bitonic(sequence a) {
  a1 = a[  0,...,n/2-1];
  a2 = a[n/2,...,n-1];
  
  b1 = make_bitonic(a1);
  b2 = make_bitonic(a2);
  
  b = merge_bitonic(b1,b2);
}

bitonic b = merge_bitonic(b1, b2) {
  b1 = sort_bitonic(b1);
  b2 = reverse_sort_bitonic(b2);
  b = [b1, b2];
}
```
</section>


<section>
## bitonic sort on a hypercube

<br>

* one element per process case
* how do we map the algorithm onto a hypercube?
    * what is the comparator?
    * how do the wires get mapped?
    
<img style="border:1px white" width=800 src="/images/svg/BitonicMerge.svg"></img>  

</section>

<section>
## bitonic sort on a hypercube

<img style="border:1px white" width=1000 src="/images/svg/hypercube_bitonic_4_0.svg"></img>
</section>

<section>
## bitonic sort on a hypercube

<img style="border:1px white" width=1000 src="/images/svg/hypercube_bitonic_4_1.svg"></img>
</section>

<section>
## bitonic sort on a hypercube

<img style="border:1px white" width=1000 src="/images/svg/hypercube_bitonic_4_2.svg"></img>
</section>

<section>
## bitonic sort on a hypercube

<img style="border:1px white" width=1000 src="/images/svg/hypercube_bitonic_4_3.svg"></img>
</section>

<section>
## communication pattern

<img style="border:1px white" width=1000 src="/images/svg/bitonic_stages_comm.svg"></img>

<div align=left>
communication characteristics of bitonic sort on a hypercube. during each stage of the algorithm, processes communicate along the dimensions shown. 
</div>
</section>

<section>
## bitonic sort on a hypercube

```octave
function y = hcube_bitonic_sort(p, id, x)
  d = log2(p);
  
  for i=0:d-1 
    for j=i:-1:0
      partner = flip_bit(id, j) % id xor 2^j
      if id.bit(i+1) == id.bit(j)
        comp_exchange_min (x, partner);
      else
        comp_exchange_max (x, partner);
      end
    end
  end
end    
```
</section>

<section>
## more than one element per process

<br>

### hypercube

<br>

$$ T_p = \underbrace{\mathcal{O}\left(\frac{n}{p}\log \frac{n}{p}\right)}_\text{local sort} + \underbrace{\mathcal{O}\left(\frac{n}{p}\log^2 p\right)}_\text{comparisons} + \underbrace{\mathcal{O}\left(\frac{n}{p}log^2 p\right)}_\text{communication} $$
</section>

</section>
<!-- ====================================== -->

<section>
## self-test questions

<br>

* how does the complexity of bitonic sort change when implemented on other topologies?
* compare the number of comparisons and communication of mergesort with bitonic.
* which architectures is bitonic sort best suited for? 

</section>
