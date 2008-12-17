trigger DiscussionMessageAfterInsert on DiscussionMessage__c bulk (after insert) {
	if (!TeamUtil.currentlyExeTrigger) {
		try {		
		    
		    List<String> idsTeam = new List<String>();
			for (DiscussionMessage__c iterMsg : Trigger.new) {
				idsTeam.add(iterMsg.team__c); 
			}
		    
		    List<Group> groupTeam = [select id, Name from Group where Name like 'teamSharing%'];
		    List<DiscussionTopic__c> topicList = [select id, MessageCount__c, DiscussionForum__c, Team__c from DiscussionTopic__c where Team__c in: idsTeam];
		    List<DiscussionForum__c> forumList = [select Id, MessageCount__c, Team__c from DiscussionForum__c where Team__c in: idsTeam];		    
		    
		    for (DiscussionMessage__c m : Trigger.new) {
		       // Update Message count at topic
		       Id topicId = m.DiscussionTopic__c;       
		       List<DiscussionMessage__c> countMessage = [select Id, DiscussionTopic__c from DiscussionMessage__c where DiscussionTopic__c =: m.DiscussionTopic__c limit 2];
		       Boolean findTopic = false;
		       Integer countTopic = 0;
		       while (!findTopic && countTopic < topicList.size()) {
		       		if (topicList[countTopic].Id == topicId) {
		       			findTopic = true;
		       			if(countMessage.size() == 2){
			       			topicList[countTopic].LastPostedMessage__c = m.Id;
		       			}
		       			topicList[countTopic].MessageCount__c += 1;
		       			update topicList[countTopic];
		       		}
		    		countTopic++;
		    	}
		       
		       // Update Message count at forum  
		       	String teamId = m.Team__c;
		  		Boolean findForum = false;
		  		Integer countForum = 0;
		  		while (!findForum && countForum < forumList.size()) {
		  			if (forumList[countForum].Team__c == teamId) {
		  				findForum = true;
		  				if(countMessage.size() == 2){
			  				forumList[countForum].MessageCount__c += 1;
			     			forumList[countForum].LastPostedMessage__c = m.Id; 
			     			update forumList[countForum];
		  				}
		  			}
		  			countForum++;
		  		}     
		       
		       // Instantiate the sharing objects
			   DiscussionMessage__Share fShare = new DiscussionMessage__Share();
			   fShare.ParentId = m.Id;    
			   // Set the ID of user or group being granted access
			   	String groupName = 'teamSharing' + m.team__c;
			   	Boolean findGroup = false;
			   	Integer countGroup = 0;
			   	while (!findGroup && countGroup < groupTeam.size()) {
					if (groupTeam[countGroup].Name == groupName) {
						findGroup = true;	
						fShare.UserOrGroupId = groupTeam[countGroup].Id;
					}
					countGroup++;
			   	}
			   // Set the access level
			   fShare.AccessLevel = 'read';
			   fShare.RowCause = 'Manual';          
			   // Add objects to list for insert
			   insert fShare;    	   
		        
			}
		} finally {
        	TeamUtil.currentlyExeTrigger = false;
		}
	} 	
}