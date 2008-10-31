//----------------------------------------------------------------------
//	File:		perf.cc
//	Programmer:	Sunil Arya and David Mount
//	Last modified:	03/04/98 (Release 0.1)
//	Description:	Methods for performance stats
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

#include "ANN.h"			// basic ANN includes
#include "ANNperf.h"		// performance includes

//----------------------------------------------------------------------
//  Performance statistics
//	The following data and routines are used for computing
//	performance statistics for nearest neighbor searching.
//	Because these routines can slow the code down, they can be
//	activated and deactiviated by defining the PERF variable,
//	by compiling with the option: -DPERF
//----------------------------------------------------------------------

//----------------------------------------------------------------------
//  Global counters for performance measurement
//----------------------------------------------------------------------

int		N_data_pts  = 0;	// number of data points
int		N_visit_lfs = 0;	// number of leaf nodes visited
int		N_visit_spl = 0;	// number of splitting nodes visited
int		N_visit_shr = 0;	// number of shrinking nodes visited
int		N_visit_pts = 0;	// visited points for one query
int		N_coord_hts = 0;	// coordinate hits for one query
int		N_float_ops = 0;	// floating ops for one query
SampStat	visit_lfs;		// stats on leaf nodes visits
SampStat	visit_spl;		// stats on splitting nodes visits
SampStat	visit_shr;		// stats on shrinking nodes visits
SampStat	visit_nds;		// stats on total nodes visits
SampStat	visit_pts;		// stats on points visited
SampStat	coord_hts;		// stats on coordinate hits
SampStat	float_ops;		// stats on floating ops
SampStat	average_err;		// average error
SampStat	rank_err;		// rank error

//----------------------------------------------------------------------
//  Routines for statistics.
//----------------------------------------------------------------------

void reset_stats(int data_size)		// reset stats for a set of queries
{
    N_data_pts  = data_size;
    visit_lfs.reset();
    visit_spl.reset();
    visit_shr.reset();
    visit_nds.reset();
    visit_pts.reset();
    coord_hts.reset();
    float_ops.reset();
    average_err.reset();
    rank_err.reset();
}

void reset_counts()			// reset counts for one query
{
    N_visit_lfs = 0;
    N_visit_spl = 0;
    N_visit_shr = 0;
    N_visit_pts = 0;
    N_coord_hts = 0;
    N_float_ops = 0;
}

void update_stats()			// update stats with current counts
{
    visit_lfs += N_visit_lfs;
    visit_nds += N_visit_spl + N_visit_lfs;
    visit_spl += N_visit_spl;
    visit_shr += N_visit_shr;
    visit_pts += N_visit_pts;
    coord_hts += N_coord_hts;
    float_ops += N_float_ops;
}

					// print a single statistic
void print_one_stat(char *title, SampStat s, double div)
{
    cout << title << "= [ ";
    cout.width(9); cout << s.mean()/div		<< " : ";
    cout.width(9); cout << s.stdDev()/div	<< " ]<";
    cout.width(9); cout << s.min()/div		<< " , ";
    cout.width(9); cout << s.max()/div		<< " >\n";
}

void print_stats(			// print statistics for a run
    ANNbool validate)			// true if average errors desired
{
    cout.precision(4);			// set floating precision
    cout << "  (Performance stats: "
	 << " [      mean :    stddev ]<      min ,       max >\n";
    print_one_stat("    leaf_nodes       ", visit_lfs, 1);
    print_one_stat("    splitting_nodes  ", visit_spl, 1);
    print_one_stat("    shrinking_nodes  ", visit_shr, 1);
    print_one_stat("    total_nodes      ", visit_nds, 1);
    print_one_stat("    points_visited   ", visit_pts, 1);
    print_one_stat("    coord_hits/pt    ", coord_hts, N_data_pts);
    print_one_stat("    floating_ops_(K) ", float_ops, 1000);
    if (validate) {
    	print_one_stat("    average_error    ", average_err, 1);
    	print_one_stat("    rank_error       ", rank_err, 1);
    }
    cout.precision(6);			// restore the default
    cout << "  )\n";
}
