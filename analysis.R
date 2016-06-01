library(plyr)

######download/unzip files
fileName <- "smtPhone.zip"
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if(!file.exists(fileName)){
  download.file(fileUrl, destfile = fileName, mode='wb')
  unzip(fileName)
}
######download/unzip files



setwd("UCI HAR Dataset")



######read tables
activity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")

subject_test <- read.table("test/subject_test.txt")
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")

subject_train <- read.table("train/subject_train.txt")
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
######read tables



###### Step 1. merge the training and the test sets to create one data set
x_df <- rbind(x_test, x_train)
y_df <- rbind(y_test, y_train)
subject_df <- rbind(subject_test, subject_train)
###### Step 1. merge the training and the test sets to create one data set



###### Step 2 Extracts only the measurements on the mean and standard deviation for each measurement.
mean_std <- grep("(mean|std)", features$V2)
x_df_meanstd <- x_df[,as.numeric(mean_std)]
###### Step 2 Extracts only the measurements on the mean and standard deviation for each measurement.



###### Step 3 Uses descriptive activity names to name the activities in the data set
y_df[,1] <- activity_labels[y_df[,1],2]
###### Step 3 Uses descriptive activity names to name the activities in the data set



###### Step 4 Appropriately labels the data set with descriptive variable names.
names(x_df_meanstd) <- features[as.numeric(mean_std),2]
names(subject_df) <- "subject"
names(y_df) <- "activity"
###### Step 4 Appropriately labels the data set with descriptive variable names.

df <- cbind(x_df_meanstd, y_df, subject_df)

###### Step 5 Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
avg_df<-ddply(df, .(activity, subject), function(x) colMeans(x[,1:79]))
write.table(avg_df, "averages.txt")
###### Step 5 Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
