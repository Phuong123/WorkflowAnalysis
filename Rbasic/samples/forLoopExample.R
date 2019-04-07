# Loop across multiple strings
databaseList <- c(cybershake_rr, cybershake_heft, epigenomics_rr, epigenomics_heft,
                  inspiral_rr, inspiral_heft, sipht_rr, sipht_heft)
databaseName <- c("cybershake_rr", "cybershake_heft", "epigenomics_rr", "epigenomics_heft",
                  "inspiral_rr", "inspiral_heft", "sipht_rr", "sipht_heft")

for (i in databaseName) {
  
  databaseN = noquote(i)
  print(databaseN)
  data = query_data_from_database(databaseN)
  
  # write to files
  filename = cat(i, ".csv")
  write.csv(data, file = filename, row.names = FALSE)
}
