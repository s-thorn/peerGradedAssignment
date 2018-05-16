#Getting and Cleaning Data Week 4 Peer-graded Assignment

#Download the data
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
saved <- file.path(getwd(), "peerGradedAssignment.zip")
download.file(URL, saved)
activity <- unzip(saved)
# To load data sets (X text files), lables (y text files), 
# and subjects (subject test files), and activity labels.
train_set <- read.table(file.path(getwd(), "/UCI HAR Dataset/train/X_train.txt"))
test_set <- read.table(file.path(getwd(), "/UCI HAR Dataset/test/X_test.txt"))
y_train <- read.table(file.path(getwd(), "/UCI HAR Dataset/train/y_train.txt"))
y_test <- read.table(file.path(getwd(), "/UCI HAR Dataset/test/y_test.txt"))
train_sub <- read.table(file.path(getwd(), "/UCI HAR Dataset/train/subject_train.txt"))
test_sub <- read.table(file.path(getwd(), "/UCI HAR Dataset/test/subject_test.txt"))
activity_labels <- read.table(file.path(getwd(), "/UCI HAR Dataset/activity_labels.txt"))


# Clip together data sets
add_data <- rbind(train_set, test_set)
# The features text file only describes columns 1-549 but the data sets have 561 columns. 
# What columns are missed in the features text file?
features <- read.table("C:/Users/thorn/Desktop/Coursera/Getting and Cleaning Data/UCI HAR Dataset/features.txt")
features[550:561,1:2]
# Need to figure out which columns in the features text file are mean and standard deviation measurements.
# Specific enough to exclude meanFreq and gravityMean measurements since the instructions did not specify these measurements explicitly.
Features <- as.character(features[,2])
mFreq <- sub("meanFreq", "mFreq", Features)


# Add column names to data set
names(add_data) <- Features


# Extract only the measurements on the mean and standard deviation for each measurement.
data_mean_std <- add_data[,grep("mean|std", mFreq, value = TRUE)]
names(data_mean_std)
# Add subject column to data set
sub_train_test <- rbind(train_sub,test_sub)
add_subject <- cbind(sub_train_test,data_mean_std)

# Combine activity data for train and test sets
# Substitute activity numbers with descriptions but do not sort to keep integrity of data
# and add to data set as first column
y_train_test <- rbind(y_train,y_test)
ones <- which(y_train_test$V1 %in% 1)
twos <- which(y_train_test$V1 %in% 2)
threes <- which(y_train_test$V1 %in% 3)
fours <- which(y_train_test$V1 %in% 4)
fives <- which(y_train_test$V1 %in% 5)
sixes <- which(y_train_test$V1 %in% 6)
y_train_test$V1 <- replace(y_train_test$V1, ones, "WALKING") 
y_train_test$V1 <- replace(y_train_test$V1, twos, "WALKING_UPSTAIRS")
y_train_test$V1 <- replace(y_train_test$V1, threes, "WALKING_DOWNSTAIRS")
y_train_test$V1 <- replace(y_train_test$V1, fours, "SITTING")
y_train_test$V1 <- replace(y_train_test$V1, fives, "STANDING")
y_train_test$V1 <- replace(y_train_test$V1, sixes, "LAYING") 
tidy_data <- cbind(y_train_test,add_subject)


# The two added columns [,1:2] need column names
colnames(tidy_data)[1] <- "activity"
colnames(tidy_data)[2] <- "subject"
# To include a column for the original data set of each observation.
train <- rep("training",7352)
test <- rep("test",2947)
set<- c(train, test)
tidy_data$set <- set
# Clean up columns to represent only one variable.
library(tidyr)
cleaning <- gather(tidy_data, domainMotionSignals, number, -c(activity, subject, set))
clean <- separate(cleaning, domainMotionSignals, c("signal", "mean_or_std", "direction"))
# clean_not <- spread(clean, mean_or_std, number)
# The above code line is not possible. Can't spread the mean_or_std column as there are multiple measures of each.  
# The duplicates would not fit into one observation.
# I'd like to break the data set into seperate tables, but I don't have a column with a unique identifier to link the tables.
#observation <- cleaning %>% 
  #select(activity:domain,direction) %>%
  #unique


# Save clean data frame as an R script
save(clean, file = file.path(getwd(),"clean.R"))

# Create a second, independent tidy data set with the average of each variable for each activity and each subject.
library(dplyr)
second_td <- group_by(clean, activity, subject, set, signal, mean_or_std, direction)
mean_df <- summarize_all(second_td, mean)

