
#ifndef _LFR_SUT_H_
#define _LFR_SUT_H_

#include "type1.h"
#include "time1.h"

/** Initialize SUT */
extern void sut_init();

/** Run SUT (one step) */
extern void sut_run(double OAT, double RATSP, double* RAT_out);

#endif /* _LFR_SUT_H_*/
