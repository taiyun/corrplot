#' @export
corrMatOrder <- function(corr, order=c("AOE", "FPC", "hclust", "alphabet"),
	hclust.method = c("complete", "ward", "ward.D", "ward.D2", "single", "average",
			"mcquitty", "median", "centroid"))
{

	order <- match.arg(order)
	hclust.method <- match.arg(hclust.method)

	## reorder the variables using the angular order of the eigenvectors
	if (order == "AOE") {
		x.eigen <- eigen(corr)$vectors[, 1:2]
		e1 <- x.eigen[, 1]
		e2 <- x.eigen[, 2]
		alpha <- ifelse(e1 > 0, atan(e2/e1), atan(e2/e1) + pi)
		ord <- order(alpha)
	}
	
	## reorder the variables using the first principal component
	if (order == "FPC") {
		x.eigen <- eigen(corr)$vectors[, 1:2]
		e1 <- x.eigen[, 1]
		ord <- order(e1)
	}
	
	## reorder the variables in alphabet ordering
	if(order =="alphabet"){
		ord <- sort(rownames(corr))
	}

	## reorder the variables using hclhust
	if(order == "hclust"){
		ord <- order.dendrogram(as.dendrogram(hclust(as.dist(1-corr),
		method = hclust.method)))
	}

	return(ord)
}
