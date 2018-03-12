#' This is an plot function for visualizing a correlation matrix by using html5
#'
#' The function generates 'corrplot' html files viewed by Chrome which help you
#' using in a interative and convenient way.
#'
#'@param corr The correlation matrix to visualize.
#'
#'@param color Vector, 3 color hexadecimal code the corresponding correlation value 1,0,-1.
#'When it is NULL, color will be \code{color = c("#053061", "#FFFFFF", "#67001F")}
#'
#'@param size Vector, describe the width and the height of the visualiztion area.
#'@param widthRange Vector, decscribe the min and the max value of the area range.
#'
#' @import htmlwidgets
#' @export
#' @examples
#' data(mtcars)
#' M <- cor(mtcars)
#'
#' corrplot::corrplotVis(M)
corrplotVis <- function(corr, color = NULL, size=c(950,900),
		widthRange = c(100,1000)
) {
	# settings = NULL,
	 #corr = cor(mtcars)

  if(ncol(corr)<=1){
    stop("the rank of Matrix should more than 1")
  }

	 if(!is.matrix(corr)&!is.data.frame(corr))
		stop("Need a matrix or data frame!")
  if(widthRange[1]>widthRange[2])
    stop("first num of widthRange should smaller than second one")

	orderList = .orderListGenerate(corr, orderList = c("original", "AOE", "FPC", "hclust", "name"))#一个自定函数
	#use diff algorithm to cahnge orders，
	if(is.null(color)){
		color = c("#053061", "#FFFFFF", "#67001F")
	}else{
		color = colorRampPalette(color)(3)#choose three colors: max mid min
	}
	corr <- as.matrix(corr)
	colNames = colnames(corr)
	colnames(corr) = NULL
	rownames(corr) = NULL
##
	if (ncol(corr) == 1){
		outList <- list(
				matrixLength = ncol(corr),
				color = color,
				colNames = as.matrix(colNames),
				matrixData = corr,
				#method = method,
				#type = type,
				#order = order
				orderList = orderList
		)
		#return (outList)
	}else{
		outList <- list(
				matrixLength = ncol(corr),
				color = color,
				colNames = colNames,
				matrixData = corr,
				#method = method,
				#type = type,
				#order = order
				orderList = orderList
		)
		#return (outList)

	}
##
##CI,sigLevel
CI <- list()

if(ncol(corr) == 1){
  CI$p <- 1
}else{
  CI$p <- cor.mtest(corr)$p
}

###hclust seq
rectOrderNum <- list()
tree <- hclust(as.dist(1-corr),method = "complete")
##
if(ncol(corr)<4){
  numrect = 1;
}else{
numrect = c(2:4)
hc <- cutree(tree, k = numrect)
hcOrder <- hc[order(orderList$hclust),]
}

##
rectNum <- function(hcOrder){

returnNum <- NULL
for(i in unique(hcOrder)){
returnNum  <-c(returnNum ,max(which(hcOrder==i)))
}
return(returnNum)
}


rectOrderNum <- apply(hcOrder,2,rectNum)

names(rectOrderNum)<- c("a","b","c")
###
	x <- list(
		data = outList,
		size = size,
		CI = CI,
		rectOrderNum = rectOrderNum,
		range = widthRange
	)
	#print(x)

	chart = htmlwidgets::createWidget(
		'corrplot', x,
		package = 'bfdVis', width = size[1], height = size[2],
		preRenderHook = function(instance) {
			instance
		}
	)
	# chart = .addClass(chart, "ePoints")
	chart

}

#' shiny output binding
#'
#' @export
corrplotOutput <- function(outputId, width = "100%", height = "400px") {
  htmlwidgets::shinyWidgetOutput(outputId, "corrplot", width, height, package = "bfdVis")
}

#' shiny output binding
#'
#' @export
renderCorrplot <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, corrplotOutput, env, quoted = TRUE)
}


#######
###
.orderListGenerate <- function (corr, orderList) ##使用base包中的rank函数来排序,返回一个list，包含各种算法计算出来的顺序。
{
	if (length(corr) == 1){
		returnList = list(original = matrix(1),
			AOE = matrix(1),
			FPC = matrix(1),
			name = matrix(1),
			hclust = matrix(1))
		return(returnList)
	}
    hclust.method <- "complete"

	returnList <- as.list(seq_along(orderList))# ??seq_along
	names(returnList) <- orderList
	### Original Order
	returnList$original <- seq_along(colnames(corr))


	#### AOE Order
	x.eigen <- eigen(corr)$vectors[, 1:2]
    e1 <- x.eigen[, 1]
    e2 <- x.eigen[, 2]
    alpha <- ifelse(e1 > 0, atan(e2/e1), atan(e2/e1) + pi)
    ord <- rank(alpha)
	returnList$AOE <- ord

	### FPC Oder
    x.eigen <- eigen(corr)$vectors[, 1:2]
    e1 <- x.eigen[, 1]
    ord <- rank(e1)
	returnList$FPC <- ord

	### name Order
    returnList$name <- as.vector(rank(rownames(corr)))

	### hclust Order
    returnList$hclust <- order(order.dendrogram(as.dendrogram(hclust(as.dist(1 -
            corr), method = hclust.method))))

    return(returnList)
}


#' shiny server launch shell function
#'
#' @export
runServer = function(displayMatrix){
	#
	save(displayMatrix, file=file.path(system.file("shinyApps",  package="bfdVis"), "displayMatrix.RData"))
	shiny::runApp(system.file("shinyApps", package="bfdVis"))
}










