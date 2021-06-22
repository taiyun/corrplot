#' Draw rectangle(s) on the correlation matrix graph.
#'
#' Draw rectangle(s) around the chart of corrrlation matrix.
#'
#' \code{corrRect} needs the number(parameter \code{clus}) of each cluster's
#' members, while \code{corrRect.hclust}  can get the members in each cluster
#' based on hierarchical clustering (\code{\link{hclust}}).
#'
#' @param clus Vector, the number of each cluster's members.
#' @param namesMat 4-length character vector or 4-columns character matrix,
#' corresponding represents the names of xleft, ybottom, xright, ytop.
#' @param corrRes list of the \code{corrplot()} returns.
#' @param col Color of rectangles.
#' @param lwd Line width of rectangles.
#' @param \dots Additional arguments passing to function \code{rect()}.
#'
#' @example vignettes/example-corrRect.R
#' @keywords hplot
#' @author Taiyun Wei
#' @export
corrRect <- function(clus=NULL, namesMat=NULL, corrRes,
                     col = "black", lwd = 2, ...) {

  if(!is.null(clus)&!is.null(namesMat)) {
    stop('Just one of clus and namesMat be NULL')
  }

  if(!is.null(clus)&is.null(namesMat)) {
    hc <- length(clus)
    cu <- c(0, cumsum(clus))
    x1 <- cu[-(hc + 1)] + 0.5
    y1 <- sum(clus) - cu[-(hc + 1)] + 0.5
    x2 <- cu[-1] + 0.5
    y2 <- sum(clus) - cu[-1] + 0.5
  }


  if(!is.null(namesMat)&is.null(clus)) {

    corrPos <- corrRes$corrPos

    if(is.vector(namesMat)) {
      namesMat <- matrix(namesMat, ncol=4)
    }


    xy1 <- getCharXY(namesMat[,1:2, drop=FALSE], corrPos)
    xy2 <- getCharXY(namesMat[,3:4, drop=FALSE], corrPos)

    xy <- cbind(xy1, xy2)

    x1 <- apply(xy[,c(1,3), drop=FALSE], 1, min) - 0.5
    y1 <- apply(xy[,c(2,4), drop=FALSE], 1, min) - 0.5
    x2 <- apply(xy[,c(1,3), drop=FALSE], 1, max) + 0.5
    y2 <- apply(xy[,c(2,4), drop=FALSE], 1, max) + 0.5

    #X <<- (x1+x2)/2
    #Y <<- (y1+y2)/2
    #dX <<- x2 - x1
    #dY <<- y2 - y1

  }


  rect(x1, y1, x2, y2, border = col, lwd = lwd, ...)

  # segments(x1, y1, x2, y1, col=col, lwd = lwd, ...)
  # segments(x1, y1, x1, y2, col=col, lwd = lwd, ...)
  # segments(x2, y2, x2, y1, col=col, lwd = lwd, ...)
  # segments(x2, y2, x1, y2, col=col, lwd = lwd, ...)


  #symbols(x=X, y=Y, rectangles=cbind(dX, dY),
  #        add=TRUE, inches = FALSE, fg='red')

}


#' @note pure function
#' @noRd
getCharXY = function(x, dat){

  res = apply(x, 1, function(n, d=dat) d[d[,1]==n[1]&d[,2]==n[2], 3:4])

  f <- which(unlist(lapply(res, nrow))==0)
  if(length(f) > 0) {
    error  <- paste(toString(unique(x[f,])), 'paired X-Y names were not found!')
    stop(error)
  }

  return(matrix(unlist(res), byrow = TRUE, ncol = 2))
}
