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

test_that("Issue #70: Enable to plot a matrix with NA when 'is.corr = F'", {
  M <- matrix(0, ncol = 5, nrow = 5)
  M[1,1] <- NA
  expect_true(is.matrix(corrplot(M, is.corr = F)))
})


test_that("Issue #20: plotmath expressions in rownames / colnames", {
  M <- cor(mtcars)[1:5,1:5]
  colnames(M) <- c("alpha", "beta", ":alpha+beta", ": a[0]", "=a[beta]")
  rownames(M) <- c("alpha", "beta", NA, "$a[0]", "$ a[beta]")
  corrplot(M)
})

test_that("Issue #21: plotCI=rect incompatible with some methods", {
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
  expect_error(corrplot("some string"), regexp = "matrix or data frame")
  expect_error(corrplot(42), regexp = "matrix or data frame")
})

test_that("Non-correlation matrix", {
  M <- matrix(runif(100, 0, 10), nrow = 10)
  expect_error(corrplot(M), regexp = "The matrix is not in")
  expect_true(is.matrix(corrplot(M, is.corr = FALSE)))
})

test_that("Try different ordering", {
  M <- cor(mtcars)
  expect_true(identical(M, corrplot(M)))
  expect_false(identical(M, corrplot(M, order = "AOE")))
  expect_false(identical(M, corrplot(M, order = "FPC")))
  expect_false(identical(M, corrplot(M, order = "hclust")))
  expect_false(identical(M, corrplot(M, order = "alphabet")))
})

test_that("Plot without a grid should not crash", {
  # TODO: currently, we cannot test how the rendered grid looks like
  # we can only check whether it does not crash
  M <- cor(mtcars)

  # without grid
  expect_silent(corrplot(M, addgrid.col = NA))

  # white grid
  expect_silent(corrplot(M, addgrid.col = NULL, method = "color"))
  expect_silent(corrplot(M, addgrid.col = NULL, method = "shade"))

  # grey grid
  expect_silent(corrplot(M, addgrid.col = NULL, method = "circle"))
})

test_that("Issue #46: Rendering NA values", {

  M <- cor(mtcars)
  diag(M) <- NA
  M[4,2] <- NA

  # default label for NAs
  expect_silent(corrplot(M))

  # black square instead of the label
  expect_silent(corrplot(M, na.label = "square", na.label.col = "black"))

  # large matrix
  M <- matrix(runif(10000, 0.5, 1), nrow = 100)
  M[40:50,30:70] <- 0
  diag(M) <- NA
  expect_silent(corrplot(M, method = "color", cl.pos = "n", tl.pos = "n",
                         na.label = "square", addgrid.col = NA))
})

test_that("Issue #55: Support for multiple characters when rendering NAs", {
  M <- cor(mtcars)
  diag(M) <- NA

  # label with 2 chars should work
  expect_silent(corrplot(M, na.label = "NA"))

  expect_error(corrplot(M, na.label = "ABC"),
               regexp = "Maximum number of characters for NA label is: 2")

})

test_that("Using 'number.digits' parameter", {
  M <- cor(mtcars)

  expect_silent(corrplot(M, number.digits = 0))
  expect_silent(corrplot(M, number.digits = 1))
  expect_silent(corrplot(M, method = "number", number.digits = 200000))

  expect_error(corrplot(M, number.digits = 1.2), regexp = "is not TRUE" )
  expect_error(corrplot(M, number.digits = -1), regexp = "is not TRUE" )
})

test_that("par() is restored after corrplot()", {
  grDevices::pdf(NULL)
  par1 <- par("mar")
  corrplot(cor(mtcars))
  par2 <- par("mar")
  dev.off()
  expect_identical(par1, par2)
})

test_that("Issue #79: Changing aspect ratio for the plot", {
  M <- matrix(rnorm(70), ncol = 7)
  expect_silent(corrplot(M, is.corr = F, win.asp = .7, method = "circle"))
  expect_silent(corrplot(M, is.corr = F, win.asp = .7, method = "square"))
  expect_error(corrplot(M, is.corr = F, win.asp = .7, method = "pie"),
               regexp = "supported only for circle and square methods")
})
