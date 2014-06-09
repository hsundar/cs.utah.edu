---
title: Octrees in Haskell
excerpt: actually kD-tree abstractions of octrees implemented in Haskell. 
location: Austin, Texas
layout: sap-post
tags: [haskell, octree]
---

While exploring algorithms for constructing and balancing $k$D-trees, I decided to implement in Haskell. For those of you who dont know, [Haskell][] is a purely-functional programming language. 

Lets first implement a structure to store a $d$-dimensional node. Here the `anchor` is the $d$ dimensional array that holds the coordinate of the lowest corner. We also store the `depth` of the node as well as the maximum allowed depth, the `maxDepth` which by convention we choose to be $2^n - 1$.
```haskell
-- Node with Morton Ordering 
data Node   = Node {
  anchor    :: [Int] ,
  depth     ::  Int  ,
  maxDepth  ::  Int
} deriving (Show, Eq)
```	
We also define a comparison function for `Node`. Here the first case is for the case when the two nodes are identical, the second for the case when the anchors are the same; in which case we compare their respective `depth`s masked (using the bitwise and operator `.&.`) with `maxDepth`.
```haskell
-- comparison 
instance Ord Node where 
  compare (Node a1 d1 m1) (Node a2 d2 m2) 
    | a1 == a2 && d1 == d2 && m1 == m2  = EQ
    | a1 == a2   = (d1 .&. m1) `compare` (d2 .&. m2)
    | otherwise  = let maxC = head $ foldl dom_dim [] $ zipWith xor a1 a2
                       in (a1 !! maxC) `compare` (a2 !! maxC)
```
The final case is where the magic happens and it illustrates the power of functional languages like [Haskell][]. First we `xor` the `a1` and `a2` along each dimensions, to figure out by which bits they differ along each dimension. We `fold` over this array using the helper function `dom_dim`, that determines the dominant dimension. The head of the resulting folded array contains the index of the dominant dimension, which is then used to compare `a1` and `a2`.
```haskell
-- helper function 
dom_dim :: [Int] -> Int -> [Int] 
dom_dim [] x          = [0,x]
dom_dim (p:x:[]) y    = if (y<x && (xor y x) >= y)
                        then [p,x]
                        else [(p+1),y]
dom_dim _ _           = error "Incorrect use of dom_dim"
```

We also define a `root` constructor, that generates a $\{0\}^d$ anchor, with `depth` 0 and a user specified `maxDepth`.
```haskell
-- convenience root nodes 
root :: Int -> Int -> Node
root 0 _    = error "Node dimension cannot be zero"
root dim md   = Node (replicate dim 0) 0 md
```

In order to construct the octree from a set of points, we first define some helper functions. The first, `which_child` takes a Node, $N$, and a 
point, $p\in\Re^d$, as arguments and returns the child-node of the $N$, that contains $p$. Note that the strong-typing of [Haskell][] will ensure that $N$ is a $d$-dimensional `Node`. 
  
```haskell
-- returns the child octant which contains the given point
which_child :: Node -> [Double] -> Node
which_child n []  = n
which_child (Node a d md) ps = Node (zipWith lambda a ps) (d+1) md
  where lambda i x =  if floor(x*2^md) >= i+2^(md-d-1) then i + 2^(md-d-1) else i
```	

```haskell
split_nd :: Node -> [[Double]] -> Map Node [[Double]]
split_nd oct ps = M.fromListWith (++) [(lambda p, [p]) | p <- ps]
  where lambda p = which_child oct p
```
```haskell
-- subdivide an octant using points -- till maxDepth
subdivide :: Node -> [[Double]] -> [Node]
subdivide o ps = M.foldrWithKey fold_function [] $ split_nd o ps
  where fold_function oc pss ns
          | length pss == 1       = ns ++ [oc]
          | otherwise             = ns ++ (subdivide oc pss)
```
and now finally,
```haskell
-- build quadtree from list of points 
build_tree :: [[Double]] -> Int -> [Node]
build_tree ps md = subdivide (root (length $head ps) md) ps
```

[Haskell]: http://www.haskell.org/haskellwiki/Haskell