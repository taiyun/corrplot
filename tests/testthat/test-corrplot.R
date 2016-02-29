context("Visualization of a correlation matrix")

# Tests ==========

test_that("Replacing IF statements with switch", {
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
