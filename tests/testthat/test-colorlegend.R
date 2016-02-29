context("Color legend")

# suppress generating any PDFs
pdf(NULL)

test_that("Basic usage of colorlegend", {
  plot(0, type = "n")
  colorlegend(rainbow(100), 0:9)
})

test_that("Calling colorlegend without first calling plot should fail", {
  if ( length(dev.list()) != 0) {
    dev.off()
    pdf(NULL)
  }
  expect_error(colorlegend(rainbow(100), 0:9),
               regexp = "plot.new has not been called yet")
})
