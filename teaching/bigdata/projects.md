#Final Project presentations

Here is tentative schedule for the presentations.

## Mon, Dec 8 - WEB L114 - 1:25pm - 2:45 pm

### 1. Association rule learning on Hadoop
*Xinran Luo, Chao Meng, Sigmund Chow*

We want to analyze the users’ consumption habit and find the potential products the user wants to buy using association rule learning algorithm, apriori, on hadoop. This function can be used in precisely spending on advertisement in Amazon.

The apriori generates the kth candidate item sets from the previous k-1th item sets. Then it prunes the candidates which have an infrequent sub pattern according to the original transactions, to determine frequent item sets among the candidates. The pseudo code looks like this:

    L1 = {large 1-itemsets};
    for ( k = 2; Lk-1!=0; k++ ) do begin
    	Ck = apriori-gen(Lk-1); // New candidates
    	forall transactions t∈D do begin
    		Ct = subset(Ck, t); // Candidates contained in t
    		forall candidates c ∈ Ct do
    			c.count++;
    		end
    		Lk = {c ∈ Ck | c.count ≥ minsup}
    end
    Answer =∪kLk;

In the map side, we will finish process data and match the candidates and transaction. At reduce side, we calculate all the argument and do the prune in terms of Support value.


### 2. Movie recommendation system
*Anil Kumar Ravindra Mallapur, Arun Parmar*

Recommendation systems are the applications that provide recommendations to users based on the previous history of utilization to serve the users better. In this project we are implementing a recommender system for movie recommendation based on the dataset provided by MovieLens web application. We would be using collaborative filtering to construct the similarity matrix between users and movies. we would be using the matrix decomposition technique to reduce the dimensionality of the utility matrix. The implementation is based on Apache spark programmed in Python programming language. 

**References**

   1. [http://web.mit.edu/be.400/www/SVD/Singular_Value_Decomposition.htm]()
   2. [http://www2.research.att.com/~volinsky/papers/ieeecomputer.pdf]()
   3. [http://en.wikipedia.org/wiki/Recommender_system]()

**Data** 

   1. [Movielens](http://grouplens.org/datasets/movielens/)


**Data Source** [snap.stanford.edu](http://snap.stanford.edu/data/amazon-meta.html)


### 3. Predict short term movements in stock prices using news and sentiment data 
*Xiao Nan, Hehe Feng*

Our project focuses on implement short term stock price prediction system. The basic assumption is that the stock price largely depends on both inside and outside factors, where inside factor include company performance (earnings and profits), company news (introducing new products, securing a new large contract, etc), and outside factor such as industry performance, investor sentiment (bull market or bear market, news sentiments), economic environment (interest rates, economic outlook and inflation, etc).

Our project makes an effort to predict a short term stock price by analyzing 198 potential factors that may effect stock price. Firstly, we want to implement randomized svd in MPI to decompose data matrix to find out which factors may play important roles in stock price. Then by applying kalman filter or other strategy, build model and predict short term stock price based on last moment of those potentially affected factors. In the end, we will use this model on testing dataset to check accuracy of our approach. We will adjust our methods as needed. 

**Data Source** [Kaggle](https://www.kaggle.com/c/battlefin-s-big-data-combine-forecasting-challenge)

### 4. Triangle Counting
*Aravind Senguttavan, Arun Allamsetty, Chitradeep Roy*

**Aim**:
To find around which top predominant food reviewers in community, users are more crowded and organized in following that particular reviewer.
So that restaurants can invite for session , the predominant food reviewer with larger followers (sum of clustering coefficient)

**Algorithm**:

Step1) Say u1,u2,u3 are users who are visiting restaurants

	u1-6 common restaurants-u2
	u2-7 common restaurants-u3
	u3-9 common restaurants + 2uncommon restaurants-u1

Also, common restaurants and uncommon restaurants for two users are weighted 0.7 and 0.3 and normalized to 1 for edge weight.
Edge indicates common food taste between two users.

Step2) Select top 10 predominant food reviewer based on the fact that they are top 10 highest degree users.

Step3) Counting number of triangles in the graph gives the cluster coefficient for all users

Step4) These coefficients for the users indicate that the crowdedness/connectedness nearby. For each user,

* Find the nearest food taster node.
* Sum all coefficients for a particular food taster.

Step5) Find max of all sums to find crowd around which food taster is organized and well connected.
So restaurants can invite predominant food reviewer with highest sum of cluster coefficients

**References**

   1. [Counting Triangles and the Curse of the Last Reducer](http://theory.stanford.edu/~sergei/papers/www11-triangles.pdf), Siddharth Suri, Sergei Vassilvitskii
   2. [An Efficient MapReduce Algorithm for Counting Triangles in a Very Large Graph](), Ha-Myung Park

**Data** 

   1. [Yelp data set](http://www.yelp.com/dataset_challenge)
   2. [Snap](http://snap.stanford.edu/data/soc-LiveJournal1.html)

----------

## Wed, Dec 10  - WEB L114 - 1:25pm - 2:45 pm

### 1. Using SVD and PCA to compute eigenfaces
*Zef Andrade*

Use SVD and SSVD (randomized SVD) as implemented in Apache Mahout (uses Hadoop) and Apache Spark to compute eigenfaces via dimensionality reduction (PCA). Use these to classify/assign images to the closest (minimum distance) image from a set. Try to compare performance of the two frameworks.
This is a very simple project to explore Spark and Hadoop in a relatively interesting application.

From Wikipedia:
Eigenfaces is the name given to a set of eigenvectors when they are used in the computer vision problem of human face recognition. The approach of using eigenfaces for recognition was developed by Sirovich and Kirby (1987) and used by Matthew Turk and Alex Pentland in face classification.
The eigenvectors are derived from the covariance matrix of the probability distribution over the high-dimensional vector space of face images.
The eigenfaces themselves form a basis set of all images used to construct the covariance matrix. This produces dimension reduction by allowing the smaller set of basis images to represent the original training images. Classification can be achieved by comparing how faces are represented by the basis set.

**Data** [Yale face database](http://vision.ucsd.edu/content/yale-face-database)

### 2. Recommend Restaurant using Yelp data
*Ashok Jallepalli, Padmashree, Vairavan Sivaraman* 

AIM:
Map Reduce program predict the user ratings for the restaurants that a user has not visited and use machine learning paradigm to use 80% of available data to test the remaining 20 % of data.

Abstract:
We will be normalizing the ratings given by a user. Our project will use recommendation system approach to recommend a restaurant to a user who has similar ratings using CUR decomposition.Our project will take the 80% of available data and the CUR decomposition will give the missing ratings. We’ll then get the ratings from our program and verify with that 20% of data.Finally, we will recommend the restaurant to the users, if the predicted ratings for the missing field is greater than 4 or per user choice.


**Data** [Yelp data set](http://www.yelp.com/dataset_challenge)

### 3. Centrality of Networks 
*Shailesh Alva, Shravanti Manohar*

Graphs are a fundamental abstraction for representing data
sets, and graph-theoretic algorithms and analysis routines
are pervasive in several application domains today. Com-
putations involving sparse real-world graphs such as socio-
economic interactions, the world-wide web, and biological
networks only manage to achieve a tiny fraction of the
computational peak performance on the majority of current
computing systems. The primary reason is that sparse graph
analysis tends to be highly memory-intensive: codes typically 
have a large memory footprint, exhibit low degrees
of spatial and temporal locality in their memory access
patterns (compared to other workloads), and there is very
little computation to hide the latency to memory accesses.Centrality indices are answers to the question "What characterizes an important vertex?" The answer is given in terms of a real-valued function on the vertices of a graph, where the values produced are expected to provide a ranking which identifies the most important nodes.

**References**

   1. [http://www.cc.gatech.edu/~bader/papers/FastBC-MTAAP2009.pdf]()
   2. [Wikipedia](https://en.wikipedia.org/wiki/Centrality)

**Data** [Hollywood](http://law.di.unimi.it/webdata/hollywood-2009/)

### 4. Extracting Concept Aware Co-occurrence Over The Entire Web Using Map Reduce
*Klemen Simonic*

Many NLP applications require context or co-occurrence information about the words. I propose a method to obtain rich co-occurrence data for a large vocabulary of words over the entire web crawl. The method uses an efficient hashing technique to map the strings (words) into integers.The hash map is a static global object and is loaded into memory on every node. Furthermore, each mapper uses a caching technique to reduce network traffic for exchanging co-occurrences. The caching techniques is an in-memory cache and when it is full, it is flushed to through the network to reducers.

**Data**: I am using the Common WebCrawl of the entire Web.

### 5. Recommendation Engine
*Sumedha Singla, Harshit Tiwari, Srivatsava Nelaturi*

The goal of the project is to build a recommendation system for the Netflix - user-movie rating dataset. Using the given (User + Movie rating) data, we will be predicting the un-know ratings that a particular user would give to a particular movie.
The recommendation engine will take the training set as input and will establish ratings. We will test the accuracy of the engine over a testing set. The measure of accuracy would be the root mean square error between given ratings in the testing set and the rating recommended by the engine.
The user-rating data is a sparse matrix. We'll be using factorization methods for dimentionality reduction. In our case we are using Singular Value Decomposition(SVD) method. The factorization will give a low dimensional mapping between users and ratings which will be used for prediction.
We are implementing the code in Python and will run on a Spark Cluster. We will also be comparing the results using other factorization methods to understand the behavior of data patterns and accuracy of our estimation.

**References**

   1. [http://www2.research.att.com/~volinsky/papers/ieeecomputer.pdf]()
   1. [http://link.springer.com/chapter/10.1007%2F978-3-540-70987-9_5?LI=true#page-1]()
   1. [http://theanalysisofdata.com/gl/lcr.pdf]()

**Data**  [Netflix Challenge](http://www.netflixprize.com)

### 6. Movie Recommender System
*Jing Yang Meng Tian*

Netflix provided a training data set of 100,480,507 ratings that 480,189 users gave to 17,770 movies. Each training rating is a quadruplet of the form <user, movie, date of grade, grade>. The user and movie fields are integer IDs, while grades are from 1 to 5 (integral) stars. Our goal is predicting user ratings for films, based on previous ratings. In the training set, the average user rated over 200 movies, and the average movie was rated by over 5000 users, so the matrix is very sparse. For this reason, the method we will implement is UV decomposition using stochastic gradient descent. 

**Data**  [Netflix Challenge](http://www.lifecrunch.biz/wp-content/uploads/2011/04/nf_prize_dataset.tar.gz)


----------

## Tue, Dec 16 - MEB 3147 - 12pm-5pm 

**Note**: This is the classroom where we had the first two lectures 


### 1. SVD MPI CUDA Acceleration
*Huihui Zhang and Hao Hou*

Singular Value Decomposition (SVD) is a factorization of a real or complex matrix, that could be applied to signal processing and statistics. For the first attempt, we implemented the MPI version of SVD algorithm on Nvidia Tegra cluster. Then we identify several possible optimizations for GPU CUDA acceleration. Such as, vector product, reduction, and doing multiple vector computations at the same time. Finally, we optimized our CUDA code to be able to merge multiple vector operations into one matrix operations to achieve better speedups. The input matrix for SVD computation is generated from python using randomized numbers.

Our MPI version of SVD implementation referred to:

    http://www.cosy.sbg.ac.at/research/tr/2007-02_Oksa_Vajtersic.pdf
    http://code.google.com/p/elemental/source/browse/examples/lapack-like/SVD.cpp
    http://www.cnblogs.com/zhangchaoyang/articles/2575948.html
    https://github.com/amintos/mpi-factoring/tree/master/mpisvd
    
Our CUDA acceleration for SVD MPI program is based on:

	http://docs.nvidia.com/cuda/samples/6_Advanced/reduction/doc/reduction.pdf

### 2. Recommendation Using Parallel SGD
*Nipun Gunawardena, James Mitchell, Natalee Villa*

Recommendation systems are an essential part of today's websites and services. Calculating recommendations can be done using matrix factorization via stochastic gradient descent (SGD). However, it is important to parallelize SGD due to the size of the input matrix. Previous algorithms have successfully parallelized SGD, but the methods are quite complex. (Zinkevich 2010)

In this project, we explore a simpler, but not necessarily quicker, algorithm in which we divide the matrix into “independent sets”. These independent sets will be found using a graph coloring algorithm; the sets only need to be found once before running SGD.

Using this new method, we will present a recommendation system for the popular streaming movie service Netflix. 

**References**

   1. [http://papers.nips.cc/paper/4006-parallelized-stochastic-gradient-descent]()
   1. [http://dl.acm.org/citation.cfm?id=1454049]()

**Data**  [Netflix Challenge](http://www.lifecrunch.biz/wp-content/uploads/2011/04/nf_prize_dataset.tar.gz)

### 3. A faster algorithm for Betweenness Centrality on Distributed memory machines and many core machines
*Harishkumar Dasari, Shivam Sharma*

We are working on implementing a faster Betweenenss centrality algorithm as described by Ulrik Brandes and we will hopefully implement the direction optimized BFS for finding the shortest paths. It will also be interesting to see it working on GPU clusters but we are planning to push it to the future work. We plan on using a partitioner we developed for the assignments for the time being and work on partitioners like parmetis and see what impact they can have. We will also use graphs from the webpage of Laboratory for Web Algorithms.

**References**

   1. [A Faster Algorithm for Betweenness Centrality](http://www.inf.uni-konstanz.de/algo/publications/b-fabc-01.pdf), Ulrik Brandes
   2. [Direction optimizing BFS](http://www.cs.berkeley.edu/~sbeamer/beamer-sc2012.pdf), Beamer *et al.*
   3. [A space efficient parallel algorithm for computing Betweenness Centrality in Distributed Memory](http://htor.inf.ethz.ch/publications/img/edmonds-hoefler-lumsdaine-bc.pdf) Edmonds *et al.*

**Data** [http://law.di.unimi.it/datasets.php]()

### 4. An algorithm for the principal component analysis of large data sets based on SVD
*Weiyu Liu, Hang Shao*

Principal component analysis(PCA) is among the most popular tools in many areas. Recently popularized methods for PCA efficiently and reliably produce nearly optimal accuracy. This project will try to search and adapt a parallel method based on SVD for use with data sets in big dimensions effectively and efficiently. A demo will be implemented based on a popular parallel technique, MPI. In the end, the performance of the algorithm will be illustrated based on tests with several randomly generated big matrices in different dimensions.

**References**

   1. Nathan Halko, Per-Gunnar Martinsson, Yoel Shkolnisky, and Mark Tygert. (2011) An Algorithm for the Principal Component Analysis of Large Data Sets. SIAM Journal on Scientific Computing 33:5, 2580-2594.

**Data** Randomly generated big matrix in different dimensions will be used to test the algorithm's correctness, effectiveness and efficiency.

### 5. Click-buy conversion Recommendation System 
*Sarath and Vineel*

"The problem of recommending systems has been well solved in the last one decade in different contexts like dating websites, online shopping sites  and in Microsoft Xbox et. al  to engage customers and provide them with the most relevant content .But still there exist problems like cold-start problems exist due to the sparsity of data.There are no generic solutions for problems like this, but custom tailored solutions can be provided to each individual problems by using heuristics and inducing domain knowledge . In the current problem, we are given click and buy history and the task is to develop a model that would predict which items would be bought , given new items that are clicked.(This is Rec Sys 2015 challenge(http://2015.recsyschallenge.com/challenge.html).
We plan to tackle this in a couple of ways.

1. We can employ collaborative filtering .But the challenge is that , we don't have explicitly provided scores of each item with respect to the user. 
So, we would like to attempt it by assigning a score of 5 to the item clicked and 10 to the item bought. And then, we want to predict the ratings and decide what the user is buying and not. 
2. Based on the availability of time, we would like to try  and use Markov Logic Networks or providing a theoretical intuition to how and why formulating this problem  as a Markov Logic Network would be beneficial."

**Data**  We got our data from YOOCHOOSE labs, an R&D consultancy based in Israel. The data is of click and buy history of an e-commerce website in Europe recorded from April 1st 2014 to August 1st 2014. It contained 33003994 clicks which occurred in 9249729 sessions and 1150753 buys which occurred in 509696 sessions. We also know whether the item is clicked as a part of a brand items, or in a discount category. This is training data.Here is the [URL](https://s3-eu-west-1.amazona) of the data. Its around 2.74 GB.


### 6. Music Recommendation System
*Pradeepkumar Konda, Hitesh Raju, KBS Varma*

Music recommendation systems are becoming a hot topic these days due to increase in  number of online listeners to systems like Spotify, Beats, Pandora etc. Recommending users with relevant songs and predicting which songs will be liked a particular user are always a very good feature for any music application.

We are developing a music recommendation system based on the Million Song Dataset and analyzing various algorithms to identify better methods to develop music recommendation system. 

We will be dividing the listening history into two parts for training and testing. Based on our training we will be predicting the songs to which user would most likely listen to in future and which songs or which Artist’s will be more popular.

For these predictions we will be using machine learning.  To start with we are implementing collaborative filtering. We are implementing both user-based and item based collaborative filtering algorithm to learn the historical data and make recommendations. We will also be using Naive Bayes and KNN classifiers for our system.

*Data Preprocessing*:
The files in the dataset are in HDF5 format. We are converting the files to comma delimited text files to work with Hadoop. We are using HDF5 libraries to convert the .h5 files to .txt files and while doing that extracting all fields to comma delimited format.
 
*Processing*:
For Hadoop processing basic test data sample (the subset (10,000 songs) dataset which is 1.8 GB), we are running on a local machine in Hadoop Pseudo distributed mode. For the larger processing we are utilizing Amazon’s EMR (Elastic MapReduce) and S3."

**References**

   1. Thierry Bertin-Mahieux, Daniel P.W. Ellis, Brian Whitman, and Paul Lamere. The Million Song Dataset. In Proceedings of the 12th International Society for Music Information Retrieval Conference (ISMIR 2011), 2011.
   2. Efficient Top-N Recommendation for Very Large Scale Binary Rated Datasets by Fabio Aiolli
   3. Preliminary Study on a Recommender System for the Million Songs Dataset Challenge by Fabio Aiolli

**Data** The Million Song Dataset is a freely-available collection of audio features and metadata for a million contemporary popular music tracks. The Million Song Dataset started as a collaborative project between The Echo Nest and LabROSA. It was supported in part by the NSF. This dataset is also a cluster of complementary datasets contributed by the following community: SecondHandSongs dataset consisting of cover songs, musiXmatch dataset consisting of lyrics, Last.fm dataset consisting of song-level tags and similarity and Taste Profile subset consisting of user data. 
For instance the data has listening history of 110000 users given half of their listening history and the full history for 1019318 other users. This full listening history contains 48373586 unique triplets user id, track id, play count.  The raw data consisted of listening history of a million users in <user_id, song_id, play_count> format. The entire dataset is roughly 300GB. We also have a subset of 1.8GB data for basic experiments on local system.
[Track descrption with fields](http://labrosa.ee.columbia.edu/millionsong/pages/example-track-description)

### 7. Open Course Recommendation
*Jun Tang and Zhao Chang*

We retrieve data from open courses and store it in mongodb, and also generate course rating data by ourselves. Once we combine rating data and course data, we generate a item matrix and a user matrix. We cluster users based on items so we can try to turn the sparse matrix to the dense matrix. And then we perform the SVD operation. Since the data is also sparse. we need to use svd or principle component analysis to reduce to the most various data. In this case, we use randomized svd to find the k-th most various data set. We utilize this matrix to generate some missing ratings. We can use this data for recommendation and find the group of people they are interested in.    

**References**
   1. Apache Matout: http://mahout.apache.org
   2. Dietmar Jannach and Gerhard Friedrich. Tutorial: Recommender Systems, IJCAI 2013

**Data**  [Netflix Challenge](http://www.lifecrunch.biz/wp-content/uploads/2011/04/nf_prize_dataset.tar.gz)

### 8. Top K words from Tweets
*Suraj Kath, Abhinay Duppelly*

Social media networks, such as Twitter and Facebook, provide exciting opportunities that, according to a recent issue of the American Sociological Association (ASA) magazine, can “open up a new era" of social science research.The data extracted from social media has gained a growing interest among many researchers attempting to better understand the nature and power of social media. So In this project  we are accessing tweets and tokenizing them to find out top k-words used at any given interval of time(in our case k varies from 1 to 100). We are hoping that our project can be used as a tool to find patterns,news feeds etc.

**Data** Twitter
