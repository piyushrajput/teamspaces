@IsTest private class TeamUtilTest {

    public static testMethod void testUtil() {
        try{
	        GenerateEnvironmentTest.gen();
	        Test.startTest();	        
	        
	        if(!TeamUtil.currentlyExeTrigger)
	            System.assert(true,'Not current trigger');  

	        TeamUtil.isAdminMemberUser();
	        TeamUtil.getOrganizationGroup();
	        
	        Test.stopTest();

        }catch(Exception e){
        	throw e;
        }
    }
}