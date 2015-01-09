#Assignment 0 - Focused Web Crawling 

**Due Sep 2**

Please direct your questions to the TA about this assignment. 


##Assignment Description: 
It is helpful to read Web crawler and Focused crawler and at Wikipedia before working on this assignment. You are asked to implement a Web crawler. With a set of root/seed Web pages, your crawler should download a page, then follow its hyperlinks to download more pages and so on. Your crawler should continue this step repeatedly until you stop it or when there is no more linked pages to download. You can implement your crawler in any programming language of your choice. 

Your crawler should support focused crawling. In the first mode, you should limit your page crawling within a given Web domain. Specifically, only pages whose Web host site has a certain suffix (e.g., cs.utah.edu) should be crawled. 

The second mode of focused crawling is to try to crawl pages on a specific topic (e.g., "golf" or "computer science"). Obviously it is impossible to know for certain whether a page is on a certain topic before you download it. But as we discussed in class, you can get heuristics from the anchor text and surrounding text of a hyperlink. The effectiveness of focused crawling can be measured by the proportion of crawled pages that are indeed relevant to the topic. 

Your crawler should not be crawling the same URL more than once. Without this support, your crawling may fall into a loop that repeatedly downloads a particular set of pages for ever. You should also perform reasonable URL normalization to reduce redundant crawling. 

You must follow the Robot Exclusion Standard in your crawling. To simplify your work, you only need to parse and observe the Disallow directives. To limit the resource usage of your crawling, you should enable a configurable sleep time between consecutive Web page downloads. You should carefully implement these politeness measures. To avoid undesirable impact on external Web sites, you should not test on pages outside the department until you are confident about your implementation of these measures. 

In class we have discussed optimizations for crawling high-quality pages. You can also find many additional crawling optimizations beyond what we discussed in class. You do not need to implement these optimizations for completing the assignment. However, if you have interests and time, we encourage you to explore such optimizations and we will consider assigning extra credit if you make a successful implementation and can demonstrate its effect. 

We have discussed parallel Web crawling in class. Although not necessary for this assignment, extra credit will be given for parallel implementation.  

Use git and commit changes often. You will be penalized for not having committed changes frequently. 

Pre-assignment Questionnaire: 
Email the TA your answers to the following questions by Aug 27 (Wednesday).
 
1. Which programming language are you using for this assignment? What is the primary reason behind your choice? A one-line answer is sufficient. 
2. Are you performing a DFS or a BFS search? Why?

Failure to email your answers on time will result in a 10% loss in your assignment grade. We actually will not grade your answers. This is simply to ensure that you do not wait to the last minute before working on the assignment. You will not receive any feedback on your answers. However, you are welcome to visit the TA's office hours and discuss these questions. 

Demo: 
You need to set up a 10-minute demo with the TA. You will receive an announcement from the TA on the demo signup process. The earlier you sign up with the TA, the more available slots are there that you can choose from. Once your demo slot is set, we will not be able to change it unless there is an emergency. In the demo you need to show us how your implementation works (or partially works) with your own test cases. (Prepare the testing cases before the demo!) We may ask you to run some of our own test cases and ask some questions about your design & implementation. 


Grading:
 
* 50% for basic Web crawling with URL redundancy recognition.
* 10% for observing the Robot Exclusion Standard.
* 10% for focused crawling within a domain.
* 30% for focused crawling on a specific topic.
