#include "trace.h"
#include "fcu_ctrl.h"
#include "fcu_sut.h"
#include "fcu_room_wall.h"

static double RAT = 0;

/** Initialize SUT */
void sut_init()
{
	dbg_init("sut.log");
	fcu_ctrl_init();
	fcu_room_wall_init(&RAT);
}

void sut_run(double OAT, double RATSP, double* RAT_out)
{
	double fanspeed;
	double valveopen;
	//
	//
	fcu_ctrl_Step(RATSP, RAT, &fanspeed, &valveopen);
	//
	// 
	fcu_room_wall_Step(OAT, fanspeed, valveopen, &RAT);
	*RAT_out = RAT;
}
