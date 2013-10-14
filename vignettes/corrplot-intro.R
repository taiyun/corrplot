
## @knitr setup, include=FALSE
library(knitr)
opts_chunk$set(out.extra='style="display:block; margin: auto"', fig.align="center")


## @knitr methods
library(corrplot)
M <- cor(mtcars)
corrplot(M, method="circle")
corrplot(M, method="square")
corrplot(M, method="ellipse")
corrplot(M, method="number")
corrplot(M, method="shade")
corrplot(M, method="color")
corrplot(M, method="pie")


## @knitr layout
corrplot(M, type="upper")
corrplot(M, type="lower")


## @knitr mixed
corrplot.mixed(M)
corrplot.mixed(M, lower="ellipse", upper="circle")
corrplot.mixed(M, lower="square", upper="circle")



## @knitr order
corrplot(M, order ="AOE")
corrplot(M, order ="hclust")
corrplot(M, order ="FPC")
corrplot(M, order ="alphabet")


## @knitr rectangles
corrplot(M, order="hclust", addrect=2)
corrplot(M, order="hclust", addrect=3)


## @knitr color
col1 <- colorRampPalette(c("#7F0000","red","#FF7F00","yellow","white", 
  		"cyan", "#007FFF", "blue","#00007F"))
col2 <- colorRampPalette(c("#67001F", "#B2182B", "#D6604D", "#F4A582", "#FDDBC7",
			"#FFFFFF", "#D1E5F0", "#92C5DE", "#4393C3", "#2166AC", "#053061"))	
col3 <- colorRampPalette(c("red", "white", "blue"))	
col4 <- colorRampPalette(c("#7F0000","red","#FF7F00","yellow","#7FFF7F", 
			"cyan", "#007FFF", "blue","#00007F"))	
wb <- c("white","black")
## using these color spectrums
corrplot(M, order="hclust", addrect=2, col=col1(100))
corrplot(M, order="hclust", addrect=2, col=col2(50))
corrplot(M, order="hclust", addrect=2, col=col3(20))
corrplot(M, order="hclust", addrect=2, col=col4(10))
corrplot(M, order="hclust", addrect=2, col=wb, bg="gold2")


## @knitr color-label
## remove color legend and text legend 
corrplot(M, order="AOE", cl.pos="n", tl.pos="n")  
## bottom  color legend, diagonal text legend, rotate text label
corrplot(M, order="AOE", cl.pos="b", tl.pos="d", tl.srt=60)
## a wider color legend with numbers right aligned
corrplot(M, order="AOE", cl.ratio=0.2, cl.align="r")


## @knitr non-corr
corrplot(abs(M),order="AOE", col=col3(200), cl.lim=c(0,1))
## visualize a  matrix in [-100, 100]
ran <- round(matrix(runif(225, -100,100), 15))
corrplot(ran, is.corr=FALSE, method="square")
## a beautiful color legend 
corrplot(ran, is.corr=FALSE, method="ellipse", cl.lim=c(-100, 100))


## @knitr test
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
## leave blank on no significant coefficient
corrplot(M, p.mat = res1[[1]], insig = "blank")
## add p-values on no significant coefficient
corrplot(M, p.mat = res1[[1]], insig = "p-value")
## add all p-values
corrplot(M, p.mat = res1[[1]], insig = "p-value", sig.level=-1)
## add cross on no significant coefficient 
corrplot(M, p.mat = res1[[1]], order="hclust", insig = "pch", addrect=3)


## @knitr ci
## plot confidence interval(0.95, 0.95, 0.99), "rect" method
corrplot(M, low=res1[[2]], upp=res1[[3]], order="hclust",
  rect.col="navy", plotC="rect",cl.pos="n")
corrplot(M, p.mat = res1[[1]], low=res1[[2]], upp=res1[[3]], order="hclust",
	pch.col="red", sig.level = 0.01, addrect=3, rect.col="navy",
	plotC="rect",cl.pos="n")


## @knitr ani, eval=FALSE
## for(i in seq(0.1, 0, -0.005)){
##   tmp <- cor.mtest(mtcars,1-i)
## 	corrplot(M, p.mat = tmp[[1]], low=tmp[[2]], upp=tmp[[3]], order="hclust",
## 		pch.col="red", sig.level = i, plotC="rect", cl.pos="n",
## 		mar=c(0,0,1,0),
## 		title=substitute(alpha == x,list(x=format(i,digits=3,nsmall=3))))
## }


