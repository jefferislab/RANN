//----------------------------------------------------------------------
//	File:		bd_search.cc
//	Programmer:	David Mount
//	Last modified:	03/04/98 (Release 0.1)
//	Description:	Standard bd-tree search
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

#include "bd_tree.h"			// bd-tree declarations
#include "kd_search.h"			// kd-tree search declarations

//----------------------------------------------------------------------
//  Approximate searching for bd-trees.
//	See the file kd_search.cc for general information on the
//	approximate nearest neighbor search algorithm.  Here we
//	include the extensions for shrinking nodes.
//----------------------------------------------------------------------

//----------------------------------------------------------------------
//  bd_shrink::ann_search - search a shrinking node
//----------------------------------------------------------------------

void ANNbd_shrink::ann_search(ANNdist box_dist)
{
						// check dist calc term cond.
    if (ANNmaxPtsVisited && ANNptsVisited > ANNmaxPtsVisited) return;

    ANNdist inner_dist = 0;			// distance to inner box
    for (int i = 0; i < n_bnds; i++) {		// is query point in the box?
	if (bnds[i].out(ANNkdQ)) {		// outside this bounding side?
						// add to inner distance
	    inner_dist = (ANNdist) ANN_SUM(inner_dist, bnds[i].dist(ANNkdQ));
	}
    }
    if (inner_dist <= box_dist) {		// if inner box is closer
	child[IN]->ann_search(inner_dist);	// search inner child first
	child[OUT]->ann_search(box_dist);	// ...then outer child
    }
    else {					// if outer box is closer
	child[OUT]->ann_search(box_dist);	// search outer child first
	child[IN]->ann_search(inner_dist);	// ...then outer child
    }
    FLOP(3*n_bnds)				// increment floating ops
    SHR(1)					// one more shrinking node
}
