#' Visualize Correlation Matrix
#' @author Taiyun Wei
#' @email weitaiyun@gmail.com
#  last modified by Taiyun Wei 2011-12-04
corrplot <- function(corr,
		method = c("circle", "square", "ellipse", "number", "shade", "color", "pie"),
		type = c("full", "lower", "upper"), add = FALSE, 
		col = NULL, bg = "white", title = "", zoom = 1,
		diag = TRUE, outline = FALSE, mar = c(0,0,0,0),
		addgrid.col = "gray", addCoef.col = NULL, addCoefasPercent = TRUE, 

		order = c("original", "AOE", "FPC", "hclust", "alphabet"),
		hclust.method = c("complete", "ward", "single", "average",
			"mcquitty", "median", "centroid"),
		addrect = NULL, rect.col="black", rect.lwd = 2,

		addtextlabel = NULL, tl.cex = 1,
		tl.col = "red", tl.offset = 0.4, tl.srt = 90,

		addcolorlabel = c("right", "bottom","no"), cl.lim = c(-1, 1),
		cl.length = NULL, cl.cex = 0.8, cl.ratio = 0.15, 
		cl.align.text = "c", cl.offset=0.5,

		addshade = c("negative", "positive", "all"),
		shade.lwd = 1, shade.col = "white",

		p.mat = NULL, sig.level = 0.05,
		insig = c("pch","blank", "no"),
		pch = 4, pch.col = "black", pch.cex = 3,
		
		plotCI = c("no","square", "circle", "rect"),
		lowCI.mat = NULL, uppCI.mat = NULL, ...)
{
	
	method <- match.arg(method)
	type <- match.arg(type)
	order <- match.arg(order)
	hclust.method <- match.arg(hclust.method)
	addcolorlabel <- match.arg(addcolorlabel)
	plotCI <- match.arg(plotCI)
	insig <- match.arg(insig)
	
	if(!is.matrix(corr) )
		stop("Need a matrix!")
	
	corr <- corr * zoom
	if(min(corr) < -1 - .Machine$double.eps|| max(corr) > 1 + .Machine$double.eps){
		stop("The matrix is not in [-1, 1]!")
	} 
	
	if(is.null(col)){	
		col <- colorRampPalette(c("#67001F", "#B2182B", "#D6604D", "#F4A582", "#FDDBC7",
			"#FFFFFF", "#D1E5F0", "#92C5DE", "#4393C3", "#2166AC", "#053061"))(200)
	}		
	
	n <- nrow(corr)
	m <- ncol(corr)
	min.nm <- min(n,m)
	ord <- NA
	if(!order=="original"){
		ord <- corrMatOrder(corr, order=order, hclust.method=hclust.method)
		corr <- corr[ord,ord]
	}
	## set up variable names
	if (is.null(rownames(corr))) rownames(corr) <- 1:n
	if (is.null(colnames(corr))) colnames(corr) <- 1:m



	getPos.Dat <- function(mat){
		x <- matrix(1:n*m, n, m)
		tmp <- mat
		if(type=="upper")  tmp[row(x)>col(x)] <- Inf
		if(type=="lower")  tmp[row(x)<col(x)] <- Inf
		if(type=="full")   tmp <- tmp
		if(!diag)          diag(tmp) <- Inf

		Dat <- tmp[is.finite(tmp)]
		ind  <- which(is.finite(tmp),arr.ind = TRUE)
		Pos <- ind
		Pos[,1] <-  ind[,2]
		Pos[,2] <- -ind[,1] + 1 + n
		return(list(Pos, Dat))
	}

	Pos  <- getPos.Dat(corr)[[1]]
	n2 <- max(Pos[,2]); n1 <- min(Pos[,2])
	nn <- n2 - n1
	newrownames <- as.character(rownames(corr)[(n+1-n2):(n+1-n1)])
	m2 <- max(Pos[,1]); m1 <- min(Pos[,1])
	mm <- m2 - m1
	newcolnames <- as.character(colnames(corr)[m1:m2])
	DAT <- getPos.Dat(corr)[[2]]
	len.DAT <- length(DAT)

	## assign colors
	assign.color <- function(DAT){
		newcorr <- (DAT + 1)/2
		newcorr[newcorr==1] <- 1 - 1e-10
		col.fill <- col[floor(newcorr*length(col))+1]
	}
	col.fill <- assign.color(DAT)
	
	
	if(is.null(addtextlabel)){
		if(type=="full") addtextlabel <- "lt"
		if(type=="lower") addtextlabel <- "ld"
		if(type=="upper") addtextlabel <- "td"
	}	
	
	if(outline)
		col.border <- "black"
	if(!outline)
		col.border <- col.fill

	## calculate label-text width approximately
	if(!add){
		par(mar = mar, bg = "white")
		plot.new()
		xlabwidth <- ylabwidth <- 0
	
		for(i in 1:50){
			xlim <- c(m1 - 0.5 - xlabwidth, m2 + 0.5 + mm*cl.ratio*(addcolorlabel=="right"))
			ylim <- c(n1 - 0.5 - nn*cl.ratio*(addcolorlabel=="bottom"), n2 + 0.5 + ylabwidth)
			plot.window(xlim + c(-0.2,0.2), ylim + c(-0.2,0.2), 
				asp = 1, xaxs = "i", yaxs = "i")
			x.tmp <- max(strwidth(newrownames, cex = tl.cex))
			y.tmp <- max(strwidth(newcolnames, cex = tl.cex))
			if(min(x.tmp-xlabwidth, y.tmp-ylabwidth) < 0.0001) break;
			xlabwidth <- x.tmp
			ylabwidth <- y.tmp
		}

		if(addtextlabel=="no"|addtextlabel=="d") xlabwidth <- ylabwidth <- 0
		if(addtextlabel=="td")	ylabwidth <- 0
		if(addtextlabel=="ld")	xlabwidth <- 0
	
		laboffset <- strwidth("W", cex = tl.cex) * tl.offset
		xlim <- c(m1 - 0.5 - xlabwidth - laboffset, 
			m2 + 0.5 + mm*cl.ratio*(addcolorlabel=="right")) + c(-0.35,0.15)
		ylim <- c(n1 - 0.5 - nn*cl.ratio*(addcolorlabel=="bottom"), 
			n2 + 0.5 + ylabwidth*abs(sin(tl.srt*pi/180)) + laboffset) + c(-0.15, 0.35)

		if(.Platform$OS.type == "windows"){ 
			windows.options(width=7, height=7*diff(ylim)/diff(xlim))
		}
	
		plot.window(xlim=xlim , ylim=ylim, 
			asp = 1, xlab="", ylab="", xaxs = "i", yaxs = "i")
	}	
	
	## for: add = TRUE
	laboffset <- strwidth("W", cex = tl.cex) * tl.offset

	
	## squares
	symbols(Pos, add = TRUE, inches = FALSE,
			squares = rep(1, len.DAT), bg = bg, fg = bg)
	

	## circle
	if(method=="circle"&plotCI=="no"){
    	symbols(Pos, add = TRUE,  inches = FALSE, bg = col.fill,
			circles = 0.9*abs(DAT)^0.5/2, fg = col.border)
	}

	## ellipse
	if(method=="ellipse"&plotCI=="no"){
		ell.dat <- function(rho, length = 99){
    		k <- seq(0, 2*pi, length=length)
    		x <- cos(k + acos(rho)/2)/2
    		y <- cos(k - acos(rho)/2)/2
    		return(cbind(rbind(x,y),c(NA, NA)))
    	}
    	ELL.dat <- lapply(DAT, ell.dat)
		ELL.dat2 <- 0.85*matrix(unlist(ELL.dat),ncol=2,byrow=TRUE)
		ELL.dat2 <- ELL.dat2  + Pos[rep(1:length(DAT),each=100),]
		polygon(ELL.dat2, border=col.border, col=col.fill)
	}

	## number
	if(method=="number"&plotCI=="no"){
		text(Pos[,1], Pos[,2], font = 2, round(100 * DAT), col = col.fill)
	}

	## pie
	if(method=="pie"&plotCI=="no"){
    	symbols(Pos, add = TRUE, inches = FALSE, circles = rep(0.5, len.DAT)*0.85)
		pie.dat <- function(theta, length = 100){
			k <- seq(pi/2, pi/2 - theta, length = 0.5*length*abs(theta)/pi)
			x <- c(0, cos(k)/2, 0)
			y <- c(0, sin(k)/2, 0)
			return(cbind(rbind(x,y),c(NA, NA)))
    	}
    	PIE.dat <- lapply(DAT*2*pi, pie.dat)
    	len.pie <- unlist(lapply(PIE.dat, length))/2
		PIE.dat2 <- 0.85*matrix(unlist(PIE.dat),ncol=2,byrow=TRUE)
		PIE.dat2 <- PIE.dat2  + Pos[rep(1:length(DAT),len.pie),]
    	polygon(PIE.dat2, border = "black", col = col.fill)
	}

	## shade
	if(method=="shade"&plotCI=="no"){
    	addshade <- match.arg(addshade)
    	symbols(Pos, add = TRUE, inches = FALSE, squares = rep(1, len.DAT),
				bg = col.fill, fg = addgrid.col)
        shade.dat <- function(w){
			x <- w[1];  y <- w[2];  rho <- w[3]
			x1 <- x - 0.5
			x2 <- x + 0.5
			y1 <- y - 0.5
			y2 <- y + 0.5
			dat <- NA

			if((addshade=="positive"||addshade=="all")&rho>0){
				dat <- cbind(c(x1, x1, x), c(y, y1, y1),
						c(x, x2, x2), c(y2, y2 ,y))
			}
			if((addshade=="negative"||addshade=="all")&rho<0){
				dat <- cbind(c(x1, x1, x), c(y, y2, y2),
						c(x, x2, x2), c(y1, y1 ,y))
			}
      	return(t(dat))
	}

	pos_corr <- rbind(cbind(Pos, DAT))
	pos_corr2 <- split(pos_corr, 1:nrow(pos_corr))
	SHADE.dat <- matrix(na.omit(unlist(lapply(pos_corr2, shade.dat))),byrow=TRUE, ncol=4)
	segments(SHADE.dat[,1], SHADE.dat[,2], SHADE.dat[,3], 
		SHADE.dat[,4], col = shade.col, lwd = shade.lwd)
	}

	##square
	if(method=="square"&plotCI=="no"){
		symbols(Pos, add = TRUE, inches = FALSE,
			squares = abs(DAT)^0.5, bg = col.fill, fg = col.border)
	}

	##  color
	if(method=="color"&plotCI=="no"){
    	symbols(Pos, add = TRUE, inches = FALSE,
			squares = rep(1, len.DAT), bg = col.fill, fg = col.border)
	}

	## add grid
	if(!is.null(addgrid.col)){
    	symbols(Pos, add=TRUE, inches = FALSE,  bg = NA,
			squares = rep(1, len.DAT), fg = addgrid.col)
	} 
	

	if(plotCI!="no"){
		if(is.null(lowCI.mat)||is.null(uppCI.mat))
			stop("Need lowCI.mat and uppCI.mat!")
		if(!order=="original"){
			lowCI.mat <- lowCI.mat[ord,ord]
			uppCI.mat <- uppCI.mat[ord,ord]
		}
		pos.lowNew  <- getPos.Dat(lowCI.mat)[[1]]
		lowNew      <- getPos.Dat(lowCI.mat)[[2]]
		pos.uppNew  <- getPos.Dat(uppCI.mat)[[1]]
		uppNew      <- getPos.Dat(uppCI.mat)[[2]]
		if(!(method=="circle"||method=="square"))
			stop("method shoud be circle or square if draw confidence interval!")
		k1 <- (abs(uppNew) > abs(lowNew))
		bigabs <- uppNew 
		bigabs[which(!k1)] <- lowNew[!k1]
		smallabs <- lowNew
		smallabs[which(!k1)] <- uppNew[!k1]
		sig <- sign(uppNew * lowNew)
		
		if(plotCI=="circle"){	
			symbols(pos.uppNew[,1], pos.uppNew[,2],
				add = TRUE,  inches = FALSE,
				circles = 0.95*abs(bigabs)**0.5/2,  
				bg = ifelse(sig>0, col.fill, col[ceiling((bigabs+1)*length(col)/2)]),
				fg = ifelse(sig>0, col.fill, col[ceiling((bigabs+1)*length(col)/2)]))
			symbols(pos.lowNew[,1], pos.lowNew[,2],
				add = TRUE, inches = FALSE, 
				circles = 0.95*abs(smallabs)**0.5/2, 
				bg = ifelse(sig>0, bg, col[ceiling((smallabs+1)*length(col)/2)]),
				fg = ifelse(sig>0, col.fill, col[ceiling((smallabs+1)*length(col)/2)]))
		}
		
		if(plotCI=="square"){
			symbols(pos.uppNew[,1], pos.uppNew[,2],
				add = TRUE,  inches = FALSE,
				squares = abs(bigabs)**0.5,  
				bg = ifelse(sig>0, col.fill, col[ceiling((bigabs+1)*length(col)/2)]),
				fg = ifelse(sig>0, col.fill, col[ceiling((bigabs+1)*length(col)/2)]))
			symbols(pos.lowNew[,1], pos.lowNew[,2],
				add = TRUE, inches = FALSE, 
				squares = abs(smallabs)**0.5, 
				bg = ifelse(sig>0, bg, col[ceiling((smallabs+1)*length(col)/2)]),
				fg = ifelse(sig>0, col.fill, col[ceiling((smallabs+1)*length(col)/2)]))
		}

		if(plotCI=="rect"){
			rect.width <- 0.25
			rect(pos.uppNew[,1]-rect.width, pos.uppNew[,2]+smallabs/2,
				pos.uppNew[,1] +rect.width, pos.uppNew[,2]+bigabs/2,
				col=col.fill, border=col.fill)
			segments(pos.lowNew[,1]-rect.width, pos.lowNew[,2]+DAT/2,
				pos.lowNew[,1]+rect.width, pos.lowNew[,2]+DAT/2,
				col="black",lwd=1)	
			segments(pos.uppNew[,1]-rect.width, pos.uppNew[,2]+uppNew/2,
				pos.uppNew[,1]+rect.width, pos.uppNew[,2]+uppNew/2,
				col="black",lwd=1)
			segments(pos.lowNew[,1]-rect.width, pos.lowNew[,2]+lowNew/2,
				pos.lowNew[,1]+rect.width, pos.lowNew[,2]+lowNew/2,
				col="black",lwd=1)
			segments(pos.lowNew[,1]-0.5,pos.lowNew[,2], 
				pos.lowNew[,1]+0.5, pos.lowNew[,2],col = "grey70", lty=3)
		}

	}
	

	if(!is.null(p.mat)&!insig=="no"){
    	if(!order=="original")
    	p.mat <- p.mat[ord, ord]
		pos.pNew  <- getPos.Dat(p.mat)[[1]]
    	pNew      <- getPos.Dat(p.mat)[[2]]
    	
		ind.p <- which(pNew > (sig.level))
    	if(insig=="pch"){
			points(pos.pNew[,1][ind.p], pos.pNew[,2][ind.p],
				pch = pch, col = pch.col, cex = pch.cex, lwd=2)
		}
		if(insig=="blank"){
			symbols(pos.pNew[,1][ind.p], pos.pNew[,2][ind.p], inches = FALSE,
				squares = rep(1, length(pos.pNew[,1][ind.p])),
				fg = addgrid.col, bg = bg, add = TRUE)
		}
	}
	
	
	if(addcolorlabel!="no"){		
		colRange <- assign.color(cl.lim)
		ind1 <- which(col==colRange[1])
		ind2 <- which(col==colRange[2])
		colbar <- col[ind1:ind2]
		
		if(is.null(cl.length)) 
		cl.length <- ifelse(length(colbar)>20, 11, length(colbar)+1)
		
		labels <- seq(cl.lim[1],cl.lim[2], length=cl.length)
		at <- seq(0,1,length=length(labels))
		
		if(addcolorlabel=="right"){
			vertical <- TRUE
			xlim <- c(m2 + 0.5 + mm*0.02, m2 + 0.5 + mm*cl.ratio)
			ylim <- c(n1-0.5, n2+0.5)
		}

		if(addcolorlabel=="bottom"){
			vertical <- FALSE
			xlim <- c(m1-0.5, m2+0.5)
			ylim <- c(n1 - 0.5 - nn*cl.ratio, n1 - 0.5- nn*0.02)
		}
		colorlegend(colbar=colbar, labels=round(labels/zoom, 2), 
			offset=cl.offset, ratio.colbar = 0.3, cex = cl.cex,
			xlim = xlim, ylim = ylim, vertical = vertical, align= cl.align.text)
	}

	
	## add variable names and title
	if(addtextlabel!="no"){
        ylabwidth2 <- strwidth(newrownames, cex = tl.cex)
        xlabwidth2 <- strwidth(newcolnames, cex = tl.cex)
        pos.xlabel <- cbind(m1:m2, n2 + 0.5 + laboffset)
        pos.ylabel <- cbind(m1 - 0.5, n2:n1)

        if(addtextlabel=="td"){
			if(type!="upper") stop("type should be \"upper\" if addtextlabel is \"dt\".")
			pos.ylabel <- cbind(m1:(m1+nn)-0.5, n2:n1)
		}
        if(addtextlabel=="ld"){
			if(type!="lower") stop("type should be \"lower\" if addtextlabel is \"ld\".")
            pos.xlabel <- cbind(m1:m2, n2:(n2-mm) + 0.5 + laboffset)
        }
		if(addtextlabel=="d"){
			##if(type!="full") stop("type should be \"full\" if addtextlabel is \"d\".")
			pos.ylabel <- cbind(m1:(m1+nn)-0.5, n2:n1)
			pos.ylabel <- pos.ylabel[1:min(n,m),]
			symbols(pos.ylabel[,1]+0.5, pos.ylabel[,2],add = TRUE,
				bg = bg, fg = addgrid.col,
				inches = FALSE, squares = rep(1, length(pos.ylabel[,1])))
			text(pos.ylabel[,1]+0.5, pos.ylabel[,2], newcolnames[1:min(n,m)],
                col = tl.col, cex = tl.cex, ...)
		} else {
			text(pos.xlabel[,1], pos.xlabel[,2], newcolnames, srt = tl.srt, 
				adj=ifelse(tl.srt==0, c(0.5,0), c(0,0)),
                col = tl.col, cex = tl.cex, offset=tl.offset, ...)
			text(pos.ylabel[,1], pos.ylabel[,2], newrownames,
                col = tl.col, cex = tl.cex, pos=2, offset=tl.offset, ...)
		}
	}

	title(title, ...)
   
	## add numbers
	if(!is.null(addCoef.col)&(!method == "number")){
		text(Pos[,1], Pos[,2],  col = addCoef.col,
		labels = round(DAT*ifelse(addCoefasPercent, 100, 1)/zoom, 
				ifelse(addCoefasPercent, 0, 2)))
	}

	if(type=="full"&plotCI=="no"&!is.null(addgrid.col))
		rect(m1-0.5, n1-0.5, m2+0.5, n2+0.5, border=addgrid.col)
	##  draws rectangles
	if(!is.null(addrect)&order=="hclust"&type=="full"){
		corrRect.hclust(corr, k = addrect, 
			method = hclust.method, col = rect.col, lwd = rect.lwd)
	}

	invisible(ord)
} 

