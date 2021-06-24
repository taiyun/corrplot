#' Draw color legend.
#'
#' @param colbar Vector, color of colbar.
#' @param labels Vector, numeric or character to be written.
#' @param at Numeric vector (quantile), the position to put labels. See examples
#'   for details.
#' @param xlim See in \code{\link{plot}}
#' @param ylim See in \code{\link{plot}}
#' @param vertical Logical, whether the colorlegend is vertical or horizon.
#' @param ratio.colbar The width ratio of colorbar to the total colorlegend
#'   (including colorbar, segments and labels).
#' @param lim.segment Vector (quantile) of length 2, the elements should be in
#'   [0,1], giving segments coordinates ranges. If the value is NULL or 'auto',
#'   then the ranges are derived automatically.
#' @param align Character, alignment type of labels, \code{'l'} means left,
#'   \code{'c'} means center and \code{'r'} right.
#' @param addlabels Logical, whether add text label or not.
#' @param \dots Additional arguments, passed to \code{\link{plot}}
#'
#' @example vignettes/example-colorlegend.R
#' @keywords hplot
#' @author Taiyun Wei
#' @export
colorlegend = function(
  colbar,
  labels,
  at = NULL,
  xlim = c(0, 1),
  ylim = c(0, 1),
  vertical = TRUE,
  ratio.colbar = 0.4,
  lim.segment = 'auto', # NOTE: NULL treated as 'auto'
  align = c('c', 'l', 'r'),
  addlabels = TRUE,
  ...)
{
  if (is.null(at) && addlabels) {
    at = seq(0L, 1L, length = length(labels))
  }

  if (any(is.null(lim.segment)) || any(lim.segment == 'auto')) {
    lim.segment = ratio.colbar + c(0, ratio.colbar * .2)
  }

  if (any(at < 0L) || any(at > 1L)) {
    stop('at should be between 0 and 1')
  }

  if (length(lim.segment) != 2) {
    stop('lim.segment should be a vector of length 2')
  }

  if (any(lim.segment < 0L) || any(lim.segment > 1L)) {
    stop('lim.segment should be between 0 and 1')
  }

  align = match.arg(align)
  xgap = diff(xlim)
  ygap = diff(ylim)
  len = length(colbar)
  rat1 = ratio.colbar
  rat2 = lim.segment

  if (vertical) {

      at = at * ygap + ylim[1]
      yyy = seq(ylim[1], ylim[2], length = len + 1)

      rect(rep(xlim[1], len), yyy[1:len],
           rep(xlim[1] + xgap * rat1, len), yyy[-1],
           col = colbar, border = colbar)
      rect(xlim[1], ylim[1], xlim[1] + xgap * rat1, ylim[2], border = 'black')
      segments(xlim[1] + xgap * rat2[1], at, xlim[1] + xgap * rat2[2], at)

      if (addlabels) {
        pos.xlabel = rep(xlim[1] + xgap * max(rat2, rat1), length(at))
        switch(align,
          l = text(pos.xlabel, y = at, labels = labels, pos = 4, ...),
          r = text(xlim[2],    y = at, labels = labels, pos = 2, ...),
          c = text((pos.xlabel + xlim[2]) / 2, y = at, labels = labels, ...),
          stop('programming error - should not have reached this line!')
        )
      }
  } else {

    at = at * xgap + xlim[1]
    xxx = seq(xlim[1], xlim[2], length = len + 1)

    rect(xxx[1:len], rep(ylim[2] - rat1 * ygap, len),
         xxx[-1], rep(ylim[2], len),
         col = colbar, border = colbar)
    rect(xlim[1], ylim[2] - rat1 * ygap, xlim[2], ylim[2], border = 'black')
    segments(at, ylim[2] - ygap * rat2[1], at, ylim[2] - ygap * rat2[2])

    if (addlabels) {
      pos.ylabel = rep(ylim[2] - ygap * max(rat2, rat1), length(at))
      switch(align,
       l = text(x = at, y = pos.ylabel, labels = labels, pos = 1, ...),
       r = text(x = at, y = ylim[1],    labels = labels, pos = 2, ...),
       c = text(x = at, y = (pos.ylabel + ylim[1]) / 2, labels = labels, ...),
       stop('programming error - should not have reached this line!')
      )
    }
  }
}
