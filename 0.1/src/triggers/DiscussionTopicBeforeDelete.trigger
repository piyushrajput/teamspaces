trigger DiscussionTopicBeforeDelete on DiscussionTopic__c bulk (before delete) {

    DiscussionTopic__c[] d = Trigger.old;
    
	List<DiscussionMessage__c> msgList = [	Select Id from DiscussionMessage__c where DiscussionTopic__c in :Trigger.old  ];    	
	

	delete msgList;  	  

}