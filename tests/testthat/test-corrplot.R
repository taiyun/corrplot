context("Visualization of a correlation matrix")

# Tests ==========

test_that("Replacing IF statements with SWITCH statement", {
  orig_code <- function(type) {
    tl.pos <- NULL
    if (type == "full")  tl.pos <- "lt"
    if (type == "lower") tl.pos <- "ld"
    if (type == "upper") tl.pos <- "td"
    return(tl.pos)
  }

  switch_code <- function(type) {
    tl.pos <- switch(type, full = "lt", lower = "ld", upper = "td")
    return(tl.pos)
  }

  for (t in c("full", "lower", "upper", "DUMMY", NULL)) {
    expect_equal(orig_code(t), switch_code(t))
  }
})

test_that("Issue #7: Enable to plot a matrix with NA", {
  M <- cor(mtcars)
  diag(M) <- NA
  expect_equal(corrplot(M), M)
})

test_that("Issues #21: plotCI=rect incompatible with some methods", {
  M <- cor(mtcars)
  L <- M - 0.1
  U <- M + 0.1
  expect_equal(corrplot.mixed(M, lower = "circle", upper = "number",
                              low = L, upp = U, plotCI = "rect"), M)
  expect_equal(corrplot.mixed(M, lower = "number", upper = "circle",
                              low = L, upp = U, plotCI = "rect"), M)
  expect_equal(corrplot.mixed(M, lower = "circle", upper = "square",
                              low = L, upp = U, plotCI = "rect"), M)
  expect_equal(corrplot.mixed(M, lower = "ellipse", upper = "square",
                              low = L, upp = U, plotCI = "rect"), M)
  expect_equal(corrplot.mixed(M, lower = "pie", upper = "square",
                              low = L, upp = U, plotCI = "rect"), M)
})

test_that("Issue #43: Return value should be the same as corrplot function", {
  M <- cor(mtcars)
  expect_equal(corrplot.mixed(M), corrplot(M))
})

test_that("Should only work with matrix or dataframe", {
  expect_error(corrplot("some string"),
               regexp = "matrix or data frame")
  expect_error(corrplot(42),
               regexp = "matrix or data frame")
})

test_that("Non-correlation matrix", {
  M <- matrix(runif(100, 0, 10), nrow = 10)
  expect_error(corrplot(M), regexp = "The matrix is not in")
  expect_true(is.matrix(corrplot(M, is.corr = FALSE)))
})

test_that("Try different ordering", {
  M <- cor(mtcars)
  expect_true(  identical(M, corrplot(M)) )
  expect_false( identical(M, corrplot(M, order = "AOE")) )
})

test_that("Plot without a grid should not crash", {
  # TODO: currently, we cannot test how the rendered grid looks like
  # we can only check whether it does not crash
  M <- cor(mtcars)

  # without grid
  corrplot(M, addgrid.col = NA)

  # white grid
  corrplot(M, addgrid.col = NULL, method = "color")
  corrplot(M, addgrid.col = NULL, method = "shade")

  # grey grid
  corrplot(M, addgrid.col = NULL, method = "circle")
})

test_that("Issue #46: Rendering NA values", {

  M <- cor(mtcars)
  diag(M) <- NA
  M[4,2] <- NA

  # default with questionmarks
  corrplot(M)

  # black square instead of the label
  corrplot(M, na.label = "square", na.label.col = "black")

  # large matrix
  M <- matrix(runif(10000, 0.5, 1), nrow = 100)
  M[40:50,30:70] <- 0
  diag(M) <- NA
  corrplot(M, method = "color", cl.pos = "n", tl.pos = "n",
           na.label = "square", addgrid.col = NA)
})

test_that("Using 'number.digits' parameter", {
  M <- cor(mtcars)

  corrplot(M, number.digits = 0)
  corrplot(M, number.digits = 1)
  corrplot(M, method = "number", number.digits = 200000) # should not fail

  expect_error(corrplot(M, number.digits = 1.2), regexp = "is not TRUE" )
  expect_error(corrplot(M, number.digits = -1), regexp = "is not TRUE" )
})
