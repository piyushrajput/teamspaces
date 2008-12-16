@isTest private class TeamsDetailTest {
    
    public static String USERID =  UserInfo.getUserId();
    
    public static testMethod void testTeam() {
        try{
            GenerateEnvironmentTest.gen();
            Test.startTest();
            
            TeamsDetailController team = new TeamsDetailController();
            Team__c t = GenerateEnvironmentTest.newTeam;
            team.setTeamIdParam(t.Id);
            team.getTeamDetail();
            Boolean b = team.getInTeamSubscription();
            t = team.getTeamspace();
            Boolean open = team.getTeamIsOpen();
            String param = team.getTeamIdParam();
            Boolean message = team.getShowJoinTeamMessage();
            System.currentPageReference().getParameters().put('j','true');
            team.assignShowJoinTeamMessage();
            System.currentPageReference().getParameters().put('j','false');
            team.assignShowJoinTeamMessage();
            UserPermissions up = team.getUserPermissionsWiki();
            String image = team.getTeamspaceImage();
            team.joinTeam();
            team.refreshJoinEvent();
            team.leaveTeam();
            
            Test.stopTest();
        }catch(Exception e){
            throw e;
        }
    }
}