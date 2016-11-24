model Room_OM
  //
  //	Room Model - modelling the thermal model for a room
  //	Input Arguments:
  //		Tisurf - wall internal surface temperature in [C]
  //		valveopen - heating/cooling coil valve opening position that varies from 0 to 1
  //		fanspeed - fan spend that varies from 0 to 1
  //
  //	Output Arguments:
  //		RAT - indoor room air temperature [C]
  //
  //	files required: None
  //
  //	Author:         UTRC Ireland
  //
  //	Created:        07.08.2015
  //	Last revision:  07.08.2015
  //
  //--------------------------------------------------------------
  // UTC PROPRIETARY – Created at UTRC-I – Contains E.U. data only
  //--------------------------------------------------------------
  //
  //FCU coil parameters
  parameter Real mdotwt = 0.1 "total water flow rate availbale from the heat pump";
  parameter Real LWT = 40.0 "leaving water temperature";
  parameter Real eps = 0.4 "coil effectiveness";
  parameter Real cWater = 4181.0 "specific heat of water";
  parameter Real Awall = 60.0 "wall surface area";
  parameter Real hAir = 4.0 "heat transfer coefficient";
  Real mdotw "water flow rate leaving the valve";
  Real EWT "entering water temperature";
  Real Qin "heat transferred to the air in the coil";
  Real Qout "heat lost through room walls";
  //FCU fan parameters
  parameter Real mdotat = 0.5 "total air flow rate availbale from the fan";
  Real mdota "air flow rate leaving the fan";
  Real SAT "supply air temperature";
  //Room parameters
  //parameter Real R = 0.05 "thermal resistance of the wall";
  parameter Real rohAir = 1.204 "density of air";
  parameter Real vAir = 300.0 "room air volume";
  parameter Real cAir = 1012.0 "specific heat of air";
  parameter Real RATinit = 16.0 "initial room air temperature";
  Real vo(start = 0.0001);
  Real fs(start = 0.0001);
  Real DT(start = 0);
  Modelica.Blocks.Interfaces.RealInput Tisurf "wall internal surface temperature" annotation(Placement(visible = true, transformation(origin = {-98, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-98, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput valveopen annotation(Placement(visible = true, transformation(origin = {-96, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-96, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput fanspeed annotation(Placement(visible = true, transformation(origin = {-98, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput RAT(start = RATinit) annotation(Placement(visible = true, transformation(origin = {104, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {104, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput energy(start = 0) annotation(Placement(visible = true, transformation(origin = {106, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {102, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  vo = if valveopen > 0 then valveopen else 0.0001;
  fs = if fanspeed > 0 then fanspeed else 0.0001;
//coil equations
  Qin = vo * mdotwt * cWater * (LWT - EWT);
  Qin = eps * mdotat * fs * cAir * (LWT - RAT);
  Qin = mdota * cAir * (SAT - RAT);
  mdotw = vo * mdotwt;
//Fan equations
  mdota = fs * mdotat;
//Room equations
  Qout = hAir * Awall * (RAT - Tisurf);
  der(RAT) = DT / (rohAir * cAir * vAir);
  DT = Qin - Qout;
  der(energy) = Qin;
//Requirments Check
  assert(fanspeed >= 0.01, "UTRC-FCU-002: FCU air damper should be opened at least 0.10.", AssertionLevel.warning);
  assert(EWT - LWT <= 5, "UTRC-FCU-001: Difference between EWT and LWT for HP should be less than 5 C", AssertionLevel.warning);
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), uses(Modelica(version = "3.2.2")));
end Room_OM;
