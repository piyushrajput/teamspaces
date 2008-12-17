trigger TeamAfterInsert on Team__c (after insert) {
	
	
	for (Team__c t : Trigger.new) {
		
		/**
		* Add Discussion Forum to the Team 
		*/		
		DiscussionForum__c newForum = new DiscussionForum__c();
		newForum.Team__c = t.Id;
		insert newForum;
		
		/**
		* Add a Project for this Team 
		*/		
		Project2__c p = new Project2__c();
		p.Team__c = t.Id;
		p.synchClndr__c = false;
		p.Priority__c = 'Medium';
		p.Name = t.Name + ' Project';
		insert p;
	}  	
	    	
}