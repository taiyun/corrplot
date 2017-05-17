context("Visualization of a correlation matrix")

# Tests ==========

test_that("Testing 'cl.pos' parameter", {
  M <- cor(mtcars)
  expect_silent(corrplot(M, cl.pos = TRUE))
  expect_silent(corrplot(M, cl.pos = FALSE))
  expect_silent(corrplot(M, cl.pos = "r"))
  expect_silent(corrplot(M, cl.pos = "b"))
})

test_that("Testing 'tl.pos' parameter", {
  M <- cor(mtcars)
  expect_silent(corrplot(M, tl.pos = TRUE))
  expect_silent(corrplot(M, tl.pos = FALSE))
  expect_silent(corrplot(M, tl.pos = "d"))
  expect_silent(corrplot(M, tl.pos = "n"))
  expect_silent(corrplot(M, tl.pos = "lt"))
  expect_silent(corrplot(M, tl.pos = "ld", type = "lower"))
  expect_silent(corrplot(M, tl.pos = "td", type = "upper"))
})


test_that("Testing 'cl.lim' parameter", {
  M <- cor(mtcars)
  expect_silent(corrplot(M, cl.lim = c(-1, 1)))
  expect_error(corrplot(M, cl.lim = c(0, 1)),
               regexp = "color limits should cover matrix")
})

test_that("Testing 'tl.pos' parameter", {
  M <- cor(mtcars)
  expect_silent(corrplot(M, tl.pos = "td", type = "upper"))
  expect_error(corrplot(M, tl.pos = "td", type = "lower"),
               regexp = "type should be")
  expect_silent(corrplot(M, tl.pos = "ld", type = "lower"))
  expect_error(corrplot(M, tl.pos = "ld", type = "upper"),
               regexp = "type should be")
})

test_that("Testing 'corrRect' function", {
  M <- cor(mtcars)
  corrplot(M, method = "circle", order = "FPC")
  corrRect(c(5,6))
})

test_that("Testing 'outline' parameter", {
  M <- cor(mtcars)
  expect_silent(corrplot(M, outline = FALSE))
  expect_silent(corrplot(M, outline = TRUE))
  expect_silent(corrplot(M, outline = "white"))

  for (unsupported in list(42, NA, NULL)) {
    expect_error(corrplot(M, outline = unsupported),
                 regexp = "Unsupported value type for parameter outline")
  }

  expect_error(corrplot(M, outline = ""),
               regexp = "invalid color name")

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
                              lowCI = L, uppCI = U, plotCI = "rect"), M)
  expect_equal(corrplot.mixed(M, lower = "number", upper = "circle",
                              lowCI = L, uppCI = U, plotCI = "rect"), M)
  expect_equal(corrplot.mixed(M, lower = "circle", upper = "square",
                              lowCI = L, uppCI = U, plotCI = "rect"), M)
  expect_equal(corrplot.mixed(M, lower = "ellipse", upper = "square",
                              lowCI = L, uppCI = U, plotCI = "rect"), M)
  expect_equal(corrplot.mixed(M, lower = "pie", upper = "square",
                              lowCI = L, uppCI = U, plotCI = "rect"), M)
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

  expect_silent(corrplot(M, addrect = 2, order = "hclust", type = "full"))
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

test_that("Issue #18", {
  M <- cor(mtcars)
  # TODO: calling the function without actually checking anything
  expect_silent(corrplot(M, method = "pie"))
  expect_silent(corrplot(M, method = "pie", outline = TRUE))
  expect_silent(corrplot(M, method = "pie", outline = "white"))
})

test_that("Issue #76: separate `col` parameters corrplot.mixed", {
  M <- cor(mtcars)
  expect_silent(corrplot.mixed(M, lower.col = "black"))
  expect_silent(corrplot.mixed(M, lower = "circle",
                               upper = "number", upper.col = "black"))
})

test_that("Mark significant correlations", {
  M <- cor(mtcars)
  fakepmat <- 1 - abs(M) ^ .2  # Hmisc::rcorr provides a p-value matrix, but
  # don't want to introduce the dependency
  expect_silent(corrplot(M, p.mat = fakepmat, insig = "label_sig", pch = "!",
                         sig.level = c(.001, .1, .99)))
  expect_silent(corrplot(M[1:2, ], p.mat = fakepmat[1:2, ], method = "ellipse",
                         insig = "label_sig", pch.col = "white"))
  expect_silent(corrplot(M, p.mat = fakepmat, insig = "label_sig",
                         pch = "p<.05", pch.cex = .5, order = "AOE"))
})
