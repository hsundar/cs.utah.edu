# [CS 6230: Parallel Computing and High Performance Computing](/teaching/spring2015.html)

## Assignment 0 

0. All code samples and job scripts are available on the [course github page](https://github.com/hsundar/CS6230). 
1. Install compilers and an MPI library ([openmpi](http://www.open-mpi.org/software/ompi/v1.8/) or [mpich](http://www.mpich.org/downloads/)) on your laptop.
2. Create accounts and get access to [Tangent][] & [Stampede][]. We will be using these machine for all our assignments and projects. 
		* Read the basic documentation for [Tangent][] as well as [Stampede][]
		* Compile `hello_mpi.c` and submit a job on both machines. 
3. Write a simple MPI program that does the following,

	* generate a random integer array, with 100 elements per process, on all processes. **hint**: initialize the RNG using some function of the rank of the process.
	* broadcast one value (say the first) from the *root* (rank 0 or any process really) to all other processes. lets call this the **pivot**.  
```c
int root = 0;
int pivot = array[0];
MPI_Bcast( &pivot, 1, MPI_INT, root, MPI_COMM_WORLD );
```

	* on each process compute how many elements are less than the pivot.
	* Now *reduce* to obtain the total number of elements (globally) less than the pivot. Reduce to receive the result on the root and print it out.
```c
int localLessThan, globalLessThan;
MPI_Reduce(&localLessThan, &globalLessThan, 1, MPI_INT, MPI_SUM, root, MPI_COMM_WORLD);
```
	
	* run on [Tangent][] & [Stampede][] with increasing values of $p$, i.e., the number of processes. Since we are fixing the number of elements per process to 100, this is a weak scalability experiment. What can you infer about the complexity of `MPI_Reduce`? Time only the reduction.   

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
