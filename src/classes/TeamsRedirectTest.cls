@IsTest private class TeamsRedirectTest {
    
    public static testMethod void testTeam() {
        try{
			GenerateEnvironmentTest.gen();

            Test.startTest();            
			
			GenerateEnvironmentTest.createTeamType();            
            TeamsRedirectController team = new TeamsRedirectController();
            Team__c t = GenerateEnvironmentTest.newTeam;
            team.setTeamId(t.Id);
            team.getTeam();
            PageReference page = team.redirect();
            
            Test.stopTest();   
        }catch(Exception e){
            throw e;
        }
    }   
}