#' Significance test which produces p-values and confidence intervals for each
#' pair of input features.
#'
#' @param mat Input matrix of size \code{NxF},
#'   with \code{N} rows that represent samples
#'   and \code{F} columns that represent features.
#' @param \dots Additional arguments passed to function \code{\link{cor.test}},
#'   e.g. \code{conf.level = 0.95}.
#'
#' @return Return a list containing:
#'   \item{p}{Square matrix of size \code{FxF} with p-values as cells}
#'   \item{lowCI}{Square matrix of size \code{FxF}, each cell represents the
#'   \emph{lower part} of a confidence interval}
#'   \item{uppCI}{Square matrix of size \code{FxF}, each cell represents the
#'   \emph{upper part} of a confidence interval}
#'
#' @seealso Function \code{\link{cor.test}}
#'
#' @keywords p-value confidence significance
#' @export
cor.mtest <- function(mat, ...) {
  mat <- as.matrix(mat)
  n <- ncol(mat)
  p.mat <- lowCI.mat <- uppCI.mat <- matrix(NA, n, n)
  diag(p.mat) <- 0
  diag(lowCI.mat) <- diag(uppCI.mat) <- 1
  for (i in 1:(n - 1)) {
    for (j in (i + 1):n) {

      tmp <- cor.test(x = mat[,i], y = mat[,j], ...)
      p.mat[i,j] <- p.mat[j,i] <- tmp$p.value

      # only "pearson" method provides confidence intervals
      if (!is.null(tmp$conf.int)) {
        lowCI.mat[i,j] <- lowCI.mat[j,i] <- tmp$conf.int[1]
        uppCI.mat[i,j] <- uppCI.mat[j,i] <- tmp$conf.int[2]
      }
    }
  }

  colnames(p.mat) <- rownames(p.mat) <- colnames(mat)
  colnames(lowCI.mat) <- rownames(lowCI.mat) <- colnames(mat)
  colnames(uppCI.mat) <- rownames(uppCI.mat) <- colnames(mat)

  list(
    p = p.mat,
    lowCI = lowCI.mat,
    uppCI = uppCI.mat
  )
}
