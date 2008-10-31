//----------------------------------------------------------------------
//	File:		bd_pr_search.cc
//	Programmer:	David Mount
//	Last modified:	03/04/98 (Release 0.1)
//	Description:	Priority search for bd-trees
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
#include "kd_pr_search.h"		// kd priority search declarations

//----------------------------------------------------------------------
//  Approximate priority searching for bd-trees.
//	See the file kd_pr_search.cc for general information on the
//	approximate nearest neighbor priority search algorithm.  Here
//	we include the extensions for shrinking nodes.
//----------------------------------------------------------------------

//----------------------------------------------------------------------
//  bd_shrink::ann_search - search a shrinking node
//----------------------------------------------------------------------

void ANNbd_shrink::ann_pri_search(ANNdist box_dist)
{
    ANNdist inner_dist = 0;			// distance to inner box
    for (int i = 0; i < n_bnds; i++) {		// is query point in the box?
	if (bnds[i].out(ANNprQ)) {		// outside this bounding side?
						// add to inner distance
	    inner_dist = (ANNdist) ANN_SUM(inner_dist, bnds[i].dist(ANNprQ));
	}
    }
    if (inner_dist <= box_dist) {		// if inner box is closer
	if (child[OUT] != KD_TRIVIAL)		// enqueue outer if not trivial
	    ANNprBoxPQ->insert(box_dist,child[OUT]);
	child[IN]->ann_pri_search(inner_dist);	// continue with inner child
    }
    else {					// if outer box is closer
	if (child[IN] != KD_TRIVIAL)		// enqueue inner if not trivial
	    ANNprBoxPQ->insert(inner_dist,child[IN]);
	child[OUT]->ann_pri_search(box_dist);	// continue with outer child
    }
    FLOP(3*n_bnds)				// increment floating ops
    SHR(1)					// one more shrinking node
}
