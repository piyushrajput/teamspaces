trigger DiscussionTopicAfterDelete on DiscussionTopic__c (after delete) {

 	 for (DiscussionTopic__c t : Trigger.old) {
        
        DiscussionForum__c forum;
        
        Id forumId = t.DiscussionForum__c;
        
      	forum = [select TopicCount__c from DiscussionForum__c where Id =:forumId ];
		
		// Decrease Topic Count
		forum.TopicCount__c -= 1;
          
      	update forum;      
    }
}