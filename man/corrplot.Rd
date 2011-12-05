\name{corrplot}
\Rdversion{1.1}
\alias{corrplot}

\title{
A visualization of a correlation matrix.
}
\description{
A graphical display of a correlation matrix, confidence interval. 
The details of graph are paid great attention to.

It can also visualize a general matrix if using parameter \code{zoom} to scale matrix.
}

\usage{
corrplot(corr,
		method = c("circle", "square", "ellipse", "number", "shade", "color", "pie"),
		type = c("full", "lower", "upper"), add = FALSE,
		col = NULL, bg = "white", title = "",  zoom = 1,
		diag = TRUE, outline = FALSE, mar = c(0,0,0,0),
		addgrid.col = "gray", addCoef.col= NULL, addCoefasPercent = TRUE, 

		order = c("original", "AOE", "FPC", "hclust", "alphabet"),
		hclust.method = c("complete", "ward", "single", "average",
							"mcquitty", "median", "centroid"),
		addrect = NULL, rect.col = "black", rect.lwd = 2,

		addtextlabel = NULL, tl.cex = 1,
		tl.col = "red", tl.offset = 0.4, tl.srt = 90,

		addcolorlabel = c("right", "bottom","no"), cl.lim = c(-1, 1),
		cl.length = NULL, cl.cex = 0.8, cl.ratio = 0.15, 
		cl.align.text = "c",cl.offset = 0.5,

		addshade = c("negative", "positive", "all"),
		shade.lwd = 1, shade.col = "white",

		p.mat = NULL, sig.level = 0.05,
		insig = c("pch","blank", "no"),
		pch = 4, pch.col = "black", pch.cex = 3,
		
		plotCI = c("no","square", "circle", "rect"),
		lowCI.mat = NULL, uppCI.mat = NULL, ...)
}

\arguments{
  \item{corr}{
The correlation matrix to visualize, must be square if \code{order} is not \code{"original"}.
For general matrix, please use \code{zoom} to convert.
}
  \item{method}{
Character, the visualization method of correlation matrix to be used. Currently, it supports seven methods, named \code{"circle"} (default), \code{"square"}, \code{"ellipse"}, \code{"number"}, \code{"pie"}, \code{"shade"} and \code{"color"}. See examples for details.

The areas of circles or squares show the absolute value of corresponding correlation 
coefficients. Method \code{"pie"} and \code{"shade"} came from Michael Friendly's 
job (with some adjustment about the shade added on), and \code{"ellipse"} came from 
D.J. Murdoch and E.D. Chow's job, see in section References.
}
  \item{type}{
Character, \code{"full"} (default), \code{"upper"} or \code{"lower"}, display full matrix,
lower triangular or upper triangular matrix.
}

  \item{add}{
Logical, if \code{TRUE}, the graph is added to an existing plot, otherwise a new plot is created.
}

  \item{col}{
Vector, the color of glyphs.
It is distributed uniformly in [-1, 1] (after zoom). 

If NULL, \code{col} will be \code{colorRampPalette(col2)(200)}, see example about col2.
}
 

  \item{bg}{
The background color.
}

  \item{title}{
Character, title of the graph.
}

  \item{zoom}{
Numeric, zoom for matrix \code{corr}: \code{corr <- corr * zoom}.

If the input matrix is not a correlation matrix in [-1, 1], 
then we can specify \code{zoom} to make the input matrix in [-1,1] and use corrplot() to
visualize it. 

Warning: you should make sure the visualization you take after data zoom is meaningful.

}


  \item{diag}{
Logical, whether display the correlation coefficients on the principal diagonal.
}

  \item{outline}{
Logical, whether plot outline of circles, square and ellipse.
}

  \item{mar}{
See \code{\link{par}}.
}


  \item{addgrid.col}{
The color of grid, if \code{NULL}, don't add grid.
}


  \item{addCoef.col}{
Color of coefficients added on the graph. If \code{NULL} (default), add no coefficients. 
}

  \item{addCoefasPercent}{
Logic, whether translate coefficients into percentage style for spacesaving. 
}


  \item{order}{
Character, the ordering method of the correlation matrix. 
	\itemize{
		\item \code{"original"} for original order (default).
		\item \code{"AOE"} for the angular order of the eigenvectors. 
		\item \code{"FPC"} for the first principal component order.
		\item \code{"hclust"} for the hierarchical clustering order.
		\item \code{"alphabet"} for alphabetical order.
	}

See function \code{\link{corrMatOrder}} for details.
}

  \item{hclust.method}{
Character, the agglomeration method to be used when \code{order} is \code{\link{hclust}}. This should be one of \code{"ward"}, \code{"single"}, \code{"complete"}, \code{"average"}, \code{"mcquitty"}, \code{"median"} or \code{"centroid"}.
}

  \item{addrect}{
Integer, the number of rectangles draws on the graph according to the hierarchical cluster,
only valid when \code{order} is \code{hclust}. If \code{NULL} (default), then
add no rectangles.
}

  \item{rect.col}{
Color for rectangle border(s), only valid when \code{addrect} is equal or greater than 1.
}

  \item{rect.lwd}{
Numeric, line width for borders for rectangle border(s), only valid
when \code{addrect} is equal or greater than 1.
}



  \item{addtextlabel}{
Character, \code{"lt"}, \code{"ld"}, \code{"td"}, \code{"d"} or \code{"no"}, giving position of 
text labels; \code{"lt"} means left and top, \code{"ld"} means left and diagonal, 
\code{"td"} means top and diagonal(near), \code{"d"} means diagonal, \code{"no"} means
don't add textlabel.
}

  \item{tl.cex}{
Numeric, for the size of text label (variable names).
}

  \item{tl.col}{
The color of text label.
}

  \item{tl.offset}{
Numeric, for text label, see \code{\link{text}}.
}

  \item{tl.srt}{
Numeric, for text label string rotation in degrees, see \code{\link{text}}.
}

  \item{addcolorlabel}{
Character, \code{"right"} (default), \code{"bottom"} or \code{"no"}, where to draw colorlabel. 
If \code{"no"}, don't draw colorlabel.
}

  \item{cl.lim}{
The  limits \code{(x1, x2)} (after zoom) in the colorlabel.
}

\item{cl.length}{
Integer, the number of number-text in colorlabel, passed to \code{\link{colorlegend}}.
If \code{NULL}, \code{cl.length} is \code{length(col) + 1} when \code{length(col) <=20};
\code{cl.length} is 11 when \code{length(col) > 20}
}

\item{cl.cex}{
Numeric, cex of number-label in colorlabel,  passed to \code{\link{colorlegend}}.
}

\item{cl.ratio}{
Numeric, to justify the width of colorlabel, 0.1~0.2 is suggested.
}

\item{cl.align.text}{
Character, \code{"l"}, \code{"c"} (default) or \code{"r"}, for number-label in colorlabel, 
\code{"l"} means left, \code{"c"} means center, and \code{"r"} means right.
}

\item{cl.offset}{
Numeric, for number-label in colorlabel, see \code{\link{text}}.
}

  \item{addshade}{
Character for shade style, \code{"negative"}, \code{"positive"} or \code{"all"}, 
only valid when \code{method} is \code{"shade"}. If \code{"all"}, all
correlation coefficients' glyph will be shaded; if \code{"positive"}, 
only the positive will be shaded; if \code{"negative"}, only the negative 
will be shaded. Note: the angle of shade line is different, 
45 degrees for positive and 135 degrees for negative.
}

  \item{shade.lwd}{
Numeric, the line width of shade.
}

  \item{shade.col}{
The color of shade line.
}

  \item{p.mat}{
Matrix of p-value, if \code{NULL}, arguments \code{sig.level}, \code{insig}, 
\code{pch}, \code{pch.col}, \code{pch.cex} is invalid.
}

  \item{sig.level}{
Significant level,  if the p-value in \code{p-mat} is bigger than \code{sig.level}, then
the corresponding correlation coefficient is regarded as insignificant.
}

  \item{insig}{
Character, specialized insignificant correlation coefficients, 
\code{"pch"} (default), \code{"blank"} or \code{"no"}. 
If \code{"blank"}, wipe away the corresponding glyphs; 
if \code{"pch"}, add characters (see \code{pch} for details) on corresponding glyphs; 
if \code{"no"}, don't take any measures.
}

  \item{pch}{
Add character on the glyphs of insignificant correlation coefficients(only valid when 
\code{insig} is \code{"pch"}). See \code{\link{par}}.
}

  \item{pch.col}{
The color of pch (only valid when \code{insig} is \code{"pch"}).
}

  \item{pch.cex}{
The cex of pch (only valid when \code{insig} is \code{"pch"}).
}


  \item{plotCI}{
Character, method to plot confidence interval, if \code{"no"}, don't plot confidence interval. 
If \code{"rect"}, plot rectangles whose upper side means upper bound, lower side means 
lower bound, and correlation coefficients are also added on the rectangles. If \code{"circle"}, first plot a circle of the bigger absolute bound, then plot the smaller. Warning: if the 
two bounds are the same sign, then the smaller circle will be wiped away, thus formed a ring. Method \code{"square"} is similar to \code{"circle"}. 
}

  \item{lowCI.mat}{
Matrix of the lower bound of confidence interval.
}

  \item{uppCI.mat}{
Matrix of the upper bound of confidence interval.
}


  \item{\dots}{
Additional arguments passing to function \code{text} for drawing text lable.
}

}

\value{
(Invisibly) returns a single permutation vector.
}

\details{
\code{corrplot} function offers flexible ways to visualize correlation matrix, 
lower and upper bound of confidence interval matrix. 
}


\references{
Michael Friendly (2002).
\emph{Corrgrams: Exploratory displays for correlation matrices}.
The American Statistician, 56, 316--324.


D.J. Murdoch, E.D. Chow (1996).
\emph{A graphical display of large correlation matrices}.
The American Statistician, 50, 178--180.
}

\author{
 Taiyun Wei
}

\note{
	\code{Cairo} and \code{cairoDevice} package is strongly recommended to produce
	high-quality PNG, JPEG, TIFF bitmap files, especially for that \code{method}
	is \code{circle}, \code{ellipse} .
}

\seealso{
The \code{plotcorr} function in the \code{ellipse} package and \code{corrgram} function in the \code{corrgram} package has some similarities.

Package \code{seriation} offered more methods to reorder matrices, such as 
ARSA, BBURCG, BBWRCG, MDS, TSP, Chen and so forth.
}

\examples{


data(mtcars)
M <- cor(mtcars)
##  different color series
col1 <- colorRampPalette(c("#7F0000","red","#FF7F00","yellow","white", 
			"cyan", "#007FFF", "blue","#00007F"))
col2 <- colorRampPalette(c("#67001F", "#B2182B", "#D6604D", "#F4A582", "#FDDBC7",
			"#FFFFFF", "#D1E5F0", "#92C5DE", "#4393C3", "#2166AC", "#053061"))	
col3 <- colorRampPalette(c("red", "white", "blue"))	
col4 <- colorRampPalette(c("#7F0000","red","#FF7F00","yellow","#7FFF7F", 
			"cyan", "#007FFF", "blue","#00007F"))	
wb <- c("white","black")


par(ask = TRUE)


## different color scale and methods to display corr-matrix
corrplot(M, method="number", col="black", addcolorlabel="no")
corrplot(M, method="number")
corrplot(M)
corrplot(M, order ="AOE")
corrplot(M, order ="AOE", addCoef.col="grey")

corrplot(M, order="AOE", col=col1(20), cl.length=21,addCoef.col="grey")
corrplot(M, order="AOE", col=col1(10),addCoef.col="grey")

corrplot(M, order="AOE", col=col2(200))
corrplot(M, order="AOE", col=col2(200),addCoef.col="grey")
corrplot(M, order="AOE", col=col2(20), cl.length=21,addCoef.col="grey")
corrplot(M, order="AOE", col=col2(10),addCoef.col="grey")

corrplot(M, order="AOE", col=col3(100))
corrplot(M, order="AOE", col=col3(10))


corrplot(M, method="color", col=col1(20), cl.length=21,order = "AOE", addCoef.col="grey")
corrplot(M, method="square", col=col2(200),order = "AOE")
corrplot(M, method="ellipse", col=col1(200),order = "AOE")
corrplot(M, method="shade", col=col3(20),order = "AOE")
corrplot(M, method="pie", order = "AOE")

## col=wb
corrplot(M, col = wb, order="AOE", outline=TRUE, addcolorlabel="no")
## like Chinese wiqi, suit for either on screen or white-black print.
corrplot(M, col = wb, bg="gold2",  order="AOE", addcolorlabel="no")


## mixed methods: It's more efficient if using function "corrplot.mixed"
## circle + ellipse
corrplot(M,order="AOE",type="upper",addtextlabel="d")
corrplot(M,add=TRUE, type="lower", method="ell",order="AOE",
	diag=FALSE,addtextlabel="no", addcolorlabel="no")
	
## circle + square
corrplot(M,order="AOE",type="upper",addtextlabel="d")
corrplot(M,add=TRUE, type="lower", method="square",order="AOE",
	diag=FALSE,addtextlabel="no", addcolorlabel="no")

## circle + colorful number
corrplot(M,order="AOE",type="upper",addtextlabel="d")
corrplot(M,add=TRUE, type="lower", method="number",order="AOE",
	diag=FALSE,addtextlabel="no", addcolorlabel="no")

## circle + black number
corrplot(M,order="AOE",type="upper",addtextlabel="tp")
corrplot(M,add=TRUE, type="lower", method="number",order="AOE", col="black",
	diag=FALSE,addtextlabel="no", addcolorlabel="no")

	
## order is hclust and draw rectangles
corrplot(M, order="hclust")
corrplot(M, order="hclust", addrect = 2)
corrplot(M, order="hclust", addrect = 3, rect.col = "red")
corrplot(M, order="hclust", addrect = 4, rect.col = "blue")
corrplot(M, order="hclust", hclust.method="ward", addrect = 4)



## visualize a  matrix in [0, 1]
corrplot(abs(M),order="AOE", cl.lim=c(0,1))
corrplot(abs(M),order="AOE", col=col1(20), cl.lim=c(0,1))
corrplot(abs(M),order="AOE", col=col3(200), cl.lim=c(0,1))

## visualize a  matrix in [0, 6]
corrplot(6*abs(M),order="AOE", zoom=1/6, col=col3(200), cl.lim=c(0,1))

## visualize a  matrix in [-6, 6]
corrplot(6*M, order="AOE", zoom=1/6,col=col3(200))
corrplot(round(6*M,1), order="AOE", zoom=1/6,col=col3(200), 
		addCoef.col="grey", addCoefasPercent=FALSE)

## text-labels and plot type
corrplot(M, order="AOE", tl.srt=45)
corrplot(M, order="AOE", tl.srt=60)
corrplot(M, order="AOE", addtextlabel="d",addcolorlabel="no")
corrplot(M, order="AOE", diag=FALSE, addtextlabel="d")
corrplot(M, order="AOE", type="upper")
corrplot(M, order="AOE", type="upper", diag=FALSE)
corrplot(M, order="AOE", type="lower", addcolorlabel="b")
corrplot(M, order="AOE", type="lower", addcolorlabel="b", diag=FALSE)



#### color-legend
corrplot(M, order="AOE", cl.ratio=0.2, cl.align="l")
corrplot(M, order="AOE", cl.ratio=0.2, cl.align="c")
corrplot(M, order="AOE", cl.ratio=0.2, cl.align="r")
corrplot(M, order="AOE", addcolorlabel="bottom")
corrplot(M, order="AOE", addcolorlabel="bottom", addtextlabel="d")
corrplot(M, order="AOE", addcolorlabel="no")



##the input matrix is not square
corrplot(M[1:8,])
corrplot(M[,1:8])



cor.mtest <- function(mat, conf.level = 0.95){
	mat <- as.matrix(mat)
	n <- ncol(mat)
	p.mat <- lowCI.mat <- uppCI.mat <- matrix(NA, n, n)
	diag(p.mat) <- 0
	diag(lowCI.mat) <- diag(uppCI.mat) <- 1
	for(i in 1:(n-1)){
		for(j in (i+1):n){
			tmp <- cor.test(mat[,i], mat[,j], conf.level = conf.level)
			p.mat[i,j] <- p.mat[j,i] <- tmp$p.value
			lowCI.mat[i,j] <- lowCI.mat[j,i] <- tmp$conf.int[1]
			uppCI.mat[i,j] <- uppCI.mat[j,i] <- tmp$conf.int[2]
		}
	}
	return(list(p.mat, lowCI.mat, uppCI.mat))
}

res1 <- cor.mtest(mtcars,0.95)
res2 <- cor.mtest(mtcars,0.99)


## specialized the insignificant value according to the significant level
corrplot(M, p.mat = res1[[1]], sig.level=0.2)
corrplot(M, p.mat = res1[[1]], sig.level=0.05)
corrplot(M, p.mat = res1[[1]], sig.level=0.01)
corrplot(M, p.mat = res1[[1]], insig = "blank")
corrplot(M, p.mat = res1[[1]], order="hclust", insig = "blank", addrect=3)
corrplot(M, p.mat = res1[[1]], order="hclust", insig = "pch", addrect=3)



## plot confidence interval(0.95), "square" method	
corrplot(M,low=res1[[2]], upp=res1[[3]],
	plotC="circle", addg="grey20",addc="no")
corrplot(M, p.mat = res1[[1]],low=res1[[2]], upp=res1[[3]],
	plotC="circle", addg="grey20",addc="no")
corrplot(M, low=res1[[2]], upp=res1[[3]], 
	col=c("white","black"),bg="gold2",order="AOE",
	plotCI="circle",addc="no",pch.col="red")
corrplot(M, p.mat = res1[[1]], low=res1[[2]], upp=res1[[3]], 
	col=c("white","black"),bg="gold2",order="AOE",
	plotCI="circle",addc="no",pch.col="red")
	
## plot confidence interval(0.95), "square" method	
corrplot(M, low=res1[[2]], upp=res1[[3]],
	col=c("white","black"),bg="gold2", order="AOE",
	plotCI="square",addg=NULL,addc="no")
corrplot(M, p.mat = res1[[1]],low=res1[[2]], upp=res1[[3]],
	col=c("white","black"),bg="gold2",order="AOE",pch.col="red", 
	plotC="square", addg=NULL,addc="no")
	
## plot confidence interval(0.95, 0.95, 0.99), "rect" method
corrplot(M, low=res1[[2]], upp=res1[[3]], order="hclust",
	rect.col="navy", plotC="rect",addc="no")
corrplot(M, p.mat = res1[[1]], low=res1[[2]], upp=res1[[3]], order="hclust",
	pch.col="red", sig.level = 0.05, addrect=3, rect.col="navy",
	plotC="rect",addc="no")
corrplot(M, p.mat = res2[[1]], low=res2[[2]], upp=res2[[3]], order="hclust",
	pch.col="red", sig.level = 0.01, addrect=3, rect.col="navy",
	plotC="rect",addc="no")


## an animation of changing confidence interval in different significance level
par(ask=FALSE)
for(i in seq(0.1, 0.001, -0.001)){
	tmp <- cor.mtest(mtcars,1-i)
	corrplot(M, p.mat = tmp[[1]], low=tmp[[2]], upp=tmp[[3]], order="hclust",
		pch.col="red", sig.level = i, plotC="rect", addc="no",
		mar=c(0,0,1,0), 
		title=substitute(alpha == x,list(x=format(i,digits=3,nsmall=3))))
	Sys.sleep(0.01)
}

}

\keyword{hplot}% __ONLY ONE__ keyword per line
