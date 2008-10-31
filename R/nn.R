# ===============================
# NEAR NEIGHBOUR FINDER
# ===============================

nn <- function(data, mask=seq(from=1, to=1, length=(length(data[1,])-1)), p=10)
{
	# Coerce to a data.frame
	if(is.data.frame(data) == FALSE)
		data <- data.frame(data)
	
	# Check that this is an input/output dataset
	if(length(data[1,]) <= 1)
		stop("Please make this an input/output dataset.")	
		
	num.inputs 	<- sum(mask)
	num.cols	<- length(data[1,])
	dimension	<- length(data[1,])
	M		    <- length(data[,1])
	
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

