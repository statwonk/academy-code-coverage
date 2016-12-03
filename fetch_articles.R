# https://ropensci.org/tutorials/rentrez_tutorial.html
# devtools::install_github("ropensci/rentrez")
options(stringsAsFactors = FALSE)
library(rentrez)
library(magrittr)
library(dplyr)
library(purrr)
library(xml2)
library(XML)

pubmed_search_field <- function(.data, field) {
  pretty_field_name <- field %>%
    gsub("//", "", .) %>%
    gsub("([A-Z])","\\_\\1", .) %>%
    tolower() %>%
    substr(2, .Machine$integer.max)

  message("fetching field:", field)
  .data %>%
    xml_children() %>%
    {
      data.frame(x = xml_text((.) %>% xml_find_all(field)))
    } %>% tbl_df() %>%
    rename_(.dots = setNames("x", pretty_field_name))
}

res <- entrez_search(db = "pubmed", term = '"JAMA Pediatr"[journal]', use_history = TRUE)
xmlrec <- entrez_fetch(db="pubmed", web_history = res$web_history, rettype="xml", parsed=TRUE)

c("//DateCreated",
  "//PubDate",
  "//Journal//Title",
  "//ArticleTitle") %>%
  lapply(function(.x) { pubmed_search_field(xml2::read_xml(as(xmlrec, "character")), .x) }) %>%
  bind_cols() %>%
  write.table("jama_pediatrics.csv", sep = ",", row.names = FALSE)

