# note: replace quanteda call with str_detect

dict <- read_csv("data-raw/constraint.csv")

tmp <- c("inequality, inequality", "I care about inequality", "xxx", "assistant")

str_detect(tmp[1], dict$constraint)
str_detect(tmp[2], dict$constraint)
str_detect(tmp[3], dict$constraint)
str_detect(tmp[4], dict$constraint)

discursive_constraint <- function(data, openends, dictionary) {
  ### combine regular survey and open-ended data
  resp <- apply(data[, openends], 1, paste, collapse = " ")

  count <- rep(0, length(resp))
  for(i in 1:length(dictionary)){
    count <- count + str_count(resp, dictionary[i])
  }

  count/max(count)
}

discursive_constraint(data = cces, openends = c(paste0("oe0", 1:9), "oe10"), dictionary = dict$constraint)


