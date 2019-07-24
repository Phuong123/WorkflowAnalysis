# Read Data and Preliminary Process

# Set working directory 
setwd("/Users/phuong/rworkspace/WorkflowAnalysis/Radvance/moea/montagedata")

## Use SQLite Database
library(DBI)
library(RSQLite)

## connect to databases --> should be improved using loop

#databaseNames = c("Montage_Exp1","Montage_Exp2","Montage_Exp3","Montage_Exp4","Montage_Exp5")
databaseNames = c("workflowExperiments4")

## Prepare query functions
## query data function

query_data_from_database <- function(database) {
  tempData <- dbGetQuery(database,'
                         select * from experiments e
                         inner join configfile f on e.id = f.expId
                         inner join configInstances i on f.id = i.configfileId
                         group by i.configfileId '
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
data = read.csv("workflowExperiments4_core.csv")
data1 = subset(data, data$provisioningRate == 1.0)
data2 = subset(data, data$provisioningRate == 0.9)

newdata = cbind(data1, data2)
write.csv(newdata, file = "newdata2.csv", row.names = FALSE)

## for calculating pareto front using jMetal
write.table(newdata, file = "newdata2_paretocal.csv", sep=",",  col.names=FALSE, row.names = FALSE, quote = FALSE)

data = read.csv("Montage_Exp1_core.csv")

data1 = subset(data, data$provisioningRate == 0.9)
write.csv(data1, file = "data1.csv", row.names = FALSE)
colnames(data1) <- c("makespan1", "totalCosts1", "provisioningRate1", "numVmsStart1",	"numVmsTotal1", "capacityInterruptionRate1", "numInterruptions1")

data2 = subset(data, data$provisioningRate == 0.8)
write.csv(data2, file = "data2.csv", row.names = FALSE)
colnames(data2) <- c("makespan2", "totalCosts2", "provisioningRate2", "numVmsStart2",	"numVmsTotal2", "capacityInterruptionRate2", "numInterruptions2")

newdata <- order(c(1:ncol(data1), 1:ncol(data2)))
#cbind data1 and data2, interleaving columns with x
newdata2 <- cbind(data1, data2)[,newdata]
write.csv(newdata2, file = "newdata2.csv", row.names = FALSE)

#newdata = cbind(data1, data2)
#write.csv(newdata, file = "newdata.csv", row.names = FALSE)

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





