#' Reorder a correlation matrix.
#'
#' Draw rectangle(s) around the chart of corrrlation matrix based on the number
#' of each cluster's members.
#'
#' @param corr Correlation matrix to reorder.
#'
#' @param order Character, the ordering method for the correlation matrix.
#' \itemize{
#'    \item{\code{'AOE'} for the angular order of the eigenvectors.
#'      It is calculated from the order of the angles, \eqn{a_i}:
#'      \deqn{ a_i = arctan (e_{i2} / e_{i1}), if e_{i1} > 0}
#'      \deqn{ a_i = arctan (e_{i2} / e_{i1}) + \pi, otherwise.}
#'      where \eqn{e_1} and \eqn{e_2} are the largest two eigenvalues
#'      of matrix \code{corr}.
#'      See Michael Friendly (2002) for details.}
#'    \item{\code{'FPC'} for the first principal component order.}
#'    \item{\code{'hclust'} for hierarchical clustering order.}
#'    \item{\code{'alphabet'} for alphabetical order.}
#' }
#'
#' @param hclust.method Character, the agglomeration method to be used when
#'   \code{order} is \code{hclust}. This should be one of \code{'ward'},
#'   \code{'ward.D'}, \code{'ward.D2'}, \code{'single'}, \code{'complete'},
#'   \code{'average'}, \code{'mcquitty'}, \code{'median'} or \code{'centroid'}.
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
corrMatOrder = function(
  corr,
  order = c('AOE', 'FPC', 'hclust', 'alphabet'),
  hclust.method = c('complete', 'ward', 'ward.D', 'ward.D2', 'single',
                    'average', 'mcquitty', 'median', 'centroid'))
{

  order = match.arg(order)
  hclust.method = match.arg(hclust.method)

  switch(order,
    AOE = reorder_using_aoe(corr),
    FPC = reorder_using_fpc(corr),
    hclust = reorder_using_hclust(corr, hclust.method),
    alphabet = sort(rownames(corr))
  )
}

#' Reorder the variables using the angular order of the eigenvectors.
#' @note pure function
#' @noRd
reorder_using_aoe = function(corr) {
  x.eigen = eigen(corr)$vectors[, 1:2]
  e1 = x.eigen[, 1]
  e2 = x.eigen[, 2]
  alpha = ifelse(e1 > 0, atan(e2 / e1), atan(e2 / e1) + pi)
  order(alpha) # returned vector
}

#' Reorder the variables using the first principal component.
#' @note pure function
#' @noRd
reorder_using_fpc = function(corr) {
  x.eigen = eigen(corr)$vectors[, 1:2]
  e1 = x.eigen[, 1]
  order(e1) # returned vector
}

#' Reorder the variables using hclust (Hierarchical Clustering).
#' @note pure function
#' @noRd
reorder_using_hclust = function(corr, hclust.method) {
  hc = hclust(as.dist(1 - corr), method = hclust.method)
  order.dendrogram(as.dendrogram(hc)) # returned vector
}
