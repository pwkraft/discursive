test_that("discursive_size runs without error", {
  expect_no_error(
    discursive_size(data = cces,
                    openends = c(paste0("oe0", 1:9), "oe10"),
                    meta = c("age", "educ_cont", "pid_cont", "educ_pid", "female"),
                    args_prepDocuments = list(lower.thresh = 10),
                    args_stm = list(K = 25, seed = 12345))
  )
})
