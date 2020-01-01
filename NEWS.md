# RANN (in development)

* switch GitHub repo to jefferislab/RANN

# RANN 2.6.1

* Fix Solaris compile error (as requested by BDR, #25)
* Correct usage for compiler vs preprocessor flags (#26)

# RANN 2.6.0

* remove register key word from libANN code (at request of CRAN, #23)

# RANN 2.5.1

* bug fix wrong result dimensions when query is a vector (#17)
  thanks to github user dayey1
* bug fix: check query vs data dimensions
* register native routines (now a NOTE on R 3.4.0)
* fix CRAN URLs in README

# RANN 2.5.0

* completely remove defunct nn function
* add note in README about new RANN1 package offering Manhattan (L1) metric as
  an alternative to Euclidean (L2) metric. Note that RANN1 is only available on 
  github at the time of writing).
* dev: use ANN_ROOT macro to unsquare distances

# RANN 2.4.1

* fix malformed URL field in DESCRIPTION (K. Hornik)

# RANN 2.4.0

* fix crashing bug when receving N x 0 input matrix
  (thanks to Rajaraman V for bug report)
* doc: correct documentation of return type and other clarifications.
* dev: switch to testthat for tests
* dev: add Travis CI integration (https://travis-ci.org/jefferis/RANN)
* dev: add rstudio project, retire StatET Eclipse project

# RANN 2.3.0

* remove nn() function since underlying get_NN() had memory leaks (noticed by Brian Ripley)
* make nn2() use input data as query when query not specified)
* add Arya and Mount as authors (in accordance with CRAN policies, again BDR)
* add Arya, Mount and University of Maryland in Copyright line
  (in accordance with CRAN policies, again BDR)
* add COPYRIGHT file to make it clear exactly which files are from the ANN
  library and therefore subject to that library's copyright.

# RANN 2.2.1

* fix yet more warnings for CRAN due to presence in ANN of 
  exit(), std:cout and std:cerr

# RANN 2.2.0

* no user-visible changes in theory
* switch to roxygen2 for documentation
* use this to provide a NAMESPACE as requested for CRAN
* and switch from deprecated .First.lib to useDynLib
