Coursera: Getting and Cleaning Data
Peer Graded Assignment
There are four important components of this project as follows:

1. Raw Data Set
Data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
Here is the link for the project data:
"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


2. Tidy Data Set
As stated in the Coursera Course "Getting and Cleaning Data" video, the components of Tidy Data are as follows:
1. Each variable you measure should be in one column
2. Each different observation of that variable should be in a different row
3. There should be one table for each "kind" of variable
4. If you have multiple tables, they should include a column in the table that allows them to be linked.
Also, each column should have a descriptive variable name.
Variables are lower case as requested by ******* for simplicity
In our tidy data set, each column represents a separate variable.  The columns begin (far left) with fixed variables activity and subject.
As the columns move to the right, we see a separate column for each variable that was measured.  Breaking down the columns any further is unnecessary and/or introduces N/As.
For a full description of variable names, please see the code book.

3. Code Book (meta data) that describes each variable and its values in the tidy data set. (See Code Book text file)

4. Script to go from Raw Data Set to Tidy Data Set (See run_analysis.R file)