corrplot.mixed <- function(corr, lower = "number", 
    upper = "circle", tl.pos = c("d", "lt", "n"), 
    diag = c("n", "l", "u"), bg = "white", addgrid.col = "gray", 
    ...) 
{
    diag <- match.arg(diag)
    tl.pos <- match.arg(tl.pos)
    n <- nrow(corr)
    corrplot(corr, type = "upper", method = upper, diag = TRUE, 
        tl.pos = tl.pos, ...)
    corrplot(corr, add = TRUE, type = "lower", method = lower, 
        diag = (diag == "l"), tl.pos = "n", cl.pos = "n", 
        ...)
    if (diag == "n" & tl.pos != "d") {
        symbols(1:n, n:1, add = TRUE, bg = bg, fg = addgrid.col, 
            inches = FALSE, squares = rep(1, n))
    }
} 
