library(dplyr)

## Set wd
setwd("/Users/phuong/PhD/Programs/Prediction/practices/queryData")

workflowName = c("cybershake", "inspiral", "sipht", "epigenomics")
scheduleName = c("_rr","_heft")

## Concatenate workflowName and scheduleName
for(workflow in workflowName) {
  for(schedule in scheduleName) {
    
    fileName = paste(workflow, schedule, ".csv", sep="")
    # print(fileName)
    data = read.csv(fileName)
    
    # process Data
    data = select(data,makespan,total_costs,instanceTypes,numOfVms,provisioningRate,num_vms,capacityIntrptRates,num_interruptions,daxFiles,planScheduleAlg)
    
    ## sapply does not work double times so we use temporary file temp.csv 
    data <- sapply(data,function(x) {x <- gsub("\\[|\\]","", x)})
    write.csv(data,"temp.csv", row.names = FALSE)
    
    data = read.csv("temp.csv")
    data <- sapply(data,function(x) {x <- gsub("config/dax/","", x)})
    
    # write to new file
    newName = paste("./pareto/",workflow, schedule, "_core2", ".csv", sep = "")
    # write.csv(data, file = newName, row.names = FALSE)
    write.table(data, file = newName, sep=",",  col.names=FALSE, row.names = FALSE, quote = FALSE)
    
  }
  
}






