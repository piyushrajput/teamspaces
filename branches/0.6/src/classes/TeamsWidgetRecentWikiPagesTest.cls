@IsTest private class TeamsWidgetRecentWikiPagesTest { 
    public static testMethod void testTeam() { 
        GenerateEnvironmentTest.gen();
		
		Test.startTest();
		
        TeamsWidgetRecentWikiPagesController team = new TeamsWidgetRecentWikiPagesController();
        
        Team__c newTeam = GenerateEnvironmentTest.newTeam;
        team.setTeamId(newTeam.Id);
        
        if (team.getTeamId() == null){
            System.assert(true, 'Null team Id');    
        }
        
        UserPermissions userPermissions = new UserPermissions();
        
        userPermissions.getCanView();
        userPermissions.getCanComment();
        userPermissions.getCanManage();
        userPermissions.getCanCreate();
        userPermissions.getObjectType();
        userPermissions.getTeam();
        userPermissions.getId();
        
        team.getUserPermissions();
        team.getWikis();
        team.getWikiPagesCount();
        
        team.setSidebar(true);
        team.getSidebar();
        
        Test.stopTest();
    }
}