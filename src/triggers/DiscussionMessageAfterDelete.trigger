trigger DiscussionMessageAfterDelete on DiscussionMessage__c bulk (after delete) {
	if (!TeamUtil.currentlyExeTrigger) {
		try {	
			TeamUtil.currentlyExeTrigger = true;
			
			List<String> idsTeam = new List<String>();
			for (DiscussionMessage__c m : Trigger.old) {
				idsTeam.add(m.team__c); 
			}
			
			List<DiscussionMessage__c> dmList = [Select Id, ParentMessage__c from DiscussionMessage__c where ParentMessage__c in: Trigger.old];
			List<DiscussionTopic__c> topic = [select id, MessageCount__c, LastPostedMessage__c, DiscussionForum__c, Team__c from DiscussionTopic__c where team__c in: idsTeam];
			List<DiscussionForum__c> forums = [select id, MessageCount__c, LastPostedMessage__c, Team__c from DiscussionForum__c where team__c in: idsTeam];
						
			for (DiscussionMessage__c m : Trigger.old) {	  
		       	// Update Message count at topic
		       Id topicId = m.DiscussionTopic__c;
		       Boolean findDiscussion = false;
		       Integer countD = 0;
		       while (!findDiscussion && countD < topic.size()) {
		       		if (topic[countD].Id == topicId) {
		       			findDiscussion = true;
		       			topic[countD].MessageCount__c -= 1;
		       			List<DiscussionMessage__c> lastMessage = [select Id, CreatedDate from DiscussionMessage__c where DiscussionTopic__c =: topic[countD].Id order by CreatedDate desc limit 2];
			       		if(lastMessage.size() > 0){
				       		if(lastMessage.size() == 2){
					       		if(topic[countD].LastPostedMessage__c == m.Id || topic[countD].LastPostedMessage__c == null){
					       			topic[countD].LastPostedMessage__c = lastMessage[0].Id;
					       		}
				       		}else if(lastMessage.size() == 1){
				       			topic[countD].LastPostedMessage__c = null;
				       		}
				       		update topic[countD];
			       		}
				       	// Update Message count at forum
				       	Integer countF = 0;
				       	Boolean findForum = false;
				       	String dfId = topic[countD].DiscussionForum__c;
				       	while (!findForum && countF < forums.size()) {
				       		if (forums[countF].Id == dfId) {
				       			findForum = true;
			       				forums[countF].MessageCount__c -= 1;
				       			if(forums[countF].LastPostedMessage__c == m.Id || forums[countF].LastPostedMessage__c == null){
					       			Integer incLimit = 1;
								 	Boolean isLast = false;
								 	Integer totalMessages = [select count() from DiscussionMessage__c where Team__c =: m.Team__c];
								 	if(totalMessages > 0){
									 	while(!isLast && incLimit <= totalMessages){
									 		List<DiscussionMessage__c> lastMessages = [select Id, DiscussionTopic__c, Team__c 
									 												from DiscussionMessage__c 
									 												where Team__c =: m.Team__c 
									 												order by CreatedDate desc 
									 												limit : incLimit];
									 		if(lastMessages.size() > 0){
									 			Integer lastElement = lastMessages.size() - 1;
									 			List<DiscussionMessage__c> countTopicMessages = [select Id, DiscussionTopic__c 
									 															from DiscussionMessage__c 
									 															where DiscussionTopic__c =: lastMessages[lastElement].DiscussionTopic__c 
									 															limit 2];
									 			if(countTopicMessages.size() > 1){
									 				forums[countF].LastPostedMessage__c = lastMessages[lastElement].Id;
									 				isLast = true;
									 			}else {
									 				forums[countF].LastPostedMessage__c = null;
									 			}
									 		}else{
									 			forums[countF].LastPostedMessage__c = null;
									 			isLast = true;
									 		}
									 		incLimit++;
									 	}
								 	}else{
								 		forums[countF].LastPostedMessage__c = null;
								 	}
					       		}
						       	update forums[countF];
				       		}	
				       		countF++;	
				       	}
		       		}
		       		countD++;
		       	}
		       	
		       	List<DiscussionMessage__c> delDM = new List<DiscussionMessage__c>();
		       	Integer countM = 0;
		       	while (countM < dmList.size()) {
		       		if (dmList[countM].ParentMessage__c == m.Id) {
		       			delDM.add(dmList[countM]);
		       		}
		       		countM++;	
		       	}
		       	if(delDM.size() > 0){
					delete delDM;
		       	}
			}
		} finally {
        	TeamUtil.currentlyExeTrigger = false;
		}
	} 	
}