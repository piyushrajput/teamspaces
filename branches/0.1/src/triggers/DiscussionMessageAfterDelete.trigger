trigger DiscussionMessageAfterDelete on DiscussionMessage__c (after delete) {

	for (DiscussionMessage__c m : Trigger.old) {	    	

       // Update Message count at topic
       
       DiscussionTopic__c topic;
       
       Id topicId = m.DiscussionTopic__c;       
       
       topic = [select MessageCount__c, DiscussionForum__c from DiscussionTopic__c where Id =:topicId ];
       
       topic.MessageCount__c -= 1;
       
       update topic;
       
       // Update Message count at forum 
       
       DiscussionForum__c df;
       
       String dfId = topic.DiscussionForum__c;
       
       df = [select MessageCount__c from DiscussionForum__c where Id =: dfId];
       
       df.MessageCount__c -= 1;
       
       update df;
       
       // Delete child messages 
       
       List<DiscussionMessage__c> dmList;
       
       dmList = [Select Id from DiscussionMessage__c where ParentMessage__c =: m.Id];
       
       if(dmList.size() >= 1){
		   	for(DiscussionMessage__c parentMessage: dmList){
		   		delete parentMessage;
		   	}
       }
       
	}
	
}