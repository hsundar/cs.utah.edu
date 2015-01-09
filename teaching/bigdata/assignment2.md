#Assignment 2 - MapReduce & Hadoop  

**Due Oct 20**

Mail your ssh public keys to the TA asap. You can generate your ssh key using `ssh_keygen` on the machine that you are going to use to connect to the server. Remember to rename the `id_rsa.pub` file as `username.key` and mail it to the TA. If you are using multiple machines to connect to the server, it might be a good idea to check out [ssh config](http://nerderati.com/2011/03/17/simplify-your-life-with-an-ssh-config-file/).

You can work in groups. No more than two students per group. Exceptions will be made only in rare circumstances. Code submission will be via github. Please [tag]() you final commit as "assignment 2" before the deadline. The TA will evaluate this version of the code. In addition, you need to submit a report as a PDF file via canvas. Please register as groups on canvas. I will grade the report. Make sure you have enough time to work on the report. 
*Please commit code frequently as the respective users. You will be penalized for not committing code often.* 

## server and running jobs 

Once your ssh keys have been added to the system you will be able to connect to [Apt](https://www.flux.utah.edu/project/apt).   You should be able to log in to `$USER@apt023.apt.emulab.net` using your ssh key (that's the resource manager node). 
Hadoop is installed under `/usr/local/hadoop-2.5.0` on each machine and should allow you to start jobs.  For instance, to run an example
from the distribution:

```bash
resourcemanager$ cd /usr/local/hadoop-2.5.0   
resourcemanager$ ./bin/hdfs dfs -mkdir /user/hari    
resourcemanager$ ./bin/hdfs dfs -put etc/hadoop input    
resourcemanager$ ./bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.5.1.jar grep input output 'dfs[a-z.]+'      
resourcemanager$ ./bin/hdfs dfs -cat output/*    
```

The HDFS web interface is here:

    http://apt027.apt.emulab.net:50070/

and the resource manager is:

    http://apt023.apt.emulab.net:8088/


## 1. matrix multiplication 

For the first problem, you will implement matrix-matrix multiplication. You will implement both the grouped version of single-pass as well as the two-pass algorithms discussed in class. In both cases, make sure your code works for rectangular matrices and not only for square matrices. You can decide on any format for the input data. You can generate random (dense) matrices to test your algorithm. Submit along with your mapreduce code scripts/programs for converting to/from the following matrix format to your internal format. 

```txt
num_rows num_cols
binary dump of matrix entries in double precision
```

Here is a sample C code to read/write such a file. 

```cpp
int num_rows, num_cols;
double *mat;

FILE* fp = fopen(filename, "rb");
fscanf(fp, "%d %d\n", &num_rows, &num_cols);
// allocate memory
mat = (double *) malloc ( num_rows * num_cols * sizeof (double) );
fread(mat, sizeof(double), num_rows*num_cols, fp);
fclose(fp);

// now write to it ...
fp = fopen(filename, "wb");
fprintf(fp, "%d %d\n", num_rows, num_cols);
fwrite (mat, sizeof(double), num_rows*num_cols, fp);
fclose(fp);

```

Compare the performance of the two versions for different problem sizes as well as different group sizes. Use matrix sizes $(100,1000,10000)\times(100,1000,10000)$. Try larger sizes if you can. What is the best grouping strategy? Does the optimal group size depend on the size of the matrices? 

## 2. page rank  

Implement the page rank algorithm with taxation to avoid dead-ends and spider traps. The input will be sparse matrices available from this [website](http://law.di.unimi.it/datasets.php). Specifically, use test your implementation on the following graphs,

1. 	hollywood-2011
2. 	dblp-2011
3. 	enron
4. 	webbase-2001

Describe how you stored the connectivity matrix on disk and how you computed the transition matrix. What inference can you derive from using PageRank on the these datasets. List the top-10 vertices for graphs 1,2 & 4. For all graphs, except the enron one, you have access to the vertex labels (ids, URLs).

Modify your code to implement the TrustRank of the page. Test using dataset 4. The user will specify which pages (indices) correspond to trustworthy pages. It might be good to look at the URLs and identify reasonable candidates for trustworthy pages. Calculate the spam-mass of the webpages and list the top-10 pages with the largest spam mass.
