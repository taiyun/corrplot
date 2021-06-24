context('Adding Correlation Rectangles')

# Tests ==========

test_that('Testing error', {
  M = cor(mtcars)
  r = rbind(c('gear', 'wt', 'qsec', 'carb'),
          c('wt', 'qsec', 'carb', 'gear'))
  corrplot(M, method = 'circle', order = 'AOE', diag=TRUE, type='upper') -> p
  expect_error(corrRect(namesMat = r, corrRes = p))
})
