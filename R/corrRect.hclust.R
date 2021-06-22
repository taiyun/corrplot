#' Draw rectangles on the correlation matrix graph.
#'
#' Draw rectangles on the correlation matrix graph based on hierarchical cluster
#' (\code{\link{hclust}}).
#'
#' @param corr Correlation matrix for function \code{corrRect.hclust}. It use
#'   \code{1-corr} as dist in  hierarchical clustering (\code{\link{hclust}}).
#'
#' @param k Integer, the number of rectangles drawn on the graph according to
#'   the hierarchical cluster, for function \code{corrRect.hclust}.
#'
#' @param col Color of rectangles.
#' @param lwd Line width of rectangles.
#'
#' @param method Character, the agglomeration method to be used for hierarchical
#'   clustering (\code{\link{hclust}}). This should be (an unambiguous
#'   abbreviation of) one of \code{"ward"}, \code{"ward.D"}, \code{"ward.D2"},
#'   \code{"single"}, \code{"complete"}, \code{"average"}, \code{"mcquitty"},
#'   \code{"median"} or \code{"centroid"}.
#'
#' @example vignettes/example-corrRect.hclust.R
#' @keywords hplot
#' @author Taiyun Wei
#' @export
corrRect.hclust = function(
  corr,
  k = 2,
  col = "black",
  lwd = 2,
  method = c("complete", "ward", "ward.D", "ward.D2", "single", "average",
             "mcquitty", "median", "centroid") )
{
  n = nrow(corr)
  method = match.arg(method)
  tree = hclust(as.dist(1 - corr), method = method)
  hc = cutree(tree, k = k)
  clustab = table(hc)[unique(hc[tree$order])]
  cu = c(0, cumsum(clustab))

  rect(cu[-(k + 1)] + 0.5,
       n - cu[-(k + 1)] + 0.5,
       cu[-1] + 0.5,
       n - cu[-1] + 0.5,
       border = col, lwd = lwd)
}
