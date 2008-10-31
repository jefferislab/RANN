//----------------------------------------------------------------------
//	File:		bd_tree.h
//	Programmer:	David Mount
//	Last modified:	03/04/98 (Release 0.1)
//	Description:	Declarations for standard bd-tree routines
//----------------------------------------------------------------------
// Copyright (c) 1997-1998 University of Maryland and Sunil Arya and David
// Mount.  All Rights Reserved.
//
// This software and related documentation is part of the
// Approximate Nearest Neighbor Library (ANN).
//
// Permission to use, copy, and distribute this software and its
// documentation is hereby granted free of charge, provided that
// (1) it is not a component of a commercial product, and
// (2) this notice appears in all copies of the software and
//     related documentation.
//
// The University of Maryland (U.M.) and the authors make no representations
// about the suitability or fitness of this software for any purpose.  It is
// provided "as is" without express or implied warranty.
//----------------------------------------------------------------------

#ifndef ANN_bd_tree_H
#define ANN_bd_tree_H

#include "ANNx.h"			// all ANN includes
#include "kd_tree.h"			// kd-tree includes

//----------------------------------------------------------------------
//  bd-tree shrinking node.
//	The main addition in the bd-tree is the shrinking node, which
//	is declared here.
//
//	Shrinking nodes are defined by list of orthogonal halfspaces.
//	These halfspaces define a (possibly unbounded) orthogonal
//	rectangle.  There are two children, in and out.  Points that
//	lie within this rectangle are stored in the in-child, and the
//	other points are stored in the out-child.
//
//	We use a list of orthogonal halfspaces rather than an
//	orthogonal rectangle object because typically the number of
//	sides of the shrinking box will be much smaller than the
//	worst case bound of 2*dim.
//
//	BEWARE: Note that constructor just copies the pointer to the
//	bounding array, but the destructor deallocates it.  This is
//	rather poor practice, but happens to be convenient.  The list
//	is allocated in the bd-tree building procedure rbd_tree() just
//	prior to construction, and is used for no other purposes.
//
//	WARNING: In the near neighbor searching code it is assumed that
//	the list of bounding halfspaces is irredundant, meaning that there
//	are no two distinct halfspaces in the list with the same outward
//	pointing normals.
//----------------------------------------------------------------------

class ANNbd_shrink : public ANNkd_node	// splitting node of a kd-tree
{
    int			n_bnds;		// number of bounding halfspaces
    ANNorthHSArray	bnds;		// list of bounding halfspaces
    ANNkd_ptr		child[2];	// in and out children
public:
    ANNbd_shrink(			// constructor
	int		nb,		// number of bounding halfspaces
	ANNorthHSArray	bds,		// list of bounding halfspaces
	ANNkd_ptr ic=NULL, ANNkd_ptr oc=NULL)	// children
	{
	    n_bnds	= nb;			// cutting dimension
	    bnds	= bds;			// assign bounds
	    child[IN]	= ic;			// set children
	    child[OUT]	= oc;
	}

    ~ANNbd_shrink()			// destructor
	{
	    if (child[IN]!= NULL && child[IN]!=  KD_TRIVIAL) delete child[IN];
	    if (child[OUT]!= NULL&& child[OUT]!= KD_TRIVIAL) delete child[OUT];
	    if (bnds != NULL)
		delete [] bnds;		// delete bounds
	}

    virtual void getStats(			// get tree statistics
		int dim,			// dimension of space
		ANNkdStats &st,			// statistics
		ANNorthRect &bnd_box);		// bounding box
    virtual void print(int level, ostream &out);// print node
    virtual void dump(ostream &out);		// dump node

    virtual void ann_search(ANNdist);		// standard search routine
    virtual void ann_pri_search(ANNdist);	// priority search routine
};

#endif
