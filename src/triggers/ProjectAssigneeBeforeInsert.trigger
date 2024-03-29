trigger ProjectAssigneeBeforeInsert on ProjectAssignee__c (before insert) {
	if (!TeamUtil.currentlyExeTrigger) {
 		try {
	        
	        //
			// Need to populate the Team__c field on the comment object
			//
			List<String> projectTasks = new List<String>();
	      	for(ProjectAssignee__c newAssignee : trigger.new){
	        	projectTasks.add(newAssignee.ProjectTask__c );
	        }
	        
			Map<Id, ProjectTask__c> taskMap = new Map<Id, ProjectTask__c>([select Team__c,(Select User__c From ProjectAssignee__r where User__c =: UserInfo.getUserId()) from ProjectTask__c where Id in: projectTasks]);
			
			for(ProjectAssignee__c newAssignee : trigger.new){
	        	newAssignee.Team__c = taskMap.get(newAssignee.ProjectTask__c ).Team__c;
	        }			
			
			//
			// Once we have populated the Team field we can do our usual pre insert check list
			//
	        List<String> idsTeam = new List<String>();
	        List<String> queueNames = new List<String>();
	      	for(ProjectAssignee__c newAssignee : trigger.new){
	        	idsTeam.add(newAssignee.team__c);
	        	queueNames.add('Project' + newAssignee.team__c);
	        }
	        
	        // Check to see if this is an admin user.  If so they can create in any team 
	        List<User> teamAdmin = [Select id, Profile.PermissionsModifyAllData, ProfileId, Name From User where id =:UserInfo.getUserId() limit 1];
			Boolean isAdmin = false;
		
			if(teamAdmin[0].Profile.PermissionsModifyAllData){
				//Is SysAdmin
				// Might need to do this per author.  What if mutiple authors come through the trigger???
				isAdmin = true;			
			}		
	        
	        Map<Id, TeamProfile__c> profileMap = new Map<Id, TeamProfile__c>();
	        if(!isAdmin){
				// Check to see if the user is in the team and if so then use that Team Profile
				for(TeamMember__c tm: [select Team__c,												
											  TeamProfile__r.ManageProjectTasks__c ,									
											  TeamProfile__r.CreateProjectTasks__c													
										from TeamMember__c 
										where User__c =:UserInfo.getUserId() 
										and Team__c in: idsTeam]) {
					profileMap.put(tm.Team__c, tm.TeamProfile__r);
				}
												 
			
				// If the user is not a membe of the team then we have to go to to the public profile of the team
				// to figure out the permissions.
				for(Team__c t: [select PublicProfile__c, 
									   PublicProfile__r.ManageProjectTasks__c,
									   PublicProfile__r.CreateProjectTasks__c
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
            
	        // I think i need to add the code to let assignees change things...add assignees.
	        for(ProjectAssignee__c newAssignee : trigger.new){
	        	
	        	// Check to see if this user can create a wiki page
	        	TeamProfile__c profile = profileMap.get(newAssignee.Team__c);
	        	
	        	List<ProjectAssignee__c> assignees  = taskMap.get(newAssignee.ProjectTask__c ).ProjectAssignee__r;
	        	
	        	if(!isAdmin && !profile.CreateProjectTasks__c && !profile.ManageProjectTasks__c && assignees.size() == 0)
	        		newAssignee.addError('Cannot Insert A Task Assignee. Insufficient Privileges');
	        	
				
				Id queueId = queueMap.get('Project' + newAssignee.team__c);
				if(queueId != null)
					newAssignee.OwnerId = queueId;

	        }	        
	        
		} finally {
        	TeamUtil.currentlyExeTrigger = false;
		}
	}    
}