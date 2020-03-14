"This script knits the final report together.

Usage: scripts/knit.R --final_report=<final_report>" -> doc

library(docopt)

opt <- docopt(doc)

main <- function(final_report) {
	rmarkdown::render(final_report, 
										c("html_document", "pdf_document"))
  print("final report in html and pdf created in docs from .Rmd")
}

main(opt$final_report)
