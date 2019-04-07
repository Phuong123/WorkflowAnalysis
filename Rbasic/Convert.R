setwd("/Users/phuong/rworkspace/WorkflowAnalysis/TechnicalReports")

library(knitr)
pandoc('README.md', format='latex') # LaTeX/PDF
