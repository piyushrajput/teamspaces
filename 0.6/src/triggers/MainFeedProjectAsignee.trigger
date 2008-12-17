trigger MainFeedProjectAsignee on ProjectAssignee__c bulk (after insert, after delete) {
	if (!TeamUtil.currentlyExeTrigger) {
		try {		
			if (trigger.isInsert) {
				List<MiniFeed__c> minifeed = new List<MiniFeed__c>();
			    List<String> idsTask = new List<String>();
			    List<String> idsUser = new List<String>();
			    for (ProjectAssignee__c newAssignee : Trigger.new) {
			    	idsTask.add(newAssignee.ProjectTask__c);
			    	idsUser.add(newAssignee.User__c);
			    }
			    List<ProjectTask__c> ProjectTaskList =[ SELECT Id, Team__c, Team__r.Id, Team__r.Name , Name FROM  ProjectTask__c WHERE Id in: idsTask];
			    List<User> userList =[ SELECT Id, Name FROM  User WHERE Id in: idsUser];
			    
			    for(Integer i = 0; i < Trigger.new.size(); i++) {
					// Must do some auxiliar querys
			        ProjectAssignee__c n = Trigger.new[i];
					
					ProjectTask__c ProjectTask = new ProjectTask__c();
					Boolean findTask = false;
					Integer countTask = 0;
					while (!findTask && countTask < ProjectTaskList.size()) {
						if (ProjectTaskList[countTask].Id == n.ProjectTask__c) {
							findTask = true;
							ProjectTask = ProjectTaskList[countTask];
						}
						else {
							countTask++;
						}	
					}
					
					User currentUser;
					Boolean findUser = false;
					Integer countUser = 0;
					while (!findUser && countUser < userList.size()) {
						if (userList[countUser].Id == n.User__c) {
							findUser = true;
							currentUser	= userList[countUser];
						}
						else {
							countUser++;
						}	
					}
					
					// Blurb:	    
			        minifeed.add( new MiniFeed__c( Type__c='TaskAssigned',
			        									FeedDate__c=System.now(),
			                                           	Team__c=ProjectTask.Team__c,
			                                           	User__c=n.CreatedById,
			                                           	Message__c='assigned new task ' + ProjectTask.Name + ' to <a href="/apex/PeopleProfileDisplay?id=' + n.User__c + '">' + currentUser.Name +  '</a> in <a href="/apex/TeamsRedirect?id=' + ProjectTask.Team__c + '">' + ProjectTask.Team__r.Name + '</a><span style="display:none;">' + ProjectTask.Id + '</span>'));
				} 
				
				insert minifeed;
			}
			
			if (trigger.isDelete) {	 
				List<MiniFeed__c> minifeed = new List<MiniFeed__c>();
			    List<String> idsTask = new List<String>();
			    List<String> idsUser = new List<String>();
			    for (ProjectAssignee__c newAssignee : Trigger.old) {
			    	idsTask.add(newAssignee.ProjectTask__c);
			    	idsUser.add(newAssignee.User__c);
			    }
			    List<ProjectTask__c> ProjectTaskList =[ SELECT Id, Team__c, Team__r.Id, Team__r.Name , Name FROM  ProjectTask__c WHERE Id in: idsTask];
			    List<User> userList =[ SELECT Id, Name FROM  User WHERE Id in: idsUser];
				
				for(Integer i = 0; i < Trigger.old.size(); i++) {
					// Must do some auxiliar querys
			        ProjectAssignee__c n = Trigger.old[i];
					
					ProjectTask__c ProjectTask = new ProjectTask__c();
					Boolean findTask = false;
					Integer countTask = 0;
					while (!findTask && countTask < ProjectTaskList.size()) {
						if (ProjectTaskList[countTask].Id == n.ProjectTask__c) {
							findTask = true;
							ProjectTask = ProjectTaskList[countTask];
						}
						else {
							countTask++;
						}	
					}
					
					minifeed.add( new MiniFeed__c( Type__c='TaskAssignedDelete',
			        									FeedDate__c=System.now(),
			                                           	Team__c=ProjectTask.Team__c,
			                                           	User__c=n.CreatedById,
			                                           	Message__c='unassigned task ' + ProjectTask.Name + ' to you<span style="display:none;">' + n.User__c + '////' + ProjectTask.Id + '</span>'));
				}
				insert minifeed;
			}
			    
		} finally {
        	TeamUtil.currentlyExeTrigger = false;
		}
	} 				    
}