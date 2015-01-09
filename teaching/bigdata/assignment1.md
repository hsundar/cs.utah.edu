#Assignment 1 - MPI Programming 

**Due Sep 29**

In this homework, you can work in groups. No more than two students per group. Exceptions will be made only in rare circumstances. Code submission will be via github. Please [tag]() you final commit as "assignment 1" before the deadline. The TA will evaluate this version of the code. In addition, you need to submit a report as a PDF file via canvas. Please register as groups on canvas. ~~Each group member must submit the same write-up. (For logistical reasons, every member of the group must submit the homework.)~~ I will grade the report. Make sure you have enough time to work on the report. 
*Please commit code frequently as the respective users. You will be penalized for not committing code often.* 

You will use CHPC's Kingspeak cluster for all problems. Please run all programs with 1 MPI process per core. 

M = Million = $10^6$    
B = Billion = $10^9$

`$SCRATCH` = `/uufs/chpc.utah.edu/common/home/ci-water4-0/CS6965/`

#1. Distributed Sorting

Implement an parallel samplesort that has the same signature as the the
ANSI C `qsort()` routine but supports MPI parallelism. For this reason,
it should have an additional argument; the MPI communicator (e.g. `MPI_COMM_WORLD`). 
Write a driver routine called `sort` that takes one
argument, the size of array to be sorted (initialized to random integers).

On the write-up, give pseudocode for your algorithm, and report wall clock time/core/$n$
results for $n$ = 1M-100B of elements, using up to 16 nodes on Kingspeak with 1
MPI task per socket. 

Report **strong scaling** using a problem size of 1B (`long`) integers from 1-16 nodes. Report **weak scaling** using a grain size of 100M from 1-16 nodes. 

### Sorting to-from disk
Modify your code to read in the input file from scratch (`$SCRATCH/data/sort_data.dat`) using MPI-IO. Run on 16-nodes with all 256 processes reading the file in parallel and write out the final sorted array to disk in parallel as well. A smaller test file is also available on scratch for debugging purposes (`$SCRATCH/data/sort_data_debug.dat`). 

What is the disk-to-disk sort-throughput you are able to achieve? How does your implementation perform on the second dataset (`$SCRATCH/data/sort_alt_data.dat`)? If the performance is different, why does this happen? What steps (would you | did you) take to fix the issues (if they exist)?     

#2. Graph Coloring

Implement the Jones-Plassmann coloring algorithm using MPI. Use graphs from [this page](http://mat.gsia.cmu.edu/COLOR/instances.html) to test your algorithm's performance.

* What distributed data-structure did you choose for representing the graph? 
* What is the best I/O strategy for reading such graphs from disk?
* Are you able to get the optimal coloring (in terms of number of colors) for a representative set of graphs? 
* Report strong scalability using different graphs from 1-16 nodes. How sensitive is the scalability to the type of graphs (number of vertices, edges and colors)? Report and **explain** scalability for **at least** the following graphs:
	* le450_5a.col (450,5714), 5
	* le450_15b.col (450,8169), 15
	* le450_25a.col (450,8260), 25
	* DSJC1000.9.col.b (1000,898898)
	* flat1000_76_0.col.b (1000,246708), 76     
* Report weak scalability using different graphs from 1-16 nodes. Choose graphs from the list that have the same optimal coloring (either listed or numerically computed) with different number of nodes/vertices that are roughly equal to the ideal weak scaling sizes. 


#3. Maximum Subarray Sum

You are given a one dimensional array that may contain both positive and negative integers, find the sum of contiguous subarray of numbers which has the largest sum.

For example, if the given array is $[-2, -5, \underline{6}, \underline{-2}, \underline{-3}, \underline{1}, \underline{5}, -6]$, then the maximum subarray sum is 7 (underlined numbers).

**Input**: A distributed array of doubles of size $n$ (generate randomly $\in (-100, 100)$).

* Consider the sequential complexity to compute the maximum subarray sum? Can you design a divide & conquer algorithm to compute the sum in $\mathcal{O}(n\log n)$? Can you compute the sum in $\mathcal{O}(n)$?
* **Parallelization**: Write the pseudocode for the parallel versions of the divide & conquer algorithm. Is it possible to have a parallel (distributed memory) implementation of the $\mathcal{O}(n)$ algorithm? If so, write the pseudocode.
* (**extra credit**) Implement the best parallel algorithm for the maximal subarray problem in MPI and analyze its performance.         