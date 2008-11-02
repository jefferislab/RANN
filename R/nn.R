# ===============================
# NEAR NEIGHBOUR FINDER
# ===============================

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
		nn       = double(p*M), PACKAGE="knnFinder")
		
	# now put the returned vectors into (M x p) arrays
	nn.indexes=matrix(results$nn.idx,ncol=p,byrow=TRUE)
	nn.dist=matrix(results$nn,ncol=p,byrow=TRUE)

	return(list(nn.idx=data.frame(nn.indexes), nn.dists=data.frame(nn.dist)))
}

nn2 <- function(data, query, k=min(10,nrow(data)),searchtype=c("standard","priority"),eps=0.0)
{
	dimension	<- ncol(data)
	ND		    <- nrow(data)
	NQ		    <- nrow(query)
	
	# Check that both datasets have same dimensionality
	if(ncol(data) != ncol(query) )
		stop("Query and data tables must have same dimensions")	

	if(k>ND)
		stop("Cannot find more nearest neighbours than there are points")
		
	searchtype=match.arg(searchtype)

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
		as.integer(searchtype=="priority"), 
		nn.idx   = integer(k*NQ),
		nn       = double(k*NQ), PACKAGE="knnFinder")
		
	# now put the returned vectors into (nq x k) arrays
	nn.indexes=matrix(results$nn.idx,ncol=k,byrow=TRUE)
	nn.dist=matrix(results$nn,ncol=k,byrow=TRUE)

	return(list(nn.idx=nn.indexes, nn.dists=nn.dist))
}
