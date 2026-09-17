data_path <- "UCI HAR Dataset"
filename <- "getdata_dataset.zip"

##Download and unzip the dataset:
if(!file.exists(filename)){
        fileURL <- " 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileURL, filename, method - "curl")
}
if(!file.exists("UCI HAR Dataset")) {
        unzip(filename)
}

####Load activity labels and Features
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[, 2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

##Extract the data on mean and standard deviation
featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)


##Load the Datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt"[featuresWanted.names])
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainsubjects, trainActivities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

#Merging Datasets and adding Labels
allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", featuresWanted.names)

allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

#Create independant tidy dataset
library(dplyr)

tidy_data <- data %>%
        group_by(subject, activity) %>%
        summarise(
                across(
                        where(is.numeric),
                        mean
                ),
                .groups = "drop"
        )

#Final Dataset to a File
write.table(
        tidy_data,
        file = "tidy_data.txt",
        row.names = FALSE
)

print(tidy_data)


