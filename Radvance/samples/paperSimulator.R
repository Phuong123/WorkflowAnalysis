######################### Multiple Plots ##########################


# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

library(ggplot2)

# This example uses the ChickWeight dataset, which comes with ggplot2
# First plot
p1 <- ggplot(ChickWeight, aes(x=Time, y=weight, colour=Diet, group=Chick)) +
  geom_line() +
  ggtitle("Growth curve for individual chicks")

# Second plot
p2 <- ggplot(ChickWeight, aes(x=Time, y=weight, colour=Diet)) +
  geom_point(alpha=.3) +
  geom_smooth(alpha=.2, size=1) +
  ggtitle("Fitted growth curve per diet")

# Third plot
p3 <- ggplot(subset(ChickWeight, Time==21), aes(x=weight, colour=Diet)) +
  geom_density() +
  ggtitle("Final weight, by diet")

# Fourth plot
p4 <- ggplot(subset(ChickWeight, Time==21), aes(x=weight, fill=Diet)) +
  geom_histogram(colour="black", binwidth=50) +
  facet_grid(Diet ~ .) +
  ggtitle("Final weight, by diet") +
  theme(legend.position="none")        # No legend (redundant in this graph)    

multiplot(p1, p2, p3, p4, cols=2)

######################## Starting Plots #######################
# Read data
library(dplyr)
setwd("/Users/phuong/PhD/Programs/Prediction/practices/queryData")

# Round robin algorithm
roundrobin = read.csv("cybershake_rr_core.csv")
## Calculate average
data <- select(roundrobin, provisioningRate, capacityIntrptRates, makespan, total_costs, instanceTypes) %>%
         group_by(instanceTypes, provisioningRate, capacityIntrptRates) %>%
         summarise(ExecutionTime=mean(makespan), Costs=mean(total_costs))

write.csv(data, file = "RRCybershake.csv", row.names = FALSE)

# Heft algorithm
heft = read.csv("cybershake_heft_core.csv")
## Calculate average
data <- select(heft, provisioningRate, capacityIntrptRates, makespan, total_costs, instanceTypes) %>%
  group_by(instanceTypes, provisioningRate, capacityIntrptRates) %>%
  summarise(ExecutionTime=mean(makespan), Costs=mean(total_costs))

write.csv(data, file = "Cybershake_heft_groupby.csv", row.names = FALSE)


### Analysis 1
library(ggplot2)
g1 <- ggplot(roundrobin, aes(x=provisioningRate, y=makespan, color=instanceTypes)) + 
            geom_point() +
            facet_wrap( ~ instanceTypes, ncol=2) +  # columns defined by 'instanceTypes' 
            theme_bw()  + # apply bw theme
            #theme(plot.title = element_text(hjust=0.5)) + 
            theme(plot.title=element_text(size=20, 
                                  face="bold", 
                                  family="American Typewriter",
                                  color="tomato",
                                  hjust=0.5,
                                  lineheight=1.2),  # title
                  plot.subtitle=element_text(size=15, 
                                     family="American Typewriter",
                                     face="bold",
                                     hjust=0.5),  # subtitle
                  plot.caption=element_text(size=15),  # caption
                  axis.title.x=element_text(vjust=1, size=15),  # X axis title
                  axis.title.y=element_text(size=15),  # Y axis title
                  axis.text.x=element_text(size=10, vjust=.5),  # X axis text
                  axis.text.y=element_text(size=10)) + # Y axis text
              theme(strip.background =element_rect(fill="white")) +
              theme(strip.text = element_text(colour = 'blue')) +
              theme(plot.caption = element_text(hjust=0.5, size=rel(1.2))) + 
              labs(title="Cybershake Workflow using Round Robin", x="Fulfillment Rate", y="Makespan", caption="Figure1:  Cybershake workflow running on Spot Instance with RR")  # add axis lables and plot title.
print(g1)


### Analysis 2
g2 <- ggplot(data, aes(x=provisioningRate, y=ExecutionTime, color=instanceTypes)) + 
  geom_point() +
  facet_wrap( ~ instanceTypes, ncol=2) +  # columns defined by 'instanceTypes' 
  theme_bw()  + # apply bw theme
  #theme(plot.title = element_text(hjust=0.5)) + 
  theme(plot.title=element_text(size=20, 
                                face="bold", 
                                family="American Typewriter",
                                color="tomato",
                                hjust=0.5,
                                lineheight=1.2),  # title
        plot.subtitle=element_text(size=15, 
                                   family="American Typewriter",
                                   face="bold",
                                   hjust=0.5),  # subtitle
        plot.caption=element_text(size=15),  # caption
        axis.title.x=element_text(vjust=1, size=15),  # X axis title
        axis.title.y=element_text(size=15),  # Y axis title
        axis.text.x=element_text(size=10, vjust=.5),  # X axis text
        axis.text.y=element_text(size=10)) + # Y axis text
  theme(strip.background =element_rect(fill="white")) +
  theme(strip.text = element_text(colour = 'blue')) +
  theme(plot.caption = element_text(hjust=0.5, size=rel(1.2))) + 
  labs(title="Cybershake Workflow using Round Robin", x="Fulfillment Rate", y="Execution Time", caption="Figure1:  Cybershake workflow running on Spot Instance with RR")  # add axis lables and plot title.
print(g2)

g22 <- ggplot(data, aes(x=capacityIntrptRates, y=ExecutionTime, color=instanceTypes)) + 
  geom_point() +
  facet_wrap( ~ instanceTypes, ncol=2) +  # columns defined by 'instanceTypes' 
  theme_bw()  + # apply bw theme
  #theme(plot.title = element_text(hjust=0.5)) + 
  theme(plot.title=element_text(size=20, 
                                face="bold", 
                                family="American Typewriter",
                                color="tomato",
                                hjust=0.5,
                                lineheight=1.2),  # title
        plot.subtitle=element_text(size=15, 
                                   family="American Typewriter",
                                   face="bold",
                                   hjust=0.5),  # subtitle
        plot.caption=element_text(size=15),  # caption
        axis.title.x=element_text(vjust=1, size=15),  # X axis title
        axis.title.y=element_text(size=15),  # Y axis title
        axis.text.x=element_text(size=10, vjust=.5),  # X axis text
        axis.text.y=element_text(size=10)) + # Y axis text
  theme(strip.background =element_rect(fill="white")) +
  theme(strip.text = element_text(colour = 'blue')) +
  theme(plot.caption = element_text(hjust=0.5, size=rel(1.2))) + 
  labs(title="Cybershake Workflow using Round Robin", x="Capacity Interruption Rate", y="Execution Time", caption="Figure1:  Cybershake workflow running on Spot Instance with RR")  # add axis lables and plot title.
print(g22)

#multiplot(g2, g22, cols=2)

### Analysis 3
g3 <- ggplot(data, aes(x=provisioningRate, y=Costs, color=instanceTypes)) + 
  geom_point() +
  facet_wrap( ~ instanceTypes, ncol=2) +  # columns defined by 'instanceTypes' 
  theme_bw()  + # apply bw theme
  #theme(plot.title = element_text(hjust=0.5)) + 
  theme(plot.title=element_text(size=20, 
                                face="bold", 
                                family="American Typewriter",
                                color="tomato",
                                hjust=0.5,
                                lineheight=1.2),  # title
        plot.subtitle=element_text(size=15, 
                                   family="American Typewriter",
                                   face="bold",
                                   hjust=0.5),  # subtitle
        plot.caption=element_text(size=15),  # caption
        axis.title.x=element_text(vjust=1, size=15),  # X axis title
        axis.title.y=element_text(size=15),  # Y axis title
        axis.text.x=element_text(size=10, vjust=.5),  # X axis text
        axis.text.y=element_text(size=10)) + # Y axis text
  theme(strip.background =element_rect(fill="white")) +
  theme(strip.text = element_text(colour = 'blue')) +
  theme(plot.caption = element_text(hjust=0.5, size=rel(1.2))) + 
  labs(title="Cybershake Workflow using Round Robin", x="Fulfillment Rate", y="Costs", caption="Figure1:  Cybershake workflow running on Spot Instance with RR")  # add axis lables and plot title.
print(g3)

### Analysis 4
g4 <- ggplot(data, aes(x=capacityIntrptRates, y=Costs, color=instanceTypes)) + 
  geom_point() +
  facet_wrap( ~ instanceTypes, ncol=2) +  # columns defined by 'instanceTypes' 
  theme_bw()  + # apply bw theme
  #theme(plot.title = element_text(hjust=0.5)) + 
  theme(plot.title=element_text(size=20, 
                                face="bold", 
                                family="American Typewriter",
                                color="tomato",
                                hjust=0.5,
                                lineheight=1.2),  # title
        plot.subtitle=element_text(size=15, 
                                   family="American Typewriter",
                                   face="bold",
                                   hjust=0.5),  # subtitle
        plot.caption=element_text(size=15),  # caption
        axis.title.x=element_text(vjust=1, size=15),  # X axis title
        axis.title.y=element_text(size=15),  # Y axis title
        axis.text.x=element_text(size=10, vjust=.5),  # X axis text
        axis.text.y=element_text(size=10)) + # Y axis text
  theme(strip.background =element_rect(fill="white")) +
  theme(strip.text = element_text(colour = 'blue')) +
  theme(plot.caption = element_text(hjust=0.5, size=rel(1.2))) + 
  labs(title="Cybershake Workflow using Round Robin", x="Capacity Interruption Rate", y="Costs", caption="Figure1:  Cybershake workflow running on Spot Instance with RR")  # add axis lables and plot title.
print(g4)

### Analysis 5

library("plot3D")

x <- data$provisioningRate
y <- data$capacityIntrptRates
z <- data$ExecutionTime

scatter3D(x, y, z, clab = c("Execution Time", "Width (cm)"))
scatter3D(x, y, z, phi = 0, pch = 16, 
          main = "Cybershake workflow", xlab = "Fulfillment Rate",
          ylab ="Interruption Rate", zlab = "Execution Time")

scatter3D(x, y, z, phi = 0, bty = "b2", pch = 20, cex = 1, expand = 0.6,
          col = c(data$instanceTypes),
          main = "Cybershake", xlab = "Fulfillment Rate",
          ylab ="Interruption Rate", zlab = "Makespan",
          ticktype = "detailed",
          colkey = list(data$instanceTypes), side = 1, 
          addlines = TRUE, length = 0.5, width = 0.5,
          labels = c(data$instanceTypes)
          )
#text3D(x, y, z,  labels = data$instanceTypes, add = TRUE, colkey = FALSE, cex = 0.5)

### Analysis 6

library("plot3D")

x <- data$provisioningRate
y <- data$capacityIntrptRates
z <- data$Costs

colvarA <- as.numeric(as.factor(data$instanceTypes))
colsets <-levels(as.factor(data$instanceTypes))

scatter3D(x, y, z, phi = 0, bty = "g", pch = 20, cex = 2, expand = 0.5,
          highlight.3d = TRUE, type = "h",
          col = c(data$instanceTypes),
          main = "Cybershake", xlab = "Fulfillment Rate",
          ylab ="Interruption Rate", zlab = "Costs($)",
          ticktype = "detailed",
          clab = c("Costs")
          )

text3D(x, y, z,  labels = data$instanceTypes, add = TRUE, colkey = FALSE, cex = 0.5)

## Analysis 7
library(ggplot2)

setwd("/Users/phuong/PhD/Programs/Prediction/practices/queryData/results")

theme_set(theme_bw() + theme(plot.title = element_text(hjust=0.5)))
cybershake_heft = read.csv("cybershake_rr_core2-pareto.csv")
colnames(cybershake_heft) <- c("makespan","total_costs","instanceTypes","numOfVms","provisioningRate","num_vms","capacityIntrptRates","num_interruptions","daxFiles","planScheduleAlg")

write.csv(cybershake_heft, file = "dataTest.csv", row.names = FALSE)
gg <- ggplot(cybershake_heft, aes(x=total_costs, y=makespan)) + 
  geom_point(aes(col=instanceTypes, size=provisioningRate)) + 
  geom_smooth(method="loess", se=F) + 
  labs(subtitle="Pareto solutions", 
       y="Makespan", 
       x="Total Cost", 
       title="Executing cybershake workflow on spot instances")

gg <- ggplot(cybershake_heft, aes(x=total_costs, y=makespan)) + 
  geom_point(aes(col=instanceTypes, size=capacityIntrptRates)) + 
  geom_smooth(method="loess", se=F) + 
  labs(subtitle="Pareto solutions", 
       y="Makespan", 
       x="Total Cost", 
       title="Executing cybershake workflow on spot instances")

gg <- ggplot(cybershake_heft, aes(x=total_costs, y=makespan)) + 
  geom_point(aes(col=instanceTypes)) + 
  geom_smooth(method="loess", se=F) + 
  labs(subtitle="Pareto solutions", 
       y="Makespan", 
       x="Total Cost", 
       title="Executing cybershake workflow on spot instances")

plot(gg)

x <- cybershake_heft$provisioningRate
y <- cybershake_heft$capacityIntrptRates
z <- cybershake_heft$total_costs

scatter3D(x, y, z, phi = 0, bty = "b2", pch = 20, cex = 2, expand = 0.8,
          highlight.3d = TRUE,
          col = c(data$instanceTypes),
          main = "Cybershake", xlab = "Fulfillment Rate",
          ylab ="Interruption Rate", zlab = "Costs($)",
          ticktype = "detailed",
          clab = c("Costs"))
text3D(x, y, z,  labels = cybershake_heft$instanceTypes, add = TRUE, colkey = FALSE, cex = 0.5)


### Pareto front example 
library(GPareto)

#------------------------------------------------------------
# Simple example
#------------------------------------------------------------

x <- c(0.2, 0.4, 0.6, 0.8)
y <- c(0.8, 0.7, 0.5, 0.1)

plot(x, y, col = "green", pch = 20) 

plotParetoEmp(cbind(x, y), col = "green")
## Alternative
plotParetoEmp(cbind(x, y), col = "red", add = FALSE)

## With maximization
plotParetoEmp(cbind(x, y), col = "blue", max = TRUE)

## 3D plots
library(rgl)
set.seed(5)
X <- matrix(runif(60), ncol=3)
Xnd <- t(nondominated_points(t(X)))
plot3d(X)
plot3d(Xnd, col="red", size=8, add=TRUE)
plot3d(x=min(Xnd[,1]), y=min(Xnd[,2]), z=min(Xnd[,3]), col="green", size=8, add=TRUE)
X.range <- diff(apply(X,2,range))
bounds <- rbind(apply(X,2,min)-0.1*X.range,apply(X,2,max)+0.1*X.range)
plotParetoEmp(nondominatedPoints = Xnd, add=TRUE, bounds=bounds, alpha=0.5)








