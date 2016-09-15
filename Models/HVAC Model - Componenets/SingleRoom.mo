model SingleRoom
  Modelica.Blocks.Interfaces.RealOutput RAT annotation(Placement(visible = true, transformation(origin = {106, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {104, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Wall wall1 annotation(Placement(visible = true, transformation(origin = {-44, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  window window1 annotation(Placement(visible = true, transformation(origin = {-38, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Indoor indoor1 annotation(Placement(visible = true, transformation(origin = {46, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qAir annotation(Placement(visible = true, transformation(origin = {-102, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qLoad annotation(Placement(visible = true, transformation(origin = {-104, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput OAT annotation(Placement(visible = true, transformation(origin = {-104, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(window1.windowTemp, indoor1.windowTemp) annotation(Line(points = {{-28, -46}, {24, -46}, {24, -6}, {36, -6}, {36, -6}}, color = {0, 0, 127}));
  connect(wall1.wallTemp, indoor1.wallTemp) annotation(Line(points = {{-34, 54}, {-8, 54}, {-8, 0}, {36, 0}, {36, 0}}, color = {0, 0, 127}));
  connect(qLoad, indoor1.qLoad) annotation(Line(points = {{-104, 10}, {10, 10}, {10, 4}, {36, 4}, {36, 4}}, color = {0, 0, 127}));
  connect(qAir, indoor1.qAir) annotation(Line(points = {{-102, 90}, {20, 90}, {20, 10}, {36, 10}, {36, 10}}, color = {0, 0, 127}));
  connect(OAT, wall1.OAT) annotation(Line(points = {{-104, -88}, {-70, -88}, {-70, 54}, {-54, 54}, {-54, 54}}, color = {0, 0, 127}));
  connect(indoor1.airTemp, RAT) annotation(Line(points = {{56, 2}, {100, 2}, {100, 4}, {100, 4}}, color = {0, 0, 127}));
  connect(RAT, window1.RAT) annotation(Line(points = {{106, 4}, {90, 4}, {90, -32}, {-60, -32}, {-60, -40}, {-48, -40}, {-48, -40}}, color = {0, 0, 127}));
  connect(OAT, window1.OAT) annotation(Line(points = {{-104, -88}, {-60, -88}, {-60, -52}, {-48, -52}, {-48, -52}}, color = {0, 0, 127}));
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Bitmap(extent = {{-44, 56}, {-44, 56}})}));
end SingleRoom;