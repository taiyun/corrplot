context('cor.mtest - significance test and confidence intervals')

test_that('Basic usage of cor.mtest', {

  res1 = cor.mtest(mtcars)

  expect_true(is.list(res1))
  expect_true(is.matrix(res1$p))
  expect_true(is.matrix(res1$lowCI))
  expect_true(is.matrix(res1$uppCI))

  expect_equal(dim(res1$p), c(11, 11))

  expect_equal(dim(res1$p), dim(res1$lowCI))
  expect_equal(dim(res1$p), dim(res1$uppCI))

})

test_that('Single-column input', {
  mat = data.frame(feature = 1:5)

  expect_silent(res = cor.mtest(mat))

  expect_equal(dim(res$p), c(1, 1))
  expect_equal(dim(res$lowCI), c(1, 1))
  expect_equal(dim(res$uppCI), c(1, 1))

  expect_equal(res$p[1, 1], 0)
  expect_equal(res$lowCI[1, 1], 1)
  expect_equal(res$uppCI[1, 1], 1)

  expect_equal(rownames(res$p), 'feature')
  expect_equal(colnames(res$p), 'feature')
  expect_equal(rownames(res$lowCI), 'feature')
  expect_equal(colnames(res$lowCI), 'feature')
  expect_equal(rownames(res$uppCI), 'feature')
  expect_equal(colnames(res$uppCI), 'feature')
})

test_that('Additional params', {
  expect_silent(cor.mtest(mtcars, conf.level = 0.95))
  expect_silent(cor.mtest(mtcars, method = 'spearman', exact = FALSE))

  # unknown parameters are silently ignored
  expect_silent(cor.mtest(mtcars, dummy = 'dummy'))
})
