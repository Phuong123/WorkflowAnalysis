hsb2 <- read.csv("https://stats.idre.ucla.edu/stat/data/hsb2.csv")
names(hsb2)

varlist <- names(hsb2)[8:11]
varlist

models <- lapply(varlist, function(x) {
  lm(substitute(read ~ i, list(i = as.name(x))), data = hsb2)
})

## look at the first element of the list, model 1
models[[1]]

## apply summary to each model stored in the list, models
lapply(models, summary)

par(mfrow = c(2, 2))
invisible(lapply(models, plot))
