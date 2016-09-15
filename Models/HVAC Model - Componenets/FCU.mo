model FCU
  parameter Real MWater = 30;
  parameter Real cWater = 4181;
  Real temp;
  Modelica.Blocks.Interfaces.RealOutput qFCU annotation(Placement(visible = true, transformation(origin = {106, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {102, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput coilTemp annotation(Placement(visible = true, transformation(origin = {106, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {104, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qCoil annotation(Placement(visible = true, transformation(origin = {-104, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qFan annotation(Placement(visible = true, transformation(origin = {-104, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
algorithm
  qFCU := qCoil - qFan;
  temp := (qCoil - qFan) / (MWater * cWater);
equation
  der(coilTemp) = temp;
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
end FCU;