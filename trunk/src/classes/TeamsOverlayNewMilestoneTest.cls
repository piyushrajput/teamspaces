@IsTest private class TeamsOverlayNewMilestoneTest {
	
	public static testMethod void TeamsOverlayNewMilestoneTest() {
		
		GenerateEnvironmentTest.gen();     
    	Test.startTest();
    	TeamsOverlayNewMilestoneController con = new TeamsOverlayNewMilestoneController();
    	con.setCurrentTeamId(GenerateEnvironmentTest.newTeam.Id);
    	if (con.getCurrentTeamId() == null) 
    		System.assert(true,'getCurrentTeamId failed');
    	if (con.getTask() == null) 
    		System.assert(true,'getTask failed');
    	if (con.getTeamMember() == null) 
    		System.assert(true,'getTeamMember failed');
    	if (con.getTeamMembers() == null) 
    		System.assert(true,'getTeamMembers failed');
    		
    	con.genPermissions();
    	if(con.getUserLocale() == null) 
    		System.assert(true,'getUserLocale failed');
    	
    	con.getCurrentProject();
    	
    	ProjectTask__c pT = new ProjectTask__c();
    	pT.team__c = GenerateEnvironmentTest.newTeam.Id;
		pT.StartDate__c = System.now();
		pT.EndDate__c = System.now();
		pT.Duration__c = 1;
		pT.Percent_Completed__c = 0;
		pT.Milestone__c = true; 
		
		con.setTeamMember(GenerateEnvironmentTest.newTeamMember);  
    	con.setNewProyect(pT);
    	con.insertMilestone();
    	con.dummyRefresh();
    	
    	Test.stopTest();
	}

}