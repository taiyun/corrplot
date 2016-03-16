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

test_that("Issues #21: ", {
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
