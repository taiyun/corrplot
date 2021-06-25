context('Adding Correlation Rectangles')

# Tests ==========

test_that('Testing error', {
  M = cor(mtcars)
  r = rbind(c('gear', 'wt', 'qsec', 'carb'),
          c('wt', 'qsec', 'carb', 'gear'))
  corrplot(M, method = 'circle', order = 'AOE', diag=TRUE, type='upper') -> p
  expect_error(corrRect(namesMat = r, corrRes = p))
})

test_that('pipe operator', {
  if(getRversion() >= '4.1.0') {
    M = cor(mtcars)
    r = c('gear', 'wt', 'qsec', 'carb')
    corrplot(M, method = 'circle', order = 'AOE') |> corrRect(name = r)
  }
})

