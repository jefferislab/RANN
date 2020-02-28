#include <cstdlib>						// C standard lib defs
#include <iomanip>				// I/O manipulators
#include <cmath>			// math includes
#include <iostream>			// I/O streams
#include <cstring>			// C-style strings

#include <math.h>    // math routines
#include <R.h>       // R header

namespace ann2 {

#include <ANN/ANN.h> // ANN library header

}

//------------------------------------------------------------------------------------------------
//				 Near Neighbours Program
//------------------------------------------------------------------------------------------------
extern "C"
{
	void get_NN_2Set(double *data, double *query, int *D, int *ND, int *NQ, int *K, double *EPS,
		int *SEARCHTYPE, int *USEBDTREE, double *SQRAD, int *nn_index, double *distances)
	{
	using namespace ann2;
	
	const int d = *D;		// Number of Dimensions for points
	const int nd = *ND;		// Number of Data points
	const int nq= *NQ;		// Number of Query points
	const int k = *K;		// Maximum number of Nearest Neighbours

	const int searchtype = *SEARCHTYPE;
	const bool usebdtree = *USEBDTREE?true:false;

	const double error_bound = *EPS;	// enough said!
	const double sqRad = *SQRAD;		// Squared Radius for rad search
	
	ANNkd_tree	*the_tree;	// Search structure

	ANNpointArray data_pts 	= annAllocPts(nd,d);		// Allocate data points
	ANNidxArray nn_idx 		= new ANNidx[k];		// Allocate near neigh indices
	ANNdistArray dists 		= new ANNdist[k];		// Allocate near neighbor dists

	int *d_ptr = new int[d];
	int ptr = 0;
	
	// set up column offsets for query point matrix (to convert Row/Col major)
	for(int i = 0; i < d; i++)
	{
		d_ptr[i] = i*nd;
	}

	for(int i = 0; i < nd; i++) // now construct the points
	{
		for(int j = 0; j < d; j++)
		{
			data_pts[i][j]=data[ d_ptr[j]++ ];
		}
	}
	
	if(usebdtree){
		the_tree = new ANNbd_tree(	// Build search structure
				data_pts,			// The data points
				nd,					// Number of data points
				d);					// Dimension of space				
	} else {
		the_tree = new ANNkd_tree( data_pts, nd, d);
	}

	// set up offsets for query point matrix (to convert Row / Col major)
	for(int i = 0; i < d; i++)
	{
		d_ptr[i] = i*nq;
	}
	
	ANNpoint pq = annAllocPt(d);
	for(int i = 0; i < nq; i++)	// Run all query points against tree
	{
		// read coords of current query point
		for(int j = 0; j < d; j++)
		{
			pq[j]=query[ d_ptr[j]++ ];
		}
		
		switch(searchtype){
			case 1:
			the_tree->annkSearch(	// search
				pq,	// query point
				k,		// number of near neighbors
				nn_idx,		// nearest neighbors (returned)
				dists,		// distance (returned)
				error_bound);	// error bound			
			break;
			
			case 2:  // Priority search
			the_tree->annkPriSearch(pq, k, nn_idx, dists, error_bound);
			break;
			
			case 3: // Fixed radius search 
			the_tree->annkFRSearch(	pq,	sqRad, k, nn_idx, dists,error_bound);			
			break;
		}		

		for (int j = 0; j < k; j++)
		{
			distances[ptr] = ANN_ROOT(dists[j]);	// unsquare distance
			nn_index[ptr++]  = nn_idx[j] + 1;	// put indices in returned array
		}
	}

	// Do a little bit of memory management......
	annDeallocPt(pq);
	annDeallocPts(data_pts);
	delete [] nn_idx;
	delete [] dists;
	delete [] d_ptr;
	delete the_tree;
	}
}

