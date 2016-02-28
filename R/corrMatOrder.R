#' Reorder a correlation matrix.
#'
#' Draw rectangle(s) around the chart of corrrlation matrix based on the number
#' of each cluster's members.
#'
#' @param corr Correlation matrix to reorder.
#'
#' @param order Character, the ordering method for the correlation matrix.
#' \itemize{
#'    \item{\code{"AOE"} for the angular order of the eigenvectors.
#'      It is calculated from the order of the angles, \eqn{a_i}:
#'      \deqn{ a_i = tan (e_{i2}/e_{i1}), if e_{i1}>0}
#'      \deqn{ a_i = tan (e_{i2}/e_{i1}) + \pi, otherwise.}
#'      where \eqn{e_1} and \eqn{e_2} are the largest two eigenvalues
#'      of matrix \code{corr}.
#'      See Michael Friendly (2002) for details.}
#'    \item{\code{"FPC"} for the first principal component order.}
#'    \item{\code{"hclust"} for hierarchical clustering order.}
#'    \item{\code{"alphabet"} for alphabetical order.}
#' }
#'
#' @param hclust.method Character, the agglomeration method to be used when
#'   \code{order} is \code{hclust}. This should be one of \code{"ward"},
#'   \code{"ward.D"}, \code{"ward.D2"}, \code{"single"}, \code{"complete"},
#'   \code{"average"}, \code{"mcquitty"}, \code{"median"} or \code{"centroid"}.
#'
#' @return Returns a single permutation vector.
#'
#' @seealso Package \code{seriation} offers more methods to reorder matrices,
#'   such as ARSA, BBURCG, BBWRCG, MDS, TSP, Chen and so forth.
#'
#' @example vignettes/example-corrMatOrder.R
#' @author Taiyun Wei
#' @keywords hplot
#' @export
corrMatOrder <- function(corr, order=c("AOE", "FPC", "hclust", "alphabet"),
	hclust.method = c("complete", "ward", "ward.D", "ward.D2", "single", "average",
			"mcquitty", "median", "centroid"))
{

	order <- match.arg(order)
	hclust.method <- match.arg(hclust.method)

	## reorder the variables using the angular order of the eigenvectors
	if (order == "AOE") {
		x.eigen <- eigen(corr)$vectors[, 1:2]
		e1 <- x.eigen[, 1]
		e2 <- x.eigen[, 2]
		alpha <- ifelse(e1 > 0, atan(e2/e1), atan(e2/e1) + pi)
		ord <- order(alpha)
	}

	## reorder the variables using the first principal component
	if (order == "FPC") {
		x.eigen <- eigen(corr)$vectors[, 1:2]
		e1 <- x.eigen[, 1]
		ord <- order(e1)
	}

	## reorder the variables in alphabet ordering
	if (order == "alphabet") {
		ord <- sort(rownames(corr))
	}

	## reorder the variables using hclhust
	if (order == "hclust") {
		ord <- order.dendrogram(as.dendrogram(hclust(as.dist(1 - corr),
		method = hclust.method)))
	}

	return(ord)
}
