context("Color legend")

# suppress generating any PDFs
pdf(NULL)

test_that("Basic usage of colorlegend", {
  plot(0, type = "n")
  expect_silent(colorlegend(rainbow(100), 0:9))
  expect_silent(colorlegend(rainbow(100), 0:9, vertical = FALSE))
})

test_that("Calling colorlegend without first calling plot should fail", {
  if ( length(dev.list()) != 0) {
    dev.off()
    pdf(NULL)
  }
  expect_error(colorlegend(rainbow(100), 0:9),
               regexp = "plot.new has not been called yet")
})

test_that("Issues #64, #66: lim.segment in function colorlegend()", {
  plot(0, type = "n")

  expect_error(colorlegend(rainbow(100), 0:9, lim.segment = 1),
               regexp = "should be a vector of length 2")

  expect_error(colorlegend(rainbow(100), 0:9, lim.segment = c(1,2,3)),
               regexp = "should be a vector of length 2")

  # lim.segment[1] >= 0
  expect_error(colorlegend(rainbow(100), 0:9, lim.segment = c(-0.1, 0)),
               regexp = "should be between 0 and 1")

  # lim.segment[2] <= 1
  expect_error(colorlegend(rainbow(100), 0:9, lim.segment = c(0, 1.1)),
               regexp = "should be between 0 and 1")

  # automatic lim.segment
  expect_silent(colorlegend(rainbow(100), 0:9, lim.segment = NULL))

  # Issue #66: more intuitive value for automatic lim.segment
  expect_silent(colorlegend(rainbow(100), 0:9, lim.segment = "auto"))
  expect_error(colorlegend(rainbow(100), 0:9, lim.segment = "otherstring"),
               regexp = "should be a vector of length 2")

  expect_silent(colorlegend(rainbow(100), 0:9, lim.segment = c(0,1)))
})

test_that("Parameter `at` should be between 0 and 1", {
  plot(0, type = "n")

  expect_error(colorlegend(rainbow(100), 0:2, at = c(-1,.5,.8)),
               regexp = "should be between 0 and 1")

  expect_silent(colorlegend(rainbow(100), 0:2, at = c(0,.5,.8)))
})
