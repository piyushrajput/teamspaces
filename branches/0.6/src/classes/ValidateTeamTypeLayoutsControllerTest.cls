@IsTest private class ValidateTeamTypeLayoutsControllerTest {
	public static testMethod void test() {
		GenerateEnvironmentTest.gen();
        Test.startTest(); 
     	GenerateEnvironmentTest.createTeamType();
     	
     	ValidateTeamTypeLayoutsController newTeamType = new ValidateTeamTypeLayoutsController();
     	newTeamType.getTypes();
     	newTeamType.getPages();
     	
     	Test.stopTest();   
	}
}