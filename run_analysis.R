# =============================================================================
# Description
# This script does the following. 
# 0.    create the data frames from training and test data sets
# 1.    Merges the training and the test sets to create one data set.
# 2.	Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3.	Uses descriptive activity names to name the activities in the data set
# 4.	Appropriately labels the data set with descriptive variable names. 
# 5.	From the data set in step 4, creates a second, independent tidy data set 
#       with the average of each variable for each activity and each subject.
# 6.    Creates in directory with raw data subdirectory called "Analysis" 
#       and write into this directory file called "Analisys_result.txt", 
#       each contains resulting tidy data.
# =============================================================================

library(data.table)
library( plyr )
library(reshape2)

# 0. DF creating from training and test data sets
training_set0 <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE, sep="") #, col.names = c_names) 
test_set0 <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE, sep="") #, col.names = c_names)

# 2 Extracting only the measurements on the mean and standard deviation for each measurement.
feature_vector <- read.table("./UCI HAR Dataset/features.txt", header=FALSE, sep="", stringsAsFactors = FALSE)
c_names <- feature_vector[, 2]

cwmean <- grep("mean()", c_names, fixed = TRUE) # vector of num. of columns containing in name "mean()"
cwstd <- grep("std()", c_names, fixed = TRUE) # vector of num. of columns containing in name "std()"
# mean(var1) != var1 by mean(var2), so vectors used on the angle() variable were excludet 
n_ok_col <- sort(c(cwmean, cwstd))
training_set <- training_set0[, n_ok_col]
test_set <- test_set0[, n_ok_col]

cn <- c_names[n_ok_col]
cn <- gsub(pattern="()-", replacement="_", cn, fixed = TRUE)
cn <- gsub(pattern="()", replacement="", cn, fixed = TRUE)
cn <- gsub(pattern="-", replacement="_", cn, fixed = TRUE)
cn <- gsub(pattern="tBody", replacement="timeBody", cn, fixed = TRUE)
cn <- gsub(pattern="tGravity", replacement="timeGravity", cn, fixed = TRUE)
cn <- gsub(pattern="fBody", replacement="freqBody", cn, fixed = TRUE)
c_names_ok <- cn

# creating new vectors with subject codes in each data frames
# activity codes for training_set & test_set
training_activ_code <- read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE, sep="")
test_activ_code <- read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE, sep="")

# subject_code
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE, sep="")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE, sep="")

training_set1 <- cbind(subject_train, training_activ_code, training_set)
test_set1 <- cbind(subject_test, test_activ_code, test_set)
# rm(training_set, test_set) # удаляем уже ненужные ДФ, чтобы освободить ОП

# 4. Appropriately labels the data set with descriptive variable names.
colnames(training_set1) <- c("subject", "activity", c_names_ok)
colnames(test_set1) <- c("subject", "activity", c_names_ok)

# 1. Merging the training and the test sets to create one data set
# mergedSets0 = merge(training_set1, test_set1, by=c("subject", "activity"), all=TRUE, suffixes = c(".trn",".tst"))
mergedSet = merge(training_set1, test_set1, all = TRUE);
feat_names_mergedSet <- c_names_ok
for (i in 1:length(feat_names_mergedSet)) {
        feat_names_mergedSet[i] <- paste("aver_of_", feat_names_mergedSet[i], sep="")
}
colnames(mergedSet) <- c("subject", "activity", feat_names_mergedSet)

# 3 Using descriptive activity names to name the activities in the data set (exotic technique ;))
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE, sep="", stringsAsFactors = FALSE)
for (i in 1:nrow(mergedSet)) {
        act <- mergedSet[i, "activity"]
        mergedSet[i, "activity"] <- activity_labels[act,2]
}

# 5. From the data set in step 4, creating a second, independent tidy data set with the average of each variable for each activity and each subject.        
data_Melt <- melt(mergedSet, id=c("subject", "activity"), measure.vars=feat_names_mergedSet)
res <- dcast(data_Melt, subject + activity ~ variable, mean)

# 6.txt file created with write.table() using row.name=FALSE 
if( !file.exists("./UCI HAR Dataset/Analysis")) {dir.create("./UCI HAR Dataset/Analysis")}
write.table(res, "./UCI HAR Dataset/Analysis/Analisys_result.txt",row.name=FALSE)
