context('Adding Correlation Rectangles')

# Tests ==========
test_that('Testing running', {
  M = cor(mtcars)
  r = rbind(c('gear', 'wt', 'qsec', 'carb'),
            c('wt', 'qsec', 'carb', 'gear'))
  i = c(1, 5, 11)
  expect_silent(corrRect(corrplot(M, type = 'upper'), i))
  expect_silent(corrRect(corrplot(M, type = 'lower'), i))
  expect_silent(corrRect(corrplot(M), namesMat = c('gear', 'wt', 'qsec', 'carb')))
  expect_silent(corrRect(corrplot(M), namesMat = r))
})



test_that('Testing error', {
  M = cor(mtcars)
  r = rbind(c('gear', 'wt', 'qsec', 'carb'),
          c('wt', 'qsec', 'carb', 'gear'))
  corrplot(M, method = 'circle', order = 'AOE', diag = TRUE, type='upper') -> p
  expect_error(corrRect(namesMat = r, corrRes = p))
})

test_that('pipe operator', {
  if(getRversion() >= '4.1.0') {
    M = cor(mtcars)
    r = c('gear', 'wt', 'qsec', 'carb')
    corrplot(M, method = 'circle', order = 'AOE') |> corrRect(name = r)
  }
})


test_that('You should just input one of index, name and namesMat!', {
  M = cor(mtcars)
  expect_error(corrRect(corrplot(M), index = c(1, 5, 11), name = c('gear', 'wt')),
               regexp = 'You should just input one of index, name and namesMat!')
})


test_that('List \'corrRes\' must be inputted!', {
  M = cor(mtcars)
  corrplot(M)
  expect_error(corrRect(), regexp = 'List \'corrRes\' must be inputted!')
})



test_that('Non-existent name found!', {
  M = cor(mtcars)
  expect_error(corrRect(corrplot(M), name = c('carb', 'gearssss')),
               regexp = 'Non-existent name found!')
})


test_that('colnames and rownames must be same when index or name is inputted!', {
  M = cor(mtcars)
  expect_error(corrRect(corrplot(M[1:3, 4:6]), name = c('mpg', 'carb')),
               regexp = 'colnames and rownames must be same when index or name is inputted!')

  expect_error(corrRect(corrplot(M[1:3, 4:6]), index = c(1, 5, 11)),
               regexp = 'colnames and rownames must be same when index or name is inputted!')
})
