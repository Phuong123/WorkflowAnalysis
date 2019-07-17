## These are core steps for dealing with data
library(DBI)
library(RSQLite)

# Set wd
setwd("/Users/phuong/PhD/Programs/Ranalysis")

########################### Query and Store data to csv file ###########################

## connect to databases
cybershake_rr_1000    <- dbConnect(SQLite(), dbname="experiment_CyberShake.db")

## query data function
query_data_from_database <- function(database) {
  tempData <- dbGetQuery(database,'
                         select * from experiments e
                         inner join configfile h on e.id = h.expId
                         inner join configInstances f on f.configfileId = h.id
                         ')
  return(tempData)
}

## Get data and write to csv files
data1 = query_data_from_database(cybershake_rr_1000)
write.csv(data1, file = "cybershake_rr_1000.csv", row.names = FALSE)

## clear results and disconnect
dbClearResult(data1)
dbDisconnect(data1)

########################### Process the data for optimization ##########################
library(dplyr)

workflowName = c("cybershake")
scheduleName = c("_rr_1000")

## Concatenate workflowName and scheduleName
for(workflow in workflowName) {
  for(schedule in scheduleName) {
    
    fileName = paste(workflow, schedule, ".csv", sep="")
    # print(fileName)
    data = read.csv(fileName)
    
    # process Data
    data = select(data,makespan,totalCosts,instanceType,numVmsStart,numVmsTotal,provisioningRate,capacityInterruptionRate,numInterruptions,daxFiles,schedulingPlanningAlgorithm,biddingStrategy)
    
    ## sapply does not work double times so we use temporary file temp.csv 
    data <- sapply(data,function(x) {x <- gsub("\\[|\\]","", x)})
    write.csv(data,"temp.csv", row.names = FALSE)
    
    data = read.csv("temp.csv")
    data <- sapply(data,function(x) {x <- gsub("config/dax/","", x)})
    
    # write to new file
    newName = paste(workflow, schedule, "_core", ".csv", sep = "")
    
    write.csv(data, file = newName, row.names = FALSE)
    
    ## Use for computing pareto solutions
    newName = paste("./pareto/",workflow, schedule, "_core2", ".csv", sep = "")
    # Without double quote for each value
    write.table(data, file = newName, sep=",",  col.names=FALSE, row.names = FALSE, quote = FALSE)
    
  }
  
}

## Process Data second phase

# Read data
library(dplyr)

# Round robin algorithm
roundrobin = read.csv("cybershake_rr_1000_core.csv")
## Calculate average
data <- select(roundrobin, provisioningRate, capacityInterruptionRate, makespan, totalCosts, instanceType) %>%
  group_by(instanceType, provisioningRate, capacityInterruptionRate) %>%
  summarise(ExecutionTime=mean(makespan), Costs=mean(totalCosts))

write.csv(data, file = "cybershake_rr_1000_groupby.csv", row.names = FALSE)

## Use for computing pareto solutions
newName = paste("./pareto/", "cybershake_rr_1000_groupby_core2", ".csv", sep = "")
# Without double quote for each value
write.table(data, file = newName, sep=",",  col.names=FALSE, row.names = FALSE, quote = FALSE)


## Calculate the pareto optimal sets

### ./generatePareto_ver2.sh
setwd("/Users/phuong/PhD/Programs/jMetal")
system("./generatePareto_ver2.sh", wait=FALSE)


## Ploting or Visualization

