# ggplot2 part-1: Introduction
# http://r-statistics.co/Complete-Ggplot2-Tutorial-Part1-With-R-Code.html

## Setup
options(scipen=999)  # turn off scientific notation like 1e+06

library(ggplot2)
data("midwest", package = "ggplot2")  # load the data
## midwest <- read.csv("http://goo.gl/G1K41K") # alt source 
### View(midwest)

## Init ggplot
ggplot(midwest, aes(x=area, y=poptotal))  # area and poptotal are columns in 'midwest'

## Scatter plot
ggplot(midwest, aes(x=area, y=poptotal))  + geom_point()

## add linear model
g <- ggplot(midwest, aes(x=area, y=poptotal)) + geom_point() + geom_smooth(method="lm")  # set se=FALSE to turnoff confidence bands
plot(g)

## adjust X and Y axis
g <- ggplot(midwest, aes(x=area, y=poptotal)) + geom_point() + geom_smooth(method="lm")  # set se=FALSE to turnoff confidence bands

# Delete the points outside the limits
g + xlim(c(0, 0.1)) + ylim(c(0, 1000000))   # deletes points
# g + xlim(0, 0.1) + ylim(0, 1000000)   # deletes points

# Zoom in
g <- ggplot(midwest, aes(x=area, y=poptotal)) + geom_point() + geom_smooth(method="lm")  # set se=FALSE to turnoff confidence bands

# Zoom in without deleting the points outside the limits. 
# As a result, the line of best fit is the same as the original plot.
g1 <- g + coord_cartesian(xlim=c(0,0.1), ylim=c(0, 1000000))  # zooms in
plot(g1)

## Add Title and Labels
### Method 1
 
g1 + labs(title="Area Vs Population", subtitle="From midwest dataset", y="Population", x="Area", caption="Midwest Demographics")

### Method 2
g1 + ggtitle("Area Vs Population", subtitle="From midwest dataset") + xlab("Area") + ylab("Population")


## Summary - A full plot call
# Full Plot call
library(ggplot2)
ggplot(midwest, aes(x=area, y=poptotal)) + 
  geom_point() + 
  geom_smooth(method="lm") + 
  coord_cartesian(xlim=c(0,0.1), ylim=c(0, 1000000)) + 
  labs(title="Area Vs Population", subtitle="From midwest dataset", y="Population", x="Area", caption="Midwest Demographics") + 
  theme(plot.title = element_text(hjust=0.5), plot.subtitle = element_text(hjust=0.5))

# Change point size and color
ggplot(midwest, aes(x=area, y=poptotal)) + 
  geom_point(col="steelblue", size=3) +         # Set static color and size for points
  geom_smooth(method="lm", col="firebrick") +   # change the color of line
  coord_cartesian(xlim=c(0,0.1), ylim=c(0, 1000000)) + 
  labs(title="Area Vs Population", subtitle="From midwest dataset", y="Population", x="Area", caption="Midwest Demographics") + 
  theme(plot.title = element_text(hjust=0.5), plot.subtitle = element_text(hjust=0.5))

# Change color to reflect the categories
ggplot(midwest, aes(x=area, y=poptotal)) + 
  geom_point(aes(col=state), size=3) +         # Set static color and size for points
  geom_smooth(method="lm", col="firebrick") +   # change the color of line
  coord_cartesian(xlim=c(0,0.1), ylim=c(0, 1000000)) + 
  labs(title="Area Vs Population", subtitle="From midwest dataset", y="Population", x="Area", caption="Midwest Demographics") + 
  theme_bw() +
  theme(plot.title = element_text(hjust=0.5), plot.subtitle = element_text(hjust=0.5))

# Change Axis Texts

gg <- ggplot(midwest, aes(x=area, y=poptotal)) + 
  geom_point(aes(col=state), size=3) +         # Set static color and size for points
  geom_smooth(method="lm", col="firebrick") +   # change the color of line
  coord_cartesian(xlim=c(0,0.1), ylim=c(0, 1000000)) + 
  labs(title="Area Vs Population", subtitle="From midwest dataset", y="Population", x="Area", caption="Midwest Demographics") + 
  theme_bw() +
  theme(plot.title = element_text(hjust=0.5), plot.subtitle = element_text(hjust=0.5))

gg + scale_x_continuous(breaks=seq(0, 0.1, 0.01), labels = sprintf("%1.2f%%", seq(0, 0.1, 0.01))) + 
  scale_y_continuous(breaks=seq(0, 1000000, 200000), labels = function(x){paste0(x/1000, 'K')})  

# Reverse X Axis Scale
##gg + scale_x_reverse()
library(RColorBrewer)
head(brewer.pal.info, 10)  # show 10 palettes
#>          maxcolors category colorblind
#> BrBG            11      div       TRUE
#> PiYG            11      div       TRUE
#> PRGn            11      div       TRUE
#> PuOr            11      div       TRUE
#> RdBu            11      div       TRUE
#> RdGy            11      div      FALSE
#> RdYlBu          11      div       TRUE
#> RdYlGn          11      div      FALSE
#> Spectral        11      div      FALSE
#> Accent           8     qual      FALSE