model Wall
  // model paramters
  //Layer 1 : Gypsum Plasterboard
  parameter Real rohWallLayer1 = 950;
  parameter Real vWallLayer1 = 0.065;
  parameter Real cWallLayer1 = 840;
  parameter Real alphaWallLayer1 = 16;
  // Layer 2 : Plywood
  parameter Real rohWallLayer2 = 560;
  parameter Real vWallLayer2 = 0.0975;
  parameter Real cWallLayer2 = 2500;
  parameter Real alphaWallLayer2 = 10;
  // Layer 3 : Glass Fiber
  parameter Real rohWallLayer3 = 12;
  parameter Real vWallLayer3 = 0.325;
  parameter Real cWallLayer3 = 840;
  parameter Real alphaWallLayer3 = 12;
  // Layer 4 : Air Gap
  parameter Real rohWallLayer4 = 1999;
  parameter Real vWallLayer4 = 0.325;
  parameter Real cWallLayer4 = 1012;
  parameter Real alphaWallLayer4 = 3.6;
  // Layer 5 : Gypsum Plasterboard
  parameter Real rohWallLayer5 = 950;
  parameter Real vWallLayer5 = 0.1625;
  parameter Real cWallLayer5 = 840;
  parameter Real alphaWallLayer5 = 6.4;
  parameter Real aWall = 6.5;
  parameter Real initTemp = 16;
  Real WTLayer1(start = initTemp);
  Real qWallLayer1;
  Real WTLayer2(start = initTemp);
  Real qWallLayer2;
  Real WTLayer3(start = initTemp);
  Real qWallLayer3;
  Real WTLayer4(start = initTemp);
  Real qWallLayer4;
  Real qWallLayer5;
  // model function
  Modelica.Blocks.Interfaces.RealInput OAT annotation(Placement(visible = true, transformation(origin = {-104, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput wallTemp(start = initTemp) annotation(Placement(visible = true, transformation(origin = {106, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {104, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
algorithm
  qWallLayer1 := 60 * alphaWallLayer1 * aWall * (OAT - WTLayer1) / (rohWallLayer1 * vWallLayer1 * cWallLayer1);
  qWallLayer2 := 60 * alphaWallLayer2 * aWall * (WTLayer1 - WTLayer2) / (rohWallLayer2 * vWallLayer2 * cWallLayer2);
  qWallLayer3 := 60 * alphaWallLayer3 * aWall * (WTLayer2 - WTLayer3) / (rohWallLayer3 * vWallLayer3 * cWallLayer3);
  qWallLayer4 := 60 * alphaWallLayer4 * aWall * (WTLayer3 - WTLayer4) / (rohWallLayer4 * vWallLayer4 * cWallLayer4);
  qWallLayer5 := 60 * alphaWallLayer5 * aWall * (WTLayer4 - wallTemp) / (rohWallLayer5 * vWallLayer5 * cWallLayer5);
equation
  der(WTLayer1) = qWallLayer1;
  der(WTLayer2) = qWallLayer2;
  der(WTLayer3) = qWallLayer3;
  der(WTLayer4) = qWallLayer4;
  der(wallTemp) = qWallLayer5;
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
end Wall;