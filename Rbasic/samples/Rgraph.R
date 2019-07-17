library(ggplot2)

setwd("~/javaprogs/jMetal")
a <- read.table("FUN.tsv")
plot(a)

####### Data Analysis #######

setwd("/Users/phuong")

data <- read.csv("epigenomics-rr.csv")

### Some basic summaries
head(data)
str(data)

summary(data$makespan)
summary(data$total_costs)

### Makespan and Interruption Rate
table(data$provisioningRate)
barplot(table(data$provisioningRate))
hist(data$provisioningRate)

library(gcookbook) # For the data set
ggplot(cabbage_exp, aes(x=Date, y=Weight, fill=Cultivar)) + geom_bar(stat="identity")

ggplot(cabbage_exp, aes(x=Date, y=Weight, fill=Cultivar)) + geom_bar(stat="identity") + guides(fill=guide_legend(reverse=TRUE))

library(plyr) # Needed for desc()
ggplot(cabbage_exp, aes(x=Date, y=Weight, fill=Cultivar, order=desc(Cultivar))) + geom_bar(stat="identity")

ggplot(cabbage_exp, aes(x=interaction(Date, Cultivar), y=Weight)) + geom_bar(stat="identity") + geom_text(aes(label=Weight), vjust=-0.2)
ggplot(cabbage_exp, aes(x=Date, y=Weight, fill=Cultivar)) + geom_bar(stat="identity", position="dodge") +
  geom_text(aes(label=Weight), vjust=1.5, colour="white", position=position_dodge(.9), size=3)


