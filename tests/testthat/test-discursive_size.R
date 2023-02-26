test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

discursive_size(data = cces,
                openends = c(paste0("oe0", 1:9), "oe10"),
                meta = c("age", "educ_cont", "pid_cont", "educ_pid", "female"),
                args_prepDocuments = list(lower.thresh = 10),
                args_stm = list(K = 25, seed = 12345))

meta <- c("age", "educ_cont", "pid_cont", "educ_pid", "female")
openends <- c(paste0("oe0", 1:9), "oe10")
cces$resp <- apply(cces[, openends], 1, paste, collapse = " ")
cces <- cces[!apply(cces[, meta], 1, anyNA), ]
processed <- stm::textProcessor(cces$resp, metadata = cces[, meta])
out <- stm::prepDocuments(processed$documents, processed$vocab, processed$meta, lower.thresh = 10)
stm_fit <- stm::stm(out$documents, out$vocab, prevalence = as.matrix(out$meta), K=25, seed=12345)
ntopics(stm_fit, out)
