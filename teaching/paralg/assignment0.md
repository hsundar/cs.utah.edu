# [CS 6230: Parallel Computing and High Performance Computing](/teaching/spring2015.html)

## Assignment 0 

0. All code samples and job scripts are available on the [course github page](https://github.com/hsundar/CS6230). 
1. Install compilers and an MPI library ([openmpi](http://www.open-mpi.org/software/ompi/v1.8/) or [mpich](http://www.mpich.org/downloads/)) on your laptop.
2. Create accounts and get access to Kingspeak & Stampede. We will be using these machine for all our assignments and projects. Compile `hello_mpi.c` and submit a job on both Kingspeak as well as on Stampede. 

	The basic insturctions to do this on Kingspeak using the `chpc.sh` script are,

	```bash
	$ mpicc -o hello hello_mpi.c
	$ qsub chpc.sh
	```

3.  **$n$-Body Simulation** 

	Sir Isaac Newton formulated the principles governing the the motion of two particles under the influence of their mutual gravitational attraction in his famous Principia in 1687. However, Newton was unable to solve the problem for three particles. Indeed, systems of three or more particles can only be solved numerically. Write a program to simulate the motion of N particles, mutually affected by gravitational forces, and animate the results. Such methods are widely used in cosmology, plasma physics, semiconductors, fluid dynamics and astrophysics.

	

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
    