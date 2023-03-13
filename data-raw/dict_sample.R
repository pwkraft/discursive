## code to prepare `dict_sample` dataset goes here

library(tidyverse)

constraint <- read_csv("data-raw/constraint.csv") %>%
  filter(!duplicated(constraint)) %>%
  filter(str_detect(constraint, fixed("\\bbut\\b")) |
           str_detect(constraint, fixed("\\bwithout\\b")) |
           str_detect(constraint, fixed("\\band\\b")) |
           str_detect(constraint, fixed("\\balso\\b")))

dict_sample <- constraint$constraint

usethis::use_data(dict_sample, overwrite = TRUE)
