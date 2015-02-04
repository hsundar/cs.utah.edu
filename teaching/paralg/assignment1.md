# [CS 6230: Parallel Computing and High Performance Computing](/teaching/spring2015.html)

## Assignment 1 
### Due 16 Feb 2015
 
Please submit a single `pdf` and a single `tgz` named `uid.{pdf,tgz}` respectively. Let the uid start with a lowercase `u` followed by 7 digits. Upload/Submission information for these files will be provided soon. We will most probably be using the handin system.

1. **Reading**: [First chapter of Jájá's book.](/teaching/bigdata/book92-JaJa-parallel.algorithms.intro.pdf)

2. Given two vectors in $x, y \in \mathbb{R}^n$, we want to compute their **outer product** $A = x \otimes y \in \mathbb{R}^{n×\times n}$, deﬁned by $A_{ij} = x_iy_j$ . Give work-depth pseudocode for this problem. Derive work, depth, and parallelism as a function of $n$.

3. State a non-recursive PRAM algorithm for the reduction algorithm for arbitrary $n$ and $p$. That is, $n$
and $p$ don’t need to be powers of two and $n \neq p$. Derive an expression for the time and work complexity
of your algorithm. What is the expected speedup and eﬃciency? Is your algorithm work efficient?

4. Consider the **matrix-vector** multiplication problem $y = Ax$ on a PRAM machine. For PRAM, we
discussed an algorithm that uses row-wise partitioning of $A$ and $y$. This type of partitioning is called
*one-dimensional*, because partitions run across one dimension of the matrix. State a PRAM algorithm
that uses a two-dimensional partitioning of the matrix. That is, if we have $p^2$ cores, we partition $A$ into
$p$ row blocks and $p$ column blocks and $x, y$ in $p$ blocks. Derive the complexity ( $T(n, p)$ and $W(n, p)$ )
and the speedup of the algorithm. Is your algorithm work efficient (assuming $W_{sequential}(n) = \mathcal{O}(n^2)$ ) ?

5. Let $A$ be an $n\times n$ lower triangular matrix (i.e., $A_{ij} = 0$ if $j > i$) such that $A_{ii} \neq 0$, for $1\leq i \leq n$, and let $b$ be a $n$-dimensional vector. Consider the forward-substitution algorithm for solving $Ax = b$
for $x$:
\\[
\\begin{aligned} 
x_1 & = \\frac{1}{A_{11}}b_1, \\\\
x_i & = \\frac{1}{A_{ii}}\(b_i - \\sum_{j=1}^{i-1}A_{ij} x_j  \), \\quad i=2,\\cdots,n
\end{aligned} 
\\]
  Determine the work and depth of the algorithm. State a PRAM version of this algorithm and derive its time and work complexity as a function of the input size $n$ and the number of processors $p$. **Optional**: Suggest ways to improve the complexity of this algorithm.

6. Generalize the hypercube reduction algorithm for a $d$-dimensional hypercube for the case in which
the number of processors is not a power of two and for any problem size $n \geq p$. Derive an expression
for the wall-clock time $T(n, p)$ as a function of the number of processors $p$ and the problem size $n$.
Your estimate should include communication costs in terms of latency, bandwidth, and message size.

7. **Programming**: Write an MPI program that uses only `MPI_Send` and `MPI_Recv` functions to implement the following MPI collectives:
    1. `MPI_Reduce()` 
    2. `MPI_Scan()` 
    
    for both cases support at least the `MPI_SUM` operation, preferably the other standard ones as well. You are free to use any of the variants of `Send` and `Recv`, but not any of the built in collectives. Clarify on the discussion below in case of any confusion on whether a specific function can be used. You do not need to write a `main()` function. You will only be submitting your implementation for the functions with the same signature as the built in versions. 
    
    Your function prototype is given below:
```c
void uxxxxxxx_Reduce(const void *sendbuf, void *recvbuf, int count, MPI_Datatype datatype,
                    MPI_Op op, int root, MPI_Comm comm);
void uxxxxxxx_Scan(const void *sendbuf, void *recvbuf, int count, MPI_Datatype datatype,
                    MPI_Op op, MPI_Comm comm);
```
    You should clone the [github repository](https://github.com/hsundar/CS6230/) and create a folder named as per your UID(uxxxxxxx) under the `students` folder. Store your source files (`*.c, *.cpp, *.h`) here in this folder. An example is available under the `students/sample` folder that simply calls the standard MPI functions. Run the build.py python script to compile the program. 



<div id="disqus_thread"></div>
<script type="text/javascript">
/* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
var disqus_shortname = 'cs6230'; // required: replace example with your forum shortname

/* * * DON'T EDIT BELOW THIS LINE * * */
(function() {
  var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
  dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
  (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
  })();
  </script>
  <noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
  
  
  [Tangent]: https://wiki.chpc.utah.edu/display/DOCS/Tangent+User+Guide
  [Stampede]: https://portal.tacc.utexas.edu/user-guides/stampede
  
