#' @export
corrRect.hclust <- function(corr, k = 2, col = "black", lwd = 2,
  method = c("complete", "ward", "ward.D", "ward.D2", "single", "average",
             "mcquitty", "median", "centroid") )
{
  n <- nrow(corr)
  method <- match.arg(method)
  tree <- hclust(as.dist(1 - corr), method = method)
  hc <- cutree(tree, k = k)
  clustab <- table(hc)[unique(hc[tree$order])]
  cu <- c(0, cumsum(clustab))
  mat <- cbind(cu[-(k + 1)] + 0.5, n - cu[-(k + 1)] + 0.5,
               cu[-1] + 0.5, n - cu[-1] + 0.5)
  rect(mat[,1], mat[,2], mat[,3], mat[,4], border = col, lwd = lwd)
}
