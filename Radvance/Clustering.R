library(ggplot2)
library(ggalt)
library(ggfortify)

## Test 1
setwd("/Users/phuong/PhD/Programs/Prediction/practices/queryData/results")

theme_set(theme_bw() + theme(plot.title = element_text(hjust=0.5)))
cybershake_rr = read.csv("cybershake_rr_core2-pareto.csv")
colnames(cybershake_rr) <- c("makespan","total_costs","instanceTypes","numOfVms","provisioningRate","num_vms","capacityIntrptRates","num_interruptions","daxFiles","planScheduleAlg")


gg <- ggplot(cybershake_rr, aes(x=total_costs, y=makespan)) + 
  geom_point(aes(col=instanceTypes, size=provisioningRate)) + 
  geom_smooth(method="loess", se=F) + 
  labs(subtitle="Pareto solutions", 
       y="Makespan", 
       x="Total Cost", 
       title="Executing cybershake workflow on spot instances")

gg <- ggplot(cybershake_rr, aes(x=total_costs, y=makespan)) + 
  geom_point(aes(col=instanceTypes, size=capacityIntrptRates)) + 
  geom_smooth(method="loess", se=F) + 
  labs(subtitle="Pareto solutions", 
       y="Makespan", 
       x="Total Cost", 
       title="Executing cybershake workflow on spot instances")

gg <- ggplot(cybershake_rr, aes(x=total_costs, y=makespan)) + 
  geom_point(aes(col=instanceTypes)) + 
  geom_smooth(method="loess", se=F) + 
  labs(subtitle="Pareto solutions", 
       y="Makespan", 
       x="Total Cost", 
       title="Executing cybershake workflow on spot instances")

plot(gg)


## Example how to use geom_encircle

d <- data.frame(x=c(1,1,2),y=c(1,2,2)*100)

gg <- ggplot(d,aes(x,y))
gg <- gg + scale_x_continuous(expand=c(0.5,1))
gg <- gg + scale_y_continuous(expand=c(0.5,1))

gg + geom_encircle(s_shape=1, expand=0) + geom_point()
gg + geom_encircle(s_shape=1, expand=0.1, colour="red") + geom_point()
gg + geom_encircle(s_shape=0.5, expand=0.1, colour="purple") + geom_point()
gg + geom_encircle(data=subset(d, x==1), colour="blue", spread=0.02) + geom_point()
gg +geom_encircle(data=subset(d, x==2), colour="cyan", spread=0.04) + geom_point()

gg <- ggplot(mpg, aes(displ, hwy))
gg + geom_encircle(data=subset(mpg, hwy>40)) + geom_point()
gg + geom_encircle(aes(group=manufacturer)) + geom_point()
gg + geom_encircle(aes(group=manufacturer,fill=manufacturer),alpha=0.4) +
  geom_point()
gg + geom_encircle(aes(group=manufacturer,colour=manufacturer)) +
  geom_point()

ss <- subset(mpg,hwy>31 & displ<2)

gg + geom_encircle(data=ss, colour="blue", s_shape=0.9, expand=0.07) +
  geom_point() + geom_point(data=ss, colour="blue")

## Test the data
setwd("/Users/phuong/PhD/Programs/Prediction/practices/queryData/pareto")
data = read.csv("cybershake_rr_core.csv")
head(data)

## Clustering Techniques
##### Consider the dataset of only cost and makespan



## Apply clustering techniques to our data
##### Cluster and store results 



## Visualize the clusters into objective space
##### Vizualize the results to discover the pattern



