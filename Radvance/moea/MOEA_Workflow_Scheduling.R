# Read Data and Preliminary Process

# Set working directory 
setwd("/Users/phuong/rworkspace/WorkflowAnalysis/Radvance/moea")

## Use SQLite Database
library(DBI)
library(RSQLite)

## connect to databases --> should be improved using loop
databaseNames = c("scheduleTests","evolutionTest")

## Prepare query functions
## query data function

query_data_from_database <- function(database) {
  tempData <- dbGetQuery(database,'
                         select * from experiments e
                         inner join configfile f
                            on e.id = f.id
                         inner join configInstances i
                            on f.id = i.id'
                         )
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
library(dplyr)

for(workflow in databaseNames) {
  
  fileName = paste(workflow, ".csv", sep="")
  # print(fileName)
  data = read.csv(fileName)
  
  # process Data
  data = select(data, makespan, totalCosts, vmType, provisioningRate, numVmsStart,	numVmsTotal,	numVmsUnused, capacityInterruptionRate, numInterruptions, daxFiles,schedulingPlanningAlgorithm)

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

## Separate the data following conditions and merge them for calculating pareto front
data = read.csv("evolutionTest_core.csv")
data1 = subset(data, data$capacityInterruptionRate == 0.25)
data2 = subset(data, data$capacityInterruptionRate == 0.3)

newdata = cbind(data1, data2)
write.csv(newdata, file = "newdata2.csv", row.names = FALSE)

## for calculating pareto front using jMetal
write.table(newdata, file = "newdata2_paretocal.csv", sep=",",  col.names=FALSE, row.names = FALSE, quote = FALSE)

## Run jMetal to calculate the Pareto front
#### setwd("/Users/phuong/PhD/Programs/jMetal")
#### system("./generatePareto_ver2.sh", wait=FALSE)

## Plotting the Pareto front

### Preprocess data - add column name
library(ggplot2)

data = read.csv("newdata2_paretocal_pf.csv")
colnames(data) <- c("makespanPoo1","makespanPool2","totalCostPool1", "numVmsStart1",	"numVmsTotal1", "capacityInterruptionRate1", "numInterruptions1",
                    "totalCostPool2", "numVmsStart2",	"numVmsTotal2", "capacityInterruptionRate2", "numInterruptions2")

theme_set(theme_bw() + theme(plot.title = element_text(hjust=0.5)))

ggplot(data, aes(x=makespanPoo1, y=makespanPool2)) + geom_point() +  geom_line() + 
  labs(subtitle="Pareto solutions", 
       y="Makespan Pool1 ", 
       x="Makespan Pool2 ", 
       title="titleName")





