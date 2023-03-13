test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

tmp <- discursive(data = cces,
           openends = c(paste0("oe0", 1:9), "oe10"),
           dictionary = dict_sample,
           meta = c("age", "educ_cont", "pid_cont", "educ_pid", "female"),
           args_textProcessor = list(customstopwords = c("dont", "hes", "shes", "that", "etc")),
           args_prepDocuments = list(lower.thresh = 10),
           args_stm = list(K = 25, seed = 12345, verbose = FALSE))
tmp
