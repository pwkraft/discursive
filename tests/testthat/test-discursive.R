test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})


tmp <- discursive(data = cces,
                  openends = c(paste0("oe0", 1:9), "oe10"),
                  dictionary = dict_constraint,
                  meta = c("age", "educ_cont", "pid_cont", "educ_pid", "female"),
                  customstopwords = c("dont", "hes", "shes", "that", "etc"),
                  lower.tresh = 10,
                  K = 25,
                  seed = 12345)
