#include <cstdlib>						// C standard lib defs
#include <iomanip>				// I/O manipulators
#include <cmath>			// math includes
#include <iostream>			// I/O streams
#include <cstring>			// C-style strings

#ifdef RANN
#include <R.h>				// R headers for error handling
#endif


namespace ann2 {

#include "vendor/ann/ANN.cpp"
#include "vendor/ann/bd_fix_rad_search.cpp"
#include "vendor/ann/bd_pr_search.cpp"
#include "vendor/ann/bd_search.cpp"
#include "vendor/ann/bd_tree.cpp"
#include "vendor/ann/brute.cpp"
#include "vendor/ann/kd_dump.cpp"
#include "vendor/ann/kd_fix_rad_search.cpp"
#include "vendor/ann/kd_pr_search.cpp"
#include "vendor/ann/kd_search.cpp"
#include "vendor/ann/kd_split.cpp"
#include "vendor/ann/kd_tree.cpp"
#include "vendor/ann/kd_util.cpp"

}
