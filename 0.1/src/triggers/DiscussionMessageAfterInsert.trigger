trigger DiscussionMessageAfterInsert on DiscussionMessage__c (after insert) {
	
    for (DiscussionMessage__c m : Trigger.new) {	    	

       // Update Message count at topic
       
       DiscussionTopic__c topic;
       
       Id topicId = m.DiscussionTopic__c;       
       
       topic = [select MessageCount__c, DiscussionForum__c from DiscussionTopic__c where Id =: topicId ];
       
       topic.MessageCount__c += 1;
       
       // Update LastPostedMessage Topic
       
       topic.LastPostedMessage__c = m.Id;
       
       update topic;
       
       // Update Message count at forum 
       
       DiscussionForum__c df;
       
       String dfId = topic.DiscussionForum__c;
       
       df = [select Id, MessageCount__c from DiscussionForum__c where Id =: dfId];
       
       df.MessageCount__c += 1;
       
        // Update LastPostedMessage Forum
        
       df.LastPostedMessage__c = m.Id; 
       
       update df;
        
	}
	
}