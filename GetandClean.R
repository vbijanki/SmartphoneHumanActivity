# get and clean Human Activity Using Smartphones Data Set
# Author: Vinieth Bijanki

#part one: download data and merge data sets to creat one data set
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL, destfile = "data.zip")
unzip("data.zip")

setwd("./UCI HAR Dataset")
#read in the data as tables
tr_x <- read.table("train/X_train.txt")
tr_sub <- read.table("train/subject_train.txt")
tr_y <- read.table("train/y_train.txt")
t_x <- read.table("test/X_test.txt")
t_sub <- read.table("test/subject_test.txt")
t_y <- read.table("test/y_test.txt")
#merge each set of three tables, then merge both sets
tr_total <- cbind(tr_x,tr_sub,tr_y)
t_total <- cbind(t_x,t_sub, t_y)
totalData <- rbind(tr_total,t_total)
#read in features data
column_names <- c("id","name")
features_data <- read.table("features.txt", col.names = column_names)
features <- c(as.vector(features_data[,"name"]), "subject", "activity")
#filter out specific feture
feature_id_filt <- grepl("mean|std|subject|activity", features) &!grepl("meanFreq", features)
filtered_data <- totalData[,feature_id_filt]
#read in the activities data, then fill in the filtered_data table under "activities" to label wach measurment
activity_labels <- read.table("/activity_labels.txt", col.names=column_names)
for (i in 1:nrow(activity_labels)) {
  filtered_data$activity[filtered_data$activity == activity_labels[i, "id"]] <- activity_labels[i, "name"]
}
#sub names for easier human readability
feature_readable <- features[feature_id_filt]
feature_readable <- gsub("-", "_", feature_readable)
feature_readable <- gsub("BodyBody", "Body", feature_readable)
feature_readable <- gsub("Acc", "_Acceleration", feature_readable)
feature_readable <- gsub("Mag", "_Magnitude", feature_readable)
feature_readable <- gsub("^t(.*)$", "\\1_time", feature_readable)
feature_readable <- gsub("^f(.*)$", "\\1_frequency", feature_readable)


#assign these new feature names to the filtered data dataset
names(filtered_data) <- feature_readable


tidyData <- tbl_df(filtered_data) %>%
  group_by(subject, activity) %>%
   summarise_each(funs(mean)) %>%
     gather(measurement,mean,-subject, -activity)

