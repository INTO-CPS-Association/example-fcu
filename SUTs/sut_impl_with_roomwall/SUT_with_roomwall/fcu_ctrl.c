#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <sys/types.h>
#include "fcu_ctrl.h"
#include "time1.h"

const float K = 50.0;
const float Td = 0.1;
const float N = 10;
const float Ti = 5000;
const float b = 1;
const float c = 1;
const float sampletime = 1;
const float max_control = 20.0;
const float min_control = 0.0000001;

static double err = 0;
static double factor = 0;
static double uDin = 0;
static double uP = 0;
static double uD = 0;
static double uI = 0;
static double control = 0.1;
//static double MV = 0;
//static double totaluI = 0;
static double preUI = 0;
//static double totaluDin = 0;
static double preuDin = 0;

static VSTimer_t t;

FILE *f = NULL;

/** Initialize SUT */
void fcu_ctrl_init ()
{
    reset(&t);
}

static int nr_of_called = 0;

static double oldcontrol = 0;
static double oldRAT = 0;
static double oldRATSP = 0;
static BOOLEAN firstCall = 1;

double limit_control(double c)
{
	if(c > max_control)
		return max_control;
	else if (c < min_control)
		return min_control;
	else 
		return c;
}

void fcu_ctrl_Step(double RATSP, double RAT, double *fanSpeed, double *valveOpen)
{
    struct timeval now;
    ti_gettimeofday( &now, NULL );
    long long t1 = now.tv_sec * 1000000 + now.tv_usec;
    
    if(RAT != oldRAT || RATSP != oldRATSP)
    {
        oldRAT = RAT; oldRATSP = RATSP;
        dbg_printf("fcu_ctrl_Step >> [%d] at (%lld), RAT:%f, RATSP:%f, err:%f, factor:%f, uP:%f, uI:%f, uD:%f, control:%f, \n", 
            nr_of_called, t1, RAT, RATSP, err, factor, uP, uI, uD, oldcontrol);
    }
    
/*    if(firstCall) 
    {
        if(!elapsed(&t, __ms(1002))) 
        {
            *fanSpeed = oldcontrol;
            *valveSpeed = oldcontrol;
            return;
        }
    }
    else 
    {
        if(!elapsed(&t, __ms(1000))) 
        {
            *fanSpeed = oldcontrol;
            *valveSpeed = oldcontrol;
            return;
        }
    }
	*/

    if(!elapsed(&t, __ms(1000))) 
    {
        *fanSpeed = oldcontrol;
        *valveOpen = oldcontrol;
		dbg_printf("fcu_ctrl_Step << [%d] at (%lld),  \n", nr_of_called, t1);
        return;
    }
    
	nr_of_called++;
    firstCall = 0;
    reset(&t);
    err = RATSP - RAT;
    factor = Td/(sampletime + (Td/N));
    uP = K*(b*RATSP - RAT);

    if (RATSP > 1)
        uI = preUI + sampletime * (K * err/Ti);
    else
        uI = 0;
    preUI = uI;

    uDin = c*RATSP-RAT;
    uD = factor * (uD/N + K *(uDin - preuDin));
    preuDin = uDin;

    control = uP + uI + uD;
	control = limit_control(control);
	
    *fanSpeed = control;
    *valveOpen = control;
    oldcontrol = control;
    
    dbg_printf("fcu_ctrl_Step << [%d] at (%lld), RAT:%f, RATSP:%f, err:%f, factor:%f, uP:%f, uI:%f, uD:%f, control:%f,%f, \n", 
        nr_of_called, t1, RAT, RATSP, err, factor, uP, uI, uD, (uP+uI+uD), control);
    fflush(f);
    return;
}
