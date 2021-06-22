context("cor.mtest - significance test and confidence intervals")

test_that("Basic usage of cor.mtest", {

  res1 = cor.mtest(mtcars)

  expect_true(is.list(res1))
  expect_true(is.matrix(res1$p))
  expect_true(is.matrix(res1$lowCI))
  expect_true(is.matrix(res1$uppCI))

  expect_equal(dim(res1$p), c(11,11))

  expect_equal(dim(res1$p), dim(res1$lowCI))
  expect_equal(dim(res1$p), dim(res1$uppCI))

})

test_that("Additional params", {
  expect_silent(cor.mtest(mtcars, conf.level = 0.95))
  expect_silent(cor.mtest(mtcars, method = "spearman", exact = FALSE))

  # unknown parameters are silently ignored
  expect_silent(cor.mtest(mtcars, dummy = "dummy"))
})
