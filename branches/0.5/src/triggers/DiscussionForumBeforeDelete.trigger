trigger DiscussionForumBeforeDelete on DiscussionForum__c bulk (before delete) {
	if (!TeamUtil.currentlyExeTrigger) {
		try {	
			TeamUtil.currentlyExeTrigger = true;
			List<DiscussionTopic__c> topicList = [select Id from DiscussionTopic__c where DiscussionForum__c in :Trigger.old];    	
			delete topicList;
		} finally {
        	TeamUtil.currentlyExeTrigger = false;
		}
	} 			 	
}