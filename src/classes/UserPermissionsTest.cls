public class UserPermissionsTest {
	
	/**
	* Run code coverage for UserPermissions class
	*@static
	*@void
	*@testMethod
	*/ 
	public static testMethod void UserPermissionsTest(){
		UserPermissions up = new UserPermissions();
		
		//Get Team Admin Queue
		Group ta = [select Id from Group where Name ='Team Admin'];

		//Get GroupMembers for Team Admin Queue
		List<GroupMember> gMembers = [select Id, UserOrGroupId from GroupMember where GroupId =: ta.Id];

		
		//
		Set<String> groupMemberIds = new Set<String>();
		for(GroupMember gm : gMembers){
			groupMemberIds.add(gm.UserOrGroupId);
		}
		//Get All Users, captcha non Team Admin user.
		List<User> users = [select Id from User];
		String userId = null; 
		for(User u : users){
			if(!groupMemberIds.contains(u.Id)){
				userId = u.Id;
				break;	
			}
		}
		
		//Set non Admin user
		up.setId(userId);
		
		//Get one TeamMember & Team for non Admin user.
		TeamMember__c teamMember = [select Id, Team__c from TeamMember__c where User__c =: userId limit 1];

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
		
		//Test Bookmark Permissions
		Bookmark__c bm = [select Id from Bookmark__c limit 1];
		up.setObjectType('Bookmark');
		up.setPermissions();		
		
		//Test Blogs Permissions
		up.setObjectType('Blog');
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
		
		//Test Admin User (current user should be App Admin for this)
		up.setId(UserInfo.getUserId());
		up.setPermissions(); 

	}

}