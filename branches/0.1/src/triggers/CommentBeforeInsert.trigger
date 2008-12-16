trigger CommentBeforeInsert on Comment__c (before insert) {
	
	for (Comment__c t : Trigger.new) {
			
     	t.PostedBy__c 	= UserInfo.getUserId();   
     	t.PostedDate__c = System.now();  
     	
	}
	
}