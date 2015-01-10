# [CS 6230: Parallel Computing and High Performance Computing](/teaching/spring2015.html)

## [Schedule, Lectures Slides & Readings](/teaching/paralg/schedule.html)

## Spring 2015 - WEB L120 - MW 3-4:20pm

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

###Prerequisites & Expectations  
While there are no formal prerequisites, basic understanding of Partial differential equations, linear algebra, sequential algorithms and data structures is expected. Additionally, reasonable programming skills (preferably C/C++ or Fortran) and familiarity with Linux or Unix is also expected. The assignments/projects will be parallelized using OpenMP and MPI (Message Passing Interface).

Adherence to the CoE and SoC academic guidelines is expected. Please read the following. 

* [College of Engineering Academic Guidelines from their web page](http://www.coe.utah.edu/wp-content/uploads/pdf/faculty/semester_guidelines.pdf)
* [School of Computing Misconduct Policy Please Read](http://www.cs.utah.edu/graduate/cheating_policy)

### Workload

There will be a 2-3 programming assignments, a mid-term exam and a final project. The assignments will be based on materials discussed in class.  A tentative grade division is listed below.

	10% - class participation 
	15% - assignment #1
	15% - assignment #2
	20% - midterm
	15% - assignment #3
	25% - final project

The assignments will be a combination of theoretical problems and a programming task. Template code for the programming tasks is available on the [course github page](https://github.com/hsundar/CS6230). The programming tasks will be automatically graded. You will be awarded 60% marks for correctness of your code and the remaining 40% will be based on performance (runtime and scalability) compared to other students.

### Books and reading materials 

I shall keep adding reading materials during the semester. 

* While there are no formal books for this course, the following two books will be helpful as references.
	* Gramma et al. [Introduction to Parallel Computing](http://www-users.cs.umn.edu/~karypis/parbook/)
	* Jájá, [An introduction to Parallel Algorithms](http://www.pearsonhighered.com/educator/academic/product/0,1144,0201548569,00.html)
* [Intro to Sequential Algorithms](/teaching/bigdata/seqAlgIntro.pdf) 
* [Intro to Parallel Algorithms](/teaching/bigdata/book92-JaJa-parallel.algorithms.intro.pdf) - first chapter of Jájá's book.
* [Parallel Algorithms](/teaching/bigdata/preprint96-Blelloch.Maggs-Parallel.Algorithmcs.pdf)
* [Parallel Computing - Blaise Barney, Lawrence Livermore National Laboratory](https://computing.llnl.gov/tutorials/parallel_comp/)
* [MPI Reference](/teaching/bigdata/book96-Dongarra-MPI.The.Complete.Reference.pdf)


### Course mailing list 

We will be using google groups to communicate. Please subscribe yourself to this group, as all announcements will be made using this.

<div align=center>
<iframe id="forum_embed"
 src="javascript:void(0)"
 scrolling="no"
 frameborder="0"
 width="900"
 height="700">
</iframe>

<script type="text/javascript">
 document.getElementById("forum_embed").src =
  "https://groups.google.com/forum/embed/?place=forum/cs6230&utah.edu" +
  "&showsearch=true&showpopout=true&parenturl=" +
  encodeURIComponent(window.location.href);
</script>

</div>
