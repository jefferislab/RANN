# Wrapper for Arya and Mount's Approximate Nearest Neighbours (ANN) C++ library

Finds the k nearest neighbours for every point in a given dataset in O(N
log N) time using Arya and Mount's ANN library (v1.1.3). There is
support for approximate as well as exact searches, fixed radius searches
and 'bd' as well as 'kd' trees. The distance is computed using the L2
(Euclidean) metric. Please see package 'RANN.L1' for the same
functionality using the L1 (Manhattan, taxicab) metric.

## See also

[`nn2`](https://jefferislab.github.io/RANN/reference/nn2.md)

## Author

**Maintainer**: Gregory Jefferis <jefferis@gmail.com>
([ORCID](https://orcid.org/0000-0002-0587-9355))

Authors:

- Samuel E. Kemp

- Sunil Arya ([ORCID](https://orcid.org/0000-0003-0939-4192))
  \[copyright holder\]

- David Mount ([ORCID](https://orcid.org/0000-0002-3290-8932))
  \[copyright holder\]

Other contributors:

- Kirill Müller ([ORCID](https://orcid.org/0000-0002-1416-3412))
  \[contributor\]

- University of Maryland (ANN library is copyright University of
  Maryland and Sunil Arya and David Mount. See file COPYRIGHT for
  details) \[copyright holder\]
