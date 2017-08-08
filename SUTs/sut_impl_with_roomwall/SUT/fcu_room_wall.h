
#ifndef _LFR_ROOM_WALL_H_
#define _LFR_ROOM_WALL_H_

#include "type1.h"
#include "time1.h"
#include "trace.h"

void fcu_room_wall_init(double *RAT_init);
void fcu_room_wall_Step(double OAT, double fanspeed, double valveopen, double *RAT_out);

//
#endif /* _LFR_ROOM_WALL_H_ */
