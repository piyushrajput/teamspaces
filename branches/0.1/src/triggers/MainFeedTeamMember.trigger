trigger MainFeedTeamMember on TeamMember__c (after update, after insert, after delete)  {
	
	/**
	* This happens after insert
	* Team Member Add
	* Team Member Join
	*/	
	if(trigger.isInsert){
	
	  List<MiniFeed__c> minifeed = new List<MiniFeed__c>();
	
	    for(Integer i = 0; i < Trigger.new.size(); i++) {
	
	        TeamMember__c n = Trigger.new[i];  
			
			Team__c TeamJoined = [select Name, Id from Team__c where Id =: n.Team__c ];
			
			User UserData = [ SELECT Id, Name FROM User WHERE Id =: n.User__c ];
			
			// User Added by other user
			if(n.CreatedById != n.User__c){
	        // Blurb:
	        minifeed.add( new MiniFeed__c( Type__c='TeamMemberAdd',
	                                           	User__c=n.CreatedById,
	                                           	FeedDate__c=System.now(),
	                                           	Team__c=n.Team__c,
	                                           	Message__c=' added '+ UserData.Name + ' to the team <a href="/apex/TeamsRedirect?id=' + n.Team__c + '">' + TeamJoined.Name + '</a>' ));
			} else {
			// User joined
	        minifeed.add( new MiniFeed__c( Type__c='TeamMemberJoin',
	        									FeedDate__c=System.now(),
	                                           	Team__c=n.Team__c,
                                   				User__c=n.User__c,
                                   				Message__c=' joined the team <a href="/apex/TeamsRedirect?id=' + n.Team__c + '">' + TeamJoined.Name + '</a>' ));
			}
	    }
	    insert minifeed;
	}
	
	/**
	* This happens after Update
	*/	
	if(trigger.isUpdate){

    List<MiniFeed__c> minifeed = new List<MiniFeed__c>();

	    for(Integer i = 0; i < Trigger.old.size(); i++) {
	
	        TeamMember__c o = Trigger.old[i];
	        TeamMember__c n = Trigger.new[i];
	
			Team__c Team = [select Name, Id from Team__c where Id =: o.Team__c ];
			
			User UserData = [ SELECT Id, Name FROM User WHERE Id =: n.User__c ];
			
	        // Blurb:
	        if(o.TeamRole__c != n.TeamRole__c){
		        // Modified team Role
		        minifeed.add( new MiniFeed__c( Type__c='TeamEditRole',
	                                           User__c=n.LastModifiedById,
	                                           FeedDate__c=System.now(),
	                                           Team__c=n.Team__c,
	                                           Message__c=' updated <a href="/apex/PeopleProfileDisplay?id=' + n.User__c +'">' + UserData.Name + '\'s</a> team role to ' + n.TeamRole__c + ' in the <a href="/apex/TeamsRedirect?id=' + n.Team__c + '">' + Team.Name + '</a> team '));
	        } else {
	        	// Modified Team Profile
	        	if(o.TeamProfile__c != n.TeamProfile__c){
	        		
	        		TeamProfile__c TeamProfile = [Select Id, Name FROM TeamProfile__c WHERE Id =: n.TeamProfile__c];
	        		
		        	minifeed.add( new MiniFeed__c( Type__c='TeamEditProfile',
		                                           User__c=n.LastModifiedById,
		                                           FeedDate__c=System.now(),
	                                           	   Team__c=n.Team__c,
		                                           Message__c=' updated <a href="/apex/PeopleProfileDisplay?id=' + n.User__c +'">' + UserData.Name + '\'s</a> team profile to ' + TeamProfile.Name + ' in the <a href="/apex/TeamsRedirect?id="' + n.Team__c + '">' + Team.Name + '</a> team '));
	        	}
	        }
	    }
	
	    insert minifeed;

  	}
	
	/**
	* This happens after Delete
	*/		
	if(trigger.isDelete){
		
	  	List<MiniFeed__c> minifeed = new List<MiniFeed__c>();
	
   		for(Integer i = 0; i < Trigger.old.size(); i++) {
	
	        TeamMember__c o = Trigger.old[i];
			
			Team__c deletedTeam = [select Name, Id from Team__c where Id =: o.Team__c ];
	        // Blurb:
	        minifeed.add( new MiniFeed__c( Type__c='TeamMemberLeave',
	                                           User__c=o.User__c,
	                                           FeedDate__c=System.now(),
	                                           Team__c=o.Team__c,
	                                           Message__c=' left the team <a href="/apex/TeamsRedirect?id=' + o.Team__c + '">' + deletedTeam.Name + '</a>' ));
    	}
    
    insert minifeed;
    
	}
		
}