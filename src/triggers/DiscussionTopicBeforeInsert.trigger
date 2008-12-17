trigger DiscussionTopicBeforeInsert on DiscussionTopic__c (before insert) {

		for (DiscussionTopic__c t : Trigger.new) {
			
	     	t.PostedBy__c 	= UserInfo.getUserId();  
	     	t.PostedDate__c = System.now();  
	     	
		}
}