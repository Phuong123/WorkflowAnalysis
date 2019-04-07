## A short tutorial ggplot in R
## http://r-statistics.co/ggplot2-Tutorial-With-R.html

library(ggplot2)

############1. Setup data set and basic information

ggplot(diamonds)  # setup data if only the dataset is known.

## Setup X axis
ggplot(diamonds, aes(x=carat))  # if only X-axis is known.
                                # The Y-axis can be specified in respective geoms.
## Setup X and Y axes
ggplot(diamonds, aes(x=carat, y=price))  # if both X and Y axes are fixed for all layers.

## Setup color
ggplot(diamonds, aes(x=carat, color=cut))  # Each category of the 'cut' variable will now have a distinct  color, once a geom is added.

############2. Setup the full plot with layer ~ geom 

##  Adding scatterplot geom (layer1) and smoothing geom (layer2).
ggplot(diamonds, aes(x=carat, y=price, color=cut)) + geom_point() + geom_smooth()

## Alternatively, we can specify those aesthetics inside the geom layer
ggplot(diamonds) + geom_point(aes(x=carat, y=price, color=cut)) + geom_smooth(aes(x=carat, y=price, color=cut))

## group smooth lines into one
## First alternative
ggplot(diamonds) + geom_point(aes(x=carat, y=price, color=cut)) + geom_smooth(aes(x=carat, y=price)) # Remove color from geom_smooth
## Second alternative
ggplot(diamonds, aes(x=carat, y=price)) + geom_point(aes(color=cut)) + geom_smooth()  # same but simpler


## Use color column in dataset
ggplot(diamonds, aes(x=carat, y=price)) + geom_point(aes(color=color)) + geom_smooth()  # same but simpler
ggplot(diamonds, aes(x=carat, y=price, color=cut, shape=color)) + geom_point()

##############3. Setup the label for the plot

## centering the title : + theme(plot.title = element_text(hjust=0.5))
gg = ggplot(diamonds, aes(x=carat, y=price, color=cut)) + geom_point() + labs(title="Scatterplot", x="Carat", y="Price")  # add axis lables and plot title.
print(gg)

##############4.Using theme to adjust more 

## Almost everything is set, except that we want to increase the size of the labels and change the legend title.
## Adjusting the legend title is a bit tricky. If your legend is that of a color attribute 
## and it varies based in a factor, you need to set the name using scale_color_discrete(),

## If the legend shows a shape attribute based on a factor variable, you need to change 
## it using scale_shape_discrete(name="legend title").
## Had it been a continuous variable, use scale_shape_continuous(name="legend title") instead.
gg1 <- gg + theme(plot.title=element_text(size=30, face="bold"), 
                  axis.text.x=element_text(size=15), 
                  axis.text.y=element_text(size=15),
                  axis.title.x=element_text(size=25),
                  axis.title.y=element_text(size=25)) + 
                  scale_color_discrete(name="Cut of diamonds")  # add title and axis text, change legend title.
print(gg1)  # print the plot

##############5. Facets

gg1 + facet_wrap( ~ cut, ncol=3)  # columns defined by 'cut'

gg1 + facet_wrap(color ~ cut)     # row: color, column: cut

gg1 + facet_wrap(color ~ cut, scales="free")  # row: color, column: cut

## Seems to be better and more beautiful
gg1 + facet_grid(color ~ cut)   # In a grid

###############6. Commonly used features

library(ggfortify)
autoplot(AirPassengers) + labs(title="AirPassengers")  # where AirPassengers is a 'ts' object

## Plot multiple timeseries on same ggplot
# Approach 1:
data(economics, package="ggplot2")  # init data
economics <- data.frame(economics)  # convert to dataframe
ggplot(economics) + geom_line(aes(x=date, y=pce, color="pcs")) + geom_line(aes(x=date, y=unemploy, col="unemploy")) + scale_color_discrete(name="Legend") + labs(title="Economics") # plot multiple time series using 'geom_line's

# Approach 2:
library(reshape2)
df <- melt(economics[, c("date", "pce", "unemploy")], id="date")
ggplot(df) + geom_line(aes(x=date, y=value, color=variable)) + labs(title="Economics")# plot multiple time series by melting

##### Bar charts

plot1 <- ggplot(mtcars, aes(x=cyl)) + geom_bar() + labs(title="Frequency bar chart")  # Y axis derived from counts of X item
print(plot1)

df <- data.frame(var=c("a", "b", "c"), nums=c(1:3))
plot2 <- ggplot(df, aes(x=var, y=nums)) + geom_bar(stat = "identity")  # Y axis is explicit. 'stat=identity'
print(plot2)

## Custom layout
library(gridExtra)
grid.arrange(plot1, plot2, ncol=2)

##  Flipping coordinates
df <- data.frame(var=c("a", "b", "c"), nums=c(1:3))
ggplot(df, aes(x=var, y=nums)) + geom_bar(stat = "identity") + coord_flip() + labs(title="Coordinates are flipped")

## Adjust X and Y axis limits

####There are 3 ways to change the X and Y axis limits.

###### Using coord_cartesian(xlim=c(x1,x2))
###### Using xlim(c(x1,x2))
###### Using scale_x_continuous(limits=c(x1,x2))

ggplot(diamonds, aes(x=carat, y=price, color=cut)) + geom_point() + geom_smooth() + coord_cartesian(ylim=c(0, 10000)) + labs(title="Coord_cartesian zoomed in!")


## Equal coordinates
ggplot(diamonds, aes(x=price, y=price+runif(nrow(diamonds), 100, 10000), color=cut)) + geom_point() + geom_smooth() + coord_equal()


## Change themes

### Apart from the basic ggplot2 theme, you can change the look and feel of 
### your plots using one of these builtin themes.

##### theme_gray()
##### theme_bw()
##### theme_linedraw()
##### theme_light()
##### theme_minimal()
##### theme_classic()
##### theme_void()

ggplot(diamonds, aes(x=carat, y=price, color=cut)) + geom_point() + geom_smooth() + theme_bw() + labs(title="bw Theme") + theme(plot.title = element_text(hjust=0.5))

## Legend - Deleting and Changing Position

p1 <- ggplot(diamonds, aes(x=carat, y=price, color=cut)) + geom_point() + geom_smooth() + theme(legend.position="none") + labs(title="legend.position='none'")  # remove legend
p2 <- ggplot(diamonds, aes(x=carat, y=price, color=cut)) + geom_point() + geom_smooth() + theme(legend.position="top") + labs(title="legend.position='top'")    # legend at top
p3 <- ggplot(diamonds, aes(x=carat, y=price, color=cut)) + geom_point() + geom_smooth() + labs(title="legend.position='coords inside plot'") + theme(legend.justification=c(1,0), legend.position=c(1,0))  # legend inside the plot.
grid.arrange(p1, p2, p3, ncol=3)  # arrange


## Annotation
library(grid)
my_grob = grobTree(textGrob("This text is at x=0.1 and y=0.9, relative!\n Anchor point is at 0,0", x=0.1,  y=0.9, hjust=0,
                            gp=gpar(col="firebrick", fontsize=25, fontface="bold")))
ggplot(mtcars, aes(x=cyl)) + geom_bar() + annotation_custom(my_grob) + labs(title="Annotation Example")

# Reference!

# http://r-statistics.co/ggplot2-Tutorial-With-R.html 




