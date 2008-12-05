@IsTest private class FlexWebServiceTest {
    public static testMethod void test() {
        try{
			GenerateEnvironmentTest.gen();
            Test.startTest(); 
		
			FlexWebService flex = new FlexWebService();
			flex.genPermissions(GenerateEnvironmentTest.newTeam.Id, UserInfo.getUserId());
			FlexWebService.generatePermissions(UserInfo.getUserId(), GenerateEnvironmentTest.newTeam.Id);

            Test.stopTest(); 
        }catch(Exception e){
            throw e;
        }
    } 
}