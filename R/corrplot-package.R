#' @docType package
#' @name corrplot-package
#'
#' @title
#' Visualization of a correlation matrix
#'
#' @description
#' The corrplot package is a graphical display of a correlation matrix,
#' confidence interval or general matrix. It also contains some algorithms to do
#' matrix reordering. In addition, corrplot is good at details, including
#' choosing color, text labels, color labels, layout, etc.
#'
#' @author Taiyun Wei (weitaiyun@@gmail.com)
#' @author Viliam Simko (viliam.simko@@gmail.com)
#'
#' Maintainer: Taiyun Wei (weitaiyun@@gmail.com)
#'
#' @references
#' Michael Friendly (2002).
#' \emph{Corrgrams: Exploratory displays for correlation matrices}.
#' The American Statistician, 56, 316--324.
#'
#' D.J. Murdoch, E.D. Chow (1996).
#' \emph{A graphical display of large correlation matrices}.
#' The American Statistician, 50, 178--180.
#'
#' @seealso
#' The \code{plotcorr} function in the \code{ellipse} package and
#' \code{corrgram} function in the \code{corrgram} package has some
#' similarities.
#'
#' @keywords hplot
#' @keywords correlation
#' @keywords correlogram
#' @keywords feature selection
#' @keywords dimensionality reduction
NULL

.onAttach <- function(libname, pkgname) {
  # just to show a startup message
  message <- paste('corrplot', utils::packageVersion('corrplot'), 'loaded')
  packageStartupMessage(message, appendLF = TRUE)
}
