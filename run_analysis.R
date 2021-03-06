# 0 download zip file

if(!require(dplyr)) install.packages("dplyr",repos = "http://cran.us.r-project.org")

if(!file.exists("./data")){dir.create("./data")}
setwd("./data")
url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,"FUCI20Dataset.zip")
## unzip file
unzip("FUCI20Dataset.zip")

# 1 Read files
## 1.1 Read data set
xTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
xTest <- read.table("UCI HAR Dataset/test/X_test.txt")

## 1.2 Read subjects
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")

## 1.3 Read activities
activitiesTrain <- read.table("UCI HAR Dataset/train/y_train.txt")
activitiesTest <- read.table("UCI HAR Dataset/test/y_test.txt")

# 1.4 Read Activity label file
activityLabel <- read.table("./UCI HAR Dataset/activity_labels.txt")
names(activityLabel) <- c("activityNum", "activityName")

## 1.5 Read features labels
features <- read.table("UCI HAR Dataset/features.txt",stringsAsFactors = F)
names(features)<-c("featureNum", "featureName")

## 1.6 Merge training and test(bind in same order for all to preserve the sequence)
xCombined <- rbind(xTrain,xTest)
subjectCombined <-rbind(subjectTrain,subjectTest)
activitiesCombined <-rbind(activitiesTrain,activitiesTest)
descriptors <- cbind(subjectCombined,activitiesCombined)
data <- cbind(descriptors,xCombined)

## 2 Only select the features with mean() or std() in the name at the end
features <- features[grepl("mean\\(\\)|std\\(\\)", features$featureName),]

select <-data[,c(1,2,features$featureNum+2)]
names(select) <- c("subjectNum", "activityNum", features[,2])

## 3 Use descriptive names
finalData <- merge(select, activityLabel, by = "activityNum", all.x = T)

## 4. Appropriately labels the data set with descriptive variable names
tempNames <- names(finalData)
tempNames <- gsub("\\()","", tempNames)
tempNames<- gsub("^t", "Time", tempNames)
tempNames <- gsub("^f", "Frequency", tempNames)
tempNames <- gsub("-mean", "Mean", tempNames)
tempNames <- gsub("-std", "Std", tempNames)
tempNames <- gsub("Acc", "Accelerometer", tempNames)
tempNames <- gsub("Gyro", "Gyroscope", tempNames)
tempNames <- gsub("Mag", "Magnitude", tempNames)

names(finalData) <- tempNames

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

groupData <- finalData %>%
  group_by(subjectNum, activityNum,activityName) %>%
  summarise_each(funs(mean))
write.table(groupData, "TidyMeanData.txt", row.names = T)
