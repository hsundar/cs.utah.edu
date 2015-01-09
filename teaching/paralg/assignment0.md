#CS 6230: Parallel Computing and High Performance Computing

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

	**The physics**. We review the equations governing the motion of the particles according to Newton's laws of motion and gravitation. Don't worry if your physics is a bit rusty; all of the necessary formulas are included below. We'll assume for now that the position $(p_x, p_y)$ and velocity $(v_x, v_y)$ of each particle is known. In order to model the dynamics of the system, we must know the net forces exerted on each particle.

	**Pairwise force**. Newton's law of universal gravitation asserts that the strength of the gravitational force between two particles is given by the product of their masses divided by the square of the distance between them, scaled by the gravitational constant $G$, which is $6.67 \times 10^{-11} N m^2 / kg^2$. The pull of one particle towards another acts on the line between them. Since we are using Cartesian coordinates to represent the particles, it is convenient to break up the force into its $x$ and $y$ components $(F_x, F_y)$ as illustrated below.

	**Net force**. The principle of superposition says that the net force acting on a particle in the $x$ or $y$ direction is the sum of the pairwise forces acting on that particle in that direction. 

	**Acceleration**. Newton's second law of motion postulates that the accelerations in the $x$ and $y$ directions are given by: $a_x = F_x / m, a_y = F_y / m.$

	*The numerics*.  We use the leapfrog finite difference approximation scheme to numerically integrate the above equations: this is the basis for most astrophysical simulations of gravitational systems. In the leapfrog scheme, we discretize time, and increment the time variable $t$ in increments of the time quantum $\Delta t$. We maintain the position and velocity of each particle, but they are half a time step out of phase (which explains the name leapfrog). The steps below illustrate how to evolve the positions and velocities of the particles.

	1. Calculate the net force acting on each particle at time $t$ using Newton's law of gravitation and the principle of superposition.
	2. For each particle:
		1. Calculate its acceleration $(a_x, a_y)$ at time $t$ using its force at time $t$ and Newton's second law of motion.
		2. Calculate its velocity at time $t + \Delta t / 2$ by using its acceleration at time t and its velocity $(v_x, v_y)$ at time $t - \Delta t / 2$. 	Assume that the acceleration remains constant in this interval, so that the updated velocity is:   $v_x = v_x + \Delta t a_x$, and  $v_y = v_y + \Delta t a_y$.
		3. Calculate its position at time $t + \Delta t$ by using its velocity at time $t + \Delta t / 2$ and its position at time $t$. Assume that the velocity remains constant in the interval from $t$ to $t + \Delta t$, so that the resulting position is given by $p_x = p_x + \Delta t v_x$, and $p_y = p_y + \Delta t v_y$. Note that because of the leapfrog scheme, the constant velocity we are using is the one estimated at the middle of the interval rather than either of the endpoints.
	3. Draw each particle.

	As you would expect, the simulation is more accurate when $\Delta t$ is very small, but this comes at the price of more computation. Use $\Delta t = 25000$ for a reasonable tradeoff.