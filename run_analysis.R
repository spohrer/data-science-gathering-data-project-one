# run_analysis.R


# DATA SOURCE CITATION:  [1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

# STEP 1: merge training test sets with testing sets, along with the activity classes as the last column


# this is my setup for my files
# setwd("/home/cxs/Documents/online-learning/data-science-getting-and-cleaning-data-2014/code")

# we have four files to read
#  "./UCI HAR Dataset/test/X_test.txt"
#  "./UCI HAR Dataset/test/y_test.txt"
#   "./UCI HAR Dataset/train/X_train.txt"
#  "./UCI HAR Dataset/train/y_train.txt"

# my workfiles resided in subdirectories
# default these to empty strings when ready to upload this program
# subdir_train = "./UCI HAR Dataset/train/"
subdir_train = ""
# subdir_test = "./UCI HAR Dataset/test/"
subdir_test = ""
# subdir = "./UCI HAR Dataset/"
subdir = ""


 

filename = paste(subdir_train, "X_train.txt", sep = "")
con = file(filename, open="r")
df_x_train <- read.table(file=con)
close(con)

filename = paste(subdir_train, "y_train.txt", sep = "")
con = file(filename, open="r")
df_y_train <- read.table(file=con)
close(con)

filename = paste(subdir_test, "X_test.txt", sep = "")
con = file(filename, open="r")
df_x_test <- read.table(file=con)
close(con)

filename = paste(subdir_test, "y_test.txt", sep = "")
con = file(filename, open="r")
df_y_test <- read.table(file=con)
close(con)


# read in features labels 

filename = paste(subdir, "features.txt", sep = "")
con = file(filename, open="r")
dfnames <- read.table(file=con)
close(con)



# read in subject labels 
filename = paste(subdir_train, "subject_train.txt", sep = "")
con = file(filename, open="r")
df_train_subject <- read.table(file=con)
close(con)

filename = paste(subdir_test, "subject_test.txt", sep = "")
con = file(filename, open="r")
df_test_subject <- read.table(file=con)
close(con)

dim(df_x_train)
dim(df_y_train)
dim(df_x_test)
dim(df_y_test)
dim(df_train_subject)
dim(df_test_subject)


# create one dataset with ALL the variables and rows

colnames(df_x_train) <- dfnames[,2]
colnames(df_y_train) <- c("activity_number")
colnames(df_train_subject) <- c("subject_number")
df_train <- cbind( df_x_train, df_y_train)
df_train <- cbind(df_train, df_train_subject)

colnames(df_x_test) <- dfnames[,2]
colnames(df_y_test) <- c("activity_number")
colnames(df_test_subject) <- c("subject_number")
df_test <-  cbind( df_x_test, df_y_test)
df_test <- cbind(df_test, df_test_subject)

df <- rbind(df_train, df_test)

dim(df)

# head(df, n=3)


# ADDITIONAL CLEANUP

# STEP 1B: there are duplicate column names, which will cause trouble later,
# so we need to make them unique. 

nam <- colnames(df)
length(nam)  # 563, which includes our new columns for activity_number and subject_number
length(unique(nam)) # 479, which is much less then 563

# fortunately there is a function in base R that does the trick,
# I found this out by querying stackoverflow.com, The reference is:
# https://stackoverflow.com/questions/18766700/r-rename-duplicate-col-and-rownames-subindexing
# see ?make.unique
# default behavior is to append ".1", or ".2" and so on to the name

# nam <- colnames(df)
nam <- make.unique(nam)
colnames(df) <- nam
length(nam)  # 563



# STEP 2: extract only those fields that measure 
# the mean or standard deviation

nam <- colnames(df)
mean_columns <- nam[grep("mean\\(", nam)]
std_columns <-  nam[grep("std", nam)]
mycolumns <- c(mean_columns, std_columns, "activity_number", "subject_number")

df <- df[, mycolumns]
dim(df)


# STEP 3 & 4: replace the activity numbers with the descriptive names

# read in activity labels 
filename = paste(subdir, "activity_labels.txt", sep = "")
con = file(filename, open="r")
dfactivitylabels <- read.table(file=con)
close(con)

colnames(dfactivitylabels) <- c("activity_number", "activity_labels")
dim(dfactivitylabels)
str(dfactivitylabels)

# now merge the activity labels into the data set
df <- merge(df, dfactivitylabels)
dim(df)


# STEP 5: output the dataset, 
# with the average of each variable for each activity and each subject


# data.table package is by far an easier and faster way to get breakdowns on 
# multiple column subgroups

require(data.table)

# define the data frame as a data table
df <- as.data.table(df)   

# define keys on subhect_number and activity_labels
setkeyv(df, c("subject_number", "activity_labels")) 

# create the outut data frame
dfout <- df[, lapply(.SD, mean), by=c("subject_number", "activity_labels")]

# display a few rows just to see
head(dfout)

# write it out to disk, for submission

write.csv(dfout, file="tidy_analysis.txt", row.names = FALSE)


############ end of program ###############