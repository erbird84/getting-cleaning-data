


setwd("/Users/ericbird/Desktop/Playground/UCI HAR Dataset/")
library(plyr)
library(dplyr)


#1. bring in data
#bring in train files
features = read.table("features.txt", header=FALSE)
activitytype = read.table("activity_labels.txt", header = FALSE)
subject_train = read.table("train/subject_train.txt", header = FALSE)
X_Train = read.table("train/X_train.txt", header = FALSE)
Y_Train = read.table("train/Y_train.txt", header = FALSE)



#bring in test files
subject_test = read.table("test/subject_test.txt", header = FALSE)
X_Test = read.table("test/X_test.txt", header = FALSE)
Y_Test = read.table("test/Y_test.txt", header = FALSE)


#assign column names
colnames(activitytype) = c('activityId','activityType')
colnames(subject_train)  = "subjectId"
colnames(X_Train)        = features[,2]
colnames(Y_Train)        = "activityId"
colnames(subject_test) = "subjectId"
colnames(X_Test)       = features[,2] 
colnames(Y_Test)       = "activityId"

#2. limit to columns needed
#limit columns
mean_and_std <- grep("-(mean|std)\\(\\)", features[, 2])
X_Train = X_Train[,mean_and_std]
X_Test = X_Test[,mean_and_std]


#merge data
train_data = bind_cols(Y_Train,subject_train,X_Train)
test_data = bind_cols(Y_Test,subject_test,X_Test)
final_data = bind_rows(train_data,test_data)

#3. Use activity types for descriptions
final_data = left_join(final_data, activitytype, by = "activityId")
final_data = select(final_data, -activityId)

#4. Change name of subjectId to subject
final_data = rename(final_data, c("subjectId"="subject"))


#5. Aggregate data by activityType and subject
#aggregate
aggregates = final_data %>% group_by(activityType, subject) %>% summarise_each(funs(mean))


write.table(aggregates, "averages_data.txt", row.name=FALSE)





