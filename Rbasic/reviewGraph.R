library(gcookbook)

# Use dataset : simpledat
simpledat
barplot(simpledat,beside = TRUE)

# switch variables
data <- t(simpledat)
barplot(data,beside = TRUE)

# use line graph 
plot(simpledat[1,], type = "l")
lines(simpledat[2,], type = "l", col="red")

# Convert simpledat to long format
library(reshape2)
data <- simpledat
data <- melt(data, id.vars="A1", value.name = "value")
data <- data[c(2,1,3)]
names(data) <- c("Aval","Bval","Value")
data

library(ggplot2)
ggplot(data,aes(x=Aval, y=Value, fill=Bval)) + geom_bar(stat = "identity", position = "dodge")
ggplot(data,aes(x=Bval, y=Value, fill=Aval)) + geom_bar(stat = "identity", position = "dodge")

# change to line graph
ggplot(data,aes(x=Aval, y=Value, colour=Bval, group=Bval)) + geom_line()


############# Build a simple graph ############# 
dat <- data.frame(xval=1:4, yval=c(3,5,6,9), group=c("A","B","A","B"))
dat 

# Do not know that we want: line, bar, or others
ggplot(dat, aes(x=xval, y=yval))

# Add point 
ggplot(dat, aes(x=xval, y=yval)) + geom_point()

# Add group color
p <- ggplot(dat, aes(x=xval, y=yval))
p + geom_point(aes(colour=group))

#
p + geom_point(colour="blue")
p + geom_point() + scale_x_continuous(limits=c(0,8))
p + geom_point(aes(colour=group)) + scale_colour_manual(values=c("orange","forestgreen"))
