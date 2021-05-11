data(mtcars)
M <- cor(mtcars)
set.seed(0)

##  different color series
col0 <- colorRampPalette(c("white", "cyan", "#007FFF", "blue","#00007F"))
col1 <- colorRampPalette(c("#7F0000", "red", "#FF7F00", "yellow", "white",
                           "cyan", "#007FFF", "blue","#00007F"))
col2 <- colorRampPalette(c("#67001F", "#B2182B", "#D6604D", "#F4A582",
                           "#FDDBC7", "#FFFFFF", "#D1E5F0", "#92C5DE",
                           "#4393C3", "#2166AC", "#053061"))
col3 <- colorRampPalette(c("red", "white", "blue"))
col4 <- colorRampPalette(c("#7F0000", "red", "#FF7F00", "yellow", "#7FFF7F",
                           "cyan", "#007FFF", "blue", "#00007F"))


wb <- c("white", "black")

par(ask = TRUE)

## different color scale and methods to display corr-matrix
corrplot(M, method = "number", col = "black", cl.pos = "n")
corrplot(M, method = "number")
corrplot(M)
corrplot(M, order = "AOE")
corrplot(M, order = "AOE", addCoef.col = "grey")

corrplot(M, order = "AOE", col = col1(20), cl.length = 21, addCoef.col = "grey")
corrplot(M, order = "AOE", col = col1(10), addCoef.col = "grey")

corrplot(M, order = "AOE", col = col2(200))
corrplot(M, order = "AOE", col = col2(200), addCoef.col = "grey")
corrplot(M, order = "AOE", col = col2(20), cl.length = 21, addCoef.col = "grey")
corrplot(M, order = "AOE", col = col2(10), addCoef.col = "grey")

corrplot(M, order = "AOE", col = col3(100))
corrplot(M, order = "AOE", col = col3(10))


corrplot(M, method = "color", col = col1(20), cl.length = 21, order = "AOE",
         addCoef.col = "grey")
corrplot(M, method = "square", col = col2(200), order = "AOE")
corrplot(M, method = "ellipse", col = col1(200), order = "AOE")
corrplot(M, method = "shade", col = col3(20), order = "AOE")
corrplot(M, method = "pie", order = "AOE")

## col = wb
corrplot(M, col = wb, order = "AOE", outline = TRUE, cl.pos = "n")

## like Chinese wiqi, suit for either on screen or white-black print.
corrplot(M, col = wb, bg = "gold2",  order = "AOE", cl.pos = "n")


## mixed methods: It's more efficient if using function "corrplot.mixed"
## circle + ellipse
corrplot(M, order = "AOE", type = "upper", tl.pos = "d")
corrplot(M, add = TRUE, type = "lower", method = "ellipse", order = "AOE",
         diag = FALSE, tl.pos = "n", cl.pos = "n")

## circle + square
corrplot(M, order = "AOE",type = "upper", tl.pos = "d")
corrplot(M, add = TRUE, type = "lower", method = "square", order = "AOE",
         diag = FALSE, tl.pos = "n", cl.pos = "n")

## circle + colorful number
corrplot(M, order = "AOE", type = "upper", tl.pos = "d")
corrplot(M, add = TRUE, type = "lower", method = "number", order = "AOE",
         diag = FALSE, tl.pos = "n", cl.pos = "n")

## circle + black number
corrplot(M, order = "AOE", type = "upper", tl.pos = "tp")
corrplot(M, add = TRUE, type = "lower", method = "number", order = "AOE",
         col = "black", diag = FALSE, tl.pos = "n", cl.pos = "n")


## order is hclust and draw rectangles
corrplot(M, order = "hclust")
corrplot(M, order = "hclust", addrect = 2)
corrplot(M, order = "hclust", addrect = 3, rect.col = "red")
corrplot(M, order = "hclust", addrect = 4, rect.col = "blue")
corrplot(M, order = "hclust", hclust.method = "ward.D2", addrect = 4)

## visualize a  matrix in [0, 1]
corrplot(abs(M), order = "AOE", cl.lim = c(0,1))
corrplot(abs(M), order = "AOE", col = col1(20), cl.lim = c(0,1))


# when is.corr=TRUE, cl.lim only affect the color legend
# If you change it, the color is still assigned on [-1, 1]
corrplot(M/2)
corrplot(M/2, cl.lim=c(-0.5,0.5))

# when is.corr=FALSE, cl.lim is also used to assign colors
# if the matrix have both positive and negative values
# the matrix transformation keep every values positive and negative
corrplot(M*2, is.corr = FALSE, cl.lim=c(-2, 2))
corrplot(M*2, is.corr = FALSE, cl.lim=c(-2, 2) * 2)
corrplot(M*2, is.corr = FALSE, cl.lim=c(-2, 2) * 4)

## 0.5~0.6
corrplot(abs(M)/10+0.5, col=col0(10))
corrplot(abs(M)/10+0.5, is.corr = FALSE, cl.lim=c(0.5,0.6), col=col0(10))


## visualize a  matrix in [-100, 100]
ran <- round(matrix(runif(225, -100,100), 15))
corrplot(ran, is.corr = FALSE)
corrplot(ran, is.corr = FALSE, cl.lim = c(-100, 100))

## visualize a  matrix in [100, 300]
ran2 <- ran + 200

# bad color
corrplot(ran2, is.corr = FALSE, cl.lim = c(100, 300), col=col1(100))

# good color
corrplot(ran2, is.corr = FALSE, cl.lim = c(100, 300), col=col0(100))


## text-labels and plot type
corrplot(M, order = "AOE", tl.srt = 45)
corrplot(M, order = "AOE", tl.srt = 60)
corrplot(M, order = "AOE", tl.pos = "d", cl.pos = "n")
corrplot(M, order = "AOE", diag = FALSE, tl.pos = "d")
corrplot(M, order = "AOE", type = "upper")
corrplot(M, order = "AOE", type = "upper", diag = FALSE)
corrplot(M, order = "AOE", type = "lower", cl.pos = "b")
corrplot(M, order = "AOE", type = "lower", cl.pos = "b", diag = FALSE)



#### color-legend
corrplot(M, order = "AOE", cl.ratio = .2, cl.align = "l")
corrplot(M, order = "AOE", cl.ratio = .2, cl.align = "c")
corrplot(M, order = "AOE", cl.ratio = .2, cl.align = "r")
corrplot(M, order = "AOE", cl.pos = "b")
corrplot(M, order = "AOE", cl.pos = "b", tl.pos = "d")
corrplot(M, order = "AOE", cl.pos = "n")


## deal with missing Values
M2 <- M
diag(M2) = NA
corrplot(M2)
corrplot(M2, na.label = "o")
corrplot(M2, na.label = "NA")


##the input matrix is not square
corrplot(M[1:8,])
corrplot(M[,1:8])


res1 <- cor.mtest(mtcars, conf.level = 0.95)
res2 <- cor.mtest(mtcars, conf.level = 0.99)


## specialized the insignificant value according to the significant level
corrplot(M, p.mat = res1$p, sig.level = 0.2)
corrplot(M, p.mat = res1$p, sig.level = 0.05)
corrplot(M, p.mat = res1$p, sig.level = 0.01)
corrplot(M, p.mat = res1$p, insig = "blank")
corrplot(M, p.mat = res1$p, insig = "p-value")
corrplot(M, p.mat = res1$p, insig = "p-value", sig.level = -1) ## add all p-values
corrplot(M, p.mat = res1$p, order = "hclust", insig = "blank", addrect = 3)
corrplot(M, p.mat = res1$p, order = "hclust", insig = "pch", addrect = 3)


## plot confidence interval(0.95), "square" method
corrplot(M, low = res1$uppCI, upp = res1$uppCI,
         plotCI = "circle", addg = "grey20", cl.pos = "n")
corrplot(M, p.mat = res1$p, low = res1$lowCI, upp = res1$uppCI,
         plotCI = "circle", addg = "grey20", cl.pos = "n")
corrplot(M, low = res1$lowCI, upp = res1$uppCI,
         col = c("white", "black"), bg = "gold2", order = "AOE",
         plotCI = "circle", cl.pos = "n", pch.col = "red")
corrplot(M, p.mat = res1$p, low = res1$lowCI, upp = res1$uppCI,
         col = c("white", "black"), bg = "gold2", order = "AOE",
         plotCI = "circle", cl.pos = "n", pch.col = "red")

## plot confidence interval(0.95), "square" method
corrplot(M, low = res1$lowCI, upp = res1$uppCI,
         col = c("white", "black"), bg = "gold2", order = "AOE",
         plotCI = "square", addg = NULL, cl.pos = "n")
corrplot(M, p.mat = res1$p, low = res1$lowCI, upp = res1$uppCI,
         col = c("white","black"), bg = "gold2", order = "AOE", pch.col = "red",
         plotCI = "square", addg = NULL, cl.pos = "n")

## plot confidence interval(0.95, 0.95, 0.99), "rect" method
corrplot(M, low = res1$lowCI, upp = res1$uppCI, order = "hclust",
         rect.col = "navy", plotCI = "rect",cl.pos = "n")
corrplot(M, p.mat = res1$p, low = res1$lowCI, upp = res1$uppCI,
         order = "hclust", pch.col = "red", sig.level = 0.05, addrect = 3,
         rect.col = "navy", plotCI = "rect", cl.pos = "n")
corrplot(M, p.mat = res2$p, low = res2$lowCI, upp = res2$uppCI,
         order = "hclust", pch.col = "red", sig.level = 0.01, addrect = 3,
         rect.col = "navy", plotCI = "rect", cl.pos = "n")


## an animation of changing confidence interval in different significance level
## begin.animaton
par(ask = FALSE)
for (i in seq(0.1, 0, -0.005)) {
  tmp <- cor.mtest(mtcars, conf.level = 1 - i)
  corrplot(M, p.mat = tmp$p, low = tmp$lowCI, upp = tmp$uppCI, order = "hclust",
           pch.col = "red", sig.level = i, plotCI = "rect", cl.pos = "n",
           mar = c(0, 0, 1, 0),
           title = substitute(alpha == x,
                              list(x = format(i, digits = 3, nsmall = 3))))
  Sys.sleep(0.15)
}
## end.animaton
