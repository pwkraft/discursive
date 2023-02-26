test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

discursive_constraint(data = cces, openends = c(paste0("oe0", 1:9), "oe10"), dictionary = dict_constraint)
