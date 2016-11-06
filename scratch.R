# https://ropensci.org/tutorials/rentrez_tutorial.html
# devtools::install_github("ropensci/rentrez")
library(rentrez)
library(magrittr)
library(dplyr)
library(purrr)
option(stringsAsFactors = FALSE)

res <- entrez_search(db = "pubmed", term = '"JAMA Pediatr"[journal]+2016[pdat]')

output <- lapply(res$ids,
                 function(.id) {
                   print(.id)
                   res <- entrez_summary(db = "pubmed", id = .id)
                   data.frame(
                     pubdate = res$pubdate,
                     journal = res$source,
                     title = res$title,
                     authors = paste(res$authors$name, collapse = ", "),
                     url = res$availablefromurl
                   )
                 }) %>%
  bind_rows()

write.table(output, file = "data.csv", sep = ",", row.names = FALSE)




