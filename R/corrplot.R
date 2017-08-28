#' A visualization of a correlation matrix.
#'
#' A graphical display of a correlation matrix, confidence interval. The details
#' are paid great attention to. It can also visualize a general matrix by
#' setting \code{is.corr = FALSE}.
#'
#' @param corr The correlation matrix to visualize, must be square if
#'   \code{order} is not \code{"original"}. For general matrix, please using
#'   \code{is.corr = FALSE} to convert.
#'
#' @param method Character, the visualization method of correlation matrix to be
#'   used. Currently, it supports seven methods, named \code{"circle"}
#'   (default), \code{"square"}, \code{"ellipse"}, \code{"number"},
#'   \code{"pie"}, \code{"shade"} and \code{"color"}. See examples for details.
#'
#'   The areas of circles or squares show the absolute value of corresponding
#'   correlation coefficients. Method \code{"pie"} and \code{"shade"} came from
#'   Michael Friendly's job (with some adjustment about the shade added on), and
#'   \code{"ellipse"} came from D.J. Murdoch and E.D. Chow's job, see in section
#'   References.
#'
#' @param type Character, \code{"full"} (default), \code{"upper"} or
#'   \code{"lower"}, display full matrix, lower triangular or upper triangular
#'   matrix.
#'
#' @param add Logical, if \code{TRUE}, the graph is added to an existing plot,
#'   otherwise a new plot is created.
#'
#' @param col Vector, the color of glyphs. It is distributed uniformly in
#'   \code{cl.lim}. If NULL, \code{col} will be
#'   \code{colorRampPalette(col2)(200)}, see example about col2.
#'
#' @param bg The background color.
#'
#' @param title Character, title of the graph.
#'
#' @param is.corr Logical, whether the input matrix is a correlation matrix or
#'   not. We can visualize the non-correlation matrix by setting
#'   \code{is.corr = FALSE}.
#'
#' @param diag Logical, whether display the correlation coefficients on the
#'   principal diagonal.
#'
#' @param outline Logical or character, whether plot outline of circles, square
#'   and ellipse, or the color of these glyphs. For pie, this represents the
#'   color of the circle outlining the pie. If \code{outline} is \code{TRUE},
#'   the default value is \code{"black"}.
#'
#' @param mar See \code{\link{par}}.
#'
#' @param addgrid.col The color of the grid. If \code{NA}, don't add grid. If
#'   \code{NULL} the default value is chosen. The default value depends on
#'   \code{method}, if \code{method} is \code{color} or \code{shade}, the color
#'   of the grid is \code{NA}, that is, not draw grid; otherwise \code{"grey"}.
#'
#' @param addCoef.col Color of coefficients added on the graph. If \code{NULL}
#'   (default), add no coefficients.
#'
#' @param addCoefasPercent Logic, whether translate coefficients into percentage
#'   style for spacesaving.
#'
#' @param order Character, the ordering method of the correlation matrix.
#' \itemize{
#'   \item{\code{"original"} for original order (default).}
#'   \item{\code{"AOE"} for the angular order of the eigenvectors.}
#'   \item{\code{"FPC"} for the first principal component order.}
#'   \item{\code{"hclust"} for the hierarchical clustering order.}
#'   \item{\code{"alphabet"} for alphabetical order.}
#' }
#'
#' See function \code{\link{corrMatOrder}} for details.
#'
#' @param hclust.method Character, the agglomeration method to be used when
#'   \code{order} is \code{\link{hclust}}. This should be one of \code{"ward"},
#'   \code{"ward.D"}, \code{"ward.D2"}, \code{"single"}, \code{"complete"},
#'   \code{"average"}, \code{"mcquitty"}, \code{"median"} or \code{"centroid"}.
#'
#' @param addrect Integer, the number of rectangles draws on the graph according
#'   to the hierarchical cluster, only valid when \code{order} is \code{hclust}.
#'   If \code{NULL} (default), then add no rectangles.
#'
#' @param rect.col Color for rectangle border(s), only valid when \code{addrect}
#'   is equal or greater than 1.
#'
#' @param rect.lwd Numeric, line width for borders for rectangle border(s), only
#'   valid when \code{addrect} is equal or greater than 1.
#'
#' @param tl.pos Character or logical, position of text labels. If character, it
#'   must be one of \code{"lt"}, \code{"ld"}, \code{"td"}, \code{"d"} or
#'   \code{"n"}. \code{"lt"}(default if \code{type=="full"}) means left and top,
#'   \code{"ld"}(default if \code{type=="lower"}) means left and diagonal,
#'   \code{"td"}(default if \code{type=="upper"}) means top and diagonal(near),
#'   \code{"d"} means diagonal, \code{"n"} means don't add textlabel.
#'
#' @param tl.cex Numeric, for the size of text label (variable names).
#'
#' @param tl.col The color of text label.
#'
#' @param tl.offset Numeric, for text label, see \code{\link{text}}.
#'
#' @param tl.srt Numeric, for text label string rotation in degrees, see
#'   \code{\link{text}}.
#'
#' @param cl.pos Character or logical, position of color labels; If character,
#'   it must be one of \code{"r"} (default if \code{type=="upper"} or
#'   \code{"full"}), \code{"b"} (default if \code{type=="lower"}) or \code{"n"},
#'   \code{"n"} means don't draw colorlabel.
#'
#' @param cl.lim The  limits \code{(x1, x2)}  in the colorlabel.
#'
#' @param cl.length Integer, the number of number-text in colorlabel, passed to
#'   \code{\link{colorlegend}}. If \code{NULL}, \code{cl.length} is
#'   \code{length(col) + 1} when \code{length(col) <=20}; \code{cl.length} is 11
#'   when \code{length(col) > 20}
#'
#' @param cl.cex Numeric, cex of number-label in colorlabel,  passed to
#'   \code{\link{colorlegend}}.
#'
#' @param cl.ratio Numeric, to justify the width of colorlabel, 0.1~0.2 is
#'   suggested.
#'
#' @param cl.align.text Character, \code{"l"}, \code{"c"} (default) or
#'   \code{"r"}, for number-label in colorlabel, \code{"l"} means left,
#'   \code{"c"} means center, and \code{"r"} means right.
#'
#' @param cl.offset Numeric, for number-label in colorlabel, see
#'   \code{\link{text}}.
#'
#' @param number.cex The \code{cex} parameter to send to the call to \code{text}
#'   when writing the correlation coefficients into the plot.
#'
#' @param number.font the \code{font} parameter to send to the call to
#'   \code{text} when writing the correlation coefficients into the plot.
#'
#' @param number.digits indicating the number of decimal digits to be
#'   added into the plot. Non-negative integer or NULL, default NULL.
#'
#' @param addshade Character for shade style, \code{"negative"},
#'   \code{"positive"} or \code{"all"}, only valid when \code{method} is
#'   \code{"shade"}. If \code{"all"}, all correlation coefficients' glyph will
#'   be shaded; if \code{"positive"}, only the positive will be shaded; if
#'   \code{"negative"}, only the negative will be shaded. Note: the angle of
#'   shade line is different, 45 degrees for positive and 135 degrees for
#'   negative.
#'
#' @param shade.lwd Numeric, the line width of shade.
#'
#' @param shade.col The color of shade line.
#'
#' @param p.mat Matrix of p-value, if \code{NULL}, arguments \code{sig.level},
#'   \code{insig}, \code{pch}, \code{pch.col}, \code{pch.cex} is invalid.
#'
#' @param sig.level Significant level,  if the p-value in \code{p-mat} is bigger
#'   than \code{sig.level}, then the corresponding correlation coefficient is
#'   regarded as insignificant. If \code{insig} is \code{"label_sig"}, this may
#'   be an increasing vector of significance levels, in which case \code{pch}
#'   will be used once for the highest p-value interval and multiple times
#'   (e.g. "*", "**", "***") for each lower p-value interval.
#'
#' @param insig Character, specialized insignificant correlation coefficients,
#'   \code{"pch"} (default), \code{"p-value"}, \code{"blank"}, \code{"n"}, or
#'   \code{"label_sig"}. If \code{"blank"}, wipe away the corresponding glyphs;
#'   if \code{"p-value"}, add p-values the corresponding glyphs;
#'   if \code{"pch"}, add characters (see \code{pch} for details) on
#'   corresponding glyphs; if \code{"n"}, don't take any measures; if
#'   \code{"label_sig"}, mark significant correlations with pch
#'   (see \code{sig.level}).
#'
#' @param pch Add character on the glyphs of insignificant correlation
#'   coefficients(only valid when \code{insig} is \code{"pch"}). See
#'   \code{\link{par}}.
#'
#' @param pch.col The color of pch (only valid when \code{insig} is
#'   \code{"pch"}).
#'
#' @param pch.cex The cex of pch (only valid when \code{insig} is \code{"pch"}).
#'
#' @param plotCI Character, method of ploting confidence interval. If
#'   \code{"n"}, don't plot confidence interval. If "rect", plot rectangles
#'   whose upper side means upper bound and lower side means lower bound,
#'   respectively, and meanwhile correlation coefficients are also added on the
#'   rectangles. If "circle", first plot a circle with the bigger absolute
#'   bound, and then plot the smaller. Warning: if the two bounds are the same
#'   sign, the smaller circle will be wiped away, thus forming a ring. Method
#'   "square" is similar to "circle".
#'
#' @param lowCI.mat Matrix of the lower bound of confidence interval.
#'
#' @param uppCI.mat Matrix of the upper bound of confidence interval.
#'
#' @param na.label Label to be used for rendering \code{NA} cells. Default is
#'   \code{"?"}. If "square", then the cell is rendered as a square with the
#'   \code{na.label.col} color.
#'
#' @param na.label.col Color used for rendering \code{NA} cells. Default is
#'   \code{"black"}.
#'
#' @param win.asp Aspect ration for the whole plot. Value other than 1 is
#'   currently compatible only with methods "circle" and "square".
#'
#' @param \dots Additional arguments passing to function \code{text} for drawing
#'   text lable.
#'
#' @return (Invisibly) returns a reordered correlation matrix.
#'
#' @details \code{corrplot} function offers flexible ways to visualize
#'   correlation matrix, lower and upper bound of confidence interval matrix.
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
#' @author Taiyun Wei (weitaiyun@@gmail.com)
#' @author Viliam Simko (viliam.simko@@gmail.com)
#' @author Michael Levy (michael.levy@@healthcatalyst.com)
#'
#' @note \code{Cairo} and \code{cairoDevice} packages is strongly recommended to
#'   produce high-quality PNG, JPEG, TIFF bitmap files, especially for that
#'   \code{method} \code{circle}, \code{ellipse}.
#'
#' @note Row- and column names of the input matrix are used as labels rendered
#'   in the corrplot. Plothmath expressions will be used if the name is prefixed
#'   by one of the following characters: \code{:}, \code{=} or \code{$}.
#'   For example \code{":alpha + beta"}.
#'
#' @seealso Function \code{plotcorr}  in the \code{ellipse} package and
#'   \code{corrgram}  in the \code{corrgram} package have some similarities.
#'
#'   Package \code{seriation} offered more methods to reorder matrices, such as
#'   ARSA, BBURCG, BBWRCG, MDS, TSP, Chen and so forth.
#'
#' @example vignettes/example-corrplot.R
#' @import graphics grDevices stats
#' @export
corrplot <- function(corr,
  method = c("circle", "square", "ellipse", "number", "shade", "color", "pie"),
  type = c("full", "lower", "upper"), add = FALSE,
  col = NULL, bg = "white", title = "", is.corr = TRUE,
  diag = TRUE, outline = FALSE, mar = c(0, 0, 0, 0),
  addgrid.col = NULL, addCoef.col = NULL, addCoefasPercent = FALSE,

  order = c("original", "AOE", "FPC", "hclust", "alphabet"),
  hclust.method = c("complete", "ward", "ward.D", "ward.D2", "single",
                    "average", "mcquitty", "median", "centroid"),
  addrect = NULL, rect.col = "black", rect.lwd = 2,

  tl.pos = NULL, tl.cex = 1,
  tl.col = "red", tl.offset = 0.4, tl.srt = 90,

  cl.pos = NULL, cl.lim = NULL,
  cl.length = NULL, cl.cex = 0.8, cl.ratio = 0.15,
  cl.align.text = "c", cl.offset = 0.5,

  number.cex = 1, number.font = 2, number.digits = NULL,

  addshade = c("negative", "positive", "all"),
  shade.lwd = 1, shade.col = "white",

  p.mat = NULL, sig.level = 0.05,
  insig = c("pch", "p-value", "blank", "n", "label_sig"),
  pch = 4, pch.col = "black", pch.cex = 3,

  plotCI = c("n", "square", "circle", "rect"),
  lowCI.mat = NULL, uppCI.mat = NULL,
  na.label = "?", na.label.col = "black",
  win.asp = 1,
  ...)
{

  # checking multi-option input parameters
  method <- match.arg(method)
  type <- match.arg(type)
  order <- match.arg(order)
  hclust.method <- match.arg(hclust.method)
  addshade <- match.arg(addshade)
  insig <- match.arg(insig)
  plotCI <- match.arg(plotCI)

  # rescale symbols within the corrplot based on win.asp parameter
  if (win.asp != 1 && !(method %in% c("circle", "square"))) {
    stop("Parameter 'win.asp' is supported only for circle and square methods.")
  }
  asp_rescale_factor <- min(1, win.asp) / max(1, win.asp)
  stopifnot(asp_rescale_factor >= 0 && asp_rescale_factor <= 1)

  if (!is.matrix(corr) && !is.data.frame(corr)) {
    stop("Need a matrix or data frame!")
  }

  # select grid color automatically if not specified
  if (is.null(addgrid.col)) {
    addgrid.col <- switch(method, color = NA, shade = NA, "grey")
  }

  if (any(corr < cl.lim[1]) || any(corr > cl.lim[2])) {
    stop("color limits should cover matrix")
  }

  if (is.null(cl.lim)) {
    if (is.corr) {
      cl.lim <- c(-1,1)
    } else {
      cl.lim <- c(min(corr, na.rm = TRUE), max(corr, na.rm = TRUE))
    }
  }

  intercept <- 0
  zoom <- 1

  if (!is.corr) {

    c_max <- max(corr, na.rm = TRUE)
    c_min <- min(corr, na.rm = TRUE)

    # The following if-elseif-else code should exhaustively cover all 9
    # combinations of c_min and c_max variables. Each variable can be either
    # zero (0), positive (+) or negative (-).

    # c_min c_max

    # 00
    # -0
    # +0
    # --
    # 0-
    if (c_max <= 0) {
      intercept <- -cl.lim[2]
      zoom <- 1 / (diff(cl.lim))
    }

    # ++
    # +-
    # 0+
    else if (c_min >= 0) {
      intercept <- -cl.lim[1]
      zoom <- 1 / (diff(cl.lim))
    }

    # -+
    else {

      # expression from the original code as a sanity check
      stopifnot(c_max * c_min < 0)

      # newly derived expression which covers the single remainig case
      stopifnot(c_min < 0 && c_max > 0)

      intercept <- 0
      zoom <- 1 / max(abs(cl.lim))
    }

    # now, the zoom might still be Inf when cl.lim were both zero
    if (zoom == Inf) {
      stopifnot(cl.lim[1] == 0 && cl.lim[2] == 0) # check the assumption
      zoom <- 0
    }

    corr <- (intercept + corr) * zoom
  }

  cl.lim2 <- (intercept + cl.lim) * zoom
  int <- intercept * zoom

  if (min(corr, na.rm = TRUE) < -1 - .Machine$double.eps ^ .75 ||
      max(corr, na.rm = TRUE) >  1 + .Machine$double.eps ^ .75 ) {
    stop("The matrix is not in [-1, 1]!")
  }

  if (is.null(col)) {
    col <- colorRampPalette(c("#67001F", "#B2182B", "#D6604D", "#F4A582",
                              "#FDDBC7", "#FFFFFF", "#D1E5F0", "#92C5DE",
                              "#4393C3", "#2166AC", "#053061"))(200)
  }

  n <- nrow(corr)
  m <- ncol(corr)
  min.nm <- min(n,m)
  ord <- seq_len(min.nm)

  if (order != "original") {
    ord <- corrMatOrder(corr, order = order, hclust.method = hclust.method)
    corr <- corr[ord, ord]
  }

  ## set up variable names
  if (is.null(rownames(corr))) {
    rownames(corr) <- seq_len(n)
  }
  if (is.null(colnames(corr))) {
    colnames(corr) <- seq_len(m)
  }

  # assigns Inf to cells in the matrix depending on the type paramter
  apply_mat_filter <- function(mat) {
    x <- matrix(1:n * m, n, m)
    switch(type,
      upper = mat[row(x) > col(x)] <- Inf,
      lower = mat[row(x) < col(x)] <- Inf
    )

    if (!diag) {
      diag(mat) <- Inf
    }
    return(mat)
  }

  # retrieves coordinates of cells to be rendered
  getPos.Dat <- function(mat) {
    tmp <- apply_mat_filter(mat)
    Dat <- tmp[is.finite(tmp)]
    ind  <- which(is.finite(tmp), arr.ind = TRUE)
    Pos <- ind
    Pos[,1] <-  ind[,2]
    Pos[,2] <- -ind[,1] + 1 + n
    return(list(Pos, Dat))
  }

  # retrieves coordinates of NA cells
  # we use this for rending NA cells differently
  getPos.NAs <- function(mat) {
    tmp <- apply_mat_filter(mat)
    ind <- which(is.na(tmp), arr.ind = TRUE)
    Pos <- ind
    Pos[,1] <-  ind[,2]
    Pos[,2] <- -ind[,1] + 1 + n
    return(Pos)
  }

  Pos <- getPos.Dat(corr)[[1]]

  # decide whether NA labels are going to be rendered or whether we ignore them
  if (any(is.na(corr)) && is.character(na.label)) {
    PosNA <- getPos.NAs(corr)
  } else {
    # explicitly set to NULL to indicate that NA labels are not going to be
    # rendered
    PosNA <- NULL
  }

  AllCoords <- rbind(Pos, PosNA)

  # rows
  n2 <- max(AllCoords[,2])
  n1 <- min(AllCoords[,2])

  nn <- n2 - n1

  # columns
  m2 <- max(AllCoords[,1])
  m1 <- min(AllCoords[,1])

  # Issue #19: legend color bar width 0 when using just one column matrix
  # also discussed here: http://stackoverflow.com/questions/34638555/
  mm <- max(1, m2 - m1)

  # Issue #20: support plotmath expressions in rownames and colnames
  expand_expression <- function(s) {
    ifelse(grepl("^[:=$]", s), parse(text = substring(s, 2)), s)
  }

  newrownames <- sapply(
    rownames(corr)[(n + 1 - n2):(n + 1 - n1)], expand_expression)

  newcolnames <- sapply(
    colnames(corr)[m1:m2], expand_expression)

  DAT <- getPos.Dat(corr)[[2]]
  len.DAT <- length(DAT)

  rm(expand_expression) # making sure the function is only used here

  ## assign colors
  assign.color <- function(dat = DAT, color = col){
    newcorr <- (dat + 1) / 2
    newcorr[newcorr <= 0]  <- 0
    newcorr[newcorr >= 1]  <- 1 - 1e-16

    color[floor(newcorr * length(color)) + 1] # new color returned
  }

  col.fill <- assign.color()

  isFALSE <- function(x) identical(x, FALSE)
  isTRUE <- function(x) identical(x, TRUE)

  if (isFALSE(tl.pos)) {
    tl.pos <- "n"
  }

  if (is.null(tl.pos) || isTRUE(tl.pos)) {
    tl.pos <- switch(type, full = "lt", lower = "ld", upper = "td")
  }

  if (isFALSE(cl.pos)) {
    cl.pos <- "n"
  }

  if (is.null(cl.pos) || isTRUE(cl.pos)) {
    cl.pos <- switch(type, full = "r", lower = "b", upper = "r")
  }

  if (isFALSE(outline)) {
    col.border <- col.fill
  } else if (isTRUE(outline)) {
    col.border <- "black"
  } else if (is.character(outline)) {
    col.border <- outline
  } else {
    stop("Unsupported value type for parameter outline")
  }

  # restore this parameter when exiting the corrplot function in any way
  oldpar <- par(mar = mar, bg = "white")
  on.exit(par(oldpar), add = TRUE)

  ## calculate label-text width approximately
  if (!add) {
    plot.new()

    # Issue #10: code from Sébastien Rochette (github user @statnmap)
    xlabwidth <- max(strwidth(newrownames, cex = tl.cex))
    ylabwidth <- max(strwidth(newcolnames, cex = tl.cex))
    laboffset <- strwidth("W", cex = tl.cex) * tl.offset

    # Issue #10
    for (i in 1:50) {
      xlim <- c(
        m1 - 0.5 - laboffset -
          xlabwidth * (grepl("l", tl.pos) | grepl("d", tl.pos)),
        m2 + 0.5 + mm * cl.ratio * (cl.pos == "r") +
          xlabwidth * abs(cos(tl.srt * pi / 180)) * grepl("d", tl.pos)
      ) + c(-0.35, 0.15) +
          c(-1,0) * grepl("l", tl.pos) # margin between text and grid

      ylim <- c(
        n1 - 0.5 - nn * cl.ratio * (cl.pos == "b"),
        n2 + 0.5 + laboffset +
          ylabwidth * abs(sin(tl.srt * pi / 180)) * grepl("t", tl.pos)
      ) +
        c(-0.15, 0) +
        c(0, -1) * (type == "upper" && tl.pos != "n") + # nasty hack
        c(0,1) * grepl("d", tl.pos) # margin between text and grid

      # note: the nasty hack above solves multiple issues (e.g. #96, #94)

      plot.window(xlim, ylim, asp = 1, xaxs = "i", yaxs = "i")

      x.tmp <- max(strwidth(newrownames, cex = tl.cex))
      y.tmp <- max(strwidth(newcolnames, cex = tl.cex))

      laboffset.tmp <- strwidth("W", cex = tl.cex) * tl.offset
      if (max(x.tmp - xlabwidth,
              y.tmp - ylabwidth,
              laboffset.tmp - laboffset) < 1e-03) {
        break
      }

      xlabwidth <- x.tmp
      ylabwidth <- y.tmp

      laboffset <- laboffset.tmp

      if (i == 50) {
        warning(c("Not been able to calculate text margin, ",
                  "please try again with a clean new empty window using ",
                  "{plot.new(); dev.off()} or reduce tl.cex"))
      }
    }

    if (.Platform$OS.type == "windows") {
      grDevices::windows.options(width = 7,
                                 height = 7 * diff(ylim) / diff(xlim))
    }

    plot.window(xlim = xlim , ylim = ylim,
                asp = win.asp, xlab = "", ylab = "", xaxs = "i", yaxs = "i")
  }

  ## for: add = TRUE
  laboffset <- strwidth("W", cex = tl.cex) * tl.offset

  ## background for the cells
  symbols(Pos, add = TRUE, inches = FALSE,
          rectangles = matrix(1, len.DAT, 2), bg = bg, fg = bg)

  ## circle
  if (method == "circle" && plotCI == "n") {
    symbols(Pos, add = TRUE,  inches = FALSE,
            circles = asp_rescale_factor * 0.9 * abs(DAT) ^ 0.5 / 2,
            fg = col.border, bg = col.fill)
  }

  ## ellipse
  if (method == "ellipse" && plotCI == "n") {
    ell.dat <- function(rho, length = 99) {
      k <- seq(0, 2 * pi, length = length)
      x <- cos(k + acos(rho) / 2) / 2
      y <- cos(k - acos(rho) / 2) / 2
      cbind(rbind(x,y), c(NA, NA))
    }

    ELL.dat <- lapply(DAT, ell.dat)
    ELL.dat2 <- 0.85 * matrix(unlist(ELL.dat), ncol = 2, byrow = TRUE)
    ELL.dat2 <- ELL.dat2  + Pos[rep(1:length(DAT),each = 100),]
    polygon(ELL.dat2, border = col.border, col = col.fill)
  }

  ## number
  if (is.null(number.digits)) {
    # TODO: this expression might be confusing
    number.digits <- switch(addCoefasPercent + 1, 2, 0)
  }

  stopifnot(number.digits %% 1 == 0)  # is whole number
  stopifnot(number.digits >= 0)       # is non-negative number

  if (method == "number" && plotCI == "n") {
    text(Pos[,1], Pos[,2], font = number.font, col = col.fill,
         labels = round((DAT - int) * ifelse(addCoefasPercent, 100, 1) / zoom,
                        number.digits),
         cex = number.cex)
  }

  # Issue #55: Support for multiple characters when rendering NAs
  NA_LABEL_MAX_CHARS <- 2

  # renders NA cells
  if (is.matrix(PosNA) && nrow(PosNA) > 0) {

    stopifnot(is.matrix(PosNA)) # sanity check

    if (na.label == "square") {
      symbols(PosNA, add = TRUE, inches = FALSE,
              squares = rep(1, nrow(PosNA)),
              bg = na.label.col, fg = na.label.col)
    } else if (nchar(na.label) %in% 1:NA_LABEL_MAX_CHARS) {
      symbols(PosNA, add = TRUE, inches = FALSE,
              squares = rep(1, nrow(PosNA)), fg = bg, bg = bg)
      text(PosNA[,1], PosNA[,2], font = number.font,
           col = na.label.col,
           labels = na.label, cex = number.cex, ...)
    } else {
      stop(paste("Maximum number of characters for NA label is:",
                 NA_LABEL_MAX_CHARS))
    }
  }

  ## pie
  if (method == "pie" && plotCI == "n") {

    # Issue #18: Corrplot background circle
    symbols(Pos, add = TRUE, inches = FALSE,
            circles = rep(0.5, len.DAT) * 0.85, fg = col.border)

    pie.dat <- function(theta, length = 100) {
      k <- seq(pi / 2, pi / 2 - theta, length = 0.5 * length * abs(theta) / pi)
      x <- c(0, cos(k) / 2, 0)
      y <- c(0, sin(k) / 2, 0)
      cbind(rbind(x,y), c(NA, NA)) # pie.dat returned
    }

    PIE.dat <- lapply(DAT * 2 * pi, pie.dat)
    len.pie <- unlist(lapply(PIE.dat, length)) / 2
    PIE.dat2 <- 0.85 * matrix(unlist(PIE.dat), ncol = 2, byrow = TRUE)
    PIE.dat2 <- PIE.dat2  + Pos[rep(1:length(DAT), len.pie),]
    polygon(PIE.dat2, border = "black", col = col.fill)
  }

  ## shade
  if (method == "shade" && plotCI == "n") {
    symbols(Pos, add = TRUE, inches = FALSE, squares = rep(1, len.DAT),
            bg = col.fill, fg = addgrid.col)

    shade.dat <- function(w) {
      x <- w[1]
      y <- w[2]
      rho <- w[3]
      x1 <- x - 0.5
      x2 <- x + 0.5
      y1 <- y - 0.5
      y2 <- y + 0.5
      dat <- NA

      if ((addshade == "positive" || addshade == "all") && rho > 0) {
        dat <- cbind(c(x1, x1, x), c(y, y1, y1),
                     c(x, x2, x2), c(y2, y2 ,y))
      }

      if ((addshade == "negative" || addshade == "all") && rho < 0) {
        dat <- cbind(c(x1, x1, x), c(y, y2, y2),
                     c(x, x2, x2), c(y1, y1 ,y))
      }

      return(t(dat))
    }

    pos_corr <- rbind(cbind(Pos, DAT))
    pos_corr2 <- split(pos_corr, 1:nrow(pos_corr))

    SHADE.dat <- matrix(na.omit(unlist(lapply(pos_corr2, shade.dat))),
                        byrow = TRUE, ncol = 4)

    segments(SHADE.dat[,1], SHADE.dat[,2], SHADE.dat[,3],
             SHADE.dat[,4], col = shade.col, lwd = shade.lwd)
  }

  ## square
  if (method == "square" && plotCI == "n") {
    draw_method_square(Pos, DAT, asp_rescale_factor, col.border, col.fill)
  }

  ## color
  if (method == "color" && plotCI == "n") {
    draw_method_color(Pos, col.border, col.fill)
  }

  ## add grid
  draw_grid(AllCoords, addgrid.col)

  if (plotCI != "n") {

    if (is.null(lowCI.mat) || is.null(uppCI.mat)) {
      stop("Need lowCI.mat and uppCI.mat!")
    }

    if (order != "original") {
      lowCI.mat <- lowCI.mat[ord, ord]
      uppCI.mat <- uppCI.mat[ord, ord]
    }

    pos.lowNew  <- getPos.Dat(lowCI.mat)[[1]]
    lowNew      <- getPos.Dat(lowCI.mat)[[2]]
    pos.uppNew  <- getPos.Dat(uppCI.mat)[[1]]
    uppNew      <- getPos.Dat(uppCI.mat)[[2]]

    if (!method %in% c("circle", "square")) {
       stop("Method shoud be circle or square if drawing confidence intervals.")
    }

    k1 <- (abs(uppNew) > abs(lowNew))
    bigabs <- uppNew
    bigabs[which(!k1)] <- lowNew[!k1]
    smallabs <- lowNew
    smallabs[which(!k1)] <- uppNew[!k1]
    sig <- sign(uppNew * lowNew)

    color_bigabs <- col[ceiling((bigabs + 1) * length(col) / 2)]
    color_smallabs <- col[ceiling((smallabs + 1) * length(col) / 2)]

    if (plotCI == "circle") {

      symbols(pos.uppNew[,1], pos.uppNew[,2],
        add = TRUE,  inches = FALSE,
        circles = 0.95 * abs(bigabs) ^ 0.5 / 2,
        bg = ifelse(sig > 0, col.fill, color_bigabs),
        fg = ifelse(sig > 0, col.fill, color_bigabs)
      )

      symbols(pos.lowNew[,1], pos.lowNew[,2],
        add = TRUE, inches = FALSE,
        circles = 0.95 * abs(smallabs) ^ 0.5 / 2,
        bg = ifelse(sig > 0, bg, color_smallabs),
        fg = ifelse(sig > 0, col.fill, color_smallabs))
    }

    if (plotCI == "square") {
      symbols(pos.uppNew[,1], pos.uppNew[,2],
        add = TRUE,  inches = FALSE,
        squares = abs(bigabs) ^ 0.5,
        bg = ifelse(sig > 0, col.fill, color_bigabs),
        fg = ifelse(sig > 0, col.fill, color_bigabs))

      symbols(pos.lowNew[,1], pos.lowNew[,2],
        add = TRUE, inches = FALSE,
        squares = abs(smallabs) ^ 0.5,
        bg = ifelse(sig > 0, bg, color_smallabs),
        fg = ifelse(sig > 0, col.fill, color_smallabs))
    }

    if (plotCI == "rect") {
      rect.width <- 0.25
      rect(pos.uppNew[,1] - rect.width, pos.uppNew[,2] + smallabs / 2,
           pos.uppNew[,1] + rect.width, pos.uppNew[,2] + bigabs / 2,
           col = col.fill, border = col.fill)
      segments(pos.lowNew[,1] - rect.width, pos.lowNew[,2] + DAT / 2,
               pos.lowNew[,1] + rect.width, pos.lowNew[,2] + DAT / 2,
               col = "black", lwd = 1)
      segments(pos.uppNew[,1] - rect.width, pos.uppNew[,2] + uppNew / 2,
               pos.uppNew[,1] + rect.width, pos.uppNew[,2] + uppNew / 2,
               col = "black", lwd = 1)
      segments(pos.lowNew[,1] - rect.width, pos.lowNew[,2] + lowNew / 2,
               pos.lowNew[,1] + rect.width, pos.lowNew[,2] + lowNew / 2,
               col = "black", lwd = 1)
      segments(pos.lowNew[,1] - 0.5,pos.lowNew[,2],
               pos.lowNew[,1] + 0.5, pos.lowNew[,2], col = "grey70", lty = 3)
    }
  }

  if (!is.null(p.mat) && insig != "n") {
    if (order != "original") {
      p.mat <- p.mat[ord, ord]
    }

    pos.pNew  <- getPos.Dat(p.mat)[[1]]
    pNew      <- getPos.Dat(p.mat)[[2]]

    if (insig == "label_sig") {

      # Unless another character is specified, mark sig with *
      if (!is.character(pch))
        pch <- "*"

      place_points <- function(sig.locs, point) {
        text(pos.pNew[,1][sig.locs], pos.pNew[,2][sig.locs],
             labels = point, col = pch.col, cex = pch.cex, lwd = 2)
      }

      if (length(sig.level) == 1) {
        place_points(sig.locs = which(pNew < sig.level), point = pch)

      } else {
        l <- length(sig.level)
        for (i in seq_along(sig.level)) {
          iter <- l + 1 - i
          pchTmp <- paste(rep(pch, i), collapse = "")
          if (i == length(sig.level)) {
            locs <- which(pNew < sig.level[iter])
            if (length(locs)) {
              place_points(sig.locs = locs, point = pchTmp)
            }
          } else {
            locs <- which(pNew < sig.level[iter] & pNew > sig.level[iter - 1])
            if (length(locs)) {
              place_points(sig.locs = locs, point = pchTmp)
            }
          }
        }

      }

    } else {

      ind.p <- which(pNew > sig.level)
      p_inSig <- length(ind.p) > 0

      if (insig == "pch" && p_inSig) {
        points(pos.pNew[,1][ind.p], pos.pNew[,2][ind.p],
               pch = pch, col = pch.col, cex = pch.cex, lwd = 2)
      }

      if (insig == "p-value" && p_inSig) {
        text(pos.pNew[,1][ind.p], pos.pNew[,2][ind.p],
             round(pNew[ind.p],2), col = pch.col)
      }

      if (insig == "blank" && p_inSig) {
        symbols(pos.pNew[,1][ind.p], pos.pNew[,2][ind.p], inches = FALSE,
                squares = rep(1, length(pos.pNew[,1][ind.p])),
                fg = addgrid.col, bg = bg, add = TRUE)
      }
    }
  }

  ### color legend
  if (cl.pos != "n") {
    colRange <- assign.color(dat = cl.lim2)
    ind1 <- which(col == colRange[1])
    ind2 <- which(col == colRange[2])
    colbar <- col[ind1:ind2]

    if (is.null(cl.length)) {
      cl.length <- ifelse(length(colbar) > 20, 11, length(colbar) + 1)
    }

    labels <- seq(cl.lim[1], cl.lim[2], length = cl.length)

    if (cl.pos == "r") {
      vertical <- TRUE
      xlim <- c(m2 + 0.5 + mm * 0.02, m2 + 0.5 + mm * cl.ratio)
      ylim <- c(n1 - 0.5, n2 + 0.5)
    }

    if (cl.pos == "b") {
      vertical <- FALSE
      xlim <- c(m1 - 0.5, m2 + 0.5)
      ylim <- c(n1 - 0.5 - nn * cl.ratio, n1 - 0.5 - nn * 0.02)
    }

    colorlegend(colbar = colbar, labels = round(labels, 2),
                offset = cl.offset, ratio.colbar = 0.3, cex = cl.cex,
                xlim = xlim, ylim = ylim, vertical = vertical,
                align = cl.align.text)
  }

  ## add variable names and title
  if (tl.pos != "n") {
    pos.xlabel <- cbind(m1:m2, n2 + 0.5 + laboffset)
    pos.ylabel <- cbind(m1 - 0.5, n2:n1)

    if (tl.pos == "td") {
      if (type != "upper") {
        stop("type should be \"upper\" if tl.pos is \"dt\".")
      }
      pos.ylabel <- cbind(m1:(m1 + nn) - 0.5, n2:n1)
    }

    if (tl.pos == "ld") {
      if (type != "lower") {
        stop("type should be \"lower\" if tl.pos is \"ld\".")
      }
      pos.xlabel <- cbind(m1:m2, n2:(n2 - mm) + 0.5 + laboffset)
    }

    if (tl.pos == "d") {
      pos.ylabel <- cbind(m1:(m1 + nn) - 0.5, n2:n1)
      pos.ylabel <- pos.ylabel[1:min(n, m),]

      symbols(pos.ylabel[,1] + 0.5, pos.ylabel[,2], add = TRUE,
              bg = bg, fg = addgrid.col,
              inches = FALSE, squares = rep(1, length(pos.ylabel[,1])))

      text(pos.ylabel[,1] + 0.5, pos.ylabel[,2], newcolnames[1:min(n, m)],
           col = tl.col, cex = tl.cex, ...)

    } else {
      text(pos.xlabel[,1], pos.xlabel[,2], newcolnames, srt = tl.srt,
           adj = ifelse(tl.srt == 0, c(0.5,0), c(0,0)),
           col = tl.col, cex = tl.cex, offset = tl.offset, ...)
      text(pos.ylabel[,1], pos.ylabel[,2], newrownames,
           col = tl.col, cex = tl.cex, pos = 2, offset = tl.offset, ...)
    }
  }

  title(title, ...)

  ## add numbers
  if (!is.null(addCoef.col) && method != "number") {
    text(Pos[,1], Pos[,2],  col = addCoef.col,
         labels = round((DAT - int) * ifelse(addCoefasPercent, 100, 1) / zoom,
                        number.digits),
         cex = number.cex, font = number.font)
  }

  ## add grid, in case of the grid is ate when "diag=FALSE"
  if (type == "full" && plotCI == "n" && !is.null(addgrid.col)) {
    rect(m1 - 0.5, n1 - 0.5, m2 + 0.5, n2 + 0.5, border = addgrid.col)
  }

  ##  draws rectangles, call function corrRect.hclust
  if (!is.null(addrect) && order == "hclust" && type == "full") {
    corrRect.hclust(corr, k = addrect, method = hclust.method,
                    col = rect.col, lwd = rect.lwd)
  }

  invisible(corr) # reordered correlation matrix
}

#' @note pure function
#' @noRd
draw_method_square <- function(coords, values, asp_rescale_factor, fg, bg) {
  symbols(coords, add = TRUE, inches = FALSE,
          squares = asp_rescale_factor * abs(values) ^ 0.5,
          bg = bg, fg = fg)
}

#' @note pure function
#' @noRd
draw_method_color <- function(coords, fg, bg) {
  symbols(coords, squares = rep(1, nrow(coords)), fg = fg, bg = bg,
          add = TRUE, inches = FALSE)
}

#' @note pure function
#' @noRd
draw_grid <- function(coords, fg) {
  symbols(coords, add = TRUE, inches = FALSE, fg = fg, bg = NA,
          rectangles = matrix(1, nrow = nrow(coords), ncol = 2))
}
