
#ifndef _LFR_CTRL_H_
#define _LFR_CTRL_H_

#include "type1.h"
#include "time1.h"
#include "trace.h"

void fcu_ctrl_init ();
void fcu_ctrl_Step(double RATSP, double RAT, double *fanspeed, double *valveopen);
//
#endif /* _LFR_CTRL_H_ */
