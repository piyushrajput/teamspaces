trigger MainFeedProjectTask on ProjectTask__c bulk (after insert, after update, after delete) {
	
	/**
	* This happens after insert
	*/	
	if(trigger.isInsert){
		
		List<MiniFeed__c> minifeed = new List<MiniFeed__c>();
		
		for(Integer i = 0; i < Trigger.new.size(); i++) {
		
			ProjectTask__c n = Trigger.new[i];
			
			Team__c Team = [select Name, Id from Team__c where Id =: n.Team__c ]; 
			
			if(n.Milestone__c){	
			   	minifeed.add( new MiniFeed__c( Type__c='MilestoneNew',
			   											FeedDate__c=System.now(),
	                                           			Team__c=n.Team__c,	 
			                                           	User__c=n.CreatedById,
				                                       	Message__c='created new milestone ' + n.Name + ' in <a href="/apex/TeamsRedirect?id=' + n.Team__c + '">' + Team.Name + '</a>' ));
               	insert minifeed;               
			} else {
				minifeed.add( new MiniFeed__c( Type__c='TaskNew',
														FeedDate__c=System.now(),
	                                           			Team__c=n.Team__c,
			                                           	User__c=n.CreatedById,
				                                       	Message__c='created new task ' + n.Name + ' in <a href="/apex/TeamsRedirect?id=' + n.Team__c + '">' + Team.Name + '</a>' ));
               	insert minifeed;
			}
		}
	}	
	
	/**
	* This happens after insert
	*/	
	if(trigger.isUpdate){
	
			List<MiniFeed__c> minifeed = new List<MiniFeed__c>();
			
			ProjectTask__c[] n = Trigger.new;
			ProjectTask__c[] o = Trigger.old;
			// ProjectTask__c[] pt = Trigger.old; 
			    
			for(Integer i = 0; i < Trigger.new.size(); i++){
				
				Team__c Team = [select Name, Id from Team__c where Id =: n[i].Team__c ];
						if(n[i].Milestone__c){
				if(n[i].Percent_Completed__c == 100){	
				    minifeed.add( new MiniFeed__c( Type__c='MilestoneCompleted',
				    										FeedDate__c=System.now(),
	                                           				Team__c=n[i].Team__c,
				                                           	User__c=n[i].LastModifiedById,
				                                           	Message__c='updated milestone ' + n[i].Name + ' to 100% complete in <a href="/apex/TeamsRedirect?id=' + n[i].Team__c + '">' + Team.Name + '</a>' ));
						
					//insert minifeed;
					
				} else {
					minifeed.add( new MiniFeed__c( Type__c='MilestoneEdited',
															FeedDate__c=System.now(),
	                                           				Team__c=n[i].Team__c,
				                                           	User__c=n[i].LastModifiedById,
				                                           	Message__c='updated milestone information ' + n[i].Name + ' in <a href="/apex/TeamsRedirect?id=' + n[i].Team__c + '">' + Team.Name + '</a>' ));
						
					//insert minifeed;
				}			
			}else{	
				if(n[i].Percent_Completed__c == 100){	
					
					
					
					
				    minifeed.add( new MiniFeed__c( Type__c='TaskCompleted',
				    										FeedDate__c=System.now(),
	                                           				Team__c=n[i].Team__c,
				                                           	User__c=n[i].LastModifiedById,
				                                           	Message__c='updated task ' + n[i].Name + ' to 100% complete in <a href="/apex/TeamsRedirect?id=' + n[i].Team__c + '">' + Team.Name + '</a>' ));
						
					//insert minifeed;
					
				} else {
					minifeed.add( new MiniFeed__c( Type__c='TaskEdited',
															FeedDate__c=System.now(),
	                                           				Team__c=n[i].Team__c,
				                                           	User__c=n[i].LastModifiedById,
				                                           	Message__c='updated task information ' + n[i].Name + ' in <a href="/apex/TeamsRedirect?id=' + n[i].Team__c + '">' + Team.Name + '</a>' ));
						
					//insert minifeed;
				}
			}
			
		}

		insert minifeed;	
			
	
	}		
}