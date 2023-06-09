test_that("discursive_range runs without error", {
  expect_no_error(
    discursive_range(data = cces, openends = c(paste0("oe0", 1:9), "oe10"))
  )
})
