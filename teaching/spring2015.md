#CS 6230: Parallel Computing and High Performance Computing

**Spring 2015**

This course is structured to train students to reason about the design and implementation of efficient parallel
programs. The focus areas of the class will be on the modeling, implementation and evaluation of distributed,
message-passing interface (MPI) based programs, shared-memory thread-based OpenMP programs, and hybrid (MPI/OpenMP) programs. Almost all examples will be aligned with numerical scientific computing. This course is appropriate for those that want transform serial algorithms into parallel algorithms, want to modify currently existing parallel algorithms, or want to write parallel algorithms from scratch.

Here is a tentative outline of topics.

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

The schedule of the lectures, slides and reading material is available here - [Lectures & Readings](/teaching/paralg/schedule.html)

###Prerequisites & Expectations  
While there are no formal prerequisites, basic understanding of Partial differential equations, linear algebra, sequential algorithms and data structures is expected. Additionally, reasonable programming skills (preferably C/C++ or Fortran) and familiarity with Linux or Unix is also expected. The assignments/projects will be parallelized using OpenMP and MPI (Message Passing Interface).

### Workload

There will be a two programming assignments, a mid-term exam, a final project and a final exam. The assignments will be based on materials discussed in class.  A tentative grade division is listed below.

	10% - class participation (+ assignment #0)
	15% - assignment #1
	15% - assignment #2
	20% - midterm
	15% - assignment #3
	25% - final project

The assignments will be a combination of theoretical problems and a programming task. Template code for the programming tasks is available on the [course github page](https://github.com/hsundar/CS6230). The programming tasks will be automatically graded. You will be awarded 60% marks for correctness of your code and the remaining 40% will be based on performance (runtime and scalability) compared to other students. 
