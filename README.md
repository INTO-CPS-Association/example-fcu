# case-study_fcu

## Example Description

This example is inspired by the Heating Ventilation and Air Conditioning (HVAC) case study developed in Task T1.3. The Fan Coil Unit (FCU) aims to control the  air temperature in a room through the use of several physical components and software controllers. Water is heated or cooled in a *Heat Pump* and flows to the *Coil*. A *Fan* blows air through the *Coil*. The air is heated or cooled depending upon the *Coil* temperature, and flows into the room. A *Controller* is able to alter the fan speed and the rate of the water flow from the *Heat Pump* to the *Coil*.  In addition, the room temperature is affected by the walls and windows, which constitute the environment of the FCU.

The aim of the system is to maintain a set temperature in the single room in which the FCU is located.

## INTO-CPS Technology

The demonstration on INTO-CPS technologies with the FCU example concentrates on the INTO-CPS SysML profile below.

### INTO-CPS SysML Profile

#### 3-model Version

Two versions of the FCU model are defined using the INTO-CPS SysML profile. The first corresponds to the architecture used in the baseline OpenModelica and Crescendo models. In this version, three constituent parts are defined: the *RoomHeating* subsystem, a *Controller* cyber component and the physical *Environment*. The first is a continuous subsystem and comprises the *Room* and *Wall* components.  The figure defines the model platform to be 20-sim, however, this could be OpenModelica too. All of the physical elements of the system are contained in a single CT model. The controller subsystem is a cyber element and modelled in VDM-RT.

The connections between components, are similar to those in the baseline CT models, although it should be noted that the subsystem hierarchy is shown, with the *Room* component supplying and receiving the flows of the *RoomHeating* subsystem. The connections between CT and DE models show the interface that is managed during the co-simulation. Specifically, the room air temperature (*RAT*) from the CT system is communicated to the controller, which sets the fan speed *fanSpeed* and the valve open state *valveOpen* used by the Room component model *r*, with the aim of achieving the room air temperature set point *RATSP* provided by the user in the *Environment*. 

#### 4-model Version

Moving to a more 'pure' multi-modelling approach, the next model proposes an alternative subsystem structure. In this model, the ASD shows the HeatingSystem comprises four subsystems; the components comprising the *RoomHeating* subsystem defined above are lifted to be top-level components in their own right. 

This is reflected in the CD, with direct connections between the elements. Each of the CT components (*Room*, *Wall* and *Environment*) may now be modelled in different notations.


### Models

#### Models - 3-model version

#### Models - 4-model version



### Multi-model

#### Configuration - 3-model version

{
    "fmus":{
        "{controllerFMU}":"../FCU/FCUController.fmu?,
        "{roomheatingFMU}":"../FCU/RoomHeating.fmu",
        "{environmentFMU}":"../FCU/Environment"
    },
    "connections":{
        "{environmentFMU}.env.RAT_OUT":["{controllerFMU}.controller.RATSP"],
        "{environmentFMU}.env.OAT_OUT":["{roomheatingFMU}.room.OAT"],
        "{controllerFMU}.controller.valveOpen":["{roomheatingFMU}.room.valveopen"],
        "{controllerFMU}.controller.fanSpeed":["{roomheatingFMU}.room.fanspeed"],
        "{roomheatingFMU}.room.RAT":["{controllerFMU}.controller.RAT"]
    },
    "parameters":{
    },
    "algorithm":{
        "type":"fixed-step",
        "size":0.005
    }
}

#### Configuration - 4-model version

{
	"fmus":{
		"{controllerFMU}":"../FCU/FCUController.fmu",
		"{roomFMU}":"../FCU/Room.fmu",
		"{wallFMU}":"../FCU/Wall.fmu",
		"{environmentFMU}":"../FCU/Environment.fmu"
	},
	"connections":{
		"{environmentFMU}.env.RAT_OUT":["{controllerFMU}.controller.RATSP"],
		"{environmentFMU}.env.OAT_OUT":["{wallFMU}.wall.OAT"],
		"{wallFMU}.wall.Tisurf":["{roomFMU}.room.Tisurf"],
		"{roomFMU}.room.RAT":["{wallFMU}.wall.RAT"],
		"{roomFMU}.room.RAT":["{controllerFMU}.controller.RAT"],
		"{controllerFMU}.controller.valveOpen":["{roomFMU}.room.valveopen"],
		"{controllerFMU}.controller.fanSpeed":["{roomFMU}.room.fanspeed"]
	},
	"parameters":{
	},
	"algorithm":{
		"type":"fixed-step",
		"size":0.005
	}
}


### Co-simulation

### Analyses and Experiments
