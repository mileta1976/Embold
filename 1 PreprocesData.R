

######  Set working directory  #################

setwd("/home/mileta/Downloads/Machinehack/EmboldGithub")


######  Load libraries   #######################

library(textfeatures)
set.seed(0)


###### Load datasets ###############################

ltr <- RJSONIO::fromJSON('embold_train.json')
lte <- RJSONIO::fromJSON('embold_test.json')

df <- data.frame(matrix(unlist(ltr), nrow=length(ltr), byrow=T),stringsAsFactors=FALSE)
te <- data.frame(matrix(unlist(lte), nrow=length(lte), byrow=T),stringsAsFactors=FALSE)

Xtr <- df
Xte <- te

rm(ltr, lte)


###### combine columns ###########################

df$X2 <- paste(df$X1, df$X2)
te$X2 <- paste(te$X1, te$X2)


###### remove title, add label to test ############

df$X1 <- NULL
te$X1 <- NULL
te$X3 <- 0

###### rename columns  ############################

colnames(df) <- c('text', 'label')
colnames(te) <- c('text', 'label')

###### convert label to integer

df$label <- as.integer(df$label)
te$label <- as.integer(te$label)


######  combine train and test  ###################

full <- rbind(df, te)
tri <- 1:nrow(df)

rm(df, te)

######   get text features  ########################

temp <- textfeatures(full$text)

rm(full)

######  prepare new train and new test  ############

tr <- temp[tri,]
tr$title <- Xtr$X1
tr$body <- Xtr$X2
tr$label <- Xtr$X3

te <- temp[-tri,]
te$title <- Xte$X1
te$body <- Xte$X2

###### write to csv ###############################

write.csv(tr,"train14.csv", row.names = F)
write.csv(te,"test14.csv", row.names = F)
