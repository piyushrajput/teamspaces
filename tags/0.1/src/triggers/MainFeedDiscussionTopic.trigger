trigger MainFeedDiscussionTopic on DiscussionTopic__c (after insert, after update, after delete) {
	
	/**
	* This happens after insert
	*/	
	if(trigger.isInsert){
	
	  List<MiniFeed__c> minifeed = new List<MiniFeed__c>();
	
	    for(Integer i = 0; i < Trigger.new.size(); i++) {
	
	        DiscussionTopic__c n = Trigger.new[i];
			
			Team__c Team = [select Name, Id from Team__c where Id =: n.Team__c ]; 
			
	        // Blurb:
	        minifeed.add( new MiniFeed__c( 		Type__c='DiscussionNewTopic',
	        									FeedDate__c=System.now(),
	                                           	Team__c=n.Team__c,	        
	                                           	User__c=n.CreatedById,
	                                          	Message__c='created new discussion topic <a href="/apex/DiscussionDetail?id=' + n.Id +'"/>' + n.Subject__c + '</a> in <a href="/apex/TeamsRedirect?id=' + n.Team__c + '">' + Team.Name + '</a>')); 
	    }
	    insert minifeed;
	}
	
}