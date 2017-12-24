# Creating a dynamic report

# Put the report or a template of the report in file.Rmd
# Call functions from rmarkdown library to generate the report

library(rmarkdown)

# Create example.html webpage with the report content in example.Rmd

setwd("~/rworkspace/WorkflowAnalysis/Radvance/")

# Use html format
render("women.Rmd", "html_document") 

# Use pdf format - change corresponding text in Rmd
render("women.Rmd", "pdf_document") 

# Use docx format - change corresponding text in Rmd
render("women.Rmd", "word_document") 

# There are R markdown, ODT, MS Word and LaTex templates (maybe more)

