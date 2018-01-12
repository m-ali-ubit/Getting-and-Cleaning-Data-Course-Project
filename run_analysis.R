
## insert library
library(reshape2)


filename <- "getdata_dataset.zip"


## Download and unzip the dataset:
if (!file.exists(filename)){
  
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
 
   download.file(fileURL, filename, method="curl")
} 

if (!file.exists("UCI HAR Dataset")) { 
 
   unzip(filename) 
}


# Load activity labels & features
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

activity_labels[,2] <- as.character(activity_labels[,2])

features <- read.table("UCI HAR Dataset/features.txt")

features[,2] <- as.character(features[,2])


# Extract only the data on mean and standard deviation
features_m_sd <- grep(".*mean.*|.*std.*", features[,2])

features_m_sd.names <- features[features_m_sd,2]

features_m_sd.names = gsub('-mean', 'Mean', features_m_sd.names)

features_m_sd.names = gsub('-std', 'Std', features_m_sd.names)

features_m_sd.names <- gsub('[-()]', '', features_m_sd.names)


# Load the datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[features_m_sd]

train_activities <- read.table("UCI HAR Dataset/train/Y_train.txt")

train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

train <- cbind(train_subjects, train_activities, train)


test <- read.table("UCI HAR Dataset/test/X_test.txt")[features_m_sd]

test_activities <- read.table("UCI HAR Dataset/test/Y_test.txt")

test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

test <- cbind(test_subjects, test_activities, test)


# merge datasets and add labels
all_Data <- rbind(train, test)

colnames(all_data) <- c("subject", "activity", features_m_sd.names)


# turn activities & subjects into factors
all_data$activity <- factor(all_data$activity, levels = activity_labels[,1], labels = activity_labels[,2])

all_data$subject <- as.factor(all_data$subject)


all_data.melted <- melt(all_data, id = c("subject", "activity"))


all_data.mean <- dcast(all_data.melted, subject + activity ~ variable, mean)

#writing dataset into tidy.txt
write.table(all_data.mean, "tidy.txt", row.names = FALSE, quote = FALSE)

