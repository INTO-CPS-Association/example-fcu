model FCUController
  parameter Real RATSetPoint = 20.0;
  parameter Real RATTolerance = 0.50;
  Real fanStatus(start = 0.15);
  Real valveStatus;
  Real upperLimit;
  Real lowerLimit;
  Real counterStadyState;
  Modelica.Blocks.Interfaces.RealInput RAT annotation(Placement(visible = true, transformation(origin = {-104, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput damperOpening annotation(Placement(visible = true, transformation(origin = {106, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {102, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput valveOpening annotation(Placement(visible = true, transformation(origin = {106, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
algorithm
  upperLimit := RATSetPoint + RATTolerance;
  lowerLimit := RATSetPoint - RATTolerance;
  if RAT < lowerLimit then
    fanStatus := 1;
    valveStatus := 1;
    valveOpening := 1;
    damperOpening := 1;
    assert(valveOpening >= 0.15, "UTRC-FCU-004: If there is a demand request, valve position should be at least 0.15 open.", AssertionLevel.warning);
  elseif RAT > upperLimit then
    fanStatus := 0.15;
    valveStatus := 0;
    valveOpening := 0;
    damperOpening := 0.15;
  else
    valveOpening := valveStatus;
    damperOpening := fanStatus;
    counterStadyState := pre(counterStadyState) + 1;
    if counterStadyState >= 10 then
      assert(RAT <= RATSetPoint + 1 and RAT >= RATSetPoint - 1, "UTRC-FCU-003: RAT should be +/- 1C from RAT-SP.", AssertionLevel.warning);
    end if;
  end if;
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})));
end FCUController;