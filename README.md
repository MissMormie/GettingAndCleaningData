GettingAndCleaningData
======================
The run_analysis.R file contains a single function "createTidyData" and a few 
seperate commands at the bottom of the file. 

First of it checks to see if the required data (or at least the directory holding 
the data) is present, to prevent errors further on. 

The function createTidyData takes as input the locations of the files of x, y and 
subject. In this way no different code is required for creating the training and
testing data, but both are build using this function.

createTidyData() reads in the data from x, y, subject, feature and activity_labels. 
First of all it gives an id to the data frames to make sure if any ordering/arranging
or merging changes the order of a data frame the final merging is still done on 
the correct rows. 

First createTidyData renames the columns of x with the content from 'feature'. 
This then allows the script to subset x with just the columns that contain the 
word 'mean' or the word 'std'.

Next createTidyData merges the y data with the activity data to create a data frame 
that holds the written out names of the activities for all rows. After this the 
subjects are also merged into the data frame using the ids that every data frame 
has to ensure correct matching. And finally the same is done for the x data frame.