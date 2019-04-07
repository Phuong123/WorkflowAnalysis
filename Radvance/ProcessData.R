# Set wd
setwd("/Users/phuong/PhD/Thesis/SmallPapers/2.2 SpotSimulator/newData")

############################### Query and store data to csv file #######

## Use SQLite Database
library(DBI)
library(RSQLite)

## connect to databases --> should be improved using loop
databaseNames = c("experimentPaper","experimentTest", "experimentTest2")


## Prepare query functions
## query data function
query_data_from_database <- function(database) {
  tempData <- dbGetQuery(database,'
                         select * from experiments e
                         inner join configfile f
                         on e.id = f.exp_id')
  return(tempData)
}

write_query_data_to_csv <- function(database, dbName) {
  
  # Query data from corresponding database
  tempData = query_data_from_database(database)
  
  # Store data to corresponding csv file name of database
  fileName = paste(dbName,".csv",sep = "") # db is database Name
  write.csv(tempData, file = fileName, row.names = FALSE)
  
}

###  Get data, store in csv files and disconnect databases.

for (db in databaseNames) {
  # Connect to databse
  dbNameDB = paste(db,".db",sep = "")   # Database name .db
  database <- dbConnect(SQLite(), dbname=dbNameDB)
  
  # Query and store data to csv files
  write_query_data_to_csv(database, db) # pure db name without .db 
  
  # Disconnect the database
  dbDisconnect(database)
}

## Concatenate workflowName and scheduleName
for(workflow in databaseNames) {
  
  fileName = paste(workflow, ".csv", sep="")
  # print(fileName)
  data = read.csv(fileName)
  
  # process Data
  data = select(data,makespan,total_costs,instanceTypes,numOfVms,provisioningRate,num_vms,capacityIntrptRates,num_interruptions,daxFiles,planScheduleAlg)
  
  ## sapply does not work double times so we use temporary file temp.csv 
  data <- sapply(data,function(x) {x <- gsub("\\[|\\]","", x)})
  write.csv(data,"temp.csv", row.names = FALSE)
  
  data = read.csv("temp.csv")
  data <- sapply(data,function(x) {x <- gsub("config/dax/","", x)})
  
  # write to new files
  ### For using in the simulator paper
  commonName = paste(workflow, "_core", ".csv", sep = "")
  write.csv(data, file = commonName, row.names = FALSE)
  
}

###################################### Groupby and Calculate mean of cost and makespan ######

## Special case where we have 2 workflows and 2 input sizes
setwd("/Users/phuong/PhD/Thesis/SmallPapers/2.2 SpotSimulator/newData")

data = read.csv("experimentPaper_core.csv")

## 
data1 = subset(data, data$daxFiles == "Epigenomics_997.xml")
write.csv(data1, file = "Epigenomics_997.csv", row.names = FALSE)

data1_c5 = subset(data1, data1$instanceTypes == "c5.xlarge")
write.csv(data1_c5, file = "Epigenomics_997_c5xlarge.csv", row.names = FALSE)
data1_c3 = subset(data1, data1$instanceTypes == "c3.4xlarge")
write.csv(data1_c3, file = "Epigenomics_997_c34xlarge.csv", row.names = FALSE)

##
data2 = subset(data, data$daxFiles == "CyberShake_1000.xml")
write.csv(data2, file = "CyberShake_1000.csv", row.names = FALSE)

data2_c5 = subset(data2, data2$instanceTypes == "c5.xlarge")
write.csv(data2_c5, file = "CyberShake_1000_c5xlarge.csv", row.names = FALSE)
data2_c3 = subset(data2, data2$instanceTypes == "c3.4xlarge")
write.csv(data2_c3, file = "CyberShake_1000_c34xlarge.csv", row.names = FALSE)

##
data3 = subset(data, data$daxFiles == "Epigenomics_46.xml")
write.csv(data3, file = "Epigenomics_46.csv", row.names = FALSE)

data3_c5 = subset(data3, data3$instanceTypes == "c5.xlarge")
write.csv(data3_c5, file = "Epigenomics_46_c5xlarge.csv", row.names = FALSE)
data3_c3 = subset(data3, data3$instanceTypes == "c3.4xlarge")
write.csv(data3_c3, file = "Epigenomics_46_c34xlarge.csv", row.names = FALSE)

##
data4 = subset(data, data$daxFiles == "CyberShake_50.xml")
write.csv(data4, file = "CyberShake_50.csv", row.names = FALSE)

data4_c5 = subset(data4, data4$instanceTypes == "c5.xlarge")
write.csv(data4_c5, file = "CyberShake_50_c5xlarge.csv", row.names = FALSE)
data4_c3 = subset(data4, data4$instanceTypes == "c3.4xlarge")
write.csv(data4_c3, file = "CyberShake_50_c34xlarge.csv", row.names = FALSE)

## 

library(dplyr)

for(workflow in databaseNames) {
  
  fileName = paste(workflow, "_core", ".csv", sep="")
  # print(fileName)
  data = read.csv(fileName)
  
  ## Calculate average
  data <- select(data, provisioningRate, capacityIntrptRates, makespan, total_costs, instanceTypes) %>%
    group_by(instanceTypes, provisioningRate, capacityIntrptRates) %>%
    summarise(ExecutionTime=mean(makespan), Costs=mean(total_costs))
  
  ## Store to new file
  newFile = paste(workflow, "_core", "_average" ,".csv", sep="")
  write.csv(data, file = newFile, row.names = FALSE)
  
}

#### Process the groupby average for the new data with different input size.

setwd("/Users/phuong/PhD/Thesis/SmallPapers/2.2 SpotSimulator/newData/separation")

workflowNames = c("CyberShake_1000_c34xlarge","CyberShake_1000_c5xlarge",
                  "CyberShake_50_c34xlarge","CyberShake_50_c5xlarge",
                  "Epigenomics_997_c34xlarge", "Epigenomics_997_c5xlarge",
                  "Epigenomics_46_c34xlarge", "Epigenomics_46_c5xlarge"
                  )


for(workflow in workflowNames) {
  
  fileName = paste(workflow, ".csv", sep="")
  # print(fileName)
  data = read.csv(fileName)
  
  data_rr = subset(data, data$planScheduleAlg == "ROUNDROBIN")
  fileRR = paste(workflow, "_rr", ".csv", sep="")
  write.csv(data_rr, file = fileRR , row.names = FALSE)
  
  data_heft = subset(data, data$planScheduleAlg == "HEFT")
  fileHEFT = paste(workflow, "_heft", ".csv", sep="")
  write.csv(data_heft, file = fileHEFT, row.names = FALSE)
  
}

library(dplyr)
for(workflow in workflowNames) {
  
  fileName = paste(workflow, "_rr", ".csv", sep="")
  data = read.csv(fileName)
  
  ## Calculate average
  data <- select(data, provisioningRate, capacityIntrptRates, makespan, total_costs, instanceTypes) %>%
    group_by(instanceTypes, provisioningRate, capacityIntrptRates) %>%
    summarise(ExecutionTime=mean(makespan), Costs=mean(total_costs))
  
  ## Store to new file
  newFile = paste(workflow, "_rr", "_average" ,".csv", sep="")
  write.csv(data, file = newFile, row.names = FALSE)
  
}


for(workflow in workflowNames) {
  
  fileName = paste(workflow, "_heft", ".csv", sep="")
  data = read.csv(fileName)
  
  ## Calculate average
  data <- select(data, provisioningRate, capacityIntrptRates, makespan, total_costs, instanceTypes) %>%
    group_by(instanceTypes, provisioningRate, capacityIntrptRates) %>%
    summarise(ExecutionTime=mean(makespan), Costs=mean(total_costs))
  
  ## Store to new file
  newFile = paste(workflow, "_heft", "_average" ,".csv", sep="")
  write.csv(data, file = newFile, row.names = FALSE)
  
}

#### Process for on-demand only #####
library(dplyr)
setwd("/Users/phuong/PhD/Thesis/SmallPapers/2.2 SpotSimulator/newData/on-demand")

data = read.csv("experimentTest2_core.csv")

schedulePlans = c("ROUNDROBIN","HEFT")
instanceTypes = c("c5.xlarge","c3.4xlarge")
workflowNames = c("Epigenomics_997.xml","Epigenomics_46.xml","CyberShake_50.xml","CyberShake_1000.xml")


for (schedule in schedulePlans) {
  dataS = subset(data, data$planScheduleAlg == schedule)
  for(instance in instanceTypes) {
    dataI = subset(dataS, dataS$instanceTypes == instance)
    
    for (workflow in workflowNames) {
      dataW = subset(dataI, dataI$daxFiles == workflow)
      fileName = paste(workflow, instance, schedule, ".csv", sep="")
      write.csv(dataW, file = fileName, row.names = FALSE)
      
      ## Calculate average
      dataA <- select(dataW, provisioningRate, capacityIntrptRates, makespan, total_costs, instanceTypes) %>%
        group_by(instanceTypes, provisioningRate, capacityIntrptRates) %>%
        summarise(ExecutionTime=mean(makespan), Costs=mean(total_costs))
      
      ## Store to new file
      newFile =  paste(workflow, instance, schedule, "_average" ,".csv", sep="")
      write.csv(dataA, file = newFile, row.names = FALSE)
      
    }
  }
}







