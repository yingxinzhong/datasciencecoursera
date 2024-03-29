
filename <- "getdata_dataset.zip"
## Download and unzip the dataset:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
   download.file(fileURL, filename, method="curl")
 ##Unzip  
 if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

# Read activity tables 
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extracts only the measurements on the mean and standard deviation for each measurement.
 featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
 featuresWanted.names <- features[featuresWanted,2]
 featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
 featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
 featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)
 
 # Uses descriptive activity names to name the activities in the data set
 train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresWanted]
 trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
 trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
 train <- cbind(trainSubjects, trainActivities, train)
 test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted]
 testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
 testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
 test <- cbind(testSubjects, testActivities, test)
 
 # merge datasets 
 DataSet <- rbind(train, test)
 colnames(DataSet) <- c("subject", "activity", featuresWanted.names)
 
 # creates a second, independent tidy data set with the average of each variable for each activity and each subject.
 Dataset$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
 Dataset$subject <- as.factor(allData$subject)
 Dataset.melted <- melt(allData, id = c("subject", "activity"))
 Dataset.mean <- cast(allData.melted, subject + activity ~ variable, mean)
 
 #export Output to text file
 write.table(Dataset.mean, "tidy.txt", row.names = FALSE)
