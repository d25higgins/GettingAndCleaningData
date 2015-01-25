## ==================================================================
## Programming Project -- run_analysis.R
## ==================================================================
## Author: d25higgins
## Incept: January 14, 2015
## Description:
## ==================================================================
## This script performs the 5 items called for in the course project
## for Getting and Cleaning Data.
## ==================================================================
## Inputs: 
##      none - all references are internal
## Returns: tidyDataSet.txt file
## ==================================================================
## Edit History:
##
## ==================================================================


#install packages to do summary work
#Uncomment the install packages if not on machine
####install.packages("stringr)
####install.packages("data.table")
####install.packages("dplyr")
library(stringr)
library(data.table)
library(dplyr)

## Download the Data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destFile <- "./data/projectfiles.zip"
download.file(url, destFile)

## unzip the file and set the working directory to the new data directory
unzip(destFile, exdir="./data")

## Load test data into df test
testFile <- "./data/UCI HAR Dataset/test/X_test.txt"
test <- read.table(testFile)

## Load train data into df train
trainFile <- "./data/UCI HAR Dataset/train/x_train.txt"
train <- read.table(trainFile)

## Get the column names from features
colnamefile <- "./data/UCI HAR Dataset/features.txt"
featcolnames <- read.table(colnamefile)

#remove objectionable or obscure text
colnames <- featcolnames[,2]
colnames <- str_replace(colnames, "[-]", "")
colnames <- str_replace(colnames, "[(]", "")
colnames <- str_replace(colnames, "[)]", "")
colnames <- str_replace(colnames, "[,]", "")
colnames <- str_replace(colnames, "meanFreq", "ignore")
colnames <- str_replace(colnames, "-", "")


## assign the colmn names to the test and train data
colnames(test) <- colnames
colnames(train) <- colnames

## get suject_test and read into list, rename the column
subTestFile <- "./data/UCI HAR Dataset/test/subject_test.txt"
subjectTest <- read.table(subTestFile)
colnames(subjectTest) <- c("subjects")

## get y_test data and read into list, rename the column
yTestFile <- "./data/UCI HAR Dataset/test/y_test.txt"
yTest <- read.table(yTestFile)
colnames(yTest) <- c("activities")

## get suject_train and read into list, rename the column
subTrainFile <- "./data/UCI HAR Dataset/train/subject_train.txt"
subjectTrain <- read.table(subTrainFile)
colnames(subjectTrain) <- c("subjects")

## get y_train data and read into list, rename the column
yTrainFile <- "./data/UCI HAR Dataset/train/y_train.txt"
yTrain <- read.table(yTrainFile)
colnames(yTrain) <- c("activities")

labelFile <- "./data/UCI HAR Dataset/activity_labels.txt"
labels <- read.table(labelFile)

# aggregate all data to one DF
allTest <- cbind(test, yTest)
allTest <- cbind(allTest, subjectTest)
allTrain <- cbind(train, yTrain)
allTrain <- cbind(allTrain, subjectTrain)

allT <- rbind(allTest, allTrain)

#extract only the mean and std columns 
#and activities and subjects

cols <- colnames(allT)

#find the columns we need
colList <- grep("mean", cols)
colList2 <- grep("std", cols)

colList <- c(colList, colList2)
colList <- sort(colList)

colList3 <- grep("activities", cols)
colList4 <- grep("subjects", cols)
colList5 <- c(colList3, colList4)

colList <- c(colList5, colList)

meanStd <- allT[,colList]

#change activities to descriptive labels

meanStd$activities[meanStd$activities == 1] <- "WALKING"
meanStd$activities[meanStd$activities == 2] <- "WALKING_UPSTAIRS"
meanStd$activities[meanStd$activities == 3] <- "WALKING_DOWNSTAIRS"
meanStd$activities[meanStd$activities == 4] <- "SITTING"
meanStd$activities[meanStd$activities == 5] <- "STANDING"
meanStd$activities[meanStd$activities == 6] <- "LAYING"


#convert to a data.table
dt <- as.data.table(meanStd)

#group the data by activities and subjects
by_act_sub <- group_by(meanStd, activities, subjects)

#summarise the data
sumData <- summarise_each(by_act_sub,funs(mean))

write.table(sumData, file="./data/tidyDataSet.txt", row.names=FALSE)
