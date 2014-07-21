# ===============================
# NEAR NEIGHBOUR FINDER
# ===============================



#'Nearest Neighbour Search
#'
#'Uses a kd-tree to find the p number of near neighbours for each point in an
#'input/output dataset. The advantage of the kd-tree is that it runs in O(M log
#'M) time.
#'
#'The \code{RANN} package
#'utilizes the Approximate Near Neighbor (ANN) C++ library, which can give the
#'exact near neighbours or (as the name suggests) approximate near neighbours
#'to within a specified error bound.  For more information on the ANN library
#'please visit \url{http://www.cs.umd.edu/~mount/ANN/}.
#'
#'Search types: \code{priority} visits cells in increasing order of distance
#'from the query point, and hence, should converge more rapidly on the true
#'nearest neighbour, but standard is usually faster for exact searches.
#'\code{radius} only searches for neighbours within a specified radius of the
#'point.  If there are no neighbours then nn.idx will contain 0 and nn.dists
#'will contain 1.340781e+154 for that point.
#'
#'@param data A data frame or matrix where each row is a point.
#'@param query A set of points that will be queried against data - must
#'have same number of columns. If missing, uses data.
#'@param k The maximum number of near neighbours to compute. The default
#'value is set to 10.
#'@param treetype Either the standard kd tree or a bd (box-decomposition,
#'AMNSW98) tree which may perform better for larger point sets
#'@param searchtype See details
#'@param radius radius of search for searchtype='radius'
#'@param eps error bound: default of 0.0 implies exact nearest neighbour
#'search
#'@return A list of length 2 with elements, nn.idx and nn.dists
#'\item{nn.idx}{A MxP data.frame returning the near neighbour indexes.}
#'\item{nn.dists}{A MxP data.frame returning the near neighbour Euclidean distances.}
#'@author Gregory Jefferis based on earlier code by Samuel E. Kemp (knnFinder package)
#'@references Bentley J. L. (1975), Multidimensional binary search trees used
#'for associative search. Communication ACM, 18:309-517.
#'
#'Arya S. and Mount D. M. (1993), Approximate nearest neighbor searching, Proc.
#'4th Ann. ACM-SIAM Symposium on Discrete Algorithms (SODA'93), 271-280.
#'
#'Arya S., Mount D. M., Netanyahu N. S., Silverman R. and Wu A. Y (1998), An
#'optimal algorithm for approximate nearest neighbor searching, Journal of the
#'ACM, 45, 891-923.
#'@keywords nonparametric
#'@examples
#'
#'x1 <- runif(100, 0, 2*pi)
#'x2 <- runif(100, 0,3)
#'DATA <- data.frame(x1, x2)
#'nearest <- nn2(DATA,DATA)
#'@export
nn2 <- function(data, query=data, k=min(10,nrow(data)),treetype=c("kd","bd"),
                searchtype=c("standard","priority","radius"),radius=0.0,eps=0.0)
{
  dimension	<- ncol(data)
  ND		    <- nrow(data)
  NQ		    <- nrow(query)
  
  # Check that both datasets have same dimensionality
  if(ncol(data) != ncol(query) )
    stop("Query and data tables must have same dimensions")	
  
  if(k>ND)
    stop("Cannot find more nearest neighbours than there are points")
  
  searchtypeInt=pmatch(searchtype[1],c("standard","priority","radius"))
  if(is.na(searchtypeInt)) stop(paste("Unknown search type",searchtype))
  treetype=match.arg(treetype,c("kd","bd"))
  
  # Coerce to matrix form
  if(is.data.frame(data))
    data <- unlist(data,use.names=FALSE)
  
  if(!length(data)) stop("no points in data!")
  
  # Coerce to matrix form
  if(!is.matrix(query))
    query <- unlist(query,use.names=FALSE)
  
  if(!length(query)) stop("no points in query!")
  
  # void get_NN_2Set(double *data, double *query, int *D, int *ND, int *NQ, int *K, double *EPS,
  # int *nn_index, double *distances)
  
  results <- .C("get_NN_2Set",
                as.double(data),
                as.double(query),
                as.integer(dimension),
                as.integer(ND),
                as.integer(NQ),
                as.integer(k),
                as.double(eps),
                as.integer(searchtypeInt), 
                as.integer(treetype=="bd"), 
                as.double(radius*radius),
                nn.idx   = integer(k*NQ),
                nn       = double(k*NQ), PACKAGE="RANN")
  
  # now put the returned vectors into (nq x k) arrays
  nn.indexes=matrix(results$nn.idx,ncol=k,byrow=TRUE)
  nn.dist=matrix(results$nn,ncol=k,byrow=TRUE)
  
  return(list(nn.idx=nn.indexes, nn.dists=nn.dist))
}

#'Defunct functions in RANN package
#'
#'@name RANN-defunct
NULL

#'@details C code underlying nn() contained memory leaks.
#'\code{\link{nn2}} is a more flexible and efficient alternative.
#'@rdname RANN-defunct
#'@param ... Ignored
#'@export
nn<-function(...){
  .Defunct('nn2',package='RANN')
}
