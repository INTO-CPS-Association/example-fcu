model Wall_OM
  //
  //	Wall Model - modelling the thermal model for the walls inside the room
  //	Input Arguments:
  //		RAT - indoor room air temperature in [C]
  //		OAT - outside air temperature in [C]
  //
  //	Output Arguments:
  //		Tisurf - wall internal surface temperature in [C]
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
  // wall paramters
  parameter Real rhoWall = 1312.0;
  parameter Real cWall = 1360.71;
  parameter Real lambda_Wall = 0.1192;
  parameter Real lWall = 0.03 "wall thickness";
  parameter Real aWall = 60.0 "wall area";
  parameter Real hi = 8.33 "indoor heat transfer coefficient";
  parameter Real ho = 33.33 "outdoor heat transfer coefficient";
  parameter Real TisurfInit = 16.0 "initial internal surface temperature of the wall";
  parameter Real TosurfInit = 10.0 "initial external surface temperature of the wall";
  Real Tosurf(start = TosurfInit) "external surface temperature of the wall";
  Real R "wall resistance";
  Real C "thermal capacity of the wall";
  // model function
  Modelica.Blocks.Interfaces.RealOutput Tisurf(start = TisurfInit) "internal surface temperature of the wall" annotation(Placement(visible = true, transformation(origin = {106, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {104, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput OAT annotation(Placement(visible = true, transformation(origin = {-102, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput RAT annotation(Placement(visible = true, transformation(origin = {-100, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-102, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput lambdaOut annotation(Placement(visible = true, transformation(origin = {108, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {108, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
// wall heat dissipation equations
  R = lWall / (lambda_Wall * aWall);
  C = rhoWall * cWall * lWall * aWall / 2.0;
  der(Tisurf) = (hi * aWall * (RAT - Tisurf) + (Tosurf - Tisurf) / R) / C;
  der(Tosurf) = (ho * aWall * (OAT - Tosurf) + (Tisurf - Tosurf) / R) / C;
  lambdaOut = lambda_Wall;
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), uses(Modelica(version = "3.2.2")));
end Wall_OM;
