trigger MainFeedProjectTask on ProjectTask__c (after insert, after update, after delete) {
	
	/**
	* This happens after insert
	*/	
	if(trigger.isInsert){
		
		
	    List<String> teams = new List<String>();
	    for(ProjectTask__c newProject : trigger.new) {
	    		teams.add(newProject.Team__c);	
	    }
	    
	    Map<Id, Team__c> teamMap = new Map<Id, Team__c>([Select Name from Team__c where Id in: teams]);
		
		List<MiniFeed__c> minifeed = new List<MiniFeed__c>();
		for(Integer i = 0; i < Trigger.new.size(); i++) {
		
			ProjectTask__c n = Trigger.new[i];

			if(n.Milestone__c){	
			   	minifeed.add( new MiniFeed__c( Type__c='MilestoneNew',
			   											FeedDate__c=System.now(),
	                                           			Team__c=n.Team__c,	 
			                                           	User__c=n.CreatedById,
				                                       	Message__c='created new milestone ' + n.Name + ' in <a href="/apex/TeamsRedirect?id=' + n.Team__c + '">' + teamMap.get(n.Team__c).Name + '</a>' ));
               	               
			} else {
				minifeed.add( new MiniFeed__c( Type__c='TaskNew',
														FeedDate__c=System.now(),
	                                           			Team__c=n.Team__c,
			                                           	User__c=n.CreatedById,
				                                       	Message__c='created new task ' + n.Name + ' in <a href="/apex/TeamsRedirect?id=' + n.Team__c + '">' + teamMap.get(n.Team__c).Name + '</a>' ));            
			}
		}
		
		insert minifeed;
	}	
	
	/**
	* This happens after insert
	*/	
	if(trigger.isUpdate){
	
			List<String> teams = new List<String>();
	    	for(ProjectTask__c newProject : trigger.new) {
	    		teams.add(newProject.Team__c);	
	    	}
	    
	    	Map<Id, Team__c> teamMap = new Map<Id, Team__c>([Select Name from Team__c where Id in: teams]);			
			
			ProjectTask__c[] n = Trigger.new;
			ProjectTask__c[] o = Trigger.old; 
			
			List<MiniFeed__c> minifeed = new List<MiniFeed__c>();    
			
			// Subscription Email Sevice
			TeamsSubscribersEmailServices TS = new TeamsSubscribersEmailServices();
			List<String> changesList = new List<String>();
			
			for(Integer i = 0; i < Trigger.new.size(); i++){
				String changesInfo = n[i].Id + '////Fields Changed: <br>';
				if (n[i].Name != o[i].Name) {
					changesInfo += '<br>Name: From ' + o[i].Name + ' to ' + n[i].Name + '<br>';
				}
				if (n[i].Percent_Completed__c != o[i].Percent_Completed__c) {
					changesInfo += '<br>Percent Completed: From ' + o[i].Percent_Completed__c + ' to ' + n[i].Percent_Completed__c + '<br>';
				}
				
				if (n[i].Duration__c != o[i].Duration__c) {
					changesInfo += '<br>Duration: From ' + o[i].Duration__c + ' hours to ' + n[i].Duration__c + ' hours<br>';
				}
				
				if (n[i].StartDate__c != o[i].StartDate__c) {
					changesInfo += '<br>Start Date: From ' + o[i].StartDate__c.format() + ' to ' + n[i].StartDate__c.format() + '<br>';
				}
				
				if (n[i].EndDate__c != null && n[i].EndDate__c != o[i].EndDate__c) {
					
					String oldDate = '';
					if (o[i].EndDate__c != null) {
						oldDate	= o[i].EndDate__c.format();
						changesInfo += '<br>End Date: From ' + oldDate + ' to ' + n[i].EndDate__c.format() + '<br>';
					}
					else {
						changesInfo += '<br>End Date: To ' + n[i].EndDate__c.format() + '<br>';
					}
					
				}
				
				if (n[i].Description__c != o[i].Description__c) {
					changesInfo += '<br>Description: <br>From <br>' + o[i].Description__c + '<br> to <br>' + n[i].Description__c + '<br>';
				}
				
				changesList.add(changesInfo);
				
				if(n[i].Milestone__c){
					if(n[i].Percent_Completed__c == 100){	
					    minifeed.add( new MiniFeed__c( Type__c='MilestoneCompleted',
					    										FeedDate__c=System.now(),
		                                           				Team__c=n[i].Team__c,
					                                           	User__c=n[i].LastModifiedById,
					                                           	Message__c='updated milestone ' + n[i].Name + ' to 100% complete in <a href="/apex/TeamsRedirect?id=' + n[i].Team__c + '">' + teamMap.get(n[i].Team__c).Name + '</a>'));
							
						
					} else {
						minifeed.add( new MiniFeed__c( Type__c='MilestoneEdited',
																FeedDate__c=System.now(),
		                                           				Team__c=n[i].Team__c,
					                                           	User__c=n[i].LastModifiedById,
					                                           	Message__c='updated milestone information ' + n[i].Name + ' in <a href="/apex/TeamsRedirect?id=' + n[i].Team__c + '">' + teamMap.get(n[i].Team__c).Name + '</a>'));
							
					}			
				}else{	
					if(n[i].Percent_Completed__c == 100){	
						
						
						
						
					    minifeed.add( new MiniFeed__c( Type__c='TaskCompleted',
					    										FeedDate__c=System.now(),
		                                           				Team__c=n[i].Team__c,
					                                           	User__c=n[i].LastModifiedById,
					                                           	Message__c='updated task ' + n[i].Name + ' to 100% complete in <a href="/apex/TeamsRedirect?id=' + n[i].Team__c + '">' + teamMap.get(n[i].Team__c).Name + '</a>'));
							
						
					} else {
						minifeed.add( new MiniFeed__c( Type__c='TaskEdited',
																FeedDate__c=System.now(),
		                                           				Team__c=n[i].Team__c,
					                                           	User__c=n[i].LastModifiedById,
					                                           	Message__c='updated task information ' + n[i].Name + ' in <a href="/apex/TeamsRedirect?id=' + n[i].Team__c + '">' + teamMap.get(n[i].Team__c).Name + '</a>'));
							
					}
				}
			
		}

		insert minifeed;
		for (Integer i = 0; i < minifeed.size(); i++) {
			TS.TeamsMembersSubscribers(minifeed[i].Team__c, minifeed[i],changesList[i]);
		} 	
	
	}	
	
	if(trigger.isDelete){
		
		
	    List<String> teams = new List<String>();
	    for(ProjectTask__c oldProject : trigger.old) {
	    		teams.add(oldProject.Team__c);	
	    }
	    
	    Map<Id, Team__c> teamMap = new Map<Id, Team__c>([Select Name from Team__c where Id in: teams]);
		
		List<MiniFeed__c> minifeed = new List<MiniFeed__c>();
		for(Integer i = 0; i < Trigger.old.size(); i++) {
		
			ProjectTask__c n = Trigger.old[i];
			if(n.Milestone__c){	
			   	minifeed.add( new MiniFeed__c( Type__c='MilestoneDelete',
			   											FeedDate__c=System.now(),
	                                           			Team__c=n.Team__c,	 
			                                           	User__c=n.CreatedById,
				                                       	Message__c='deleted milestone ' + n.Name + ' in <a href="/apex/TeamsRedirect?id=' + n.Team__c + '">' + teamMap.get(n.Team__c).Name + '</a>' ));
               	               
			} else {
				minifeed.add( new MiniFeed__c( Type__c='TaskDelete',
														FeedDate__c=System.now(),
	                                           			Team__c=n.Team__c,
			                                           	User__c=n.CreatedById,
				                                       	Message__c='deleted task ' + n.Name + ' in <a href="/apex/TeamsRedirect?id=' + n.Team__c + '">' + teamMap.get(n.Team__c).Name + '</a>' ));            
			}
		}
		
		insert minifeed;
	}			
}