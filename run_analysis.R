#The script initializes by setting the working directory where the dataset is stored. For my script, I will use the dplyr package which I load at the beginning
setwd("C:/Users/marin/Documents/RJHUCourse/UCI HAR Dataset")
library(dplyr)

#First, I am going to create the testing and training datasets. Using the read.table command, I upload them and then cbind them WITHOUT changing the order. The objects match perfectly in row numbers which makes us more comfortable.
subjects_test <- read.table("test/subject_test.txt", header = FALSE, sep= "", dec = ".")
actions_test <- read.table("test/y_test.txt", header = FALSE, sep= "", dec = ".")
raw_measurements_test <- read.table("test/X_test.txt", header = FALSE, sep= "", dec = ".")
raw_measurements_test_merged <- cbind(subjects_test,actions_test, raw_measurements_test) 

subjects_train <- read.table("train/subject_train.txt", header = FALSE, sep= "", dec = ".")
actions_train <- read.table("train/y_train.txt", header = FALSE, sep= "", dec = ".")
raw_measurements_train <- read.table("train/X_train.txt", header = FALSE, sep= "", dec = ".")
raw_measurements_train_merged <- cbind(subjects_train,actions_train, raw_measurements_train) 
 
#Prior to merging the datasets, it is important to ensure that they have the same names. Upon inspection of the features.txt file, we see that the names in the second column are ideal for our labeling. We import them into a string vector that has two additional strings, the "subject" and "activity" for the other two variables that we cbinded from subject and activity txt files. Moreover, to avoid any issues with the std and mean variables, I decided to lower all capitals (it is also a good practice for tidy data).
features <- read.table("features.txt", header = FALSE, sep= "", dec = ".")
namelist <- tolower(features[,2])
namelistall <- c("subject", "activity", namelist)
colnames(raw_measurements_test_merged) <- namelistall
colnames(raw_measurements_train_merged) <- namelistall

#Having made sure that the names much exactly, we just have to rbind the testing and training datasets.
merged_test_training <- rbind(raw_measurements_train_merged, raw_measurements_test_merged)

#Now, we need to select only the requested variables, which are just the mean and std for each measurement. To do that, we construct a character vector that contains all the variables of interest. We use the exact names for subject and activity columns, and the grep function (with value = TRUE) to get all the names of the variables that calculate standard deviation and mean. Having constructed our vector, we just need to use the select function of dplyr together and put our vector of variable names inside the any_off argument  
values_to_extract_mean <- grep("mean", namelist, value = TRUE)

values_to_extract_std <- grep("std", namelist, value = TRUE)


variables_of_interest <- c("subject", "activity", values_to_extract_mean,values_to_extract_std)

target_variables <- select(merged_test_training, any_of(variables_of_interest))

#Having constructed the dataset, we just need to make sure that it is labeled appropriately. First, I will arrange by subject and activity. Then, I will decode the activtiy and replace the number with the appropriate label. 
target_variables <- arrange(target_variables, subject, activity)

target_variables <- mutate(target_variables, activity_labeled = ifelse (activity == 1, "WALKING",
							ifelse (activity == 2, "WALKING_UPSTAIRS",
							ifelse (activity == 3, "WALKING_DOWNSTAIRS",
							ifelse (activity == 4, "SITTING",
							ifelse (activity == 5, "STANDING","LAYING"))))), activity = NULL)

#The dataset in step 4 is now done. We only need the step 5 dataset to finish. To make sure we have a nice single table, we will use the aggrgate function using the subject and activity_labeled columns as factor variables. For clarity purposes, I will rename the grouping columns with the original names so that it is easier for the reader to navigate.
summary_table <- aggregate(target_variables, by = list(target_variables[["subject"]], target_variables[["activity_labeled"]]), mean, na.rm = TRUE)

summary_table_pre_final <- mutate(summary_table, subject_id = Group.1, activity_id = Group.2, activity_labeled = NULL, Group.1 = NULL, Group.2 = NULL)

summary_table_final <- summary_table_pre_final %>% 
	select(subject_id, activity_id, everything())

#We are all set! I wanted to save a bunch of files to assess that everything has been done correctly. Because the assignment asks a very specific output, I commented them out, but they are at your disposal!
#write.csv(target_variables, "step4dataset.csv")
#write.csv(summary_table_final, "step5dataset.csv")
#write.table(target_variables, "step4dataset.txt", row.name = FALSE)
write.table(summary_table_final, "step5dataset.txt", row.name = FALSE)
