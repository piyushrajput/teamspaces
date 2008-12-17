trigger MainFeedNotesAndAttachments on Attachment (after insert, after delete) {

	if(trigger.isInsert){
	
	  List<MiniFeed__c> minifeed = new List<MiniFeed__c>();
	
	    for(Integer i = 0; i < Trigger.new.size(); i++) {
	
	        Attachment n = Trigger.new[i];
					
	        // We need to:
	        minifeed.add( new MiniFeed__c( Type__c='Attachment',
	                                           User__c=n.CreatedById,
	                                           FeedDate__c=System.now(),
	                                           Message__c='has uploaded an attachment: <a href="' + n.Id + '">' + n.Name + '</a>' ));
	    }
	    insert minifeed;
	    
	}
	
}