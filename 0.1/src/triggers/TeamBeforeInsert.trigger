trigger TeamBeforeInsert on Team__c (before insert) {
	
	for (Team__c t : Trigger.new) {
		t.TeamCreatedDate__c = System.now();
		t.TeamCreatedBy__c = UserInfo.getUserId();
	}
}