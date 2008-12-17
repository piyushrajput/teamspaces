trigger MiniFeedStatusChange on PeopleProfile__c (after update) {

	//////////////////////////////////////////////////////////////////////
	//  This happens after insert
	//////////////////////////////////////////////////////////////////////
	
	if(trigger.isUpdate){
		
	  List<MiniFeed__c> minifeed = new List<MiniFeed__c>();
		
	    for(Integer i = 0; i < Trigger.new.size(); i++) {
			
	        PeopleProfile__c n = Trigger.new[i];
	        PeopleProfile__c o = Trigger.old[i];
	        
			// status change?
			if(n.Status__c != o.Status__c){
		        minifeed.add( new MiniFeed__c( Type__c='PeopleChangeStatus',
		                                           User__c=n.User__c,
		                                           Message__c=' ' + n.Status__c ));
			}
	    }
	
	    insert minifeed;
	}
}