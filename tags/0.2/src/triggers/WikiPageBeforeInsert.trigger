trigger WikiPageBeforeInsert on WikiPage__c (before insert) {
	if (!TeamUtil.currentlyExeTrigger) {
		try {
	        
	        List<String> idsTeam = new List<String>();
	        List<String> queueNames = new List<String>();
	      	for(WikiPage__c newWiki : trigger.new){
	        	idsTeam.add(newWiki.team__c);
	        	queueNames.add('Wiki' + newWiki.team__c);
	        }
	        
	        // Check to see if this is an admin user.  If so they can create in any team 
	        Group teamAdmin = [select Id from Group where Name = 'Team Admin'];	
			Boolean isAdmin = false;
		
			if(teamAdmin != null){
				//Is SysAdmin
				// Might need to do this per author.  What if mutiple authors come through the trigger???
				List<GroupMember> groupMember= [select Id from GroupMember where GroupId =: teamAdmin.Id and UserOrGroupId =: UserInfo.getUserId()];        	
				
				if(groupMember.size() > 0){
					isAdmin = true;
				}			
			}		
	        
	        Map<Id, TeamProfile__c> profileMap = new Map<Id, TeamProfile__c>();
	        if(!isAdmin){
				// Check to see if the user is in the team and if so then use that Team Profile
				for(TeamMember__c tm: [select Team__c,
											  TeamProfile__r.PostWikiComments__c, 													
											  TeamProfile__r.ManageWikis__c,									
											  TeamProfile__r.CreateWikiPages__c													
										from TeamMember__c 
										where User__c =:UserInfo.getUserId() 
										and Team__c in: idsTeam]) {
					profileMap.put(tm.Team__c, tm.TeamProfile__r);
				}
												 
			
				// If the user is not a membe of the team then we have to go to to the public profile of the team
				// to figure out the permissions.
				for(Team__c t: [select PublicProfile__c, 
									   PublicProfile__r.PostWikiComments__c,
									   PublicProfile__r.ManageWikis__c,
									   PublicProfile__r.CreateWikiPages__c
								from Team__c
								where Id in: idsTeam]) {
					if(profileMap.get(t.Id) == null) profileMap.put(t.Id, t.PublicProfile__r);						  	
				}
				
	        }				
	        
	        // Get the owner queue
	        Map<String, Id> queueMap = new Map<String, Id>();
			for(Group g: [select id, Name from Group where name in: queueNames and type = 'Queue' limit 1]) {
				queueMap.put(g.Name, g.Id);
			}
	        
	        // 
	        for(WikiPage__c newWiki : trigger.new){
	        	
	        	// Check to see if this user can create a wiki page
	        	TeamProfile__c profile = profileMap.get(newWiki.Team__c);
	        	
	        	if(!isAdmin && !profile.CreateWikiPages__c && !profile.ManageWikis__c)
	        		newWiki.addError('Cannot Insert a new wiki Page. Insufficient Privileges');
	        	
				
				newWiki.PageCreatedBy__c = UserInfo.getUserId();
				newWiki.PageCreatedDate__c = System.now();
				
				Id queueId = queueMap.get('Wiki' + newWiki.team__c);
				if(queueId != null)
					newWiki.OwnerId = queueId;

	        }
	        
		} finally {
        	TeamUtil.currentlyExeTrigger = false;
		}
	} 		 
}