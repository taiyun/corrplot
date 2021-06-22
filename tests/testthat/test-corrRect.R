context("Adding Correlation Rectangles")

# Tests ==========

test_that("Testing error", {
  M <- cor(mtcars)
  f=corrplot(M, method = "circle", order = "AOE", diag=TRUE, type='upper')
  r=rbind(c('gear', 'wt', 'qsec', 'carb'),
          c('wt', 'qsec', 'carb', 'gear'))
  expect_error(corrRect(namesMat=r, corrRes=f))
})
