trigger MainFeedDiscussionMessage on DiscussionMessage__c (after insert, after update, after delete) {
	/**
	* This happens after insert
	*/	
	if(trigger.isInsert){
	
	  List<MiniFeed__c> minifeed = new List<MiniFeed__c>();
	
	    for(Integer i = 0; i < Trigger.new.size(); i++) {
	
	        DiscussionMessage__c n = Trigger.new[i];
			
			Team__c Team = [select Name, Id from Team__c where Id =: n.Team__c ];
			
			DiscussionTopic__c Topic = [select Name, Id from DiscussionTopic__c where id =: n.DiscussionTopic__c];
			 
        // Blurb:
        if(n.DiscussionTopic__r.MessageCount__c > 1){
	        minifeed.add( new MiniFeed__c( Type__c='DiscussionNewReply',
	                                           	User__c=n.CreatedById,
	                                           	FeedDate__c=System.now(),
	                                           	Team__c=n.Team__c,
	                                           	Message__c='replied to discussion topic <a href="/apex/DiscussionDetails?id=' + n.DiscussionTopic__c + '>' + Topic.Name + '</a> in <a href="/apex/TeamsRedirect?id=' + n.Team__c + '">' + Team.Name + '</a>'));
			
		    }
        }        
	    
	    insert minifeed;
	} 
}