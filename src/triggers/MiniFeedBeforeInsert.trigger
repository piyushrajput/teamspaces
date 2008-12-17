trigger MiniFeedBeforeInsert on MiniFeed__c (before insert) {
	
		for (MiniFeed__c t : Trigger.new) {
			
	     	t.FeedDate__c = System.now();  
	     	
		}
}