corrRect <- function(clus, col = "black", lwd = 2){
	hc <- length(clus)
	cu <- c(0, cumsum(clus))
	mat <- cbind(cu[-(hc + 1)] + 0.5, sum(clus) - cu[-(hc + 1)] + 0.5, 
		        cu[-1] + 0.5, sum(clus) - cu[-1] + 0.5)
	rect(mat[,1], mat[,2], mat[,3], mat[,4], border = col, lwd = lwd)
} 
