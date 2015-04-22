###############################################################################  
# Coursera Course Assignment - Getting and Cleaning Data 
#   run_analysis.R
#
# uses the reshape2 package
# install it using following command: install.packages("reshape2")
#
#
###############################################################################  
##
## 1 Merges the training and the test sets to create one data set.
## 2 Extracts only the measurements on the mean and standard deviation for each
##   measurement. 
## 3 Uses descriptive activity names to name the activities in the data set
## 4 Appropriately labels the data set with descriptive variable names. 
## 5 From the data set in step 4, creates a second, independent tidy data set 
##   with the average of each variable for ###  each activity and each subject.
##
###############################################################################  

## ensure we load the reshape2 library
library(reshape2)

##########################################################
##  Merge the test and training sets into one          ###
##########################################################

#read in all the test data
data.x.test    <- read.table("./UCI HAR Dataset/test/X_test.txt")
data.y.test    <- read.table("./UCI HAR Dataset/test/y_test.txt")
data.sub.test  <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#read in all the training data
data.x.train   <- read.table("./UCI HAR Dataset/train/X_train.txt")
data.y.train   <- read.table("./UCI HAR Dataset/train/y_train.txt")
data.sub.train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

#read in variable names and activities
features   <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors=FALSE)
activity   <- read.table("./UCI HAR Dataset/activity_labels.txt")

#combine the train and test data
data.x.all   <- rbind(data.x.train, data.x.test)
data.y.all   <- rbind(data.y.train, data.y.test)
data.sub.all <- rbind(data.sub.train, data.sub.test)


#remname the columns
names(data.y.all)   <- "activity ID"
names(data.sub.all) <- "subject"
names(activity)     <- c("activity ID", "activity")
names(features)     <- c("col no.", "variable name")
names(data.x.all)   <- as.character(features[,2])

#get the columns which are labeled with mean() and std() from data.x.all
selected.x.cols <- grep('-mean|-std', colnames(data.x.all))
#remove the columns which do not have "mean" or "std" in the variable name
data.x.all <- data.x.all[,selected.x.cols]


#Merge the Activity ID to the Activity name
data.y.all <- merge(data.y.all, activity, by="activity ID", sort=FALSE)

#merge all data columns ( Subjects, Activities and 
data.all <- cbind(data.sub.all, data.y.all, data.x.all )

#removing the activity ID column 
data.all <- data.all[,-2]

## flatten the data for grouping
data.grouped <- melt(data.all, id.var = c('subject','activity'))

## calculate the grouped averages using mean function
data.avg <- dcast(data.grouped, subject + activity ~ variable, mean)

##write the data to the file.
write.table(data.avg, file="tidydata.txt")







