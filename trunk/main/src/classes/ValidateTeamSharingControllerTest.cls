@IsTest private class ValidateTeamSharingControllerTest {
	public static testMethod void testValidateTeamSharing() {

		GenerateEnvironmentTest.gen();
        Test.startTest();  
		GenerateEnvironmentTest.createTeamType();
		Team__c newTeam = GenerateEnvironmentTest.newTeam; 
		
		ValidateTeamSharingController validate = new ValidateTeamSharingController();
		
		/* ONE TEAM 1 */
		validate.setLastTeamId();
		validate.setTotalRemainingTeams();
		
		/* Change the owner, so i can delete the team Queue */
		newTeam.OwnerId = UserInfo.getUserId();
		
		String teamId;
		teamId = newTeam.Id;
		
		/**** 
		//////////////////////
		Delete the team associates Objects to do the validations failds
		/////////////////////
		****/
		/* Delete the Team share */
		List<Team__Share> newTeamShare = [select id from Team__Share where ParentId=: teamId and RowCause = 'Manual'];
		delete newTeamShare;
		
		/* Delete Mini Feeds */
		List<MiniFeed__c> newTeamMiniFeeds = [select id from MiniFeed__c where team__c =: teamId];
		List<MiniFeed__Share> newTeamMiniFeedsShare = [select id from MiniFeed__Share where ParentId in:newTeamMiniFeeds and RowCause = 'Manual'];
		delete newTeamMiniFeedsShare;
	
		/* Delete the Members */
		List<TeamMember__c> newTeamMembers = [select id from TeamMember__c where Team__c =: teamId];
		List<TeamMember__Share> newTeamMembersShare = [select id from TeamMember__Share where ParentId in:newTeamMembers and RowCause = 'Manual'];
		delete newTeamMembersShare;
		
		/* Delete the Projects */
		List<Project2__c> newTeamProjects = [select id from Project2__c where Team__c =: teamId];
		List<Project2__Share> newTeamProjectsShare = [select id from Project2__Share where ParentId in:newTeamProjects and RowCause = 'Manual'];
		delete newTeamProjectsShare;
		
		
		/* Delete the DiscussionForums */
		List<DiscussionForum__c> newTeamDiscussionForums = [select id from DiscussionForum__c where Team__c =: teamId];
		List<DiscussionForum__Share> newTeamDiscussionForumsShare = [select id from DiscussionForum__Share where ParentId in:newTeamDiscussionForums and RowCause = 'Manual'];
		delete newTeamDiscussionForumsShare;
		
		/* Delete the Queues */
		List<Group> newTeamQueues = [select id, Name from Group where name like :('%' + teamId + '%') and name !=: ('teamSharing' + teamId) and name !=: ('Team' + teamId)];
		List<GroupMember> iterQueueMembers = [select id from GroupMember where GroupId in: newTeamQueues];
		delete iterQueueMembers;
		
		List<Group> teamSharingGroup = [select id, Name from Group where name =: ('teamSharing' + teamId)];
		List<GroupMember> teamSharingGroupMembers = [select id from GroupMember where GroupId =: teamSharingGroup[0].Id];
		delete teamSharingGroupMembers;
		 
		
		validate.setTeamParam(teamId);
		String teamParam = validate.getTeamParam();
		try {
			validate.startValidation();
		}catch (Exception e) {
			System.assert(true, e);
		}
		
		validate.getProgressPercent();
		validate.getRemainingTeams();
		validate.getTotalTeams();
		validate.getDebugging();
		
		if (validate.getProcessing()) {
			validate.processValidation();
		}
		
		validate.getProgressPercent();
		validate.getResults();
		
		Test.stopTest();
	}
	
	public static testMethod void testValidateTeamSharing2() {
		GenerateEnvironmentTest.gen();
		Test.startTest();
		ValidateTeamSharingController validate = new ValidateTeamSharingController();
		
		/* ONE TEAM 2 */
		validate.setLastTeamId();
		validate.setTotalRemainingTeams();
		
		/* Create the team to process */
		Team__c newTeam = [Select t.TeamType__c, t.TeamCreatedDate__c, t.TeamCreatedBy__c, t.SystemModstamp, t.PublicProfile__c, t.Picture__c, t.ParentTeam__c, t.OwnerId, t.NewMemberProfile__c, t.Name, t.LastModifiedDate, t.LastModifiedById, t.IsDeleted, t.Id2__c, t.Id, t.Description__c, t.CreatedDate, t.CreatedById, t.ContactEmail__c From Team__c t order by CreatedDate desc limit 1];
		
		Team__c newTeam2 = new Team__c();
		newTeam2 = newTeam;
		
		/* Change the owner, so i can delete the team Queue */
		newTeam2.OwnerId = UserInfo.getUserId();
		
		String teamId = newTeam.Id;
		
		/**** 
		//////////////////////
		Delete the team associates Objects to do the validations failds
		/////////////////////
		****/
		/* Delete the Team share */
		List<Team__Share> newTeamShare = [select id from Team__Share where ParentId=: teamId and RowCause = 'Manual'];
		
		/* Delete Mini Feeds */
		List<MiniFeed__c> newTeamMiniFeeds = [select id from MiniFeed__c where team__c =: teamId];
		
		/* Delete the Members */
		List<TeamMember__c> newTeamMembers = [select id from TeamMember__c where Team__c =: teamId];
		
		/* Delete the Projects */
		List<Project2__c> newTeamProjects = [select id from Project2__c where Team__c =: teamId];
		
		
		/* Delete the DiscussionForums */
		List<DiscussionForum__c> newTeamDiscussionForums = [select id from DiscussionForum__c where Team__c =: teamId];
		
		/* Delete the Queues */
		List<Group> newTeamQueues = [select id, Name from Group where name like :('%' + teamId + '%') and name !=: ('teamSharing' + teamId) and name !=: ('Team' + teamId)];
		
		/* Delete the Team share */
		delete newTeamShare;
		
		/* Delete Mini Feeds */
		delete newTeamMiniFeeds;
	
		/* Delete the Members */
		delete newTeamMembers;
		
		/* Delete the Projects */
		delete newTeamProjects;
		
		/* Delete the DiscussionForums */
		delete newTeamDiscussionForums;
		
		/* Delete the Queues */
		validate.setTeamParam(teamId);
		validate.startValidation();
		validate.getProgressPercent();
		validate.getRemainingTeams();
		validate.getTotalTeams();
		validate.getDebugging();
		
		if (validate.getProcessing()) 
			validate.processValidation();
		
		Test.stopTest();
	}	
}