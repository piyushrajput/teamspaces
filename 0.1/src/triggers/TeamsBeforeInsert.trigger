trigger TeamsBeforeInsert on Team__c (before insert) {

		for (Team__c t : Trigger.new) {
			
	     	t.TeamCreatedBy__c = UserInfo.getUserId();  
	     	t.TeamCreatedDate__c = System.now();  
		}
}