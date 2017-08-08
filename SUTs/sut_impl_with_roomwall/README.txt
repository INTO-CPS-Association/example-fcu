Three commands are added to the project:
1. sut-build
	c:/python27/python.exe <PROJECT-LOCAL-PATH>/sut/build-suts.py

2. run-COE-n 
	../utils/run-COE.py <TEST-PROCEDURE:Test:default=RTT_TestProcedures%2FTP4SUT_RoomWall&type=6> <TEST-PROCEDURE:Part1:default=RTT_TestProcedures%2FSUT_FCU_Ctrl&type=6> <TEST-PROCEDURE:Part2:default=RTT_TestProcedures%2FRoomWall&type=6> --timeout <STRING:Duration%5Bs%5D:default=100> --stepsize <STRING:StepSize%5Bs%5D:default=1> -i  <PROJECT-LOCAL-PATH>/sut/SUT_roomwall.json
	
 3. update_guid_json
	<PROJECT-LOCAL-PATH>/sut/assembly_json_for_test.py 
