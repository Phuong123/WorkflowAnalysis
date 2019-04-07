library(gcookbook)

# Shapping your data

############################### Some basic manipulation ############################### 

# get information about dataset : heightweight
str(heightweight)

# create a data frame
name  <- c("cpu", "mem", "hdd")
value <- c(20,40,100 )
dataframe <- data.frame(name,value)
dataframe

# add column to data frame
vec <- c(10,20,30)
dataframe$time <- vec 

# delelte a colum
dataframe$time <- NULL
## OR using subset
data <- subset(dataframe, select = -time)
## Exclude badcol and othercol
data <- subset(dataframe, select = c(-badcol, -othercol))

# rename columns
names(dataframe) <- c("Name", "Value", "Time")
dataframe

# reorder columns in a data frame
dataframe <- dataframe[c(1,3,2)]
## OR using column name
dataframe <- dataframe[c("Name", "Time", "Value")]

# subset the data
## using dataset : climate (in library gcookbook)
subset(climate, Source == "Berkeley", select = c(Year, Anomaly10y))
subset(climate, Source == "Berkeley" & Year >= 1990 & Year <= 2000, select = c(Year, Anomaly10y))
## OR 
climate[1:10,c(2,5)]

# changing the order
## order of levels in a factor
sizes <- factor(c("small","large","large","small","medium", "xlarge"))
sizes

sizes <- factor(sizes, levels = c("small","medium","large","xlarge"))
sizes

## changing the order based on data value
issdata <- InsectSprays
issdata$spray
issdata$count

issdata$spray <- reorder(issdata$spray, issdata$count, FUN=mean)
issdata$spray

## changing the names of factor levels
library(plyr)
sizes1 <- revalue(sizes, c(small="S", medium="M", large="L", xlarge="XL"))
sizes1

## Remove unused levels
sizes
sizes <- sizes[c(1,2,5,6)]
sizes

## another type of renaming 
data <- c("small","medium", "large")

data[data=="small"] <- "S"
data[data=="medium"] <- "M"
data[data=="large"] <- "L"
data


###############################
# Recoding a Categorical Variable
pg <- PlantGrowth[c(1,2,11,21,22), ]
pg

oldvalues <- c("ctrl", "trt1", "trt2")
newvalues <- c("no", "yes", "yes")
pg$treatment <- newvalues[match(pg$group,oldvalues)]
## OR
pg$treatment[pg$group == "ctrl"] <- "no"
pg$treatment[pg$group == "trt1"] <- "yes"
pg$treatment[pg$group == "trt2"] <- "yes"

pg$treatment <- factor(pg$treatment)

# Recoding a Continuous Variable
# use the above pg 
pg$wtclass <- cut(pg$weight,breaks = c(0,5,6,Inf))
pg

pg$wtclass <- cut(pg$weight,breaks = c(0,5,6,Inf), labels = c("Small","Medium","Large"))
pg

############################### 15.17
# Transforming Variables
library(plyr)
library(MASS)
library(ggplot2)

hw <- heightweight
hw
hw$heightCM <- hw$heightIn*2.54
hw

# Transforming Variables by Group
cabbages
cb <- transform(cabbages, DevWt = HeadWt - mean(HeadWt))
cb
ggplot(cb, aes(x=Cult, y=HeadWt)) + geom_boxplot()

## for separate group in Cult : c39 and c52
cb <- ddply(cabbages, "Cult", transform, DevWt = HeadWt - mean(HeadWt))
cb
ggplot(cb, aes(x=Cult, y=DevWt)) + geom_boxplot()

# Summarizing Data by Group
ddply(cabbages, c("Cult", "Date"), summarise, Weight = mean(HeadWt),VitC = mean(VitC))

# dealing with NAs
c1 <- cabbages
c1$HeadWt[c(1,20,45)] <- NA
ddply(c1,c("Cult","Date"), summarise, Weight = mean(HeadWt,na.rm = TRUE), sd = sd(HeadWt,na.rm = TRUE), n = length(HeadWt))

############################### 
# Summarizing Data with Standard errors and confidence intervals
library(MASS)
library(plyr)

ca <- ddply(cabbages, c("Cult", "Date"), summarise        ,
            Weight = mean(HeadWt, na.rm = TRUE),
            sd = sd(HeadWt, na.rm = TRUE),
            n = sum(!is.na(HeadWt )),
            se = sd/sqrt(n))
ca


## multiplier
ciMult <- qt(.975, ca$n-1)
ciMult

ca$ci <- ca$se * ciMult
ca


############################### 
# Coverting Data from Wide to Long
# Use melt() from reshape2 package

anthoming
library(reshape2)
melt(anthoming,id.vars="angle", variable.names="conditions",value.name = "count")

# Coverting Data from long to Wide
# Use dcast() from reshape2
plum
library(reshape2)
dcast(plum, length + time ~ survival, value.var = "count")

############################### 
# Converting a Time Series to Times and Values
nhtemp
# Use time(), convert times & values to numeric vectors with as.numeric()

yearData  <- as.numeric(time(nhtemp))
valueData <- as.numeric(nhtemp)
## put to data frame
nht <- data.frame(year=yearData, temp=valueData)
nht

############################### ggplot2 a review ############################### 



