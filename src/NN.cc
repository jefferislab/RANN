#include <math.h>    // math routines
#include "ANN.h"     // ANN library header
#include <R.h>       // R header

//------------------------------------------------------------------------------------------------
//				 Near Neighbours Program
//------------------------------------------------------------------------------------------------
extern "C"
{
	void get_NN(double *data, int *mask, int *sumMask, int *k, int *dim, int *m_pts, int *nn_index,
		double *distances)
	{
	int		d;		// Actual Dimension
	int		M;		// Number of Data points
	double		error_bound;	// enough said!
	int		numNN;		// Max. num of NN
	ANNpointArray	data_pts;	// Data points
	ANNpointArray	output_pts;	// Query point
	ANNidxArray	nn_idx;		// Near neighbor indices
	ANNdistArray	dists;		// Near neighbor distances
	ANNkd_tree	*the_tree;	// Search structure

	d		= *dim;
	M		= *m_pts;
	numNN		= *k;
	error_bound 	= 00.00;
	
	output_pts 	= annAllocPts(M, 1);		// Allocate query point
	data_pts 	= annAllocPts(M, *sumMask);	// Allocate data points
	// NB +1 is to allow for return of the point itself which will be
	// the nearest neighbour with v1.1.1 of the ANN library
	nn_idx 		= new ANNidx[numNN+1];		// Allocate near neigh indices
	dists 		= new ANNdist[numNN+1];		// Allocate near neighbor dists

	int incOutputData 	= (d-1)*M;
	int d_ptr[d-1];
	int ptr = 0;

	// Next 2 for loops are concerned with getting the linear R array into the ANN format
	for(int i = 0; i < d-1; i++)
	{
		d_ptr[i] = 0;
		d_ptr[i] = i*M;
	} // end for

	for(int i = 0; i < M; i++) // now construct the points
	{
		ANNpoint p = new ANNcoord[*sumMask];
		int myJ = 0;
		for(int j = 0; j < d-1; j++)
		{
			int temp = d_ptr[j];

			if(mask[j] == 1)
			{
				p[myJ] = 00.00;
				p[myJ] = data[temp];
				myJ++;
			}

			d_ptr[j] = 0;
			d_ptr[j] = temp + 1;
		} // end inner for loop

		data_pts[i] = p;
		ANNpoint o;
		o = new ANNcoord[1];
		o[0] = data[incOutputData];
		output_pts[i] = o;
		incOutputData++;
	} // end for

	the_tree = new ANNkd_tree(	// Build search structure
			data_pts,		// The data points
			M,			// Number of points
			*sumMask);		// Dimension of space

	for(int i = 0; i < M; i++)	// read query points
	{
		the_tree->annkSearch(	// search
			data_pts[i],	// query point
			numNN+1,		// number of near neighbors
			nn_idx,		// nearest neighbors (returned)
			dists,		// distance (returned)
			error_bound);	// error bound

		for (int j = 1; j <= numNN; j++)
		{
			distances[ptr] = sqrt(dists[j]);	// unsquare distance
			nn_index[ptr]  = nn_idx[j] + 1;			// put indexes in returned array
			ptr++;
		} // end inner for
	} // end for

	// Do a little bit of memory management......
	delete data_pts;
	delete output_pts;
	delete nn_idx;
	delete dists;
	delete the_tree;
	}
	
	void get_NN_2Set(double *data, double *query, int *D, int *ND, int *NQ, int *K, double *EPS,
		int *nn_index, double *distances)
	{
	int		d = *D;			// Number of Dimensions for points
	int		nd = *ND;		// Number of Data points
	int		nq= *NQ;		// Number of Query points
	int		k = * K;		// Maximum number of Nearest Neighbours

	double	error_bound = *EPS;;	// enough said!

	ANNkd_tree	*the_tree;	// Search structure

	ANNpointArray data_pts 	= annAllocPts(nd,d);		// Allocate data points
	ANNidxArray nn_idx 		= new ANNidx[k];		// Allocate near neigh indices
	ANNdistArray dists 		= new ANNdist[k];		// Allocate near neighbor dists

	int d_ptr[d];
	int ptr = 0;
	
	// Next 2 for loops are concerned with getting the linear R array into the ANN format
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

	the_tree = new ANNkd_tree(	// Build search structure
			data_pts,		// The data points
			nd,			// Number of points
			d);		// Dimension of space

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
		
		the_tree->annkSearch(	// search
			pq,	// query point
			k,		// number of near neighbors
			nn_idx,		// nearest neighbors (returned)
			dists,		// distance (returned)
			error_bound);	// error bound

		for (int j = 0; j < k; j++)
		{
			distances[ptr] = sqrt(dists[j]);	// unsquare distance
			nn_index[ptr++]  = nn_idx[j] + 1;			// put indexes in returned array
		}
	}

	// Do a little bit of memory management......
	annDeallocPt(pq);
	annDeallocPts(data_pts);
	delete [] nn_idx;
	delete [] dists;
	delete the_tree;
	}
}

