![King of Curriculum](https://raw.githubusercontent.com/Franklyncc/King-of-Curriculum/master/img/header.png)


# King-of-Curriculum
## Idea
Looking for the best curriculum of highest expected GPA? King-of-curriculum helps students design their 4-year curriculum that satisfy all the graduation requirements based on one's estimated rank and the number of courses one wants to take.

We designed a mathematical programming model to schedule a curriculum with optimal GPA satisfying the following constraints:
* Time constrains
* Credit limits for required and optional courses
* Credit limits for 8 categories of general education courses
* Special limits for Management related courses and CS related courses

The constraints are the requirements of Information Management Department in National Taiwan University.

## Workflow
![Workflow](https://raw.githubusercontent.com/Franklyncc/King-of-Curriculum/master/img/workflow_detail.png)

1. Parse course metadata from [NTU Sweety Course](https://ntusweety.herokuapp.com/)
1. Parse GPA distributions of all courses
1. Preprocess into .dat file
1. Solve it by AMPL.

## Model
Quit complicated. Check [學分王課表.pdf](學分王課表.pdf)(Chinese) for model details.


## Samples
The following is the optimal 4-year (8 semesters) curriculum for a students who is of PR 85 and expect to earn 200 credits in total.

![results of PR 85 and 200 credits](https://raw.githubusercontent.com/Franklyncc/King-of-Curriculum/master/img/optimal_curriculum_at_pr_85.png)

One table for one semester. The tables are placed in ascending order, representing the curriculum for freshman fall, freshman spring, sophomore fall, sophomore spring, ..., senior spring respectively.

## Contributors
[Franklyn Chen](https://github.com/franklyncc)([Franklyn Chen](https://github.com/franklynChen)) is the main contributor for this project, generating the model and providing ideas for our team. 

[Alvin Hou](https://github.com/CryoliteZ) gathered the dataset and done the data cleaning as well as the model training.
