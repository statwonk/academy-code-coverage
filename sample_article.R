sampled_article <- readr::read_csv("https://raw.githubusercontent.com/statwonk/academy-code-coverage/master/jama_pediatrics.csv") %>%
  sample_n(size = 1, replace = TRUE) %>%
  mutate(times_sampled = times_sampled + 1)

readr::read_csv("https://raw.githubusercontent.com/statwonk/academy-code-coverage/master/jama_pediatrics.csv") %>%
  anti_join(
    sampled_article,
    by = c("journal_title", "article_title")) %>%
  bind_rows(sampled_article) %>%
  arrange(desc(times_sampled)) %>%
  write.table("jama_pediatrics.csv", sep = ",",
              row.names = FALSE, qmethod = "double",
              fileEncoding = "UTF-8")
