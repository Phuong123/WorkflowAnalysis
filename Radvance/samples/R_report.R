# Creating a dynamic report
# There are R markdown, ODT, MS Word and LaTex templates (maybe more)

## Create the report in file.Rmd. Example women.Rmd
library(rmarkdown)
setwd("~/rworkspace/WorkflowAnalysis/Radvance/")

# Use html format
# render("women.Rmd", "html_document") 

# Use pdf format - change corresponding text in Rmd
render("women.Rmd", "pdf_document") 

# Use docx format - change corresponding text in Rmd
# render("women.Rmd", "word_document") 



## Create Reports with R and LaTex
library(knitr)
knit("RandLaTex.Rnw")
knit2pdf("RandLaTex.Rnw")




## Creating dynamic reports with R and OpenOffice
# you will need to have OpenOffice (http://www.openoffice.org) installed
# library(odfWeave)
# infile <- "salaryTemplate.odt"
# outfile <- "salaryReport.odt"
# odfWeave(infile, outfile)



