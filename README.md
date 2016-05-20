[![Build Status](https://travis-ci.org/taiyun/corrplot.svg)](https://travis-ci.org/taiyun/corrplot)
[![codecov.io](https://codecov.io/github/taiyun/corrplot/coverage.svg?branch=master)](https://codecov.io/github/taiyun/corrplot?branch=master)
[![CRAN Status](http://www.r-pkg.org/badges/version/corrplot)](http://cran.r-project.org/package=corrplot)
[![CRAN Downloads](http://cranlogs.r-pkg.org/badges/corrplot)](http://www.r-pkg.org/pkg/corrplot)
[![Research software impact](http://depsy.org/api/package/cran/corrplot/badge.svg)](http://depsy.org/package/r/corrplot)

## Summary
The R package **corrplot** is for visualizing correlation matrices and
confidence intervals. It also contains some algorithms to do matrix
reordering. For examples, see its
[vignette](http://cran.r-project.org/web/packages/corrplot/vignettes/corrplot-intro.html).

This package is licensed under GPL, and available on CRAN:
<http://cran.r-project.org/package=corrplot>.

## Basic example
```r
library(corrplot)
M <- cor(mtcars)
corrplot(M, order = "hclust", addrect = 2)
```
![Basic example](http://cos.name/wp-content/uploads/2016/04/example-corrplot.png)

## Download and Install
To download the development version of the package, type the following at the R command line:
```r
install.packages("devtools")
devtools::install_github("taiyun/corrplot", build_vignettes = TRUE)
```

To download the release version of the package on CRAN, type the following at the R command line:
```r
install.packages("corrplot")
```

### How to contribute
- Fork, clone, edit, commit, push, create pull request
- Use RStudio
- Unit-testing: press `CTRL+SHIFT+T` in RStudio
  - we know that is hard to write tests especially for a visual package like this

### Reporting bugs and other issues
If you encounter a clear bug, please file a minimal reproducible example on github.

### How to perform static code analysis and style checks
We use `lintr` which also performs the analysis on Travis-CI.
Configuration for `lintr` is in `.lintr` file.
Lints are treated as warnings, but we strive to be lint-free.

In RStudio, you can run `lintr` from the console as follows:
```r
> lintr::lint_package()
```

### Who do I talk to? ###
- [Taiyun Wei](https://github.com/taiyun) (main)
- [Viliam Simko](https://github.com/vsimko) (backup)

## License
This package is free and open source software, licensed under GPL.

## Other links
- Corrplot listed at OpenHub: https://www.openhub.net/p/corrplot
- Research software impact of Corrplot (by Depsy): http://depsy.org/package/r/corrplot
- CRAN: http://cran.r-project.org/web/packages/corrplot
