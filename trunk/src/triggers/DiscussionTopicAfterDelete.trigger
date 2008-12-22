trigger DiscussionTopicAfterDelete on DiscussionTopic__c bulk (after delete) {
	if (!TeamUtil.currentlyExeTrigger) {
		try {	
			TeamUtil.currentlyExeTrigger = true;
		 	
		 	List<String> idsTeam = new List<String>();
			for (DiscussionTopic__c iterTopic : Trigger.old) {
				idsTeam.add(iterTopic.team__c); 
			}
			
			List<DiscussionForum__c> forumList = [select Id, LastPostedMessage__c, MessageCount__c, TopicCount__c, Team__c 
													from DiscussionForum__c 
													where Team__c in: idsTeam];
			System.debug(' ');
			System.debug(' ');
		 	System.debug('######################## DiscussionTopicAfterDelete ##############################');
		 	for (DiscussionTopic__c t : Trigger.old) {
		        Id forumId = t.DiscussionForum__c;
		        Boolean findForum = false;
		        Integer countForum = 0;
		        while (!findForum && countForum < forumList.size()) {
		        	if (forumList[countForum].Id == forumId) {
		        		findForum = true;
		        		if(forumList[countForum].TopicCount__c != null)
							forumList[countForum].TopicCount__c = forumList[countForum].TopicCount__c - 1;
						if(forumList[countForum].MessageCount__c != null || t.MessageCount__c != null)
							forumList[countForum].MessageCount__c = forumList[countForum].MessageCount__c - (t.MessageCount__c - 1);
						// Get the last posted message of forum 
						List<DiscussionMessage__c> forumLastMsg = [select Id, DiscussionTopic__c 
																	from DiscussionMessage__c 
																	where Id =: forumList[countForum].LastPostedMessage__c 
																	limit 1];
						System.debug('forumLastMsg.size()[' + forumLastMsg.size() + ']');
						if(forumLastMsg.size() == 0){
						 	Integer incLimit = 1;
						 	Boolean isLast = false;
						 	Integer totalMessages = [select count() from DiscussionMessage__c where Team__c =: t.Team__c];
						 	while(!isLast && incLimit < totalMessages){
						 		System.debug('totalMessages[' + totalMessages + '] incLimit[' + incLimit + ']');
						 		List<DiscussionMessage__c> lastMessages = [select Id, DiscussionTopic__c, Team__c 
						 													from DiscussionMessage__c 
						 													where Team__c =: t.Team__c 
						 													order by CreatedDate desc 
						 													limit : incLimit];
						 		System.debug('lastMessages.size()[' + lastMessages.size() + ']');
						 		if(lastMessages.size() > 0){
						 			Integer lastElement = lastMessages.size() - 1;
						 			List<DiscussionMessage__c> countTopicMessages = [select Id, DiscussionTopic__c 
						 																from DiscussionMessage__c 
						 																where DiscussionTopic__c =: lastMessages[lastElement].DiscussionTopic__c 
						 																limit 2];
						 			if(countTopicMessages.size() > 1){
						 				System.debug('LastPostedMessage__c[' + lastMessages[lastElement].Id + ']');
						 				forumList[countForum].LastPostedMessage__c = lastMessages[lastElement].Id;
						 				isLast = true;
						 			}
						 		}else {
						 			forumList[countForum].LastPostedMessage__c = null;
						 			isLast = true;
						 		}
						 		incLimit++;
						 	}
							if(!isLast)
								forumList[countForum].LastPostedMessage__c = null;
						}
			      		update forumList[countForum];
		        	}
		        	countForum++;
		        }
		    }
		} finally {
        	TeamUtil.currentlyExeTrigger = false;
		}
	} 		    
}