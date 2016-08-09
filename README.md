# case-study_fcu

## Example Description

This example is inspired by the Heating Ventilation and Air Conditioning (HVAC) case study developed in Task T1.3. The Fan Coil Unit (FCU) aims to control the  air temperature in a room through the use of several physical components and software controllers. Water is heated or cooled in a *Heat Pump* and flows to the *Coil*. A *Fan* blows air through the *Coil*. The air is heated or cooled depending upon the *Coil* temperature, and flows into the room. A *Controller* is able to alter the fan speed and the rate of the water flow from the *Heat Pump* to the *Coil*.  In addition, the room temperature is affected by the walls and windows, which constitute the environment of the FCU.

The aim of the system is to maintain a set temperature in the single room in which the FCU is located.


![Overview of the fan coil unit (FCU) example](src/resources/fcu_overview.png?raw=true "Overview of the fan coil unit (FCU) example")

## INTO-CPS Technology

The demonstration on INTO-CPS technologies with the FCU example concentrates on the INTO-CPS SysML profile below.

### INTO-CPS SysML Profile

#### 3-model Version

Two versions of the FCU model are defined using the INTO-CPS SysML profile. The first corresponds to the architecture used in the baseline OpenModelica and Crescendo models. In this version, three constituent parts are defined: the *RoomHeating* subsystem, a *Controller* cyber component and the physical *Environment*. The first is a continuous subsystem and comprises the *Room* and *Wall* components.  The figure defines the model platform to be 20-sim, however, this could be OpenModelica too. All of the physical elements of the system are contained in a single CT model. The controller subsystem is a cyber element and modelled in VDM-RT.

![Architecture Structure Diagram](src/resources/fcu_sysml_asd.png?raw=true "Architecture Structure Diagram")

The connections between components, are similar to those in the baseline CT models, although it should be noted that the subsystem hierarchy is shown, with the *Room* component supplying and receiving the flows of the *RoomHeating* subsystem. The connections between CT and DE models show the interface that is managed during the co-simulation. Specifically, the room air temperature (*RAT*) from the CT system is communicated to the controller, which sets the fan speed *fanSpeed* and the valve open state *valveOpen* used by the Room component model *r*, with the aim of achieving the room air temperature set point *RATSP* provided by the user in the *Environment*. 

![Connection Diagram](src/resources/fcu_sysml_cd.png?raw=true "Connection Diagram")


#### 4-model Version

Moving to a more 'pure' multi-modelling approach, the next model proposes an alternative subsystem structure. In this model, the ASD shows the HeatingSystem comprises four subsystems; the components comprising the *RoomHeating* subsystem defined above are lifted to be top-level components in their own right. 

![Architecture Structure Diagram](src/resources/fcu_sysml_asd_mm.png?raw=true "Architecture Structure Diagram")

This is reflected in the CD, with direct connections between the elements. Each of the CT components (*Room*, *Wall* and *Environment*) may now be modelled in different notations.

![Connection Diagram](src/resources/fcu_sysml_cd_mm.png?raw=true "Connection Diagram")

### Models

Given the constituent elements identified in the SysML models above, the FCU pilot study comprises several (simulation) models for the 3- and 4-version of the pilots.

#### Models - 3-model version

The 3-model version comprises two 20-sim models: *RoomHeating* which models the elements of the room, walls and FCU; and the physical *Environment* which provides data on the environment temperature and scenario data based on change of room temperature set point. The final constituent element is a *Controller* VDM-RT model.



Currently a single 20-sim model with two blocks is used to generate the *RoomHeating* and *Environment* FMUs. 


The VDM controller model comprises a *Sensor* class provides access to the current room temperature, and a *LimitedActuator* class  provides output for the valveOpen and fanSpeed values. The actuator is limited such that values fall only between the real values 1.0 and 0.0000001.

#### Models - 4-model version

The 4-model version shares the *Environment* and *Controller* with the previous multi-model, splitting the *RoomHeating* model into separate *Room* and *Wall* models. 


### Multi-model

#### 3-model version

The 3-model multi-model comprises 3 FMUs and 5 connections. The 3 FMUs -- FCUController.fmu, RoomHeating.fmu and Environment.fmu -- are exported from the VDM-RT and 20-sim models.  

The connections are as follows: 

- from the *EnvironmentFMUs* **RAT_OUT** port to the *ControllerFMU* **RATSP** port ;
- from the *EnvironmentFMUs* **OAT_OUT** port to the *RoomHeatingFMU* **OAT**;
-from the *ControllerFMUs* **valveOpen** port to the *RoomHeatingFMU* **valveopen**;
- from the *ControllerFMUs* **fanSpeed** port to the *RoomHeatingFMU* **fanspeed**; and
-from the *RoomHeatingFMU* **RAT** port to the *ControllerFMUs* **RAT**.

There are no parameters to set.

#### 4-model version

In the 4-model version of the FCU multi-model there are 4 FMUs and 7 connections. The 4 FMUs -- FCUController.fmu, Room.fmu, Wall.fmu and Environment.fmu -- are exported from the VDM-RT and 20-sim models.  

The connections are as follows: 
- from the *EnvironmentFMUs* **RAT\_OUT** port to the *ControllerFMU* **RATSP** port ;
- from the *EnvironmentFMUs* **OAT\_OUT** port to the *WallFMU* **OAT**;
- from the *WallFMU* **Tisurf** port to the *RoomFMUs* **Tisurf**.
- from the *RoomFMU* **RAT** port to the *WallFMUs* **RAT**.
- from the *RoomFMU* **RAT** port to the *ControllerFMUs* **RAT**.
- from the *ControllerFMUs* **valveOpen** port to the *RoomFMU* **valveopen**; and
- from the *ControllerFMUs* **fanSpeed** port to the *RoomFMU* **fanspeed**.


There are two parameters to set: **lambdaWall** and **rhoWall** which define the wall thermal conductivity and density respectively. These may be adjusted for the purposes of DSE - see below.


### Co-simulation

Co-simulation of the full scenrio (outside air temperature and room set point) has a duration of 6800 seconds. Running the two multi-models produces the same results, as shown below.

![Results](src/resources/fcu_results.png?raw=true "Results")

The results show that the set point (top left) is toggled between 20 and 0, with the fan (and valve) are adjusted to achieve the set point. The bottom right graph shows the ultimate result of the simulation -- that the room air temperature (RAT) meets the set point, maintains that temperature whilst required and then slowly drop in temperature until the set point returns to 20.

### Analyses and Experiments

#### Design Space Exploration