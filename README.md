# RANN [![Build Status](https://travis-ci.org/jefferis/RANN.svg)](https://travis-ci.org/jefferis/RANN)

Finds the k nearest neighbours for every point in a given dataset
in O(N log N) time using Arya and Mount's ANN library (v1.1.3). There is
support for approximate as well as exact searches, fixed radius searches,
bd as well as kd trees, and different metrics (currently Euclidean (L2) and Manhattan (L1)).

For further details on the underlying ANN library, see http://www.cs.umd.edu/~mount/ANN.

## Support for the Manhattan metric [![Build Status for RANN1](https://travis-ci.org/jefferis/RANN.svg?branch=master-L1)](https://travis-ci.org/jefferis/RANN)

For technical reasons it is necessary to install the `RANN1` package
in order to use the Manhattan metric.  This package is maintained in the
[`master-L1` branch](https://github.com/jefferis/RANN/tree/master-L1) of this repository.
If the Manhattan metric is requested via `RANN::nn2(..., metric = "manhattan")`,
the call will be forwarded internally to `RANN1`.

## Installation
### Released versions
The recommendation is to install the released version from [CRAN](http://cran.r-project.org/) by doing:

```r
install.packages("RANN")
```

In order to use the Manhattan metric, you also need to install the `RANN1` package:

```r
install.packages("RANN1")
```

### Bleeding Edge
You can, however, download the [tar ball](https://github.com/jefferis/RANN/tarball/master), and run `R CMD INSTALL` on it.  (Also download the [`RANN1` tar ball](https://github.com/jefferis/RANN/tarball/master-L1) for the Manhattan metric.)
Alternatively, you can use the **devtools** package to install the development version:

```r
# install.packages("devtools")

devtools::install_github("jefferis/RANN")
devtools::install_github("jefferis/RANN@master-L1") # for the Manhattan metric
```

Note: Windows users need [Rtools](http://www.murdoch-sutherland.com/Rtools/) and [devtools](http://CRAN.R-project.org/package=devtools) to install this way.

## Feedback
Please feel free to:

* submit suggestions and bug-reports at: <https://github.com/jefferis/RANN/issues>
* send pull requests after forking: <https://github.com/jefferis/RANN/>
* e-mail the maintainer: <jefferis@gmail.com>

## Copyright and License
see [inst/COPYRIGHT](inst/COPYRIGHT) and [DESCRIPTION](DESCRIPTION) files for copyright and license information.
