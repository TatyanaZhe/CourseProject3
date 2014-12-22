 This script does the following. 
 0.Create the data frames from training and test data sets
 1.Merges the training and the test sets to create one data set.
 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
 3.Uses descriptive activity names to name the activities in the data set
 4.Appropriately labels the data set with descriptive variable names. 
 5.From the data set in step 4, creates a second, independent tidy data set 
       with the average of each variable for each activity and each subject.
 6.Creates in directory with raw data subdirectory called "Analysis" 
       and write into this directory file called "Analisys_result.txt", 
       each contains resulting tidy data.
----------------------------------------------------------------------------------
Script use following packages: data.table, plyr, reshape2.
For use "run_analysis.R" place its and directory "UCI HAR Dataset" with raw data sets in your working directory.
Than just source the  R-code.
