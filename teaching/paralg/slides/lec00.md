---
title: CS6230: HPC & Parallel Algorithms
theme: white
---

<section>
# Parallel Computing
### Spring 2015 - CS:6230

[Hari Sundar](http://www.cs.utah.edu/~hari), MEB 3454     
[hari@cs.utah.edu](mailto:hari@cs.utah.edu)    
WEB L120 - MW 3-4:20pm    

</section>

<section>
<section>
# overview
</section>

<section>

## outline

* Parallel programming models
	* Shared Memory (Work/Depth, PRAM), APIs (OpenMP)
	* Distributed Memory (message passing), APIs (MPI)
* Discrete Algorithms
	* Sorting, Searching, Selecting, Merging
	* Trees, Graphs (coloring, partitioning, traversal)
* Numerical Algorithms
	* Dense/Sparse Linear Algebra (LU, SOR, Krylov, Nested Dissection)
	* Fast Transforms - FFT, Multigrid, Gauss
	* $n$-body Algorithms - Fast Multipole Methods, Tree codes, nearest neighbors
	* Time parallelism (parareal algorithms)

</section>

<section>
## Logistics

* Suggested Books
	* Gramma et al. [Introduction to Parallel Computing](http://www-users.cs.umn.edu/~karypis/parbook/)
	* Jájá, [An introduction to Parallel Algorithms](http://www.pearsonhighered.com/educator/academic/product/0,1144,0201548569,00.html)
* Research papers and other readings posted on the course webpage/canvas
* Prerequisites
	* C/C++
	* Sequential Algorithms
	* Numerical linear algebra, ODEs, PDEs
</section>

<section>
## Logistics

* 3-4 assignments
* midterm
* final project
	* teams of two
	* project proposals due by end of february
	* project reports
	* project presentations
</section>

<section>
## Logistics

* Primarily using MPI and OpenMP
	* modern C/C++ compiler
	* install openmpi or mpich on your machine
	* good for development and small debugging
* Clusters
	* CHPC - Kingspeak - 16 nodes with 16 cores each
	* XSEDE - Stampede
		* 256 nodes with 16 cores each
		* will also consider Intel Xeon Phi later in course
</section>

<section>
## Logistics

### programming problems

* [course github page](https://github.com/hsundar/CS6230)
	* basic code template
	* you will submit functions
	* automatically graded
		* correctness
		* scalability - rankings

</section>
</section>

<section>
<section>
# motivation
</section>

<section>
### why parallel computing?
<br>
<br>

* provides cost-effective (often only) means of meeting enormous resource demands of large-scale simulations
* leverages existing resources or relatively inexpensive commodity parts
* offers alternative when individual processor speeds ultimately reach limits imposed by fundamental physical laws
</section>

<section>
### reasons for caution
<br>

Parallel computing should be approached with caution

* unstable commercial market
* relative lack of available software
* immature computing environment
* challenging complexity of parallel programming 
* physical constraints (power, cooling, etc.)

<br>

<div align=justify>
Nevertheless, insatiable appetite of computational scientists for
ever greater computing capability has led them to embrace
large-scale parallelism
</div>
</section>
</section>

<section>

<section>
# architectures
</section>

<section>
###Flynn’s taxonomy

<div align=justify>
classification of computer systems by numbers of instruction streams and data streams:

<br> 

**SISD** : single instruction stream, single data stream
conventional serial computers

**SIMD** : single instruction stream, multiple data streams
special purpose, “data parallel” computers

**MISD** : multiple instruction streams, single data stream
not particularly useful, except perhaps in “pipelining”

**MIMD** : multiple instruction streams, multiple data streams
general purpose parallel computers
</div>
</section>


<section>
## SPMD Programming Style

### (Single Program, Multiple Data)
<br>
<div align=justify>
all processors execute the same program, but each operates on a different portion of the
problem data

<br>

* Easier to program than true MIMD, but more flexible than SIMD
* Although most parallel computers today are MIMD architecturally, they are usually programmed in SPMD style
</div>

</section>

<section>
## architectural issues

#### major architectural issues for parallel computer systems include

* **processor coordination**: synchronous or asynchronous?
* **memory organization** : distributed or shared?
* **address space** : local or global?
* **memory access** : uniform or nonuniform?
* **granularity** : coarse or fine?
* **scalability** : additional processors used efficiently?
* **interconnection network** : topology, switching, routing?
</section>

<section>
## distributed vs shared memory

<img style="border:1px white" width=1000 src="/images/svg/shared_dist_proc.svg"></img>

</section>

<section>
## distributed vs shared memory
<br>

|                                        | distributed\ \ \ \ \ \ \ \ \ \  | shared |
|:---------------------------------------|-------------|--------|
| scalability                            | easier      | harder |
| data mapping                           | harder      | easier |
| data integrity                         | easier      | harder |
| performance optimization     \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ | easier   | harder |
| incremental parallelization            | harder      | easier |
| automatic parallelization              | harder      | easier |

</section>

<section>
## hybrid systems

<div align=left>
memory is shared locally within SMP (symmetric multiprocessor) nodes but distributed
globally across nodes
</div>

</section>

<section>
## heterogeneous systems

has accelerators (*e.g.* GPU) in additional to SMP within a node 

<br>

### Stampede

</section>

</section>


<section>

<section>
#network topologies
</section>

<section>
## network topologies

* Access to remote data requires communication
* Direct connections would require $\mathcal{O}(p^2)$ wires and communication ports, which is infeasible for large $p$
* Limited connectivity necessitates routing data through intermediate processors or switches
* Topology of network affects algorithm design, implementation, and performance
</section>

<section>
## common network topologies

<img style="border:1px white" width=1000 src="/images/svg/topology1.svg"></img>

</section>

<section>
## common network topologies

<img style="border:1px white" width=1000 src="/images/svg/topology2.svg"></img>

</section>

<section>
## graphs - review

<br>

* **Graph**: pair $(V,E)$, where $V$ is the set of vertices or nodes connected by set $E$ of edges 
* **Complete Graph**: graph in which any two nodes are connected by an edge
* **Path** : sequence of contiguous edges in graph
* **Connected graph** : graph in which any two nodes are connected by a path 
* **Cycle** : path of length greater than one that connects a node to itself
* **Tree** : connected graph containing no cycles
* **Spanning tree** : subgraph that includes all nodes of given graph and is also a tree

</section>

<section>
## graph models

<br>

* **Graph model of network**: nodes are processors (or switches or memory units), edges are communication links
* **Graph model of computation**: nodes are tasks, edges are data dependences between tasks
* Mapping task graph of computation to network graph of target computer is instance of **graph embedding**
* **Distance** between two nodes: number of edges (hops ) in shortest path between them

</section>

<section>
## network properties

<div align=justify>
Some network properties affecting its physical realization and
potential performance

<br>

* **degree** : maximum number of edges incident on any node; determines number of communication ports per processor
* **diameter** : maximum distance between any pair of nodes; determines maximum communication delay between processors
* **bisection width** : smallest number of edges whose removal splits graph into two subgraphs of equal size; determines ability to support simultaneous global communication
* **edge length** : maximum physical length of any wire; may be constant or variable as number of processors varies
</div>
</section>

<section>
## network properties

| Network     		| Nodes\ \ \ \ \ \  	| Deg \ \ 	| Diameter\ \  	| Bisec. W. \ \ \  	| Edge L. 	|
|-------------------|:----------:	|:------:	|:--------:	|:---------------:	|------------:	|
| bus/star    		|    $k+1$   	|   $k$  	|     $2$  	|       $1$        	|         var 	|
| crossbar    		|  $k^2+2k$  	|    $4$   	|  $2(k+1)$	|       $k$       	|         var 	|
| 1-D mesh    		|     $k$    	|    $2$   	|   $k-1$  	|        $1$        	|       const 	|
| 2-D mesh    		|    $k^2$   	|    $4$   	| $2(k-1)$ 	|       $k$       	|       const 	|
| 3-D mesh    		|    $k^3$   	|    $6$   	| $3(k-1)$ 	|      $k^2$      	|       const 	|
| n-D mesh    		|    $k^n$   	|  $2n$  	| $n(k-1)$ 	|    $k^{n-1}$    	|         var 	|
| 1-D torus   		|     $k$    	|    $2$   	|   $k/2$  	|        $2$        	|       const 	|
| 2-D torus   		|    $k^2$   	|    $4$   	|    $k$   	|       $2k$      	|       const 	|
| 3-D torus   			|    $k^3$   	|    $6$   	|  $3k/2$  	|      $2k^2$     	|       const 	|
| n-D torus   			|    $k^n$   	|  $2n$  	|  $nk/2$  	|    $2k^{n-1}$   	|         var 	|
| binary tree\ \ \ \ \ 	|   $2^k-1$  	|    $3$   	| $2(k-1)$ 	|       $1$     	|         var 	|
| hypercube   			|    $2^k$   	|   $k$  	|    $k$   	|    $2^{k-1}$    	|         var 	|
| butterﬂy    			| $(k+1)2^k$ 	|    $4$   	|   $2k$   	|      $2^k$      	|         var 	|

</section>

</section>

<section>
<section>
# graph embedding
</section>

<section>
### graph embedding

<br>

<div align=left>
$\phi : V_s → V_t$ maps nodes in source graph $G_s = (V_s, E_s)$ to nodes in target graph $G_t = (V_t, E_t)$

<br>

Edges in $G_s$ mapped to paths in $G_t$

* load : maximum number of nodes in $V_s$ mapped to same node in $V_t$ 
* congestion : maximum number of edges in $E_s$ mapped to paths containing same edge in $E_t$
* dilation : maximum distance between any two nodes $\phi(u), \phi(v) \in V_t$ such that $(u,v) \in E_s$	

</div>
</section>

<section>
### graph embedding

<br>

* Uniform load helps balance work across processors
* Minimizing congestion optimizes use of available
bandwidth of network links
* Minimizing dilation keeps nearest-neighbor
communications in source graph as short as possible in
target graph
* Perfect embedding has load, congestion, and dilation 1, but
not always possible
* Optimal embedding difﬁcult to determine (NP-complete, in
general), so heuristics used to determine good embedding
</section>

<section>
### graph embedding - examples

<br>

for some important cases, good or optimal embeddings are known, for example

<img style="border:1px white" width=1000 src="/images/svg/graph_embed.svg"></img>

</section>

</section>

<section>

<section>
# message passing
</section>

<section>
## message passing

<br>

<div align=left>
Simple model for time required to send message (move data)
between adjacent nodes:
<div>

<br>

<div align=center>
$T_{msg} = t_s + t_w L$
</div>

<br>

<div align=left>
* $t_s$ = startup time = latency (i.e., time to send message of
length zero)
* $t_w$ = incremental transfer time per word ($1/t_w$ = bandwidth
in words per unit time)
* $L$ = length of message in words
<div>

<br> 

For most real parallel systems, $ts \gg tw$

</section>

<section>
## SPMD basics

<div align=left>

* **size** : total number of processors/tasks involved in computation - $p$
* **rank** : id for a particular task in the computation - $(0,\cdots,p-1)$

</div>

<br>

### two basic communication constructs

<div align=left>

* `send (data, to_proc_i)`
* `recv (data, from_proc_j)`
* **blocking** as well as **non-blocking** variants

</div> 

</section>

<section>
## communicator (\  `MPI_Comm`\  )

<div align=left>
<br>

* determines the scope within which a point-to-point or collective operation is to operate
	* size and rank are defined in terms of the communicator
* communicators are dynamic
	* they can be created and destroyed during program execution
	* `MPI_COMM_WORLD` 

</div>

<br>

```bash
$ mpirun -np 4 ./hello
```
</section>

<section>
## collective communications

<br>

multiple nodes communicating simultaneously in systematic pattern

<br>

#### Barrier 

```c
    int MPI_Barrier (MPI_Comm comm);
```

* synchronize all processes belonging to a communicator 
* **avoid**, except for debugging

</section>

<section>
## MPI collectives
<div align=left>
<br>

#### data movement

* broadcast
* gather / scatter
* all_gather
* all_to_all

<br>

#### global computation

* reduce
* scan ( prefix )
</div>
</section>

<section>
## broadcast

source node sends the same message to each of $p-1$ other nodes
```c
int MPI_Bcast (void* buffer, int count, MPI_Datatype datatype, 
               int root, MPI_Comm comm);
```

<img style="border:1px white" width=800 src="/images/svg/broadcast.svg"></img>

</section>

<section>
## broadcast

<br>
<div align=left>
generic broadcast algorithm generates *spanning tree* with source node as root

<br>

<blockquote>
**if** source $\neq$ me **then**   
\ \ \ \ receive message   
**end**	   
**foreach** neighbor    
\ \ \ \ **if** neighbor has not already received message **then**   
\ \ \ \ \ \ \ \ send message to neighbor    
\ \ \ \ **end**    
**end**
	
</blockquote>

</div>

</section>

<section>
## broadcast

<img style="border:1px white" width=800 src="/images/svg/broadcast_examples.svg"></img>

</section>

<section>
## broadcast

<br>

<div align=left>
Cost of broadcast depends on network, for example

------------|------------------------------
1-D mesh 	| $T=(p-1)(t_s + t_wL)$
2-D mesh  | $T=2(\sqrt{p}-1)(t_s + t_wL)$
hypercube \ \ \ \ \ \ \ \  | $T=\log p (t_s + t_wL)$
</div>
</section>

</section>

<section>
<section>
#MPI
### building & running 
</section>

<section>
### hello mpi

```c   
#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[]) {
  MPI_Init(&argc, &argv);

  int rank, size;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &size);

  printf ("Hello from process % of %d\n", rank, size);

  MPI_Finalize();
  return 0;
}
```

</section>

<section>
# [assignment 0](/teaching/paralg/assignment0.html)

</section>

</section>


<section>
# readings

* [Parallel Computing - Blaise Barney, Lawrence Livermore National Laboratory](https://computing.llnl.gov/tutorials/parallel_comp/)

</section>
