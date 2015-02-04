---
title: Introduction to MPI Programming
excerpt: A quick introduction to MPI programming, targetting my [Spring 2015 class](/teaching/spring2015.html)
location: Salt Lake City, Utah
layout: sap-post
tags: [mpi] [parallel]
---

This is meant to be a quick introduction to [MPI](http://en.wikipedia.org/wiki/Message_Passing_Interface). I will assume basic knowledge of C/C++ programming and some familiarity with a \*nix shell. 

MPI is a language-independent communications API that is used to program parallel computers. Primarily these are distributed-memory machines although MPI can be used to obtain good performance on shared-memory machines as well. MPI follows the SPMD (Single Program, Multiple Data) paradigm, wherein the user writes a single program that runs on all distributed **nodes**, each operating on a different chunk of data. This allows the same code to run on a single machine/node as well as on thousands. MPI requires the program (executable) to be launched on every node. We refer to this as an mpi task. This is done using the command `mpirun` or `mpiexec` with the user specifying the total number of tasks desired. Here is an example where the user launches the program `hello` using 8 mpi tasks.

```sh
 $ mpirun -np 8 ./hello
```

Common cases for the number of mpi tasks to be launched are,

* 1 mpi task per node: in this case we might use [OpenMP]([OpenMP](http://www.openmp.org/)) to acheive shared memory parallelism within the node.
* 1 mpi task per core: in this case, we assume all cores are equivalent and use mpi to acheive shared-memory as well as distributed memory parallelism.

## hello mpi

Let us now consider your first mpi program---hello world. Every mpi program needs to start with an `MPI_Init` function and end with a `MPI_Finalize` function. `MPI_Init` initializes the mpi execution environment on all processes and `MPI_Finalize` terminates and cleans up.  The MPI standard does not say what a program can do before an `MPI_Init` or after an `MPI_Finalize`. In general, you should do as little as possible. In particular, avoid anything that changes the external state of the program, such as opening files, reading standard input or writing to standard output. Once initialized, you have access to the **world** communicator---`MPI_COMM_WORLD`, basically a communicator spanning all the mpi tasks you requested via `mpirun`. So, lets take a look at `hello_mpi.c`,

~~~ {.c} 
/* hello_mpi.c */
#include <stdio.h>
#include <mpi.h>

int main(int argc, char* argv[]) {
  MPI_Init(&argc, &argv);
  
  int rank, size;
  
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &size);
  
  printf ("Hello from process %d of %d\n", rank, size);
  
  MPI_Finalize();
  return 0;
}
~~~

Lets look at this carefully. We first include the header files, in most cases you will only need to include `mpi.h`. We pass the arguments to the program to `MPI_Init` so that mpi can use this to initialize the environment. Typically the argument list is modified by `mpirun` or the batch process on the clusters and used to provide for example a list of hosts that are taking part in the computation. You pass pointers to `argc` and `argv` as `MPI_Init` will remove all the mpirun-related arguments, so that you can parse your program arguments as you would have for a sequential program. Although as of MPI-2, `MPI_Init` will accept `NULL` as input parameters, I strongly urge you not to do so. 

Once, we have initialized mpi, we can query for the size---the number of tasks in the communicator--and the rank---the id of this particular task. Remember that since `rank` is a local variable, different tasks will have a different rank. These functions are appropriately named `MPI_Comm_rank` and `MPI_Comm_world`. Both functions take a communicator of type `MPI_Comm` as the first argument. Although we have used the world communicator, `MPI_COMM_WORLD`, this can be any communicator, as we will shortly see. `MPI_COMM_WORLD` is available to you anywhere in your program (as long as it is between `MPI_Init` and `MPI_Finalize`). You will have to manage any other (sub)communicators that you manually create. The last part of the `hello_mpi` program is to print the rank and size of the processes. Remember we will get a `printf` from every mpi task, so this is not a very good idea if we use a lot of mpi tasks. While debugging, we will use `printf` to print debugging information, but one needs to be careful to print from only one task---typically the root, like this:

``` c
if (!rank) printf ("Hello from %d task\n", size);
```

## compiling & running 

Most mpi implementations provide wrappers to stand compilers to ease the compilation process. Typical examples are `mpicc` and `mpicxx` for the C and C++ compilers. It is very easy to use these wrappers to build our code---similar to how we would have used say `gcc` to build our sequential C code. As explained before, we can use `mpirun` to run out program. Here is an example.

```sh
$ mpicc -o hello_mpi hello_mpi.c
$ mpirun -np 4 ./hello_mpi
Hello from process 0 of 4
Hello from process 2 of 4
Hello from process 3 of 4
Hello from process 1 of 4
```

### submitting batch jobs on clusters

Launching our job using `mpirun` from the command line is not a scalable option for large HPC clusters. We instead use a batch environment where users submit job requests via special scripts and a centralized scheduler allocates requested resources and launches the job. We take the example of [Simple Linux Utility for Resource Management - SLURM](https://computing.llnl.gov/linux/slurm/). Here is an example script (`hello.sh`) for launching our `hello_mpi` program using 32 mpi tasks across 2 nodes.

```bash
#!/bin/bash
#SBATCH -J hello           # job name
#SBATCH -o hello.o%j       # output and error file name (%j expands to jobID)
#SBATCH -N 2 -n 32         # total number of mpi tasks requested - 2 nodes, 32 tasks
#SBATCH -p normal          # queue (partition) -- normal, development, etc.
#SBATCH -t 01:30:00        # run time (hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=username@tacc.utexas.edu   # email address for notification
#SBATCH --mail-type=begin  # email me when the job starts
#SBATCH --mail-type=end    # email me when the job finishes

ibrun ./hello_mpi              # run the MPI executable named hello_mpi
```

Depending on how the cluster is setup, the final line might use `mpirun` instead of `ibrun`. Note that we do not specify the number of mpi tasks as an argument to `ibrun` or `mpirun` in this case. Slurm takes care of this for us based on the arguments specified via the `-N` and `-n` flags. Submitting the job is done via the `sbatch` command. Check the [slurm website](https://computing.llnl.gov/linux/slurm/) for additional commands to manage the job.

```bash
$ sbatch hello.sh
```
## send & recv

The basic communication constructs in message passing are `send_to` and `recv_from`. In MPI blocking and non-blocking versions of these are available and are the most common choices. The functions for the blocking variety are,

```c
int MPI_Send(void *buf, int count, MPI_Datatype datatype, int dest, int tag, MPI_Comm comm);
```

As is common in MPI, the buffer which contains the data is commonly a contiguous array of length (at least) `count` of elements of type `datatype`. The datatype is specified using in built MPI_Datatype or custom one. Standard types include 

```c
MPI_CHAR
MPI_UNSIGNED_CHAR
MPI_INT
MPI_UNSIGNED_INT
MPI_LONG
MPI_UNSIGNED_LONG
MPI_FLOAT
MPI_DOUBLE
MPI_COMPLEX
```

The full list can be found in `mpi.h`. We will consider user specified `MPI_Datatype`s later. 

The next argument to `MPI_Send` specifies the rank of the destination process, i.e., the process to whom we wish to send the data in `buf`. The `tag` argument is an optional identifier useful in cases where multiple `MPI_Send`s might be issued by the same process to the same destination and is useful to differentiate these. The final argument is the communicator, i.e., the context in which this communication takes place. Specifically, it allows us to map the rank of the destination to a specific task. We will discuss communicators in detail in the following section. The corresponding `MPI_Recv` function looks very similar, expect for an additional status argument. This is useful to check the status of the communication, but we will ignore this for the time being. 

```c
int MPI_Recv(void *buf, int count, MPI_Datatype datatype, int source, int tag, MPI_Comm comm, MPI_Status *status);
```

With this knowledge, we can perform a simple data exchange. Let us assume that we want every even process to send an integer to the preceding even process.

```c
double u_i, u_im1, u_ip1;
MPI_Status status;

int val = 2*rank;
if (rank % 2) {
  // odd proc
  MPI_Send(&val, 1, MPI_INT, rank-1, 1, MPI_COMM_WORLD);
} else {
  // even 
  MPI_Recv(&val, 1, MPI_INT, rank+1, 1, MPI_COMM_WORLD, &status);
}  

```  

The other variants that are of most interest are the non-blocking versions, `MPI_Isend` and `MPI_Irecv`. Both of these take an additional argument `MPI_Request *request`, this is needed to wait for these to finish. You can wait for these use `MPI_Wait(MPI_Request *request, MPI_Status *status)`. You can mix and match the blocking and non-blocking version of these functions. Let us now consider the 1D Laplacian example we discussed in class. 

<div align=center>
<img style="border:1px white" width=600 src="/images/svg/laplace1d.svg"></img>
</div>

Here is the MPI version for the same code.

```c
// initialize u_i
double u_i=0.0, u_ip1, u_im1;

if (rank == 0) 
  u_im1 = alpha;
else if (rank == n)
  u_ip1 = beta;
  
MPI_Request r1, r2;
MPI_Status s1, s2;  
  
while (err < tolerance) {
  if (i>1) 
    MPI_Isend(&u_i, 1, MPI_DOUBLE, i-1, -1, MPI_COMM_WORLD, &r1);
  if (i<n) 
    MPI_Isend(&u_i, 1, MPI_DOUBLE, i+1, +1, MPI_COMM_WORLD, &r2);
  if (i<n) 
    MPI_Recv(&u_ip1, 1, MPI_DOUBLE, i+1, -1, MPI_COMM_WORLD, &s1);
  if (i>1) 
    MPI_Recv(&u_im1, 1, MPI_DOUBLE, i-1, +1, MPI_COMM_WORLD, &s2);
  
  MPI_Wait(&r1, &s1);
  MPI_Wait(&r2, &s2);

  u_i = (u_im1 + u_ip1)/2;
  err = compute_error()
}
```

**Please implement the simple 1D Laplacian example in its entirety.*** 


In many cases, the communications are (mostly) symmetrical. In such cases, it is easier to use `MPI_Sendrecv`. This is a blocking call and takes the following arguments.

```c
int MPI_Sendrecv(const void *sendbuf, int sendcount, MPI_Datatype sendtype, int dest, int sendtag,
void *recvbuf, int recvcount, MPI_Datatype recvtype, int source, int recvtag,
MPI_Comm comm, MPI_Status *status)
```

## communicators 

Now that we have the basics out of the way, lets look a bit more closely at communicators. 



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
  
