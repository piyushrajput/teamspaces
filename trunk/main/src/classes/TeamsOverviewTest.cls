@IsTest private class TeamsOverviewTest {

    public static testMethod void testTeam() {
        try{
            
            GenerateEnvironmentTest.gen();
            Test.startTest();
            
            TeamsOverviewController team = new TeamsOverviewController();
            team.setIsTest(true);
            List<PeopleProfile__c> profiles = team.getPeopleProfile();
            TeamsOverviewController.teams t = new TeamsOverviewController.teams();
            TeamsOverviewController.Letters l = new TeamsOverviewController.Letters(); 
            team.getPeopleProfile();
            team.profileExist();
            
            PaginatorControllerTest.PaginatorController();
            
            team.setFilter('newTeams');
            team.teamsForTabs();
            team.setLetterFilter();
            PageReference pr = team.profileExist();
            
            // GENERATED FOR CODE COVERAGE
            TeamUtil.isTest = true;
            Team__c teamCodCov = GenerateEnvironmentTest.newTeam;
            delete teamCodCov;

            TeamMember__c teamMemCodCov = GenerateEnvironmentTest.newTeamMember;
            update teamMemCodCov;

            TeamProfile__c teamProfCodCov = GenerateEnvironmentTest.newTeamProfile;
            update teamProfCodCov;
            TeamUtil.isTest = false;

            Test.stopTest();
        }catch(Exception e){
            throw e;
        }   
    
    }
    
}