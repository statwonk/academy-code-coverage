readr::read_csv("https://raw.githubusercontent.com/statwonk/academy-code-coverage/master/jama_pediatrics.csv") %>%
  left_join(readr::read_csv("https://raw.githubusercontent.com/statwonk/academy-code-coverage/master/jama_pediatrics.csv") %>%
              mutate(id = 1:n()) %>%
              filter(id == sample(id, 1, replace = TRUE)) %>%
              select(-id) %>% mutate(selected = 1)) %>%
  write.table("jama_pediatrics.csv", sep = ",",
              row.names = FALSE, qmethod = "double",
              fileEncoding = "UTF-8")