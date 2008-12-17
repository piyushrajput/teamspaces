trigger DiscussionMessageBeforeInsert on DiscussionMessage__c (before insert) {
	
	for (DiscussionMessage__c t : Trigger.new) {
			
     	t.PostedBy__c 	= UserInfo.getUserId();  
     	t.PostedDate__c = System.now();  
     	
	}

}