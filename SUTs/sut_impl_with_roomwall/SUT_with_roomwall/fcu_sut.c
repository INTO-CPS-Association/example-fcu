#include "trace.h"
#include "fcu_ctrl.h"
#include "fcu_sut.h"

/** Initialize SUT */
void sut_init()
{
	dbg_init("sut.log");
	fcu_ctrl_init();
}

void sut_run(double RAT, double RATSP, double* fanSpeed, double *valveOpen)
{
	//
	fcu_ctrl_Step(RATSP, RAT, fanSpeed, valveOpen);
}
