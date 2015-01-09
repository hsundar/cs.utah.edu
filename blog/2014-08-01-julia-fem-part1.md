---
title: High-order finite element implementation in Julia
excerpt: How does the performance of Julia compare to Matlab?
location: Salt Lake City, Utah
layout: sap-post
tags: [matlab, julia, fem]
---

So I have been passively following the development of [Julia][] for a while now. It sounds very promising and I hope that I can finally replace [matlab][] as my prototyping environment. In a series of blogs, I am going to port my matlab code for [high-order multigrid][homg]    to [Julia][] and compare its performance. I shall also consider the effort to parallelize the code in Julia. I plan to make small modifications to the code that should not affect the performance. 

In the first part of this series, we shall build a simple hexahedral meshing framework. The [matlab version][homg] used a simple regular grid like mesh. In this version, we shall modify this to support unstructured quad and hex meshes. This is mainly to eventually support adaptive quadtree/octree meshes. We shall start by writing a class for the reference element. 

### Reference Element &mdash; `fem.refel`   



### Mesh &mdash; `fem.mesh`

### Transform &mdash; `fem.xform`


---
[Julia]: http://julialang.org/  
[matlab]: http://www.mathworks.com/products/matlab/
[homg]: http://hsundar.github.io/homg/
