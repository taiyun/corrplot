#' Draw rectangle(s) on the correlation matrix graph.
#'
#' Draw rectangle(s) around the chart of corrrlation matrix.
#' \code{corrRect} needs the number(parameter \code{clus}) of each cluster's
#' members, while \code{corrRect.hclust}  can get the members in each cluster
#' based on hierarchical clustering (\code{\link{hclust}}).
#'
#' @param clus Vector, the number of each cluster's members.
#' @param corr Correlation matrix for function \code{corrRect.hclust}. It use
#'   \code{1-corr} as dist in  hierarchical clustering (\code{\link{hclust}}).
#' @param k Integer, the number of rectangles drawn on the graph according to
#'   the hierarchical cluster, for function \code{corrRect.hclust}.
#' @param col Color of rectangles.
#' @param lwd Line width of rectangles.
#' @param method Character, the agglomeration method to be used for hierarchical
#'   clustering (\code{\link{hclust}}). This should be (an unambiguous
#'   abbreviation of) one of \code{"ward"}, \code{"ward.D"}, \code{"ward.D2"},
#'   \code{"single"}, \code{"complete"}, \code{"average"}, \code{"mcquitty"},
#'   \code{"median"} or \code{"centroid"}.
#'
#' @examples
#' data(mtcars)
#' M <- cor(mtcars)
#' corrplot(M, method = "circle", order = "FPC")
#' corrRect(c(5,6))
#'
#' (order.hc <- corrMatOrder(M, order = "hclust"))
#' (order.hc2 <- corrMatOrder(M, order = "hclust", hclust.method = "ward"))
#' M.hc  <- M[order.hc, order.hc ]
#' M.hc2 <- M[order.hc2,order.hc2]
#'
#' par(ask = TRUE)
#' ##same as: corrplot(M, order = "hclust", addrect = 2)
#' corrplot(M.hc)
#' corrRect.hclust(corr = M.hc, k = 2)
#'
#' ##same as: corrplot(M, order = "hclust", addrect = 3)
#' corrplot(M.hc)
#' corrRect.hclust(corr = M.hc, k = 3)
#'
#' ##same as: corrplot(M, order = "hclust", hclust.method = "ward", addrect = 2)
#' corrplot(M.hc2)
#' corrRect.hclust(M.hc2, k = 2, method = "ward")
#'
#' ##same as: corrplot(M, order = "hclust", hclust.method = "ward", addrect = 3)
#' corrplot(M.hc2)
#' corrRect.hclust(M.hc2, k = 3, method = "ward")
#'
#' ##same as: corrplot(M, order = "hclust", hclust.method = "ward", addrect = 4)
#' corrplot(M.hc2)
#' corrRect.hclust(M.hc2, k = 4, method = "ward")
#'
#' @keywords hplot
#' @author Taiyun Wei
#' @export
corrRect <- function(clus, col = "black", lwd = 2){
	hc <- length(clus)
	cu <- c(0, cumsum(clus))
	mat <- cbind(cu[-(hc + 1)] + 0.5, sum(clus) - cu[-(hc + 1)] + 0.5,
		        cu[-1] + 0.5, sum(clus) - cu[-1] + 0.5)
	rect(mat[,1], mat[,2], mat[,3], mat[,4], border = col, lwd = lwd)
}
