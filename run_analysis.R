##WU YUE
##2017-08-18

# Read in the data from files
features <- read.table('./UCI HAR Dataset/features.txt',header=FALSE); 
activityType <- read.table('./UCI HAR Dataset/activity_labels.txt',header=FALSE); 
colnames(activityType)  = c('activityID','activityType');

subjectTrain <- read.table('./UCI HAR Dataset/train/subject_train.txt',header=FALSE); 
colnames(subjectTrain)<-"subjectID";
xTrain <- read.table('./UCI HAR Dataset/train/x_train.txt',header=FALSE); 
colnames(xTrain)<-features[,2];
yTrain  <- read.table('./UCI HAR Dataset/train/y_train.txt',header=FALSE);
colnames(yTrain)<-"activityID";

subjectTest <- read.table('./UCI HAR Dataset/test/subject_test.txt',header=FALSE); 
colnames(subjectTest)<-"subjectID";
xTest <- read.table('./UCI HAR Dataset/test/x_test.txt',header=FALSE);
colnames(xTest)<-features[,2];
yTest <- read.table('./UCI HAR Dataset/test/y_test.txt',header=FALSE);
colnames(yTest)<-"activityID";
#merge
trainData <- cbind(yTrain,subjectTrain,xTrain);
testData <- cbind(yTest,subjectTest,xTest);


allData <- rbind(trainData,testData);

#label with descriptive names
names<-colnames(allData);
names<-gsub("[-()]","",names);
names<-gsub("-mean","Mean",names);
names<-gsub("-std", "Std",names);

colnames(allData)<-names;

#Extract only the measurements on the mean and standard deviation for each measurement
ind<-grepl("activity",names)|grepl("subject",names)|grepl("Mean",names)|grepl("Std",names)

allData<-allData[ind];
#Appropriately label the data set with descriptive activity names
allData$activityID<-factor(allData$activityID,levels = activityType[,1],labels = activityType[,2]);

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
library(dplyr);
allData<-group_by(allData,activityID,subjectID);
allData<-summarize_all(allData,funs(mean));

write.table(allData, "./tidyData.txt", row.names = FALSE)

