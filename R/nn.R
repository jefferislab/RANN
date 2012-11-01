# ===============================
# NEAR NEIGHBOUR FINDER
# ===============================



#'Nearest Neighbour Search
#'
#'Uses a kd-tree to find the p number of near neighbours for each point in an
#'input/output dataset. The advantage of the kd-tree is that it runs in O(M log
#'M) time.
#'
#'The algorithm itself works by calculating the nearest neighbour distances in
#'input space. This calculation is achieved in O(N log N) time, where N is the
#'number of data points using Bentley's kd-tree. The \code{RANN} package
#'utilizes the Approximate Near Neighbor (ANN) C++ library, which can give the
#'exact near neighbours or (as the name suggests) approximate near neighbours
#'to within a specified error bound. We use EXACT near neighbours in \code{nn}
#'but \code{nn2} provides options for approximate searches. For more
#'information on the ANN library please visit
#'\url{http://www.cs.umd.edu/~mount/ANN/}.
#'
#'Search types: \code{priority} visits cells in increasing order of distance
#'from the query point, and hence, should converge more rapidly on the true
#'nearest neighbour, but standard is usually faster for exact searches.
#'\code{radius} only searches for neighbours within a specified radius of the
#'point.  If there are no neighbours then nn.idx will contain 0 and nn.dists
#'will contain 1.340781e+154 for that point.
#'
#'@aliases nn nn2
#'@param data An input-output dataset. FOR nn THE OUTPUT MUST BE IN THE RIGHT
#'MOST COLUMN OF A DATA FRAME OR MATRIX. nn2 uses ALL columns.
#'@param query nn2: A set of points that will be queried against data - must
#'have same number of columns.
#'@param mask nn: A vector of 1's and 0's representing input
#'inclusion/exclusion. The default mask is all 1's (i.e. include all inputs in
#'the test).
#'@param p nn:The maximum number of near neighbours to compute. The default
#'value is set to 10.
#'@param k nn2:The maximum number of near neighbours to compute. The default
#'value is set to 10.
#'@param treetype nn2: Either the standard kd tree or a bd (box-decomposition,
#'AMNSW98) tree which may perform better for larger point sets
#'@param searchtype nn2: See details
#'@param radius nn2: radius of search for searchtype='radius'
#'@param eps nn2: error bound: default of 0.0 implies exact nearest neighbour
#'search
#'@return A list of length 2 with elements, nn.idx and nn.dists
#'\item{nn.idx}{A MxP data.frame returning the near neighbour indexes.}
#'\item{nn.dists}{A MxP data.frame returning the near neighbour Euclidean distances.}
#'@author Original nn code by Samuel E. Kemp. nn2 and updates by Gregory Jefferis.
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
#'# A noisy sine wave example
#'x1 <- runif(100, 0, 2*pi)
#'x2 <- runif(100, 0,3)
#'e  <- rnorm(100, sd=sqrt(0.075)) 
#'y <- sin(x1) + 2*cos(x2) + e
#'DATA <- data.frame(x1, x2, y)		
#'nearest <- nn(DATA)
#'@export
#'@rdname nn
nn <- function(data, mask=rep.int(1, times=ncol(data)-1), p=min(10,nrow(data)))
{
	# Coerce to matrix form
	if(!is.matrix(data))
		data <- data.matrix(data)
	
	# Check that this is an input/output dataset
	if(ncol(data) <= 1)
		stop("Please make this an input/output dataset.")	

	if(p>nrow(data))
		stop("Cannot find more nearest neighbours than there are points")
		
	num.inputs 	<- sum(mask)
	dimension	<- ncol(data)
	M		    <- nrow(data)
	
	results <- .C("get_NN",
		as.matrix(data),
		as.integer(mask),
		as.integer(num.inputs),
		as.integer(p),
		as.integer(dimension),
		as.integer(M),
		nn.idx   = integer(p*M),
		nn       = double(p*M), PACKAGE="RANN")
		
	# now put the returned vectors into (M x p) arrays
	nn.indexes=matrix(results$nn.idx,ncol=p,byrow=TRUE)
	nn.dist=matrix(results$nn,ncol=p,byrow=TRUE)

	return(list(nn.idx=data.frame(nn.indexes), nn.dists=data.frame(nn.dist)))
}

#' @export
#' @rdname nn
#' @author jefferis
nn2 <- function(data, query, k=min(10,nrow(data)),treetype=c("kd","bd"),
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

	# Coerce to matrix form
	if(!is.matrix(query))
		query <- unlist(query,use.names=FALSE)
	
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
