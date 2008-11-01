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
	nn_idx 		= new ANNidx[numNN];		// Allocate near neigh indices
	dists 		= new ANNdist[numNN];		// Allocate near neighbor dists

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
			numNN,		// number of near neighbors
			nn_idx,		// nearest neighbors (returned)
			dists,		// distance (returned)
			error_bound);	// error bound

		for (int j = 0; j < numNN; j++)
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
	
	void get_NN_2Set(double *data, double *query, int *K, int *D, int *ND, int *NQ, int *nn_index,
		double *distances)
	{
	int		d = *D;			// Number of Dimensions for points
	int		nd = *ND;		// Number of Data points
	int		nq= *NQ;		// Number of Query points
	int		k = * K;		// Maximum number of Nearest Neighbours

	double	error_bound = 00.00;;	// enough said!

	ANNpointArray	data_pts;	// Data points
	ANNpointArray	query_pts;	// Query point
	ANNidxArray	nn_idx;		// Near neighbor indices
	ANNdistArray	dists;		// Near neighbor distances
	ANNkd_tree	*the_tree;	// Search structure

	query_pts 	= annAllocPts(nq,d);		// Allocate query points
	data_pts 	= annAllocPts(nd,d);		// Allocate data points
	nn_idx 		= new ANNidx[k];		// Allocate near neigh indices
	dists 		= new ANNdist[k];		// Allocate near neighbor dists

	int incOutputData 	= (d-1)*nq;
	int d_ptr[d];
	int ptr = 0;

	
	// Next 2 for loops are concerned with getting the linear R array into the ANN format
	for(int i = 0; i < d; i++)
	{
		d_ptr[i] = i*nd;
	} // end for

	for(int i = 0; i < nd; i++) // now construct the points
	{
		ANNpoint p = new ANNcoord[d];
		for(int j = 0; j < d; j++)
		{
			int temp = d_ptr[j];
			p[j]=data[temp];
			d_ptr[j] = 0;
			d_ptr[j] = temp + 1;
		} // end inner for loop
		data_pts[i] = p;
	} // end for

	the_tree = new ANNkd_tree(	// Build search structure
			data_pts,		// The data points
			nd,			// Number of points
			d);		// Dimension of space

	for(int i = 0; i < d; i++)
	{
		d_ptr[i] = i*nq;
	} // end for
	
	ANNpoint pq = annAllocPt(d);
	for(int i = 0; i < nq; i++)	// read query points
	{
		for(int j = 0; j < d; j++)
		{
			int temp = d_ptr[j];
			pq[j]=query[temp];
			d_ptr[j] = 0;
			d_ptr[j] = temp + 1;
		} // end inner for loop
		
		the_tree->annkSearch(	// search
			pq,	// query point
			k,		// number of near neighbors
			nn_idx,		// nearest neighbors (returned)
			dists,		// distance (returned)
			error_bound);	// error bound

		for (int j = 0; j < k; j++)
		{
			distances[ptr] = sqrt(dists[j]);	// unsquare distance
			nn_index[ptr]  = nn_idx[j] + 1;			// put indexes in returned array
			ptr++;
		} // end inner for
	} // end for

	// Do a little bit of memory management......
	delete data_pts;
	delete query_pts;
	delete nn_idx;
	delete dists;
	delete the_tree;
	}
}

