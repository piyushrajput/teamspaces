trigger MainFeedProjectAsignee on ProjectAssignee__c (after insert, after update, after delete) {
	
	/**
	* This happens after insert
	*/	
	if(trigger.isInsert){
	
	  List<MiniFeed__c> minifeed = new List<MiniFeed__c>();
	
	    for(Integer i = 0; i < Trigger.new.size(); i++) {
			
			// Must do some auxiliar querys
	        ProjectAssignee__c n = Trigger.new[i];
			
			ProjectTask__c ProjectTask =[ SELECT Id, Team__c, Name FROM  ProjectTask__c WHERE Id =: n.ProjectTask__c];
			
			Team__c Team = [SELECT Id, Name FROM Team__c WHERE Id =: ProjectTask.Team__c];
			
			User UserData = [ SELECT Id, Name FROM User WHERE Id =: n.User__c ];
	        
	        // Blurb:	    
	        minifeed.add( new MiniFeed__c( Type__c='TaskAssigned',
	        									FeedDate__c=System.now(),
	                                           	Team__c=Team.Id,
	                                           	User__c=n.CreatedById,
	                                           	Message__c='assigned new task ' + ProjectTask.Name + 'to <a href="/apex/PeopleProfileDisplay?id=' + n.User__c + '">' + UserData.Name +  '</a> in <a href="/apex/TeamsRedirect?id=' + ProjectTask.Team__c + '">' + Team.Name + '</a>'));
			
		    
	        }        
		    
		    insert minifeed;
	}	
}