[![Build Status](https://travis-ci.org/taiyun/corrplot.svg?branch=master)](https://travis-ci.org/taiyun/corrplot)
[![codecov.io](https://codecov.io/github/taiyun/corrplot/coverage.svg?branch=master)](https://codecov.io/github/taiyun/corrplot?branch=master)
[![CRAN Status](http://www.r-pkg.org/badges/version/corrplot)](http://cran.r-project.org/package=corrplot)
[![Rdoc](http://www.rdocumentation.org/badges/version/corrplot)](http://www.rdocumentation.org/packages/corrplot)
[![CRAN Downloads](http://cranlogs.r-pkg.org/badges/corrplot)](http://www.r-pkg.org/pkg/corrplot)
[![Support badge](https://img.shields.io/badge/stackoverflow-corrplot-yellowgreen.svg)](http://stackoverflow.com/questions/tagged/r-corrplot)

## Summary
The R package **corrplot** is for visualizing correlation matrices and
confidence intervals. It also contains some algorithms to do matrix
reordering. For examples, see its
[vignette](http://cran.r-project.org/web/packages/corrplot/vignettes/corrplot-intro.html).

This package is licensed under GPL, and available on CRAN:
<http://cran.r-project.org/package=corrplot>.

## How to cite
The R core development team and the very active community of package authors
have invested a lot of time and effort in creating R as it is today. Please give
credit where credit is due and cite R and R packages when you use them for data
analysis. To cite `corrplot` properly, call the R built-in command
`citation("corrplot")` as follows:
```r
library(corrplot)
citation("corrplot")
```

## Basic example
```r
library(corrplot)
M <- cor(mtcars)
corrplot(M, order = "hclust", addrect = 2)
```
![Basic example](https://raw.githubusercontent.com/taiyun/corrplot/master/vignettes/webimg/rectangles-1.png)

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
- [Viliam Simko](https://github.com/vsimko)
- [Taiyun Wei](https://github.com/taiyun)

## License
This package is free and open source software, licensed under MIT

## Other links
- Corrplot listed at OpenHub: https://www.openhub.net/p/corrplot
- Research software impact of Corrplot (by Depsy): http://depsy.org/package/r/corrplot
- CRAN: http://cran.r-project.org/web/packages/corrplot

### Additional development dependendencies
In order to develop the corrplot package, you might want to install the following dependencies on Ubuntu-based systems. These are mostly needed for generating the vignette.

```sh
sudo apt-get install libxml2-dev
sudo apt-get install libcurl4-openssl-dev
sudo apt-get install texlive-latex-base
sudo apt-get install texlive-latex-extra
sudo apt-get install texlive-fonts-recommended
sudo apt-get install texlive-extra-utils
sudo apt-get install librsvg2-bin
sudo apt-get install libmagick++-dev
```

```r
install.packages("lintr")
install.packages("testthat")
install.packages("roxygen2")
install.packages("magick")

base64enc, rmarkdown, tinytex
```
