README - run_analysis.R
========================================================

# Purpose:

    To do some data analysis, and data cleanup on measurements taken
    from up to 30 subjects, and their motions as measured by 
    smartphones, as they performed 6 different activities.
    
# Inputs:

    X_train.txt  = file of training observations
    y_train.txt = class variable, one for each training observation
    X_test.txt = file of test observations
    y_test.txt = class variable, one for each test observation
    
    features.txt = file that maps the 561 measurements to their names, 
                    to be used for the variable or column names
    subject_train.txt = file of the subject number participant, 
                    one for each observation in the training set,
                    varies between 1 and 30
    subject_test.txt = file of the subject number participant, 
                    one for each observation in the test set,
                    varies between 1 and 30
    activity_labels.txt = file of descriptions for each of 6 activities 
                    that are measured in this experiment
                    
    ASSUMPTION: the files will all reside in the same directory as 
                    the run_analysis program.
                    
    
# Original source of the data files:
 
DATA SOURCE CITATION:  [1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra 
 and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a 
 Multiclass Hardware-Friendly Support Vector Machine. International Workshop 
 of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

    
    
    
    
    
# Output:

    File name:  tidy_analysis.txt
    
    Format:     comma-seperated-file, with headers, saved with a .txt extension.
    
    Description:  For each measurement that focused on the mean and standard 
                deviation of the various movements that were measured in the
                experiment, we calculate a mean for each measurement grouped by 
                the subject number, and the activity.  For instance, for subject 
                number 1, and for their activity of WALKING, calculate a mean
                for each of the measurements already summarized by a mean or a 
                standard deviation.
                
    
    
# Processing -  The following steps were taken:

    Since the original files where divided into training observations, training classification,
    testing observations and testing classification, they were combined into one large file.
    
    Since the original column names may have had duplicates, the column names where made unique
    by appending either a ".1", or ".2" as appropriate.
    
    Append the class labels to the observations.
    
    Append the activity labels to each observations, matched on activity number.
    
    Append the subject numbers to each observation.
    
    Fcous only on those columns that resulted in a measurement of the mean, 
    or a standard deviation. These columns had "mean" or "std" as part of the
    feature name. I ignored those that also had "meanFreq" as part of the name.
    
    Finally, calculate a mean on each of those columns as grouped by
    subject and activity. Write this out to the file tidy_analysis.txt as
    a comma-seperated file.
    
    
    
