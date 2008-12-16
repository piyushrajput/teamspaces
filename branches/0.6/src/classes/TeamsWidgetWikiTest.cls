@IsTest private class TeamsWidgetWikiTest {
    public static testMethod void testTeam() {
        GenerateEnvironmentTest.gen();
		
		Test.startTest();
        
        TeamsWidgetWikiController team = new TeamsWidgetWikiController();
        
        Team__c newTeam = [select id from Team__c limit 1];
        team.setTeamspaceId(newTeam.Id);
        
        if (team.getTeamspaceId()== null) {
            System.assert(true,'Null Team Id'); 
        }
        
        team.getWikiPages(); 
        team.getWikiPagesSize(); 
        
        Test.stopTest();
    }
}