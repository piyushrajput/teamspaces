trigger MainFeedBlogs on BlogEntry__c (after insert, after update, after delete) {
	
	/**
	* This happens after insert
	*/	
	if(trigger.isInsert){
	
	  List<MiniFeed__c> minifeed = new List<MiniFeed__c>();
	
	    for(Integer i = 0; i < Trigger.new.size(); i++) {
	
	        BlogEntry__c n = Trigger.new[i];
	        
	        if(n.PublishedDate__c != null){ 
			
				Team__c Team = [select Name, Id from Team__c where Id =: n.Team__c ];
		        // Blurb:
		        minifeed.add( new MiniFeed__c( Type__c='BlogPublished',
		                                           User__c=n.PostedBy__c,
		                                           FeedDate__c=n.PublishedDate__c,
		                                           Team__c=n.Team__c,
		                                           Message__c='created new blog <a href="/apex/BlogDetails?id=' + n.Id +'"/>' + n.Name + '</a> in <a href="/apex/TeamsRedirect?id=' + n.Team__c + '">' + Team.Name + '</a>'));
	    
	        }
	    }
	    if(minifeed.size() > 0) { insert minifeed; }
	}
	
}