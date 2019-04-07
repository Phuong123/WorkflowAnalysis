# First example

data("USArrests") # Load the data set
df <- USArrests # Use df as shorter name

df <- na.omit(df)

df <- scale(df) 
head(df, n = 3)

###
# Subset of the data
set.seed(123)
ss <- sample(1:50, 15) # Take 15 random rows
df <- USArrests[ss, ]  # Subset the 15 rows
df.scaled <- scale(df) # Standardize the variables


