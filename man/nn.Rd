\name{nn}
\alias{nn}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Near Neighbour Search}
\description{
  Uses a kd-tree to find the p number of near neighbours for each point in an input/output dataset. The advantage of the kd-tree is that it runs in O(M log M) time.
}
\usage{
nn(data, mask=seq(from=1, to=1, length=(length(data[1,])-1)), p=10)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{data}{An input-output dataset. THE OUTPUT MUST BE IN THE RIGHT MOST COLUMN OF A DATA FRAME OR MATRIX.}
  \item{mask}{A vector of 1's and 0's representing input inclusion/exclusion. The default mask is all
  1's (i.e. include all inputs in the test).}
  \item{p}{The maximum number of near neighbours to compute. The default value is set to 10.}
}
\details{
The algorithm itself works by calculating the nearest neighbour distances in input space. This calculation
is achieved in O(M log M) time, where M is the number of data points using Bentley's kd-tree. The
\code{knnFinder} package utilizes the Approximate Near Neighbor (ANN) C++ library, which can give the exact near
neighbours or (as the name suggests) approximate near neighbours to within a specified error bound. We use EXACT near neighbours in this package. For more
information on the ANN library please visit \url{http://www.cs.umd.edu/~mount/ANN/}.
}
\value{
  \item{nn.idx}{A MxP data.frame returning the near neighbour indexes.}
  \item{nn.dists}{A MxP data.frame returning the near neighbour Euclidean distances.}
}
\references{
Bentley J. L. (1975), Multidimensional binary search trees used for associative
search. Communication ACM, 18:309-517.

Arya S. and Mount D. M. (1993),
Approximate nearest neighbor searching,
Proc. 4th Ann. ACM-SIAM Symposium on Discrete Algorithms (SODA'93), 271-280.

Arya S., Mount D. M., Netanyahu N. S., Silverman R. and Wu A. Y (1998),
An optimal algorithm for approximate nearest neighbor searching,
Journal of the ACM, 45, 891-923.
}

\author{Samuel E. Kemp. To report any bugs or suggestions please email: \email{sekemp@glam.ac.uk}}

\examples{
# A noisy sine wave example
x1 <- runif(100, 0, 2*pi)
x2 <- runif(100, 0,3)
e  <- rnorm(100, sd=sqrt(0.075)) 
y <- sin(x1) + 2*cos(x2) + e
DATA <- data.frame(x1, x2, y)		
nearest <- nn(DATA)
}

\keyword{nonparametric}
