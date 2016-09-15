model Coil
  parameter Real mdontSupWater = 0.2;
  //2;
  parameter Real cWater = 4181;
  parameter Real alphaAir = 100;
  parameter Real aCoil = 0.1;
  //0.5;
  parameter Real initCoilTemp = 10;
  Modelica.Blocks.Interfaces.RealInput waterOutTemp annotation(Placement(visible = true, transformation(origin = {-104, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput RAT annotation(Placement(visible = true, transformation(origin = {-104, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput valvePos annotation(Placement(visible = true, transformation(origin = {-104, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-102, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput waterInTemp annotation(Placement(visible = true, transformation(origin = {-104, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput coilTemp(start = initCoilTemp) annotation(Placement(visible = true, transformation(origin = {-104, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput qCoil annotation(Placement(visible = true, transformation(origin = {108, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  qCoil = valvePos * mdontSupWater * cWater * (waterInTemp - waterOutTemp) - alphaAir * aCoil * (coilTemp - RAT);
  assert(waterInTemp - waterOutTemp <= 5, "UTRC-FCU-001: Difference between EWT and LWT for HP should be less than 5 C", AssertionLevel.warning);
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
end Coil;