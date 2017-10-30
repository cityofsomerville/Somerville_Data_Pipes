#Set this for your working directory
setwd("C:/Users/eweisman/Documents/testing")

# This pulls in the credentials you need.  You must have an API key for Qscend to use this script
source("./config.R")

library(data.table)
library(RCurl)
library(dplyr)
library(tidyr)
library(jsonlite)
library(lubridate)
library(httr)
activitylist = list()
submitterlist = list()
requestlist = list()


x <- as.Date('2015-7-1')
while (x <= Sys.Date()) {
	api <- paste("https://somervillema.qscend.com/qalert/api/v1/requests/dump/?start=", month(x), "%2F", day(x), "%2F", year(x),"&end=", month(x+9), "%2F", day(x+9), "%2F", year(x+9), "&key=", Qsend_API_key, sep = "")

	d <- fromJSON(api)
	  activityChanges <- d$activity
	  activityChanges$x <- x  # maybe you want to keep track of which iteration produced it?
    activitylist[[x]] <- activityChanges # add it to your list
    
    submitterChanges <- d$submitter %>% select(-twitterId, -twitterScreenName)
    submitterChanges$x <- x  # maybe you want to keep track of which iteration produced it?
    submitterlist[[x]] <- submitterChanges # add it to your list
    
    requestChanges <- d$request
    requestChanges$x <- x  # maybe you want to keep track of which iteration produced it?
    requestlist[[x]] <- requestChanges # add it to your list

	x <- x + 10}

big_data <- rbindlist(activitylist)
big_data <- big_data[!duplicated(big_data$id),]
big_data <- select(big_data, -files,-x)
write.table(big_data, "C:/Users/eweisman/Documents/testing/dump_activity.csv",append = TRUE, sep = ",",eol = "\n",quote = TRUE, row.names = FALSE,qmethod = c("double"))

big_data <- rbindlist(submitterlist)
big_data <- big_data[!duplicated(big_data$id),]
big_data <- select(big_data, -x)
write.table(big_data, "C:/Users/eweisman/Documents/testing/dump_submitter.csv",append = TRUE, sep = ",",eol = "\n",quote = TRUE, row.names = FALSE,qmethod = c("double"))

big_data <- rbindlist(requestlist)
big_data <- big_data[!duplicated(big_data$id),]
big_data <- select(big_data, -x)
write.table(big_data, "C:/Users/eweisman/Documents/testing/dump_request.csv",append = TRUE, sep = ",",eol = "\n",quote = TRUE, row.names = FALSE,qmethod = c("double"))
