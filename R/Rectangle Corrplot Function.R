library(corrplot)

#' Add a rectangle to a correlation plot

#' @param rstart The name of the variable contained in the correlation plot that will serve as the vertical starting point of the rectangle.
#' @param rend The name of the variable contained in the correlation plot that will serve as the vertical ending point of the rectangle.
#' @param cstart (optional) The name of the variable contained in the correlation plot that will serve as the horizontal starting point of the rectangle.
#' If no cstart or cend provided, creates an on-diagonal rectangle automatically. cstart and cend allows fo off-diagonal rectangles.
#' @param rend (optional) The name of the variable contained in the correlation plot that will serve as the horizontal ending point of the rectangle.
#' If no cstart or cend provided, creates an on-diagonal rectangle automatically. cstart and cend allows fo off-diagonal rectangles.
#' @param correlation_matrix The correlation matrix the correlation plot is based on.
#' @param mirror If TRUE, also adds the equivalent rectangle from the other side of the diagonal (i.e. the "mirror" of the original).
#' @param ... Arguments to modify graphical parameters, etc.
#' @examples 
#' #Adding an on-diagonal rectangle to a correlation plot of the USArrests data with mirroring.
#' corrplot(cor(USArrests))
#' make_rect(rstart="Assault", rend="UrbanPop", correlation_matrix=cor(USArrests), mirror=TRUE)
#' 
#' #Adding an off-diagonal rectangle
#' make_rect(rstart="Murder", rend="Rape", cstart="Murder", cend="Murder", correlation_matrix=cor(USArrests))
#' 
#' @export

make_rect <- function(rstart, rend, cstart=NULL, cend=NULL, correlation_matrix, mirror=FALSE, lwd=3,...)
{
  #if the rectangle is not off-diagonal
  if (is.null(cstart)==TRUE&&is.null(cend)==TRUE){
    leftx <- which(colnames(correlation_matrix)==rstart)-1+.5
    rightx <- which(colnames(correlation_matrix)==rend)+.5
  }
  #if the rectangle is off the diagonal
  else{
    leftx <- which(colnames(correlation_matrix)==cstart)-1+.5
    rightx <- which(colnames(correlation_matrix)==cend)+.5
  }
  
  #this holds regardless of whether the rectangle is off-diagonal or not
  bottomy <- length(correlation_matrix[,1])-which(colnames(correlation_matrix)==rend)+.5
  topy <- length(correlation_matrix[,1])-which(colnames(correlation_matrix)==rstart)+1+.5
  
  #uses rect function to construct the rectangle using above values as the parameters
  rect(xleft = leftx, ybottom = bottomy, xright = rightx, ytop = topy, lwd=lwd,...)
  
  #if mirror is set to be TRUE, draws the same rectangle on the other side of the diagonal
  if (mirror==TRUE){
    make_rect(rstart=cstart,rend=cend,cstart=rstart,cend=rend, correlation_matrix=correlation_matrix, mirror=FALSE,...)
  }
}

#' Allows the creation of all rectangles on a correlation plot using a vector of cutpoints to divide them. 

#' @param cutpoints A vector containing the names of the cutpoints (i.e names of variables contained in the correlation plot). The first cutpoint is the variable that will start off the first rectangle. 
#' The second cutpoint then defines the starting point of the second rectangle, and so on.
#' @param endpoint The name of the variable contained in the correlation plot that will define the end of the last rectangle to be made.
#' @param ondiag Defaults to TRUE. If TRUE, the function will generate the associated on-diagonal rectangles.
#' @param offdiag Defaults to TRUE. If FALSE, the function will generate the associated  off-diagonal rectangles.
#' @param col_ondiag Defines the colour of on-diagonal rectangles.
#' @param col_offdiag Defines the colour of off-diagonal rectangles.
#' @param ondiag_width Defines the line width of the on-diagonal rectangles.
#' @param offdiag_width Defines the line width of the off-diagonal rectangles.
#' @param correlation_matrix The correlation matrix the correlation plot is based on.
#' @param ... Arguments to modify graphical parameters, etc.
#' @examples 
#' #Adds all rectangles associated with the cutpoints to the correlation plot for USArrests.
#' corrplot::corrplot(cor(USArrests))
#' make_all_rects(cutpoints=c("Assault", "Rape"), endpoint="Rape", correlation_matrix=cor(USArrests))
#' 
#' #Adds all on-diagonal rectangles associated with the cutpoints.
#' make_all_rects(cutpoints=c("Assault", "Rape"), endpoint="Rape", offdiag=FALSE, correlation_matrix=cor(USArrests))
#' 
#' @export

make_all_rects <- function(cutpoints, endpoint, ondiag=TRUE, offdiag=TRUE, col_ondiag="black", col_offdiag="red",ondiag_width=4, offdiag_width=3, correlation_matrix,...){
  #if allowing rectangles on the diagonal...
  if(ondiag==TRUE){
    #loop until rectangles made for all start points
    for (i in 1: (length(cutpoints)))
    {
      #if not about to make the last rectangle...
      if (i<=(length(cutpoints)-1))
      {
        make_rect(rstart=cutpoints[i], rend=colnames(correlation_matrix)[(which(colnames(correlation_matrix)==cutpoints[i+1])-1)],correlation_matrix=correlation_matrix, lwd=ondiag_width,border=col_ondiag,...)
      }
      #if about to make the last rectangle, use the endpoint
      else{
        make_rect(rstart=cutpoints[i], rend=endpoint, correlation_matrix=correlation_matrix, lwd=ondiag_width,border=col_ondiag,...)
      }
    }
  }
  #if allowing rectangles off the diagonal
  if(offdiag==TRUE){
    #loop through all the cutoff points (except the last which has no off-diagonal rectangles...)
    for (i in 1: ((length(cutpoints))-1))
    {
        #... and for each cutoff point i, loop through all the cutoff points besides i to create off-diagonal rectangles.
        for (s in i:(length(cutpoints)-1)){
            #if not about to make the last rectangle in the row
            if (s<=(length(cutpoints)-2))
            {
              make_rect(rstart=cutpoints[i], rend=colnames(correlation_matrix)[(which(colnames(correlation_matrix)==cutpoints[i+1])-1)],cstart=cutpoints[s+1],cend=colnames(correlation_matrix)[(which(colnames(correlation_matrix)==cutpoints[s+2])-1)], correlation_matrix=correlation_matrix,border=col_offdiag, lwd=offdiag_width,mirror=TRUE,...)
            }
            #if about to make the last rectangle in the row, use the endpoint
            else{
              make_rect(rstart=cutpoints[i], rend=colnames(correlation_matrix)[(which(colnames(correlation_matrix)==cutpoints[i+1])-1)], cstart=cutpoints[s+1], cend=endpoint, correlation_matrix=correlation_matrix, mirror=TRUE, border=col_offdiag, lwd=offdiag_width,...)
            }
          }
    }
  }
}