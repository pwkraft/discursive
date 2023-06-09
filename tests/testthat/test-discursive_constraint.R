test_that("discursive_constraint runs without error", {
  expect_no_error(
    discursive_constraint(data = cces, openends = c(paste0("oe0", 1:9), "oe10"), dictionary = dict_sample)
  )
})


