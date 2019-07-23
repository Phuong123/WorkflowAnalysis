# packages needed for chapter 1
library(dplyr)
library(tidyr)
library(ggplot2)
library(vioplot)
library(ascii)
library(corrplot)
library(descr)

# Import the datasets needed for chapter 1
PSDS_PATH <- file.path('~', 'statistics-for-data-scientists')
dir.create(file.path(PSDS_PATH, 'figures'))

state <- read.csv(file.path(PSDS_PATH, 'data', 'state.csv'))