# RANN

## Installation
### Released versions
The recommendation is to install the released version from [CRAN](http://cran.r-project.org/) by doing:

```r
install.packages("RANN")
```

### Bleeding Edge
You can, however, download the [tar ball](https://github.com/jefferis/RANN/tarball/master), and run `R CMD INSTALL` on it, or use the **devtools** package to install the development version:

```r
# install.packages("devtools")

library(devtools)
install_github("RANN", "jefferis")
```

Note: Windows users need [Rtools](http://www.murdoch-sutherland.com/Rtools/) and [devtools](http://CRAN.R-project.org/package=devtools) to install this way.
