// Use Euler method to calculate derivative
//
#include "fcu_room_wall.h"

// timer
static VSTimer_t t;

// Wall
static const double rhoWall = 1312.0; 
static const double cWall = 1360.71; 
static const double lambda_Wall = 0.1; 
static const double lWall = 0.03; 
static const double aWall = 60.0; 
static const double hi = 8.33; 
static const double ho = 33.33; 
static const double TisurfInit = 16.0; 
static const double TosurfInit = 10.0;
static double Tisurf_dot = 0; 
static double Tosurf_dot = 0;

static double R = 0;  
static double C = 0;  

static double OAT_in = 0;  

// interfaces between wall and room
static double Tisurf = 0;
static double Tosurf = 0;
static double RAT_out = 0;


// Wall
//
void fcu_wall_inputs (double OAT)
{
	OAT_in = OAT;
}

void fcu_wall_Step()
{
	Tisurf_dot = ((hi * aWall * (RAT_out - Tisurf) + (Tosurf - Tisurf) / R) / C); 
	Tosurf_dot = ((ho * aWall * (OAT_in - Tosurf) + (Tisurf - Tosurf) / R) / C);
}

void fcu_wall_Output()
{
	Tisurf = Tisurf + Tisurf_dot * 1;  // 1000ms = 1s every step
	Tosurf = Tosurf + Tosurf_dot * 1;
}


// Room
//
static const double mdotwt=0.1;
static const double LWT=40.0;
static const double eps=0.4;
static const double cWater=4181.0;
static const double Awall=60.0;
static const double hAir=4.0;
static const double mdotat=0.5;
static const double rohAir=1.204;
static const double vAir=300.0;
static const double cAir=1012.0;
static const double RATinit=16.0;
static const double voInit=0.0001;
static const double fsInit=0.0001;
// variables
static double DT=0;
static double mdotw=0;
static double mdota=0;
static double EWT=0;
static double Qin_dot=0;
static double Qout_dot=0;
static double SAT=0;
static double RAT_dot=0;
static double totalEnergyOut=0;
static double fs = 0;
static double vo = 0;

//
void fcu_room_inputs (double fanspeed, double valveopen)
{
	if(fanspeed > 0) 
		fs = fanspeed;
	else 
		fs = fsInit;

	if(valveopen > 0) 
		vo = valveopen;
	else 
		vo = voInit;
}

void fcu_room_Step()
{
	Qin_dot=eps*mdotat*fs*cAir*(LWT-RAT_out);
	Qout_dot=hAir*Awall*(RAT_out-Tisurf);
	DT=Qin_dot-Qout_dot;
	RAT_dot=DT/(rohAir*cAir*vAir);
}

void fcu_room_Output()
{
	mdota=fs*mdotat;
	mdotw=vo*mdotwt;
	totalEnergyOut=totalEnergyOut+Qin_dot*1;
	RAT_out=RAT_out+RAT_dot*1;
	EWT=LWT-(Qin_dot/(vo*mdotwt*cWater));
	SAT=(Qin_dot/(mdota*cAir))+RAT_out;
}

//
static double oldOAT = 0;
static double oldFanSpeed = 0;
static double oldValveOpen = 0;
static double oldRAT_out = 0;
	
// Room and Wall
void fcu_room_wall_init(double *RAT_init)
{
    reset(&t);
	R = lWall / (lambda_Wall * aWall); 
	C = rhoWall * cWall * lWall * aWall / 2.0;

	Tisurf = TisurfInit;
	Tosurf = TosurfInit;
	RAT_out = RATinit;
	*RAT_init = RATinit;
	oldRAT_out = RATinit;
	
	fs = fsInit;
	vo = voInit;
}

	
void fcu_room_wall_Step(double OAT, double fanspeed, double valveopen, double *RAT)
{
    if(OAT != oldOAT || fanspeed != oldFanSpeed || valveopen != oldValveOpen)
    {
        oldOAT = OAT; oldFanSpeed = fanspeed; oldValveOpen = valveopen;
        dbg_printf("fcu_room_wall_Step >> OAT:%f, fanspeed:%f, valveopen:%f, RAT_out:%f\n", 
            OAT, fanspeed, valveopen, oldRAT_out);
    }


    if(!elapsed(&t, __ms(1000))) 
	{
		*RAT = oldRAT_out;
		dbg_printf("fcu_room_wall_Step << RAT_out:%f\n", *RAT);
		return;
	}

    reset(&t);

	// wall
	fcu_wall_inputs(OAT);
	fcu_wall_Step();
	fcu_wall_Output();

	// room
	fcu_room_inputs(fanspeed, valveopen);
	fcu_room_Step();
	fcu_room_Output();

	*RAT = RAT_out;
	oldRAT_out = RAT_out;

    dbg_printf("fcu_room_wall_Step << RAT_out:%f\n", *RAT);
}
