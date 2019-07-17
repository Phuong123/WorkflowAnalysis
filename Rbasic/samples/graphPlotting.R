# Plotting a graph with ggplot
library(ggplot2)

## 1. The Setup
ggplot(diamonds)                # if only the dataset is known.
ggplot(diamonds, aes(x=carat))  # if only X-axis is known. The Y-axis can be specified in respective geoms.
ggplot(diamonds, aes(x=carat, y=price))     # if both X and Y axes are fixed for all layers.
ggplot(diamonds, aes(x=carat, color=cut))   # Each category of the 'cut' variable will now have a distinct  color, once a geom is added.

ggplot(diamonds, aes(x=carat), color="blue")

## 2. The Layers
diamonds
### Way1
ggplot(diamonds, aes(x=carat, y=price, color=cut)) + geom_point() + geom_smooth()

### Way2
ggplot(diamonds) + geom_point(aes(x=carat, y=price, color=cut)) + geom_smooth(aes(x=carat, y=price, color=cut))


### Way3
ggplot(diamonds, aes(x=carat, y=price)) + geom_point(aes(color=cut)) + geom_smooth()  # same but simpler


# Answer to the challenge: the shape of the points vary with color feature
ggplot(diamonds, aes(x=carat, y=price, color=cut, shape=color)) + geom_point() + scale_shape_discrete(name="legend title")


## 3. The Labels
gg <- ggplot(diamonds, aes(x=carat, y=price, color=cut)) + geom_point() + labs(title="Scatterplot", x="Carat", y="Price")  # add axis lables and plot title.
print(gg)


## 4. Themes
gg1 <- gg + theme(plot.title=element_text(size=30, face="bold"), 
                  axis.text.x=element_text(size=15), 
                  axis.text.y=element_text(size=15),
                  axis.title.x=element_text(size=25),
                  axis.title.y=element_text(size=25)) + 
  scale_color_discrete(name="Cut of diamonds")  # add title and axis text, change legend title.
  
print(gg1)  # print the plot

## 5. The Facets
gg1 + facet_wrap( ~ cut, ncol=3)  # columns defined by 'cut'
gg1 + facet_wrap(color ~ cut)     # row: color, column: cut
gg1 + facet_wrap(color ~ cut, scales="free")  # row: color, column: cut

gg1 + facet_grid(color ~ cut)     # In a grid


## 6. Commonly Used Features

# Approach 1: Plot multiple lines in a same plot
data(economics, package="ggplot2")  # init data
economics <- data.frame(economics)  # convert to dataframe
ggplot(economics) + geom_line(aes(x=date, y=pce, color="pcs")) + geom_line(aes(x=date, y=unemploy, col="unemploy")) + scale_color_discrete(name="Legend") + labs(title="Economics") # plot multiple time series using 'geom_line's

# Approach 2:
library(reshape2)
df <- melt(economics[, c("date", "pce", "unemploy")], id="date")
ggplot(df) + geom_line(aes(x=date, y=value, color=variable)) + labs(title="Economics")# plot multiple time series by melting

df <- melt(economics[, c("date", "pce", "unemploy", "psavert")], id="date")
ggplot(df) + geom_line(aes(x=date, y=value, color=variable))  + facet_wrap( ~ variable, scales="free")

# Bar charts
plot1 <- ggplot(mtcars, aes(x=cyl)) + geom_bar() + labs(title="Frequency bar chart")  # Y axis derived from counts of X item
print(plot1)
mtcars

df <- data.frame(var=c("a", "b", "c"), nums=c(1:3))
plot2 <- ggplot(df, aes(x=var, y=nums)) + geom_bar(stat = "identity")  # Y axis is explicit. 'stat=identity'
print(plot2)

library(gridExtra)
grid.arrange(plot1, plot2, plot1, plot2, ncol=2)
grid.arrange(plot1, plot2, ncol=2)

# Coordinates filp
df <- data.frame(var=c("a", "b", "c"), nums=c(1:3))
ggplot(df, aes(x=var, y=nums)) + geom_bar(stat = "identity") + coord_flip() + labs(title="Coordinates are flipped")

# Limits x or y
ggplot(diamonds, aes(x=carat, y=price, color=cut)) + geom_point() + geom_smooth() + coord_cartesian(ylim=c(0, 10000)) + labs(title="Coord_cartesian zoomed in!")

ggplot(diamonds, aes(x=carat, y=price, color=cut)) + geom_point() + geom_smooth() + ylim(c(0, 10000)) + labs(title="Datapoints deleted: Note the change in smoothing lines!")

# Equal x and y
ggplot(diamonds, aes(x=price, y=price+runif(nrow(diamonds), 100, 10000), color=cut)) + geom_point() + geom_smooth() + coord_equal()

# Save ggplot
plot1 <- ggplot(mtcars, aes(x=cyl)) + geom_bar()
ggsave("myggplot.png")  # saves the last plot.
ggsave("myggplot.png", plot=plot1)  # save a stored ggplot






