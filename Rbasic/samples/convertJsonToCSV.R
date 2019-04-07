setwd("~/rworkspace/WorkflowAnalysis/Rbasic")

# Ref 1
library("rio")
spotData <- import("us-east-1-prices.json")

export(spotData, "spot-prices-us-east-1.csv")

# Ref 2
library(plyr)
library(RJSONIO)
con <- file('us-east-1-prices.json', "r")
df  <- ldply(fromJSON(con), data.frame)
close(con)
write.csv(df, file = "spot-prices-us-east-1.csv", row.names = FALSE)
head(df,6)

# Ref 3
# Load the package required to read JSON files.
library("rjson")
# Give the input file name to the function.
result <- fromJSON(file = "us-east-1-prices.json")
# Print the result.
print(result)
# Convert JSON file to a data frame.
json_data_frame <- as.data.frame(result)
print(json_data_frame)
write.csv(json_data_frame, file = "spot-prices-us-east-1.csv", row.names = FALSE)

# Ref 4

# #!/usr/bin/Rscript 
# if (!require(jsonlite, quietly = TRUE, warn.conflicts = FALSE)) {
#   stop("This program requires the `jsonlite` package. Please install it by running `install.packages('jsonlite')` in R and then try again.")
# }
# args <- commandArgs(trailingOnly = TRUE)
# if (length(args) == 0) {
#   input <- readLines(file("stdin"))
# } else if (args[[1]] == "--help") {
#   write("Usage: json2csv <json input file> <csv output file> \nAlternatively, you can redirect inputs and outputs using pipes, stdin and stdout.", 
#         stderr())
#   q()
# } else {
#   input <- readLines(args[[1]])
# }
# df <- fromJSON(input, flatten = TRUE)
# listcols <- colnames(df[lapply(colnames(df), function(x) class(df[,x])) == "list"])
# for (col in listcols) df[col] = data.frame(unlist(lapply(df[,col], function(x) toString(unlist(x)))))
# if (length(args) > 1) {
#   write.csv(df, args[[2]], row.names = FALSE)
# } else {
#   write.csv(df, stdout(), row.names = FALSE)
# }

# Ref 5
data <- lapply(readLines("us-east-1-prices.json"), fromJSON)
write.csv(data, file = "spot-prices-us-east-1.csv", row.names = FALSE)




