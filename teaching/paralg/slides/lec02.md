---
title: CS6230: HPC & Parallel Algorithms
theme: white
---

<section>
# Parallel Programming
</section>

<!-- New Section -->
<section>
  
<section>
# parallel programming paradigms
</section>

<section>
## parallel programming paradigms

<br>

* Functional languages
* Parallelizing compilers
* Object parallel
* Data parallel
* Shared memory
* Remote memory access
* Message passing
  
</section>

<section>
## functional languages

<br>

* express **what to compute** (i.e., mathematical relationships
  to be satisfied), but not how to compute it or order in which
  computations are to be performed
* avoid artificial serialization imposed by imperative
  programming languages
* avoid storage references, side effects, and aliasing that
  make parallelization difficult
* permit full exploitation of any parallelism inherent in
  computation  
</section>

<section>
## functional languages

<br> 

* often implemented using dataflow, in which operations fire
whenever their inputs are available, and results then
become available as inputs for other operations
* tend to require substantial extra overhead in work and
storage, so have proven difficult to implement efficiently
* have not been used widely in practice, though numerous
experimental functional languages and dataflow systems
have been developed
</section>

<section>
## parallelizing compilers  

<br>

* automatically parallelize programs written in conventional
sequential programming languages
* difficult to do for arbitrary serial code
* compiler can analyze serial loops for potential parallel
execution, based on careful dependence analysis of
variables occurring in loop
* user may provide hints (directives ) to help compiler
determine when loops can be parallelized and how
* OpenMP is a standard for compiler directives

</section>

<section>
## parallelizing compilers

<br>

* automatic or semi-automatic, loop-based approach has
been most successful in exploiting modest levels of
concurrency on shared-memory systems
* many challenges remain before effective automatic
parallelization of arbitrary serial code can be routinely
realized in practice, especially for massively parallel,
distributed-memory systems
* parallelizing compilers can produce efficient “node code”
for hybrid architectures with SMP nodes, thereby freeing
programmer to focus on exploiting parallelism across
nodes
</section>

<section>
## data parallel   

<br>

* simultaneous operations on elements of data arrays,
typified by vector addition
* low-level programming languages, such as Fortran 77 and
C, express array operations element by element in some
specified serial order
* array-based languages, such as APL, Fortran 90, and
MATLAB, treat arrays as higher-level objects and thus
facilitate full exploitation of array parallelism

</section>

<section>
## data parallel 

<br>

* data parallel languages provide facilities for expressing
array operations for parallel execution, and some allow
user to specify data decomposition and mapping to
processors
* High Performance Fortran (HPF) is most visible attempt to
standardize the data parallel approach to programming
* though naturally associated with SIMD architectures, data
parallel languages have also been implemented
successfully on general MIMD architectures
* data parallel approach can be effective for highly regular
problems, but tends to be too inflexible to be effective for
irregular or dynamically changing problems  
</section>

<section>
## shared memory

* classic shared-memory paradigm, originally developed for
multitasking operating systems, focuses on control
parallelism rather than data parallelism
* multiple processes share common address space
accessible to all, though not necessarily with uniform
access time
* because shared data can be changed by more than one
process, access must be protected from corruption,
typically by some mechanism to enforce mutual exclusion
* shared memory supports common pool of tasks from
which processes obtain new work as they complete
previous tasks
  
</section>

<section>
## shared memory

<br>

* most naturally and efficiently implemented on true
shared-memory architectures, such as SMPs
* can also be implemented with reasonable efficiency on
NUMA (nonuniform memory access) shared-memory or
even distributed-memory architectures, given sufficient
hardware or software support
* with nonuniform access or distributed shared memory,
efficiency usually depends critically on maintaining locality
in referencing data, so design methodology and
programming style often closely resemble techniques for
exploiting locality in distributed-memory systems
  
</section>

<section>
## remote memory access

<br>

* one-sided, **put** and **get** communication to store data in or
fetch data from memory of another process
* does not require explicit cooperation between processes
* must be used carefully to avoid corruption of shared data
* included in MPI-2, to be discussed later  
</section>

<section>
## message passing 

<br>

* two-sided, **send** and **receive** communication between
processes
* most natural and efficient paradigm for distributed-memory
systems
* can also be implemented efficiently in shared-memory or
almost any other parallel architecture, so it is most portable
paradigm for parallel programming
* fits well with our design philosophy and offers great
flexibility in exploiting data locality, tolerating latency, and
other performance enhancement techniques
  
</section>

<section>
## message passing

<br>

* provides natural synchronization among processes
(through blocking receives, for example), so explicit
synchronization of memory access is unnecessary
* facilitates debugging because accidental overwriting of
memory is less likely and much easier to detect than with
shared-memory
* sometimes deemed tedious and low-level, but thinking
about locality tends to result in programs with good
performance, scalability, and portability
* dominant paradigm for developing portable and scalable
applications for massively parallel systems

</section>

</section>
<!-- New Section -->
<section>

<section>
# MPI
## Message Passing Interface
</section>

<section>
## mpi

<br>

* provides communication among multiple concurrent
processes
* includes several varieties of point-to-point communication,
as well as collective communication among groups of
processes
* implemented as library of routines callable from
conventional programming languages such as Fortran, C,
and C++
* has been universally adopted by developers and users of
parallel systems that rely on message passing
</section>

<section>
## mpi

<br>

* closely matches computational model underlying our
design methodology for developing parallel algorithms and
provides natural framework for implementing them
* although motivated by distributed-memory systems, works
effectively on almost any type of parallel system
* often outperforms other paradigms because it enables and
encourages attention to data locality  
</section>

<section>
## mpi

<br>

* includes more than 125 functions, with many different
options and protocols
* small subset suffices for most practical purposes
* we will cover just enough to implement algorithms we will
consider
* in some cases, performance can be enhanced by using
features that we will not cover in detail
  
</section>

<section>
## mpi

<br>

the MPI standard has evolved over the years, MPI-1, MPI-2 and MPI-3    
    
**Features of MPI-1 include**

* point-to-point communication
* collective communication
* process groups and communication domains
* virtual process topologies
* bindings for Fortran and C  
</section>

<section>
## mpi 
### building & running

<br>

### mpicc

<br>

### mpirun  
</section>

<section>
# think SPMD
</section>

<section>
## groups & communicators

<br>

* every MPI process belongs to one or more **groups**
* each process is identified by its **rank** within given group
* rank is an integer from zero to one less than the **size** of group
  (`MPI_PROC_NULL` is the rank of no process)
* initially, all processes belong to `MPI_COMM_WORLD`
* additional groups can be created by user
* the same process can belong to more than one group
* viewed as a communication domain or context, a group of
processes is called a **communicator**  
</section>

<section>
## specifying messages

<br>

<div align=left>
#### information necessary to specify message and identify its source or destination in MPI include

* **`buf`**: location in memory where message data begins
* **`count`**:  number of data items contained in message
* **`datatype`**: type of data in message
* **`source`** or **`dest`**: rank of sending or receiving process in communicator
* **`tag`**: identifier for specific message or kind of message
* **`comm`**: communicator  
</div>

</section>

<section>
## mpi datatypes

<br>

* available MPI data types include
    * C: `char`, `int`, `float`, `double`
    * `MPI_CHAR`, `MPI_INT`, `MPI_DOUBLE`
* use of MPI data types facilitates heterogeneous
  environments in which native data types may vary from
  machine to machine noncontiguous data  
* also supports user-deﬁned data types for contiguous or non-contiguous data
</section>

<section>
## minimal mpi

<br>

#### minimal set of six MPI functions we will need

```c
// Initiates use of MPI
int MPI_Init(int *argc, char ***argv);

// Concludes use of MPI
int MPI_Finalize(void);

// On return, size contains number of processes in comm
int MPI_Comm_size(MPI_Comm comm, int *size);

// On return, rank contains rank of calling process in comm
int MPI_Comm_rank(MPI_Comm comm, int *rank);

// On return, msg can be reused immediately
int MPI_Send(void *msg, int count, MPI_Datatype datatype, 
             int dest, int tag, MPI_Comm comm);

// On return, msg contains requested message
int MPI_Recv(void *msg, int count, MPI_Datatype datatype, 
            int source, int tag, MPI_Comm comm, MPI_Status *status);

```
</section>

<section>
## example: 1D Laplace

```c
#include <mpi.h>
int main(int argc, char **argv) {
  int k, p, me, left, right, count = 1, tag = 1, nit = 10;
  float ul, ur, u = 1.0, alpha = 1.0, beta = 2.0;
  MPI_Status status;
  MPI_Comm comm = MPI_COMM_WORLD;
  MPI_Init(&argc, &argv);
  MPI_Comm_size(comm, &p);
  MPI_Comm_rank(comm, &me);
  left = me-1; right = me+1;
  if (me == 0) ul = alpha; if (me == p-1) ur = beta;

  for (k = 1; k <= nit; k++) { ...
    
  }
  MPI_Finalize();
  
  return 0;
}
```
</section>

<section>
## example: 1D Laplace

```c
for (k = 0; k < nit; ++k) {
  if (me % 2 == 0) {
    if (me > 0) 
      MPI_Send(&u, count, MPI_FLOAT, left, tag, comm);
    if (me < p-1) 
      MPI_Send(&u, count, MPI_FLOAT, right, tag, comm);
    if (me < p-1) 
      MPI_Recv(&ur, count, MPI_FLOAT, right, tag, comm, &status);
    if (me > 0) 
      MPI_Recv(&ul, count, MPI_FLOAT, left, tag, comm, &status);
  } else {
    if (me < p-1) 
      MPI_Recv(&ur, count, MPI_FLOAT, right, tag, comm, &status);
    if (me > 0) 
      MPI_Recv(&ul, count, MPI_FLOAT, left, tag, comm, &status);
    if (me > 0)  
      MPI_Send(&u, count, MPI_FLOAT, left, tag, comm);
    if (me < p-1) 
      MPI_Send(&u, count, MPI_FLOAT, right, tag, comm);
  } 
  u = (ul+ur)/2.0;    
}
```
</section>

<section>
## standard send & recv functions

<br>

* standard send and receive functions are blocking,
meaning they do not return until resources speciﬁed in
argument list can safely be reused
* in particular, `MPI_Recv` returns only after receive buffer
contains requested message
* `MPI_Send` may be initiated before or after matching
`MPI_Recv` initiated
* depending on speciﬁc implementation of MPI, `MPI_Send`
may return before or after matching `MPI_Recv` initiated
  
</section>

<section>
## standard send & recv functions

<br>

* for same `source`, `tag`, and `comm`, messages are
received in order in which they were sent
* wild card values `MPI_ANY_SOURCE` and `MPI_ANY_TAG`
can be used for `source` and `tag`, respectively, in receiving
message
* actual source and tag can be determined from
`MPI_SOURCE` and `MPI_TAG` ﬁelds of `status` structure returned by `MPI_Recv`
</section>

<section>
## other mpi functions

<br>

* MPI functions covered thus far sufﬁce to implement almost
any parallel algorithm with reasonable efﬁciency
* dozens of other MPI functions provide additional
convenience, flexibility, robustness, modularity, and
potentially improved performance
* but they also introduce substantial complexity that may be
difﬁcult to manage
* for example, some facilitate overlapping of communication
and computation, but place burden of synchronization on
user  
</section>

<section>
## communication modes for sending messages

<br>

* **buffered mode** : send can be initiated whether or not
matching receive has been initiated, and send may
complete before matching receive is initiated
* **synchronous mode** : send can be initiated whether or not
matching receive has been initiated, but send will complete
only after matching receive has been initiated
* **ready mode** : send can be initiated only if matching receive
has already been initiated
* **standard mode** : may behave like either buffered mode or
synchronous mode, depending on speciﬁc implementation
of MPI and availability of memory for buffer space  
</section>

<section>
## functions for various modes

<br>

<div align=center>

Mode | Blocking \ \ \ \ \ \  | Non-Blocking
-----|----------|--------------
standard | `MPI_Send`  | `MPI_Isend`
buffered | `MPI_Bsend` | `MPI_Ibsend`
synchronous \ \ \ \  | `MPI_Ssend` | `MPI_Issend`
ready  | `MPI_Rsend` | `MPI_Irsend`

</div>

<br>

* `MPI_Recv` and `MPI_Irecv` are blocking and nonblocking
functions for receiving messages, regardless of mode
* `MPI_Buffer_attach` used to provide buffer space for buffered mode  
  
</section>

<section>
## communication modes

<br>

* nonblocking functions include **request** argument used
subsequently to determine whether requested operation
has completed
* nonblocking is different from **asynchronous**
* `MPI_Wait` and `MPI_Test` wait or test for completion of
nonblocking communication
* `MPI_Probe` and `MPI_Iprobe` probe for incoming
message without actually receiving it
* information about message determined by probing can be
used to decide how to receive it
* `MPI_Cancel` cancels outstanding message request,
useful for cleanup at end of program or after major phase
of computation
  
</section>

<section>
## standard mode

<br>

* standard mode does not specify whether messages are
buffered
* buffering allows more flexible programming, but requires
additional time and memory for copying messages to and
from buffers
* given implementation of MPI may or may not use buffering
for standard mode, or may use buffering only for messages
within certain range of sizes
* to avoid potential deadlock when using standard mode,
portability demands conservative assumptions concerning
order in which sends and receives are initiated
* user can exert explicit control by using buffered or
synchronous mode  
</section>

<section>
## persistent communication 

<br>

* communication operations that are executed repeatedly
with same argument list can be streamlined
* persistent communication binds argument list to a request,
and then the request can be used repeatedly to initiate and
complete message transmissions without repeating
argument list each time
* once an argument list has been bound using
`MPI_Send_init` or `MPI_Recv_init` (or similarly for
other modes), then request can subsequently be initiated
repeatedly using `MPI_Start`  
</section>

<section>
# collective communications

<br>

* `MPI_Bcast`
* `MPI_Alltoall`
* `MPI_Allgather`
* `MPI_Scatter`
* `MPI_Gather`

---

* `MPI_Reduce`
* `MPI_Allreduce`
* `MPI_Scan`

---

* `MPI_Barrier`\ \ \ \ \ 


</section>

<section>
## manipulating communicators

<br>

* `MPI_Comm_create`
* `MPI_Comm_dup`
* `MPI_Comm_split`
* `MPI_Comm_compare`
* `MPI_Comm_free`  
</section>

<section>
## virtual process topologies

<br>

* MPI provides virtual process topologies corresponding to
regular Cartesian grids or more general graphs
* topology is an optional additional attribute that can be given
to a communicator
* virtual process topology can facilitate some applications,
such as 2-D grid topology for matrices or 2-D or 3-D grid
topology for discretized PDEs
* virtual process topology may also help MPI achieve more
efﬁcient mapping of processes to given physical network  
</section>

<section>
## virtual process topologies

<br>

* `MPI_Dist_graph_create` creates general graph
topology, based on number of nodes, node degrees, and
graph edges speciﬁed by user
* `MPI_Cart_create` creates Cartesian topology based on
number of dimensions, number of processes in each
dimension, and whether each dimension is periodic (i.e.,
wraps around), as speciﬁed by user
* hypercubes are included, since a $k$-dimensional hypercube
is simply a $k$-dimensional torus with two processes per
dimension
* `MPI_Cart_shift` provides shift of given displacement
along any given dimension of Cartesian topology  
</section>

<section>
## virtual process topologies

<br>

* `MPI_Topo_test` determines what type of topology, if any,
has been deﬁned for given communicator
* inquiry functions provide information about existing graph
topology, such as number of nodes and edges, lists of
degrees and edges, number of neighbors of given node, or
list of neighbors of given node
* inquiry functions obtain information about existing
Cartesian topology, such as number of dimensions,
number of processes for each dimension, and whether
each dimension is periodic
* functions also available to obtain coordinates of given
process, or rank of process with given coordinates
  
</section>

</section>
<!-- New Section -->
<section>

<section>
## self test questions

<br>

#### Make sure you know how to write and run these programs:

1. MPI Hello world
2. Use nonblocking send and receive in MPI Laplace 1-D 
  example. Do you need the \ \ \  `if (me % 2 == 0)` \ \ \  test? Why or why not?
3. Eliminate conditional tests by using `MPI_PROC_NULL` in
the Laplace 1-D example
4. In the Laplace 1-D example, let each process have $m$ points
instead of one point. How does example change?
5. In the Laplace 1-D example, with each process having $m$ points, 
modify to overlap communication with computation.
</section>

<section>  
## [Next Lecture](/teaching/paralg/slides/lec03.html)
</section>

</section>
