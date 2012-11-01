\name{nn}
\alias{nn}
\alias{nn2}
\title{Nearest Neighbour Search}
\usage{
  nn(data, mask = rep.int(1, times = ncol(data) - 1),
    p = min(10, nrow(data)))

  nn2(data, query, k = min(10, nrow(data)),
    treetype = c("kd", "bd"),
    searchtype = c("standard", "priority", "radius"),
    radius = 0, eps = 0)
}
\arguments{
  \item{data}{An input-output dataset. FOR nn THE OUTPUT
  MUST BE IN THE RIGHT MOST COLUMN OF A DATA FRAME OR
  MATRIX. nn2 uses ALL columns.}

  \item{query}{nn2: A set of points that will be queried
  against data - must have same number of columns.}

  \item{mask}{nn: A vector of 1's and 0's representing
  input inclusion/exclusion. The default mask is all 1's
  (i.e. include all inputs in the test).}

  \item{p}{nn:The maximum number of near neighbours to
  compute. The default value is set to 10.}

  \item{k}{nn2:The maximum number of near neighbours to
  compute. The default value is set to 10.}

  \item{treetype}{nn2: Either the standard kd tree or a bd
  (box-decomposition, AMNSW98) tree which may perform
  better for larger point sets}

  \item{searchtype}{nn2: See details}

  \item{radius}{nn2: radius of search for
  searchtype='radius'}

  \item{eps}{nn2: error bound: default of 0.0 implies exact
  nearest neighbour search}
}
\value{
  A list of length 2 with elements, nn.idx and nn.dists
  \item{nn.idx}{A MxP data.frame returning the near
  neighbour indexes.} \item{nn.dists}{A MxP data.frame
  returning the near neighbour Euclidean distances.}
}
\description{
  Uses a kd-tree to find the p number of near neighbours
  for each point in an input/output dataset. The advantage
  of the kd-tree is that it runs in O(M log M) time.
}
\details{
  The algorithm itself works by calculating the nearest
  neighbour distances in input space. This calculation is
  achieved in O(N log N) time, where N is the number of
  data points using Bentley's kd-tree. The \code{RANN}
  package utilizes the Approximate Near Neighbor (ANN) C++
  library, which can give the exact near neighbours or (as
  the name suggests) approximate near neighbours to within
  a specified error bound. We use EXACT near neighbours in
  \code{nn} but \code{nn2} provides options for approximate
  searches. For more information on the ANN library please
  visit \url{http://www.cs.umd.edu/~mount/ANN/}.

  Search types: \code{priority} visits cells in increasing
  order of distance from the query point, and hence, should
  converge more rapidly on the true nearest neighbour, but
  standard is usually faster for exact searches.
  \code{radius} only searches for neighbours within a
  specified radius of the point.  If there are no
  neighbours then nn.idx will contain 0 and nn.dists will
  contain 1.340781e+154 for that point.
}
\examples{
# A noisy sine wave example
x1 <- runif(100, 0, 2*pi)
x2 <- runif(100, 0,3)
e  <- rnorm(100, sd=sqrt(0.075))
y <- sin(x1) + 2*cos(x2) + e
DATA <- data.frame(x1, x2, y)
nearest <- nn(DATA)
}
\author{
  Original nn code by Samuel E. Kemp. nn2 and updates by
  Gregory Jefferis.

  jefferis
}
\references{
  Bentley J. L. (1975), Multidimensional binary search
  trees used for associative search. Communication ACM,
  18:309-517.

  Arya S. and Mount D. M. (1993), Approximate nearest
  neighbor searching, Proc. 4th Ann. ACM-SIAM Symposium on
  Discrete Algorithms (SODA'93), 271-280.

  Arya S., Mount D. M., Netanyahu N. S., Silverman R. and
  Wu A. Y (1998), An optimal algorithm for approximate
  nearest neighbor searching, Journal of the ACM, 45,
  891-923.
}
\keyword{nonparametric}

