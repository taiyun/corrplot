[![R-CMD-check](https://github.com/taiyun/corrplot/workflows/R-CMD-check/badge.svg)](https://github.com/taiyun/corrplot/actions)
[![codecov.io](https://codecov.io/github/taiyun/corrplot/coverage.svg?branch=master)](https://codecov.io/github/taiyun/corrplot?branch=master)
[![CRAN Status](https://www.r-pkg.org/badges/version/corrplot)](https://cran.r-project.org/package=corrplot)
[![CRAN Downloads](https://cranlogs.r-pkg.org/badges/corrplot)](https://www.r-pkg.org/pkg/corrplot)
[![Support badge](https://img.shields.io/badge/stackoverflow-corrplot-yellowgreen.svg)](https://stackoverflow.com/questions/tagged/r-corrplot)

## Summary

R package **corrplot** provides a visual exploratory tool on correlation matrix that 
supports automatic variable reordering to help detect hidden patterns among variables.

corrplot is very easy to use and provides a rich array of plotting options in 
visualization method, graphic layout, color, legend, text labels, etc. 
It also provides p-values and confidence intervals to help users determine the 
statistical significance of the correlations.

For examples, see its
[online vignette](https://taiyun.github.io/corrplot/).


This package is licensed under the MIT license, and available on CRAN:
<https://cran.r-project.org/package=corrplot>.



## Basic example

```r
library(corrplot)
M = cor(mtcars)
corrplot(M, order = 'hclust', addrect = 2)
```
![Basic example](https://raw.githubusercontent.com/taiyun/corrplot/master/vignettes/webimg/rectangles-1.png)

## Download and Install

To download the release version of the package on CRAN, type the following at the R command line:

```r
install.packages('corrplot')
```

To download the development version of the package, type the following at the R command line:

```r
devtools::install_github('taiyun/corrplot', build_vignettes = TRUE)
```

## How to cite

To cite `corrplot` properly, call the R built-in command
`citation('corrplot')` as follows:

```r
citation('corrplot')
```

## Reporting bugs and other issues

If you encounter a clear bug, please file a minimal reproducible example on 
[github](https://github.com/taiyun/corrplot/issues).

