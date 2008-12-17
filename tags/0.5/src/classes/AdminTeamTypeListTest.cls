@IsTest private class AdminTeamTypeListTest {
    public static testMethod void testAdmin() {
        try{
        	GenerateEnvironmentTest.gen();
        	Test.startTest();		
	        GenerateEnvironmentTest.createTeamType();
	        AdminTeamTypeListController admin = new AdminTeamTypeListController();
	        TeamType__c teamType = [select Id, Name, CreatedDate, (Select Id From Teams__r), CreatedById from TeamType__c limit 1];
	        AdminTeamTypeListController.TeamTypes teamTypes =  new AdminTeamTypeListController.TeamTypes(teamType);
	        List<AdminTeamTypeListController.TeamTypes> profiles = admin.getTypes();
	        teamTypes.getCreatedDate();
	        teamTypes.getTeams();
	        teamTypes.getTeamType();
	        
			Test.stopTest();	        
        }catch(Exception e){
        	throw e;
        }
    } 
}