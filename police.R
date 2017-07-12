#### Created 3/16 by Daniel Hadley to download Somerville's Police data ####
# DPH worked with Chris Wendt to write the code that would pull from their ODBC and upload to Socrata
# This script just downloads that
# TODO: use their API to set up incremental instead of hitting their servers each night


# working Directory: the part you change for your machine #
setwd("C:/Users/mmastrobuoni.CH2SOM-MMASTROB/Documents/GitHub/Somerville_Data_Pipes/")

library(data.table)

### I save two copies, one that is for the pipelines, which I hope people will not use

qol <- fread("https://data.somervillema.gov/api/views/n5sm-r6zx/rows.csv?accessType=DOWNLOAD")

write.csv(qol,'//cos-chb-share1/Somerstat Data/Police/daily/QualityOfLife.csv')
write.csv(qol,'//cos-chb-share1/Somerstat Data/Police/daily/data_pipeline_pls_dont_use/QualityOfLife.csv')



ci <- fread("https://data.somervillema.gov/api/views/4jey-jqxb/rows.csv?accessType=DOWNLOAD")

write.csv(ci, "//cos-chb-share1/Somerstat Data/Police/daily/CriminalIncidents.csv")
write.csv(ci,'//cos-chb-share1/Somerstat Data/Police/daily/data_pipeline_pls_dont_use/CriminalIncidents.csv')



mvc <- fread("https://data.somervillema.gov/api/views/3md9-rv67/rows.csv?accessType=DOWNLOAD")

write.csv(mvc,'//cos-chb-share1/Somerstat Data/Police/daily/MotorVehicleCitations.csv')
write.csv(mvc,'//cos-chb-share1/Somerstat Data/Police/daily/data_pipeline_pls_dont_use/MotorVehicleCitations.csv')



te <- fread("https://data.somervillema.gov/api/views/j2bq-38ev/rows.csv?accessType=DOWNLOAD")

write.csv(te, "//cos-chb-share1/Somerstat Data/Police/daily/TrafficEnforcement.csv")
write.csv(te,'//cos-chb-share1/Somerstat Data/Police/daily/data_pipeline_pls_dont_use/TrafficEnforcement.csv')



#### Now we add an output to the check_pipes file ####
check_the_pipes <- read.csv("./check-the-pipes.csv", stringsAsFactors = FALSE)

# First I am just going to add today's date to show when the script ran
check_the_pipes[which(check_the_pipes$data_set == "Police_qol"), 2] <- as.character(Sys.Date())
check_the_pipes[which(check_the_pipes$data_set == "Police_ci"), 2] <- as.character(Sys.Date())
check_the_pipes[which(check_the_pipes$data_set == "Police_mvc"), 2] <- as.character(Sys.Date())
check_the_pipes[which(check_the_pipes$data_set == "Police_te"), 2] <- as.character(Sys.Date())


# Now a simple message on each saying whether the data was downloaded or not
check_the_pipes[which(check_the_pipes$data_set == "Police_qol"), 3] <- 
  ifelse(length(qol) != 1, 
         "Error dowloading latest data from Socrata",
         "Downloaded latest data from Socrata")

check_the_pipes[which(check_the_pipes$data_set == "Police_ci"), 3] <- 
  ifelse(length(ci) != 1, 
         "Error dowloading latest data from Socrata",
         "Downloaded latest data from Socrata")

check_the_pipes[which(check_the_pipes$data_set == "Police_mvc"), 3] <- 
  ifelse(length(mvc) != 1, 
         "Error dowloading latest data from Socrata",
         "Downloaded latest data from Socrata")

check_the_pipes[which(check_the_pipes$data_set == "Police_te"), 3] <- 
  ifelse(length(te) != 1, 
         "Error dowloading latest data from Socrata",
         "Downloaded latest data from Socrata")


write.csv(check_the_pipes, "./check-the-pipes.csv", row.names = FALSE)

