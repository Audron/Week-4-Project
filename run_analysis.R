## Load libary needed to write to text file and produce the cook book later on
library(plyr)

## Set working directory of extracted downloaded file
setwd("~//Coursera//Course3//week4//project//")


### STEP 1, Combine the datasets
## Declare path of the location of the datasets
datapath <- file.path("./data", "UCI HAR Dataset")

## Get a list of the files in the directory
files <- list.files(datapath, recursive = TRUE)
files

## Import the needed files
    # Subject files
SubjectTrain <- read.table(file.path(datapath, "train", "subject_train.txt"), header = FALSE)
SubjectTest <- read.table(file.path(datapath, "test", "subject_test.txt"), header = FALSE)
  # Activity files
ActivityTest <- read.table(file.path(datapath, "test", "Y_test.txt"), header = FALSE)
ActivityTrain <- read.table(file.path(datapath, "train", "Y_train.txt"), header = FALSE)
    # Features Files
FeaturesTest <- read.table(file.path(datapath, "test", "X_test.txt"), header = FALSE)
FeaturesTrain <- read.table(file.path(datapath, "train", "X_train.txt"), header = FALSE)

## Merge the datasets
Subject <- rbind(SubjectTrain, SubjectTest)
Activity <- rbind(ActivityTrain, ActivityTest)
Features <- rbind(FeaturesTrain, FeaturesTest)

## Change the column names of each dataset
names(Subject) <- c("subject")
names(Activity) <- c("activity")

## Obtain a list of names to apply to columns of a dataset
FeaturesColumnNames <- read.table(file.path(datapath, "features.txt"), head = FALSE)

## Apply the list of names to the dataset
names(Features) <- FeaturesColumnNames$V2

## Combine all datasets
CombinedData <- cbind(Subject, Activity, Features)
CombinedData

## Relabel the columns by keeping only the mesurement lables
    # Get a list of names of the labels using regex expressions for mean and standard divation only
FeaturesColumnNames2 <- FeaturesColumnNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesColumnNames$V2)]
FeaturesColumnNames2

# Obtain data that corrispons to the new list of columns which includes subject and activity as well
FinalColumnNames <- c(as.character(FeaturesColumnNames2), "subject", "activity")
FinalData <- subset(CombinedData, select = FinalColumnNames)
FinalData
str(FinalData)


### STEP 2, relabel the columns

# Clean the variable names with cleaner names

names(FinalData) <- gsub("Acc", "Accelerometer", names(FinalData))
names(FinalData) <- gsub("BodyBody", "Body", names(FinalData))
names(FinalData) <- gsub("^f", "frequency", names(FinalData))
names(FinalData) <- gsub("Gyro", "Gyroscope", names(FinalData))
names(FinalData) <- gsub("Mag", "Magnitude", names(FinalData))
names(FinalData) <- gsub("^t", "time", names(FinalData))
str(FinalData)


### STEP 3, output the data
# Output the tidy dataset into a text file
tidydata <- aggregate(. ~ subject + activity, FinalData, mean)
tidydata <- tidydata[order(tidydata$subject, tidydata$activity),]
write.table(tidydata, file = "tidydata.txt", row.name = FALSE)
tidydata

