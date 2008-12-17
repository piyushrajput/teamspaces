trigger StatusUpdateTrigger on PeopleProfile__c (after update) {

 		List<PeopleProfile__c> newUserProfileList = new List<PeopleProfile__c>();
        
        for(Integer i = 0; i < Trigger.old.size(); i++) {
        	
        	PeopleProfile__c o = Trigger.old[i];
        	PeopleProfile__c n = Trigger.new[i];
        	        	
    		n.StatusLastModifiedDate__c=System.now();
        	
        	newUserProfileList.add(n);       		
	       	
        }
        
        update newUserProfileList;
       	
}