context('Visualization of a correlation matrix')

# Tests ==========

test_that('Testing `cl.pos` parameter', {
  pvalues <- corrplot::cor.mtest(mtcars, conf.level = 0.95)

  # This throws an error in cbind(corrpos, pNew)
  res <- stats::cor(mtcars, use = "pairwise.complete.obs")
  corrplot::corrplot(res,  method = "color", insig = "n", addCoef.col = "black", p.mat = pvalues$p)

  # outputs: Error in cbind(corrPos, pNew) : Objekt 'pNew' not found
  # The created plot is correct though.

  # This is what I actually want to do
  #
  # stats::cor(mtcars, use = "pairwise.complete.obs") |
  #   > corrplot::corrplot(
  #     method = "color",
  #     type = "upper",
  #     order = "hclust",
  #     number.cex = .7,
  #     addCoef.col = "black",
  #     # Add coefficient of correlation
  #     tl.col = "black",
  #     tl.srt = 90,
  #     # Text label color and rotation
  #     # Combine with significance
  #     p.mat = p$p,
  #     sig.level = c(.001, .01, .05),
  #     insig = "n",
  #     # hide correlation coefficient on the principal diagonal
  #     diag = TRUE,
  #     tl.pos = "lt"
  #   )
  # stats::cor(mtcars, use = "pairwise.complete.obs") |
  #   > corrplot::corrplot(
  #     method = "color",
  #     type = "lower",
  #     order = "hclust",
  #     number.cex = .7,
  #     #addCoef.col = "black", # Add coefficient of correlation
  #     #tl.col = "black", tl.srt = 90, # Text label color and rotation
  #     # Combine with significance
  #     p.mat = p$p,
  #     sig.level = c(.001, .01, .05),
  #     insig = "label_sig",
  #     pch.cex = 0.8,
  #     # hide correlation coefficient on the principal diagonal
  #     diag = TRUE,
  #     add = TRUE,
  #     tl.pos = "n"
  #   )
})

