# setwd("D:/Coursera/Data scientist specilization/getting and cleaning data/assignment")
# source("run_analysis.R")
library(plyr)

if(!file.exists("./UCI HAR Dataset")) {
    stop("Please download the data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  first and place it in the directory './UCI HAR Dataset'")  
} 


createTidyData <- function(xFile, yFile, subjectFile ) {
    # read files from directory and merge together. Starting with X_test (the actual data) and
    # features (the column names)
    xTest <- read.table(xFile, colClasses = "character", header=FALSE)
    features <- read.table("./UCI HAR Dataset/features.txt",colClasses = "character", header=FALSE)
    
    #add column names from features document to xTest
    names(xTest) <- features[,2]
    
    #get only columns with std or mean values
    xTest <- xTest[grep("*std*|*mean*",names(xTest))]
    xTest <- cbind(xid=rownames(xTest), xTest)  
    
    # next we add the subjectTest data and yTest (activity data) to the xTest data frame
    # they both get an id column for merging later on.
    subjectTest <- read.csv(subjectFile, colClasses = "character", header=FALSE)
    subjectTest <- cbind(sid=rownames(subjectTest), subjectTest)
    names(subjectTest) <- c("sid", "subject")
    
    yTest <- read.csv(yFile, colClasses = "character", header=FALSE)
    yTest <- cbind(id=rownames(yTest), yTest)
    names(yTest) <- c("id","activity_id")
    
    # we read in the activities and give the columns names for easy merging. 
    # Name activities
    activityLabels <- read.csv("./UCI HAR Dataset/activity_labels.txt", colClasses = "character", header=FALSE, sep=" ")
    names(activityLabels) <- c("aid", "activity")
    
    
    #merge all four data frames 
    yTest <- merge(yTest, activityLabels, by.x="activity_id", by.y="aid") # adds activity name to row
    yTest["activity_id"] <- NULL
    merged <- merge(yTest, subjectTest, by.x="id", by.y="sid")     # combines activities and subjects
    testData <- merge(merged, xTest, by.x="id", by.y='xid')     # combine all information in one data frame
    
    # remove no longer needed variables from memory 
    rm(xTest, features, merged, subjectTest, yTest, activityLabels)  
    return (testData)
}


# call function createTidyData for botht the test and train set 
testData <- createTidyData("./UCI HAR Dataset/test/X_test.txt",
                           "./UCI HAR Dataset/test/subject_test.txt",
                           "./UCI HAR Dataset/test/y_test.txt")
trainData <- createTidyData("./UCI HAR Dataset/train/X_train.txt",
                            "./UCI HAR Dataset/train/subject_train.txt",
                            "./UCI HAR Dataset/train/y_train.txt")

# check if directory exists
if(!file.exists("data")) {
    dir.create("data")    
}

#write tidy train and test data into a file for later use
write.table(testData,file= "./data/testData.txt", sep=",")
write.table(trainData,file= "./data/trainData.txt", sep=",")

