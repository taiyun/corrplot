#' Draw rectangle(s) on the correlation matrix graph.
#'
#' Draw rectangle(s) after the correlation matrix plotted. SUGGESTION: It's more convenient
#' to draw rectangle(s) by using pipe operator `|>` since R 4.1.0.
#'
#' \code{corrRect} needs one of \code{index}, \code{name} and \code{namesMat} inputted.
#' While \code{corrRect.hclust} can get the members in each cluster
#' based on hierarchical clustering (\code{\link{hclust}}).
#'
#' @param corrRes List of the \code{corrplot()} returns.
#' @param index Vector, variable index of diag rect \code{c(Rect1from, Rect2from,
#' Rect3from, ..., RectNto)} on the correlation matrix graph.
#' It works when the colnames are the same as rownames, or both of them is NULL.
#' It needs \code{corrRes} inputted.
#' @param name Vector, variable name of diag rect \code{c(Rect1from, Rect2from,
#' Rect3from, ..., RectNto)} on the correlation matrix graph.
#' OIt works when the colnames are the same as rownames.
#' It needs \code{corrRes} inputted.
#' @param namesMat 4-length character vector or 4-columns character matrix,
#' represents the names of xleft, ybottom, xright, ytop correspondingly.
#' It needs \code{corrRes} inputted.
#' @param col Color of rectangles.
#' @param lwd Line width of rectangles.
#' @param \dots Additional arguments passing to function \code{rect()}.
#'
#' @example vignettes/example-corrRect.R
#' @keywords hplot
#' @author Taiyun Wei
#' @export
corrRect = function(corrRes = NULL, index = NULL, name = NULL, namesMat = NULL,
                    col = 'black', lwd = 2, ...) {

  if((!is.null(index) + !is.null(name) + !is.null(namesMat)) > 1) {
    stop('You should just input one of index, name and namesMat!')
  }

  if(is.null(corrRes)|!is.list(corrRes)) {
    stop('List \'corrRes\' must be inputted!')
  }

  corr = corrRes$corr
  corrPos = corrRes$corrPos
  type = corrRes$arg$type

  cName = colnames(corr)
  rName = rownames(corr)

  if(!is.null(name)) {

    if(any(cName != rName)) {
      stop('colnames and rownames should NOT be NULL!')
    }

    if(is.null(cName) | is.null(rName)) {
      stop('colnames and rownames must be same when index or name is inputted!')
    }

    if(!all(name %in% cName)) {
      stop('Non-existent name found!')
    }

    index = unlist(lapply(name, function(n) which(cName==n)))
  }



  if(!is.null(index)) {

    if(!is.null(cName) & !is.null(rName) & any(cName != rName)) {
      stop('colnames and rownames must be same when index or name is inputted!')
    }


    n = length(index)
    index[-n] = index[-n] - 1

    x1 = index[-n] + 0.5
    y1 = nrow(corr) - index[-n] + 0.5
    x2 = index[-1] + 0.5
    y2 = nrow(corr) - index[-1] + 0.5
    St = S = cbind(c(x1, x1, x2, x2), c(y1, y1, y2, y2),
                   c(x2, x1, x2, x1), c(y1, y2, y1, y2))
    St[,2] = abs(St[,2] - nrow(corr) - 1)
    St[,4] = abs(St[,4] - nrow(corr) - 1)

    if(type=='upper') {
      i = which((St[,1] - St[,2]) > -0.1 & (St[,3] - St[,4]) > -0.1)
      S = S[i,]
    }

    if(type=='lower') {
      i = which((St[,2] - St[,1]) > -0.1 & (St[,4] - St[,3]) > -0.1)
      S = S[i,]
    }

    segments(S[,1], S[,2], S[,3], S[,4], col=col, lwd = lwd, ...)
  }

  if(!is.null(namesMat)) {

    if(is.vector(namesMat)) {
      namesMat = matrix(namesMat, ncol=4)
    }

    xy1 = getCharXY(namesMat[,1:2, drop=FALSE], corrPos)
    xy2 = getCharXY(namesMat[,3:4, drop=FALSE], corrPos)

    xy = cbind(xy1, xy2)

    x1 = apply(xy[,c(1,3), drop=FALSE], 1, min) - 0.5
    y1 = apply(xy[,c(2,4), drop=FALSE], 1, min) - 0.5
    x2 = apply(xy[,c(1,3), drop=FALSE], 1, max) + 0.5
    y2 = apply(xy[,c(2,4), drop=FALSE], 1, max) + 0.5

    rect(x1, y1, x2, y2, border = col, lwd = lwd, ...)
  }

}


#' @note pure function
#' @noRd
getCharXY = function(x, dat){

  if(is.vector((x))) {
    x = matrix(x, nrow = 1)
  }

  res = apply(x, 1, function(n, d=dat) d[d[,1]==n[1]&d[,2]==n[2], 3:4])

  f = which(unlist(lapply(res, nrow))==0)
  if(length(f) > 0) {
    error  = paste(toString(unique(x[f,])), 'paired X-Y names were not found!')
    stop(error)
  }

  return(matrix(unlist(res), byrow = TRUE, ncol = 2))
}
