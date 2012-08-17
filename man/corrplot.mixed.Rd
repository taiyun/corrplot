\name{corrplot.mixed}
\Rdversion{1.1}
\alias{corrplot.mixed}

\title{
Using mixed methods to visualize a correlation matrix.
}
\description{
Using mixed methods to visualize a correlation matrix.
}
\usage{
corrplot.mixed(corr, lower = "number", upper = "circle",
	tl.pos = c("d","lt","n"), diag = c("n","l","u"), 
	bg = "white", addgrid.col = "gray",...)
}

\arguments{
  \item{corr}{
Matrix, the correlation matrix to visualize.
}

  \item{lower}{
Character, the visualization method for the lower triangular correlation matrix.
}

  \item{upper}{
Character, the visualization method for the upper triangular correlation matrix.
}

  \item{tl.pos}{
Character, \code{"lt"}, \code{"d"} or \code{"n"}, giving position of 
text labels, \code{"lt"} means left and top,  \code{"d"} means diagonal. 
If \code{"n"},  add no textlabel.
}

  \item{diag}{
Character, for specifying the glyph on the principal diagonal. It is one of
\code{"n"} (default,  draw nothing), \code{"l"} (draw the glyphs of 
lower triangular) or \code{"u"} (draw the glyphs of upper triangular). 
}
  \item{bg}{
The background color.
}

\item{addgrid.col}{
The color of grid, if \code{NULL}, don't add grid.
}

  \item{...}{
Additional arguments for corrplot's wrappers
}
}
\author{
Taiyun Wei
}

\examples{
M <- cor(mtcars)
ord <- corrMatOrder(M, order="AOE")
M2 <- M[ord,ord]
par(ask=TRUE)
corrplot.mixed(M2)
corrplot.mixed(M2, lower="ellipse", upper="circle")
corrplot.mixed(M2, lower="square", upper="circle")
corrplot.mixed(M2, lower="shade", upper="circle")
corrplot.mixed(M2, tl.pos="lt")
corrplot.mixed(M2, tl.pos="lt", diag="u")
corrplot.mixed(M2, tl.pos="lt", diag="l")
corrplot.mixed(M2, tl.pos="n")

}

\keyword{hplot}% __ONLY ONE__ keyword per line
