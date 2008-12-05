@IsTest private class TeamDetailsWidgetTest {
    public static testMethod void testTeam() {
        try{
            GenerateEnvironmentTest.gen();
            Test.startTest();               
            
            TeamDetailsWidgetController team = new TeamDetailsWidgetController();
            team.getNamespace(); 
            
            team.setTeam(GenerateEnvironmentTest.newTeam.Id);
            Team__c teamspace = team.getTeamspace();
 
            boolean  isTeamMember= team.getIsTeamMember();
            String member = team.getTeamMemberId();
            
            team.setTeam('no_id');
            member = team.getTeamMemberId();
            
            team.setTeam(GenerateEnvironmentTest.newTeam.Id);
            member = team.getTeamMemberId();
            
            boolean  isTeamAdmin= team.getIsTeamAdmin();
            String adminStr = team.getTeamAdmins();
            Integer cnt = team.getTeamCount();
            String pic = team.getTeamspaceImage(); 
            
            String pic2 = team.getTeamspaceImage();
            String userName = team.getCurrentUser();
            team.genPermissions();
            team.getTeam();
            UserPermissions up = team.getUserPermissions();
            
            team.leaveTeam();
            
            Test.stopTest();
        }catch(Exception e){
            throw e;
        }
    }
}