@IsTest private class UserPermissionsTest {
    
    /**
    * Run code coverage for UserPermissions class
    *@static
    *@void
    *@testMethod
    */ 
    public static testMethod void UserPermissionsTest(){
		GenerateEnvironmentTest.gen();
		
		Test.startTest();
		
		System.debug('\n\n///////////////////////////////////////\n INTO TEST  \n//////////////////////////////////\n\n');
		
        List<User> NOTteamAdmin = [Select id, Profile.PermissionsModifyAllData, ProfileId, Name From User where Profile.Name = 'Read Only' limit 1];
        //Set non Admin user
        String userId;
        if (NOTteamAdmin.size() > 0) {
            userId = NOTteamAdmin[0].Id;
        }
        else {
            userId = UserInfo.getUserId();
        }

		UserPermissions up = new UserPermissions();
           	
       	System.debug('\n\n///////////////////////////////////////\n USER ID: ' + userId + '\n//////////////////////////////////\n\n');
        up.setId(userId);
        
        //Get one TeamMember & Team for non Admin user.
        List<Team__c> teamList = new List<Team__c>();
        teamList = [SELECT id FROM Team__c];
        if (teamList.size() > 0 ) {
            TeamMember__c teamMember = [select Id, Team__c from TeamMember__c where User__c !=: userId limit 1];
    		
            //Test Team Permissions
            up.setTeam(teamMember.Team__c);
            up.setObjectType('Team');
            up.setPermissions();
            
            //Test WikiPage Permissions
            WikiPage__c wp = [select Id from WikiPage__c limit 1];
            up.setObjectType('Wiki');
            up.setPermissions();
            
            
            //Test DiscussionForum Permissions
            DiscussionForum__c df = [select Id from DiscussionForum__c limit 1];
            up.setObjectType('DiscussionForum');
            up.setPermissions();
            
            //Test DiscussionMessage Permissions
            DiscussionMessage__c dm = [select Id from DiscussionMessage__c limit 1];
            up.setObjectType('DiscussionMessage');
            up.setPermissions();
            
            //Test DiscussionTopic Permissions
            DiscussionTopic__c dt = [select Id from DiscussionTopic__c limit 1];
            up.setObjectType('DiscussionTopic');
            up.setPermissions();        
    
            //Test ProjectTask Permissions
            ProjectTask__c pt = [select Id from ProjectTask__c limit 1];
            up.setObjectType('Project');
            up.setPermissions();
            
            //Test getters
            userId = up.getId();        
            String objectType = up.getObjectType();
            String teamId = up.getTeam();
            // String tId = up.getObjectId();       
            Boolean canMange = up.getCanManage();
            Boolean canCreate = up.getCanCreate();
            Boolean canComment = up.getCanComment();
            Boolean canView = up.getCanView();
        }
        
        //Test Admin User (current user should be App Admin for this)
        up = new UserPermissions();
        up.setId(UserInfo.getUserId());
        up.setPermissions(); 
       	
       	Test.stopTest();
    }
    
}