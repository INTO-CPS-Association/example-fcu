model Fan
  parameter Real mdontSupFan = 1.1;
  parameter Real cAir = 4181;
  Modelica.Blocks.Interfaces.RealInput coilTemp annotation(Placement(visible = true, transformation(origin = {-104, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -82}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput fanDamperPos annotation(Placement(visible = true, transformation(origin = {-104, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput AHUAirInTemp annotation(Placement(visible = true, transformation(origin = {-104, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput qFan annotation(Placement(visible = true, transformation(origin = {106, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {104, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
algorithm
  qFan := mdontSupFan * fanDamperPos * cAir * (coilTemp - AHUAirInTemp);
  assert(fanDamperPos >= 0.1, "UTRC-FCU-002: FCU air damper should be opened at least 0.10.", AssertionLevel.warning);
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
end Fan;