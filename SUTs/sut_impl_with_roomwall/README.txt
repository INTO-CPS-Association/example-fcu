There are two SUT implementations in this folder.
- SUT: a standalone SUT with the controller, wall and room altogether in a program
- SUT_with_roomwall: only have the controller in C and expect room and wall from 20-Sim models.

1. Copy all in this folder into <PROJECT-LOCAL-PATH>/sut/ (where <PROJECT-LOCAL-PATH> is the test project path)

2. Add three commands to the project through "Project Setting"
- sut-build
	c:/python27/python.exe <PROJECT-LOCAL-PATH>/sut/build-suts.py

- run-COE-n 
	../utils/run-COE.py <TEST-PROCEDURE:Test:default=RTT_TestProcedures%2FTP4SUT_RoomWall&type=6> <TEST-PROCEDURE:Part1:default=RTT_TestProcedures%2FSUT_FCU_Ctrl&type=6> <TEST-PROCEDURE:Part2:default=RTT_TestProcedures%2FRoomWall&type=6> --timeout <STRING:Duration%5Bs%5D:default=100> --stepsize <STRING:StepSize%5Bs%5D:default=1> -i  <PROJECT-LOCAL-PATH>/sut/SUT_roomwall.json
	
 - update_guid_json
	<PROJECT-LOCAL-PATH>/JSONs/sut/assembly_json_for_test.py 

3. Execute "sut-build" to build both SUTs into test procedures (FMUs) 
4. Execute "update_guid_json" to update GUID in the json file
5. Execute "run-COE-n" to run a test with three FMUs 
