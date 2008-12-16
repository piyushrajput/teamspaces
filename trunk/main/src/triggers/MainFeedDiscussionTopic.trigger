trigger MainFeedDiscussionTopic on DiscussionTopic__c bulk (after insert) {
	if (!TeamUtil.currentlyExeTrigger) {
		try {		
			
			/**
			* This happens after insert
			*/	
			
		} finally {
        	TeamUtil.currentlyExeTrigger = false;
		}
	} 		
}