##Step 1
##Read the train data set
xtrain <- read.table ("train/X_train.txt")
ytrain <- read.table ("train/y_train.txt" ,col.names = "activity_id")
sbj_train <- read.table ("train/subject_train.txt", col.names = "subject_id")

##Add Id column
ytrain$ID <- as.numeric(row.names(ytrain))
sbj_train$ID <- as.numeric(row.names(sbj_train))
xtrain$ID <- as.numeric(row.names(xtrain))

#merge y_train, subject_train and X_train
tr <- merge(sbj_train, ytrain, by = c('ID'), all = TRUE)
train <- merge (tr, xtrain, by = ('ID'), all = TRUE)



##Read the test data set
xtest <- read.table ("test/X_test.txt")
ytest <- read.table ("test/y_test.txt"  ,col.names = "activity_id")
sbj_test <- read.table ("test/subject_test.txt", col.names= "subject_id")

##Add Id column
ytest$ID <- as.numeric(row.names(ytest))
sbj_test$ID <- as.numeric(row.names(sbj_test))
xtest$ID <- as.numeric(row.names(xtest))

#merge y_test, subject_test and X_test
te <- merge(sbj_test, ytest, by = c('ID'), all = TRUE)
test <- merge (te, xtest, by = ('ID'), all = TRUE)


#merge test and train data to get the total data either using merge or rbind
##data <- merge( train , test, all = TRUE)
data <- rbind(train , test)


##Step 2
features <- read.table("features.txt", col.names = c("feature_id", "feature_name"))
mean_sd_features <- features [grep("mean|std", features$feature_name),]

data2 <- data[, c(c(1, 2, 3), mean_sd_features$feature_id + 3) ]

##Step 3
actname = read.table("activity_labels.txt", col.names=c("activity_id", "activity_name"),)
data3 <- merge(data2, actname)

##Step 4
mean_sd_features$feature_name = gsub("\\(\\)", "", mean_sd_features$feature_name)
mean_sd_features$feature_name = gsub("-", ".", mean_sd_features$feature_name)

for (i in 1:length(mean_sd_features$feature_name)) {
     colnames(data3)[i + 3] <- mean_sd_features$feature_name[i]
}

data4 <- data3

##Step 5
drops <- c("ID","activity_name")
data5 <- data4[,!(names(data4) %in% drops)]
aggdata <-aggregate(data5, by=list(subject = data5$subject_id, activity = data5$activity_id), FUN=mean, na.rm=TRUE)
drops <- c("subject","activity")
aggdata <- aggdata[,!(names(aggdata) %in% drops)]
aggdata = merge(aggdata, actname)
write.table(file="submit.txt", x=aggdata, row.name = FALSE)


