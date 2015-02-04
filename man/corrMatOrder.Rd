\name{corrMatOrder}
\Rdversion{1.1}
\alias{corrMatOrder}

\title{
Reorder a correlation matrix.
}
\description{
Draw rectangle(s) around the chart of corrrlation matrix based on the number 
of each cluster's members.
}
\usage{
corrMatOrder(corr, order=c("AOE", "FPC", "hclust", "alphabet"),
	hclust.method = c("complete", "ward", "ward.D", "ward.D2", "single", "average",
	"mcquitty", "median", "centroid"))
}

\arguments{
  \item{corr}{
Correlation matrix to reorder.
}

  \item{order}{
Character, the ordering method for the correlation matrix. 
	\itemize{
		\item \code{"AOE"} for the angular order of the eigenvectors. It is calculated from the order of the angles, \eqn{a_i}:
			\deqn{ a_i = tan (e_{i2}/e_{i1}), if e_{i1}>0}
			\deqn{ a_i = tan (e_{i2}/e_{i1}) + \pi, otherwise.}
			where \eqn{e_1} and \eqn{e_2} are the largest two eigenvalues of matrix \code{corr}.
			See Michael Friendly (2002) for details.
		\item \code{"FPC"} for the first principal component order.
		\item \code{"hclust"} for hierarchical clustering order.
		\item \code{"alphabet"} for alphabetical order.
	}
}
  \item{hclust.method}{
Character, the agglomeration method to be used when \code{order} is \code{hclust}. This should be one of \code{"ward"}, \code{"ward.D"}, \code{"ward.D2"}, \code{"single"}, \code{"complete"}, \code{"average"}, \code{"mcquitty"}, \code{"median"} or \code{"centroid"}.
}

}

\value{
Returns a single permutation vector.
}

\seealso{
Package \code{seriation} offers more methods to reorder matrices, such as 
ARSA, BBURCG, BBWRCG, MDS, TSP, Chen and so forth.
}


\author{
Taiyun Wei
}

\examples{

M <- cor(mtcars)
(order.AOE <- corrMatOrder(M, order="AOE"))
(order.FPC <- corrMatOrder(M, order="FPC"))
(order.hc <- corrMatOrder(M, order="hclust"))
(order.hc2 <- corrMatOrder(M, order="hclust", hclust.method="ward"))
M.AOE <- M[order.AOE,order.AOE ]
M.FPC <- M[order.FPC,order.FPC ]
M.hc  <- M[order.hc, order.hc ]
M.hc2 <- M[order.hc2,order.hc2]



par(ask=TRUE)
corrplot(M)
corrplot(M.AOE)
corrplot(M.FPC)
corrplot(M.hc)

corrplot(M.hc)
corrRect.hclust(corr=M.hc, k=2)

corrplot(M.hc)
corrRect.hclust(corr=M.hc, k=3)

corrplot(M.hc2)
corrRect.hclust(M.hc2, k=2, method="ward")

}

\keyword{hplot}% __ONLY ONE__ keyword per line
