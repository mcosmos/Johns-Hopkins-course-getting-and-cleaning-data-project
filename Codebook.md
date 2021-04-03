---
title: "Codebook"
author: "Marinos Kosmopoulos"
date: "4/2/2021"
output: pdf_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Codebook

The setwd command directs the working directory to the location I unzipped the course folder. All the output of the script is also saved there. 

The names of the files are unchanged. The label train corresponds to the training data, and the label test to the testing data. 

The raw_measurements correspond to the 561 column txt file with all the variables. 

Importantly, the step 4 dataset is the only object in the manuscript that has both the "train" and "test" label in its name. The other "merge" files correspond to the cbinding between the files of the train and testing clusters.

As I would need to get the "mean" and "standard deviation files" I wanted to avoid any problems with capital letters. Therefore, when I imported the names from the features.txt file, I lowered all the letters. 

'README.md' The readme markdown file that was asked from the course.

'step5dataset.txt' The output of the script. This 181 line txt document contains the averages for all the mean and std measurements from both the test and training datasets. The first row is the heading of the table , containing all the column names (which correspond to the labeled varialbe whose average is taken) The first column corresponds to the subject, the second column to the activity label. The rest are the average of the summary varialbe (mean or std) for all the measurements. 

'run_analysis.R' The project's script.