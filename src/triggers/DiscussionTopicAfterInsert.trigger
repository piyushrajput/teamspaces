trigger DiscussionTopicAfterInsert on DiscussionTopic__c (after insert) {
	
	for (DiscussionTopic__c t : Trigger.new) {
       
        DiscussionForum__c forum;
        
        Id forumId = t.DiscussionForum__c;
              	
       	forum = [select TopicCount__c from DiscussionForum__c where Id =: forumId ];

    	forum.TopicCount__c = forum.TopicCount__c + 1;

        update forum;
     }
}