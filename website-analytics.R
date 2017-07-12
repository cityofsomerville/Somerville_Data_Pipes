#### Created 3/16 by Daniel Hadley to download and upload Somerville's website data ####


# working Directory: the part you change for your machine #
setwd("C:/Users/mmastrobuoni.CH2SOM-MMASTROB/Documents/GitHub/Somerville_Data_Pipes")


# This pulls in the credentials you need
# Nothing from this, but make sure to copy the oauth_token when you copy the repository 

library(RGoogleAnalytics)
library(RCurl)
library(dplyr)
library(tidyr)


# Load the token object
load("oauth_token")
ValidateToken(oauth_token)


# Create a list of Query Parameters
query.list <- Init(start.date = as.character(Sys.Date()-1),
                   end.date = as.character(Sys.Date()),
                   dimensions = "ga:pageTitle",
                   metrics = "ga:sessions,ga:pageviews",
                   max.results = 1000,
                   table.id = "ga:26776898")

# Create the query object
ga.query <- QueryBuilder(query.list)
# Fire the query to the Google Analytics API
ga.df <- GetReportData(ga.query, oauth_token)




#### Top from last day #### 
# dates
today <- Sys.Date()
yesterday <- today - 1
time <- Sys.time()

ga.df$pageTitle <- gsub("| City of Somerville Website", "", ga.df$pageTitle)

write.csv(ga.df, "//cos-chb-share1/Somerstat Data/Website_Analytics/LastTwentyFour.csv")
write.csv(ga.df, "//cos-chb-share1/Somerstat Data/Website_Analytics/data_pipeline_pls_dont_use/LastTwentyFour.csv")




#### Now we add an output to the check_pipes file ####
check_the_pipes <- read.csv("./check-the-pipes.csv", stringsAsFactors = FALSE)

# First I am just going to add today's date to show when the script ran
check_the_pipes[which(check_the_pipes$data_set == "Website Analytics"), 2] <- as.character(Sys.Date())


# Now a simple message on each saying whether the data was downloaded or not
check_the_pipes[which(check_the_pipes$data_set == "Website Analytics"), 3] <- 
  ifelse(length(ga.df) < 2, 
         "Error dowloading latest data from Google API",
         "Downloaded latest data from Google API")


write.csv(check_the_pipes, "./check-the-pipes.csv", row.names = FALSE)

