corrplot.mixed <- function(corr, lower = "number", 
    upper = "circle", addtextlabel = c("d", "lt", "no"), 
    diag = c("n", "l", "u"), bg = "white", addgrid.col = "gray", 
    ...) 
{
    diag <- match.arg(diag)
    addtextlabel <- match.arg(addtextlabel)
    n <- nrow(corr)
    corrplot(corr, type = "upper", method = upper, diag = TRUE, 
        addtextlabel = addtextlabel, ...)
    corrplot(corr, add = TRUE, type = "lower", method = lower, 
        diag = (diag == "l"), addtextlabel = "no", addcolorlabel = "no", 
        ...)
    if (diag == "n" & addtextlabel != "d") {
        symbols(1:n, n:1, add = TRUE, bg = bg, fg = addgrid.col, 
            inches = FALSE, squares = rep(1, n))
    }
} 
