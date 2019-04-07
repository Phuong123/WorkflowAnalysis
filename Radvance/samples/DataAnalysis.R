# Set wd
setwd("/Users/phuong/PhD/Programs/Prediction/practices/NEWDATA")

############################### Query and store data to csv file #######

## Use SQLite Database
library(DBI)
library(RSQLite)

## connect to databases --> should be improved using loop
databaseNames = c("CyberShake", "Inspiral", "Sipht", "Epigenomics","Montage",
                  "CyberShake_heft","Inspiral_heft","Sipht_heft","Epigenomics_heft","Montage_heft")


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


################################ Extract and manipulate data from csv files #####
library(dplyr)

## Set wd
setwd("/Users/phuong/PhD/Programs/Prediction/practices/NEWDATA")

workflowName = c("CyberShake", "Inspiral", "Sipht", "Epigenomics","Montage",
                 "CyberShake_heft","Inspiral_heft","Sipht_heft","Epigenomics_heft","Montage_heft")

## Concatenate workflowName and scheduleName
for(workflow in workflowName) {
    
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
    commonName = paste("./coreData/",workflow, "_core", ".csv", sep = "")
    write.csv(data, file = commonName, row.names = FALSE)
    
    ### For calculating the pareto solutions
    newName = paste("./pareto/",workflow, "_core_for_pareto", ".csv", sep = "")
    write.table(data, file = newName, sep=",",  col.names=FALSE, row.names = FALSE, quote = FALSE)
    
}

###################################### Groupby and Calculate mean of cost and makespan ######

library(dplyr)
## Set wd
setwd("/Users/phuong/PhD/Programs/Prediction/practices/NEWDATA/coreData")

# Round robin and heft algorithms
workflowName = c("CyberShake", "Inspiral", "Sipht", "Epigenomics","Montage",
                 "CyberShake_heft","Inspiral_heft","Sipht_heft","Epigenomics_heft","Montage_heft")

for(workflow in workflowName) {
  
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

############################## Calculate pareto solutions for all of the data in pareto folder #####
### ./generatePareto.sh
setwd("/Users/phuong/PhD/Programs/jMetal")
system("./generatePareto.sh", wait=FALSE)

### Organize code in R 
# functions.R
# add = function(a, b) {
# return(a + b)
# }

# Script.R 
# source('functions.R')
# add(2,4)

############################## The necessary data is availale at this step #########################

############# Use "coreData" or "pareto folder" to do clustering


############## and use pareto results folder to do visualization
library(ggplot2)

setwd("/Users/phuong/PhD/Programs/Prediction/practices/NEWDATA/results")


## Declare plot functions
plotFollowProvision <- function(data, workflowName) {
  
  titleName = paste(workflowName, "- execution on SI ", sep = "")
  
  provisionPlot = ggplot(data, aes(x=total_costs, y=makespan)) + 
    geom_point(aes(col=instanceTypes, size=provisioningRate)) + 
    geom_smooth(method="loess", se=F) + 
    labs(subtitle="Pareto solutions", 
         y="Makespan", 
         x="Total Cost", 
         title=titleName)
  
  return (provisionPlot)
}

plotFollowInterruption <- function(data, workflowName) {
  
  titleName = paste(workflowName, "- execution on SI ", sep = "")
  
  interruptionPlot = ggplot(data, aes(x=total_costs, y=makespan)) + 
    geom_point(aes(col=instanceTypes, size=capacityIntrptRates)) + 
    geom_smooth(method="loess", se=F) + 
    labs(subtitle="Pareto solutions", 
         y="Makespan", 
         x="Total Cost", 
         title=titleName)
 
 return(interruptionPlot)
}
  
## Prepare plots
workflowName = c("CyberShake", "Inspiral", "Sipht", "Epigenomics","Montage")

for(workflow in workflowName) {
  
  fileName = paste(workflow, "_core_for_pareto-solutions", ".csv", sep="")
  # print(fileName)
  theme_set(theme_bw() + theme(plot.title = element_text(hjust=0.5)))
  data = read.csv(fileName)
  colnames(data) <- c("makespan","total_costs","instanceTypes","numOfVms","provisioningRate","num_vms","capacityIntrptRates","num_interruptions","daxFiles","planScheduleAlg")
  
  ## plot and store
  if(identical(workflow, "CyberShake")) {
    c1 = plotFollowProvision(data,workflow)
    c2 = plotFollowInterruption(data,workflow)
  }
  else if(identical(workflow, "Inspiral")) {
    i1 = plotFollowProvision(data,workflow)
    i2 = plotFollowInterruption(data,workflow)
  }
  else if (identical(workflow, "Sipht")){
    s1 = plotFollowProvision(data,workflow)
    s2 = plotFollowInterruption(data,workflow)
  }
  else if (identical (workflow, "Epigenomics")) {
    e1 = plotFollowProvision(data,workflow)
    e2 = plotFollowInterruption(data,workflow)
  }
  else {
    m1 = plotFollowProvision(data,workflow)
    m2 = plotFollowInterruption(data,workflow)
  }
  
}

## Add Source
setwd("/Users/phuong/rworkspace/WorkflowAnalysis/Radvance")
source('MultiplePlots.R')
multiplot(c1, i1, s1, e1, m1, cols=3)

### Ploting 3D - a consideration for simulator paper

x <- cybershake_heft$provisioningRate
y <- cybershake_heft$capacityIntrptRates

# z is a matrix of x and y
z <- cybershake_heft$total_costs

scatter3D(x, y, z, phi = 0, bty = "b2", pch = 20, cex = 2, expand = 0.8,
          highlight.3d = TRUE,
          col = c(data$instanceTypes),
          main = "Cybershake", xlab = "Fulfillment Rate",
          ylab ="Interruption Rate", zlab = "Costs($)",
          ticktype = "detailed",
          clab = c("Costs"))
text3D(x, y, z,  labels = cybershake_heft$instanceTypes, add = TRUE, colkey = FALSE, cex = 0.5)

