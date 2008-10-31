# ===============================
# NEAR NEIGHBOUR FINDER
# ===============================

nn <- function(data, mask=rep.int(1, times=ncol(data)-1), p=min(10,nrow(d))
{
	# Coerce to matrix form
	if(!is.matrix(data))
		data <- data.matrix(data)
	
	# Check that this is an input/output dataset
	if(ncol(data) <= 1)
		stop("Please make this an input/output dataset.")	

	if(p>nrow(d))
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
		
    # now put the returned vector into an (M x p) array
    nn.indexes  <- array(dim=c(M, p))
    nn.dist     <- array(dim=c(M, p))
    output.dist <- array(dim=c(M, p))
    ptr        <- 1
    for(i in 1 : M)
    {
        for(j in 1 : p)
        {
            nn.indexes[i,j]  <- results$nn.idx[ptr]
            nn.dist[i,j]     <- (results$nn[ptr])
            ptr <- ptr + 1
        } # end inner for
    } # end outer for

    return(list(nn.idx=data.frame(nn.indexes), nn.dists=data.frame(nn.dist)))
}

