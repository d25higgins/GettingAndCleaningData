# Getting and Cleaning Data Course Project

## Tidy Data from a previous study

The script file run_analysis.R is used to produce a tidy data set from the Human Activity Recognition Using Smartphones Dataset.

The script is self-contained and requires no inputs.  It is assumed that the script will run from a current working directory and will build its own data directory underneath it.  The link to the original data is embedded in the script and it should run and produce the tidyDataSet.txt in the same ./data/ directory.

If the machine where the script is to be run doesn't have some of the necessary scripts, then the install.packages lines at the top of the script file should be uncommented before running.

Included with this file and the R script should be a codebook file with information on the variables and data produced.  

The run_analysis.R file is fairly well documented if there are any questions about the methodology.  There is no additional INSTRUCTION LIST file since there are no manual operations. However, below is a short sysnopsis of what the script does.  The actual script code should be viewed to see any deatails.

## Script Synopsis

Generally, the script file will download the original data and extract it from the zip file.  It should be noted that the script relys on the data.table, dplyr and stringr packages and will reference those Libraries.

The test and train datasets are loaded and the variable names are also loaded.  Before being applied to the datasets the names as cleaned up a bit due to some sketchy naming.

The names are added and the test and train datasets are merged.  To this, the subjects and activities are also added.

The activities are replaced with values instead of indexes.

A subset of the data is placed into a data table.  This subset only contains variables dealing with Mean and Standard Deviation values.

Finally the filtered data is grouped by the activities and subjects and a mean of the remaing columns is taken and that is what is finally written out to the tidyDataSet.txt file.

