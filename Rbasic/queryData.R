# Set wd
setwd("/Users/phuong/PhD/Programs/Prediction/practices/queryData")

## Use SQLite Database
library(DBI)
library(RSQLite)


## connect to databases
cybershake_rr     <- dbConnect(SQLite(), dbname="CyberShake.db")
cybershake_heft   <- dbConnect(SQLite(), dbname="CyberShake-heft.db")
epigenomics_rr    <- dbConnect(SQLite(), dbname="Epigenomics.db")
epigenomics_heft  <- dbConnect(SQLite(), dbname="Epigenomics-heft.db")
inspiral_rr       <- dbConnect(SQLite(), dbname="Inspiral.db")
inspiral_heft     <- dbConnect(SQLite(), dbname="Inspiral-heft.db")
sipht_rr          <- dbConnect(SQLite(), dbname="Sipht.db")
sipht_heft        <- dbConnect(SQLite(), dbname="Sipht-heft.db")

## query data function
query_data_from_database <- function(database) {
  tempData <- dbGetQuery(database,'
                         select * from experiments e
                         inner join configfile f
                         on e.id = f.exp_id')
  return(tempData)
}

## Get data and write to csv files
data1 = query_data_from_database(cybershake_rr)
write.csv(data1, file = "cybershake_rr.csv", row.names = FALSE)

data2 = query_data_from_database(cybershake_heft)
write.csv(data2, file = "cybershake_heft.csv", row.names = FALSE)

data3 = query_data_from_database(epigenomics_rr)
write.csv(data3, file = "epigenomics_rr.csv", row.names = FALSE)

data4 = query_data_from_database(cybershake_heft)
write.csv(data4, file = "epigenomics_heft.csv", row.names = FALSE)

data5 = query_data_from_database(inspiral_rr)
write.csv(data5, file = "inspiral_rr.csv", row.names = FALSE)

data6 = query_data_from_database(inspiral_heft)
write.csv(data6, file = "inspiral_heft.csv", row.names = FALSE)

data7 = query_data_from_database(sipht_rr)
write.csv(data5, file = "sipht_rr.csv", row.names = FALSE)

data8 = query_data_from_database(sipht_heft)
write.csv(data6, file = "sipht_heft.csv", row.names = FALSE)



## read a table
## dbReadTable(mydb1, "experiments")

## Query some specific data
## res = dbSendQuery(mydb1, "SELECT * FROM experiments WHERE id < 10")
## data = dbFetch(res)
## head(data)


## clear results for further query
dbClearResult(data1)
dbClearResult(data2)
dbClearResult(data3)
dbClearResult(data4)
dbClearResult(data5)
dbClearResult(data6)
dbClearResult(data7)
dbClearResult(data8)

## disconnect from the database
dbDisconnect(data1)
dbDisconnect(data2)
dbDisconnect(data3)
dbDisconnect(data4)
dbDisconnect(data5)
dbDisconnect(data6)
dbDisconnect(data7)
dbDisconnect(data8)


# cybershake_rr     <- dbConnect(SQLite(), dbname="CyberShake.db")
# epigenomics_rr    <- dbConnect(SQLite(), dbname="Epigenomics.db")
# inspiral_rr       <- dbConnect(SQLite(), dbname="Inspiral.db")
# sipht_rr          <- dbConnect(SQLite(), dbname="Sipht.db")
# montage_rr        <- dbConnect(SQLite(), dbname="Montage.db")

# ## Get data and write to csv files
# write_query_data_to_csv <- function(database) {
#   
#   tempData = query_data_from_database(database)
#   
#   if(identical(database, cybershake_rr)) {
#     write.csv(tempData, file = "cybershake_rr.csv", row.names = FALSE)
#   }
#   else if(identical(database, epigenomics_rr)) {
#     write.csv(tempData, file = "epigenomics_rr.csv", row.names = FALSE)
#   }
#   else if (identical(database, inspiral_rr)){
#     write.csv(tempData, file = "inspiral_rr.csv", row.names = FALSE)
#   }
#   else if (identical (database, sipht_rr)) {
#     write.csv(tempData, file = "sipht_rr.csv", row.names = FALSE)
#   }
#   else {
#     write.csv(tempData, file = "montage_rr.csv", row.names = FALSE)
#   }
# }

# Execute the query and get data
# databases = c(cybershake_rr, epigenomics_rr, inspiral_rr, sipht_rr, montage_rr)
# for (database in databases) {
#   write_query_data_to_csv(database)
#   dbDisconnect(database)
# }


