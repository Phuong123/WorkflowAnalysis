# Creating a dynamic report

# Put the report or a template of the report in file.Rmd
# Call functions from rmarkdown library to generate the report

library(rmarkdown)

# Create example.html webpage with the report content in example.Rmd
# render(example.Rmd, "html_document") 
setwd("~/rworkspace/WorkflowAnalysis/Radvance/")
render("women.Rmd", "html_document") 

# There are R markdown, ODT, MS Word and LaTex templates (maybe more)

