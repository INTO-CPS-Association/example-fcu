model Indoor
  // model paramters
  parameter Real rohAir = 1.204;
  parameter Real vAir = 50.0;
  parameter Real cAir = 1012.0;
  parameter Real alphaAir = 100.0;
  parameter Real aWall = 16.0;
  //parameter Real mdotSupFan = 1.1;
  parameter Real aWindow = 1.0;
  parameter Real initTemp = 16;
  //Real RAT(start = 16);
  Real qWall;
  Real qWindow;
  Real temp(start = 0);
  // model interface (input/output)
  Modelica.Blocks.Interfaces.RealInput qAir annotation(Placement(visible = true, transformation(origin = {-102, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-96, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // model function
  Modelica.Blocks.Interfaces.RealInput windowTemp annotation(Placement(visible = true, transformation(origin = {-102, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-98, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput airTemp(start = initTemp) annotation(Placement(visible = true, transformation(origin = {106, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {104, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qLoad(start = 0) annotation(Placement(visible = true, transformation(origin = {-102, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-98, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput wallTemp annotation(Placement(visible = true, transformation(origin = {-102, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
algorithm
  qWall := alphaAir * aWall * (wallTemp - airTemp);
  //qAir := mdotSupFan * cAir * (coilTemp - airTemp);
  qWindow := alphaAir * aWindow * (windowTemp - airTemp);
  temp := 60 * (qWall + qAir + qWindow + qLoad) / (rohAir * vAir * cAir);
  //airTemp := RAT;
equation
  der(airTemp) = temp;
  //  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
end Indoor;