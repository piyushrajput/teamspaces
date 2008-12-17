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
			
			DiscussionMessage__c lastMessage = new DiscussionMessage__c();
			
			for (DiscussionMessage__c m : Trigger.old) {	  
		       	// Update Message count at topic
		       Id topicId = m.DiscussionTopic__c;
		       Boolean findDiscussion = false;
		       Integer countD = 0;
		       while (!findDiscussion && countD < topic.size()) {
		       		if (topic[countD].Id == topicId) {
		       			List<DiscussionMessage__c> lastMessageList = new List<DiscussionMessage__c>();
		       			lastMessageList = [select Id, CreatedDate from DiscussionMessage__c where DiscussionTopic__c =: topic[countD].Id order by CreatedDate desc limit 1];
		       			if(lastMessageList.size() > 0)
		       				lastMessage = lastMessageList.get(0);
		       			findDiscussion = true;
			       		topic[countD].MessageCount__c = topic[countD].MessageCount__c - 1;
			       		if(topic[countD].LastPostedMessage__c == m.Id || topic[countD].LastPostedMessage__c == null){
			       			topic[countD].LastPostedMessage__c = lastMessage.Id;
			       		}
				       	update topic[countD];
				       	// Update Message count at forum
				       	String dfId = topic[countD].DiscussionForum__c;
				       	
				       	Boolean findForum = false;
				       	Integer countF = 0;
				       	while (!findForum && countF < forums.size()) {
				       		if (forums[countF].Id == dfId) {
				       			findForum = true;
				       			forums[countF].MessageCount__c = forums[countF].MessageCount__c - 1;
				       			if(forums[countF].LastPostedMessage__c == m.Id || forums[countF].LastPostedMessage__c == null){
					       			forums[countF].LastPostedMessage__c = lastMessage.Id;
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