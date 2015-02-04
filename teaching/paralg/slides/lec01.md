---
title: CS6230: HPC & Parallel Algorithms
theme: white
---

<section>

<section>
# overview
</section>

<section>
## no cheating

<br>

[School of Computing Cheating Policy](http://www.cs.utah.edu/graduate/cheating_policy)

</section>

<section>
## cluster etiquette
</section>

<section>
## [mpi introduction](/blog/2015-01-13-intro-to-mpi.html)
</section>

<section>
## accounts

<br>

* google groups
* CHPC - Tangent
* XSEDE - Stampede
</section>

</section>

<section>
# Parallel Algorithm Design
</section>

<!-- New Section -->

<section>

<section>
# computational model
</section>

<section>
## computational model

<br>

* **Task**: sequential program and its local storage
* **Parallel computation**: two or more tasks executing concurrently
* **Communication channel**: link between two tasks over which messages can be sent and received
  * **send** is **nonblocking** : sending task resumes execution immediately
  * **receive** is **blocking** : receiving task blocks execution until requested message is available  
</section>

<section>
  ## Example: Laplace's equation
  
<br>

<div align=left>  
#### consider Laplace's equation in 1D
  
  \\[ \\Delta u = 0 \\]
  
#### on the interval $a<t<b$ with boundary conditions
  
  \\[ u(a) = \\alpha, \\quad\\quad u(b) = \\beta. \\]

<br>
  
#### we seek approximate solution values $u_i \approx u(t_i)$ at mesh points 

\\[t_i=a+ih, i=0,\\cdots,n+1,\\] 

<br>

#### where $h=(b-a)/(n+1)$.

</div>
  
</section>

<section>
## Example: Laplace's equation

<br>

<div align=left>
  
#### Finite difference approximation

\\[  u''(t_i) \\approx \\frac{u_{i+1} - 2u_i + u_{i-1}}{h^2} \\]


#### yields a tridiagonal system of algebraic equations

\\[  \\frac{u_{i+1} - 2u_i + u_{i-1}}{h^2} = 0, \\quad i=1,\\cdots,n \\]


#### for $u_i, i=0,\cdots,n$, where $u_0=\alpha$ and $u_{n+1}=\beta$. 

<br>

#### Starting from initial guess $u^{(0)}$, compute Jacobi iterates

\\[ u_i^{(k+1)} = \\frac{u_{i-1}^{(k)} + u_{i+1}^{(k)}}{2}, \\quad i=1,\\cdots,n \\]


#### for $k=1,\cdots$ until convergence.
</div>

</section>

<section>
## Example: Laplace's equation

<br>

<div align=left>
* **Define $n$ tasks, one for each $u_i, i = 1,\cdots,n$**
* **Task $i$ stores initial value of $u_i$ and updates it at each iteration until convergence**
* **To update $u_i$, necessary values of $u_{i-1}$ and $u_{i+1}$ are obtained from neighboring tasks $i-1$ and $i+1$**
  
  <img style="border:1px white" width=1000 src="/images/svg/laplace1d.svg"></img>
  
* **Tasks $1$ and $n$ determine $u_0$ and $u_{n+1}$ from BC** 
</div>

</section>

<section>
## Example: Laplace's equation

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
}
```

<img style="border:1px white" width=1000 src="/images/svg/laplace1d.svg"></img>

</section>

<section>
  ## mapping tasks to processors
  
  <br>
  
  * tasks must be assigned to physical processors for
  execution
  * tasks can be mapped to processors in various ways,
  including multiple tasks per processor
  * semantics of program should not depend on number of
  processors or particular mapping of tasks to processors
  * performance usually sensitive to assignment of tasks to
  processors due to concurrency, workload balance,
  communication patterns, etc
  * computational model maps naturally onto
  distributed-memory multicomputer using message passing
</section>

<!-- section>
  ## other models of parallel computation
  
  <br>
  
  * PRAM - Parallel Random Access Machine
  * LogP - Latency/Overhead/Gap/Processors
  * BSP - Bulk Synchronous Parallel 
  * CSP - Communicating Sequential Processes
  * Linda - Tuple space
  * and many others ... 
</section -->

</section>

<!-- New Section -->
<section>
  
<section>
# design methodology
</section>

<!-- section>
  ## four step design methodology
  
  <br>
  
  * **partition**: decompose problem into fine-grain tasks,
  maximizing number of tasks that can execute concurrently
  * **communication**: determine communication pattern among
  fine-grain tasks, yielding **task graph** with fine-grain tasks
  as nodes and communication channels as edges
  * **agglomeration**: combine groups of fine-grain tasks to form
  fewer but larger coarse-grain tasks, thereby reducing
  communication requirements
  * **mapping**: assign coarse-grain tasks to processors, subject to
  tradeoffs between communication costs and concurrency
  
</section -->

<section>
## four step design methodology

  <img style="border:1px white" width=1000 src="/images/svg/parallel_design.svg"></img>

</section>

<section>
## partition

<img style="border:1px white" width=1000 src="/images/svg/parallel_design.svg"></img>

decompose problem into fine-grain tasks, maximizing number of tasks that can execute concurrently
</section>

<section>
## communication
<img style="border:1px white" width=1000 src="/images/svg/parallel_design.svg"></img>

determine communication pattern among fine-grain tasks, yielding **task graph** with fine-grain tasks
as nodes and communication channels as edges
</section>

<section>
## agglomeration
<img style="border:1px white" width=1000 src="/images/svg/parallel_design.svg"></img>

combine groups of fine-grain tasks to form fewer but larger coarse-grain tasks, thereby reducing
communication requirements
</section>

<section>
## mapping
<img style="border:1px white" width=1000 src="/images/svg/parallel_design.svg"></img>

assign coarse-grain tasks to processors, subject to tradeoffs between communication costs and concurrency
</section>

</section>

<!-- New Section -->
<section>
  
<section>
# partition

<br>

<img style="border:1px white" width=500 src="/images/svg/parallel_design.svg"></img>
</section>

<section>
  ## partitioning strategies
  
  <br>
  
  * **domain decomposition** : subdivide geometric domain into
  subdomains
  * **functional decomposition** : subdivide system into multiple
  components
  * **independent tasks** : subdivide computation into tasks that
  do not depend on each other (embarrassingly parallel )
  * **array parallelism** : simultaneous operations on entries of
  vectors, matrices, or other arrays
  * **divide-and-conquer** : recursively divide problem into
  tree-like hierarchy of subproblems
  * **pipelining** : break problem into sequence of stages for
  each of sequence of objects
</section>

<section>
  ## desirable properties of partitioning
  
  <br>
  
  * maximum possible concurrency in executing resulting
  tasks
  * many more tasks than processors
  * number of tasks, rather than size of each task, grows as
  overall problem size increases
  * tasks reasonably uniform in size
  * redundant computation or storage minimized
</section>

<section>
## example: domain decomposition

<br>

<img style="border:1px white" width=1000 src="/images/svg/domain_decomposition.svg"></img>

<div align=left>
#### 3-D domain partitioned along one (left), two (center), or all three (right) of its dimensions
  
With 1-D or 2-D partitioning, minimum task size grows with problem size, but not with 3-D partitioning
</div>  

</section>
</section>

<section>
<section>
# communication

<br>

<img style="border:1px white" width=500 src="/images/svg/parallel_design.svg"></img>
</section>

<section>
## communication patterns

<br>

* Communication patterns are determined by data dependences
  among tasks: because memory/storage is local to each task, any
  data stored or produced by one task and needed by
  another must be communicated between them
* Communication patterns may be 
    * local or global
    * structured or random
    * persistent or dynamically changing
    * synchronous or sporadic
</section>

<section>
## desirable properties of communication

<br>

* frequency and volume minimized
* highly localized (between neighboring tasks)
* reasonably uniform across channels
* network resources used concurrently
* does not inhibit concurrency of tasks
* overlapped with computation as much as possible

</section>
</section>

<section>

<section>
# agglomeration

<br>

<img style="border:1px white" width=500 src="/images/svg/parallel_design.svg"></img>
</section>

<section>
## agglomeration

<br>

* increasing task sizes can **reduce communication** but also reduces potential concurrency
* subtasks that can’t be executed concurrently (**inherently sequential**) are obvious candidates for combining into single task
* maintaining **balanced workload** is still important
* **replicating computation** can eliminate communication and is advantageous if result is cheaper to compute than to communicate
</section>

<section>
## Example: Laplace's equation  

<br>
<div align=left>
  
#### Combine groups of consecutive mesh points $t_i$ and corresponding solution values $u_i$ into coarse-grain tasks, yielding $p$ tasks, each with $n/p$ of $u_i$ values

<img style="border:1px white" width=1000 src="/images/svg/agglomerate.svg"></img>

#### Communication is greatly reduced, but $u_i$ values within each coarse-grain task must be updated sequentially
</div>
</section>

<section>
## Example: Laplace's equation  

```c
// initialize u[l,..,r]
int m = n/p; // = r-l+1
double u[m+2], u_bar[m+2];
double u_lm1, u_rp1;

while (err < tolerance) { 
  if (rank>1) send(u[1], rank-1);
  if (rank<p) send(u[m], rank+1);
  if (rank<p) recv(u[m+1], rank+1);
  if (rank>1) recv(u[0], rank-1);
  
  for (i=1; i<m+1; ++i)
    u_bar[i] = (u[i-1]+u[i+2])/2;
  wait(sends to complete);
  
  u = u_bar;
}
```
  
<img style="border:1px white" width=1000 src="/images/svg/agglomerate.svg"></img>
  
</section>

<section>
  # can we do better?
</section>

<section>
## overlapping communication and computation 

<br>

* updating of solution values $u_i$ is done only after all
communication has been completed, but only two of those
values actually depend on awaited data
* since communication is often much slower than
computation, initiate communication by sending all
messages first, then update all **interior** values while
awaiting values from neighboring tasks
* much (possibly all ) of updating can be done while task
would otherwise be idle awaiting messages
* performance can often be enhanced by overlapping
communication and computation in this manner

</section>

<section>
## Example: Laplace's equation  

```c
// initialize u[l,..,r]

while (err < tolerance) { 
  if (rank>1) send(u[1], rank-1);
  if (rank<p) send(u[m], rank+1);
  
  for (i=2; i<m; ++i) // l+1,...,r-1
    u_bar[i] = (u[i-1]+u[i+2])/2;
    
  if (rank<p) recv(u[m+1], rank+1);
  u_bar[m] = (u[m-1]+u[m+1])/2;
  if (rank>1) recv(u[0], rank-1);
  u_bar[1] = (u[0]+u[2])/2;
  
  wait(sends to complete);
  
  u = u_bar;
}
```

<img style="border:1px white" width=1000 src="/images/svg/agglomerate.svg"></img>

</section>

<section>
## surface-to-volume effect
  
<img style="border:1px white" width=1000 src="/images/svg/domain_decomposition.svg"></img>

* for domain decomposition,
    * **computation $\propto$ volume**
    * **communication $\propto$ surface area**
* higher-dimensional decompositions have more favorable surface-to-volume ratio
* partitioning across more dimensions yields more neighboring subdomains but smaller total volume of communication than partitioning across fewer dimensions

</section>

<section>
# scalability
</section>
</section>

<section>
<section>
# mapping

<br>

<img style="border:1px white" width=500 src="/images/svg/parallel_design.svg"></img>
</section>

<section>
## mapping

<br>

* as with agglomeration, mapping of coarse-grain tasks to
processors should maximize concurrency, minimize
communication, maintain good workload balance, etc.
* but connectivity of coarse-grain task graph is inherited
from that of fine-grain task graph, whereas connectivity of
target interconnection network is independent of problem
* communication channels between tasks may or may not
correspond to physical connections in underlying
interconnection network between processors
</section>

<section>
## mapping

<br>

<div align=left>
  
#### two communicating tasks can be assigned to
* one processor, avoiding interprocessor communication but
sacrificing concurrency
* two adjacent processors, so communication between the
tasks is directly supported, or
* two nonadjacent processors, so message routing is
required

<br>

#### In general, finding optimal solution to these tradeoffs is NP-complete, so heuristics are used to find an effective compromise
</div>  
</section>

<section>
## mapping

<br>

* for many problems, task graph has a regular structure that
can make mapping easier
* if communication is mainly global, then communication
performance may not be sensitive to placement of tasks on
processors, so random mapping may be as good as any
* random mappings are sometimes used deliberately to avoid
communication **hot spots**, where some communication
links are oversubscribed with message traffic

</section>

<section>
## mapping strategies

<br>

<div align=left>
#### with tasks and processors consecutively numbered in some ordering,

* **block mapping** : blocks of $n/p$ consecutive tasks are assigned to successive processors
* **cyclic mapping** : task $i$ is assigned to processor $i \mod p$
* **reﬂection mapping** : like cyclic mapping except tasks are
assigned in reverse order on alternate passes
* **block-cyclic mapping** and **block-reﬂection mapping** : blocks
of tasks assigned to processors as in cyclic or reﬂection

<br>

#### For higher-dimensional grids, these mappings can be applied in each dimension
</div>

</section>

<section>
## examples of mapping
  <img style="border:1px white" width=1000 src="/images/svg/mapping.svg"></img>
</section>

<section>
## dynamic mapping

<br>

* if task sizes vary *during* computation or can’t be predicted
in advance, tasks may need to be reassigned to
processors dynamically to maintain reasonable workload
balance throughout computation
* to be beneficial, gain in load balance must more than
offset cost of communication required to move tasks and
their data between processors
* dynamic load balancing is usually based on local exchanges
of workload information (and tasks, if necessary), so work
diffuses over time to be reasonably uniform across
processors  
  
</section>

<section>
## task scheduling

<br>

* with multiple tasks per processor, execution of those tasks
must be scheduled over time
* for shared-memory, any idle processor can simply select
next ready task from common pool of tasks
* for distributed-memory, analogous approach is
manager/worker paradigm, with manager dispatching
tasks to workers
* manager/worker scales poorly, as the manager becomes
the bottleneck, so a hierarchy of managers and workers
becomes necessary---basically a more decentralized scheme

</section>

<section>
## task scheduling

* for a completely decentralized scheme, it can be difficult to
determine when the overall computation has been completed,
so a termination detection scheme is required
* with multithreading, task scheduling can conveniently be
driven by availability of data: whenever executing task
becomes idle awaiting data, another task is executed
* for problems with regular structure, it is often possible to
determine mapping in advance that yields reasonable load
balance and natural order of execution

</section>

</section>
<!-- New Section -->

<section>
## summary 
<br>

<img style="border:1px white" width=1000 src="/images/svg/parallel_design.svg"></img>
</section>

<section>
# readings & todo 

<br>

[MPI Introduction](/blog/2015-01-13-intro-to-mpi.html)     
[MPI Reference](/teaching/bigdata/book96-Dongarra-MPI.The.Complete.Reference.pdf)    
[Gramma et al., Introduction to Parallel Computing](http://www-users.cs.umn.edu/~karypis/parbook/)
</section>
