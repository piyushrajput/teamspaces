trigger MainFeedComments on Comment__c (after insert, after update, after delete) {
	
	/**
	* This happens after insert
	*/	
	if(trigger.isInsert){
	
	  List<MiniFeed__c> minifeed = new List<MiniFeed__c>();
	
	    for(Integer i = 0; i < Trigger.new.size(); i++) {
	
	        Comment__c n = Trigger.new[i];
			
	        // Blurb:
	        if(n.BlogEntry__c != null){
	        	
	        	
				BlogEntry__c blog = [SELECT Name, Id, Team__c from BlogEntry__c WHERE Id =: n.BlogEntry__c ];
				
				Team__c team = [SELECT Name, Id from Team__c WHERE Id =: blog.Id];
	        	
		        minifeed.add( new MiniFeed__c( Type__c='BlogNewComment',
		                                           	User__c=n.CreatedById,
		                                           	FeedDate__c=System.now(),
	                                           		Team__c=team.Id,
		                                           	Message__c='commented on blog <a href="/apex/BlogDetails?id=' + n.BlogEntry__c + '">' + blog.Name + '</a> in <a href="/apex/TeamsRedirect?id=' + blog.Team__c + '">' + team.Name + '</a>' ));
				
				 insert minifeed;
		    }
	     
	        
	        if(n.ParentWikiPage__c != null){
	        	
	        	
				WikiPage__c Wiki = [SELECT Name, Id, Team__c from WikiPage__c WHERE Id =: n.ParentWikiPage__c];
	        	Team__c team = [SELECT Name, Id from Team__c WHERE Id =: Wiki.Team__c];
	        	
		        minifeed.add( new MiniFeed__c( Type__c='WikiNewComment',
		        									FeedDate__c=System.now(),
	                                           		Team__c=team.Id,
		                                           	User__c=n.CreatedById,
		                                           	Message__c='commented on wiki page <a href="/apex/WikiPage?idWP=' + n.ParentWikiPage__c + '">' + Wiki.Name + '</a> in <a href="/apex/TeamsRedirect?id=' + Wiki.Team__c + '">' + team.Name + '</a>' ));
				
			  	insert minifeed;
	        }  	   
		}
	}
}