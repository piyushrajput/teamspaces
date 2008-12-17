trigger DiscussionForumBeforeDelete on DiscussionForum__c bulk (before delete) {


    DiscussionForum__c[] d = Trigger.old;
    
	List<DiscussionTopic__c> topicList = [	Select Id from DiscussionTopic__c where DiscussionForum__c in :Trigger.old  ];    	
	

	delete topicList;  	 
    
}