
context("Html5 of corrplot")


test_that("basic usage of corrplotVis",{
M <- cor(mtcars)
expect_silent(corrplotVis(M))

})


test_that("different size of svg in corrplotVis",{
  M <- cor(mtcars)
  expect_silent(corrplotVis(M, size = c(500,600)))

})

test_that("test color in corrplotVis",{
  M <- cor(mtcars)
  expect_silent(corrplotVis(M, color = c("#053061", "#FFFFFF", "#67001F")))
  expect_silent(corrplotVis(M, color = c("#053061", "#FFFFFF")))

})


test_that("test rangwidth of corrplotVis",{
  M <- cor(mtcars)
  expect_silent(corrplotVis(M,widthRange = c(200,1000)))
  expect_error(corrplotVis(M, widthRange = c(1000,500)))
})

