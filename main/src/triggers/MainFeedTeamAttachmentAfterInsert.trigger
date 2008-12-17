trigger MainFeedTeamAttachmentAfterInsert on Attachment (after insert) {

	if (!TeamUtil.currentlyExeTrigger) {
		try {

			// Search of the names of the teams
		    List<String> listTeams = new List<String>();
		    for(Attachment newAttachment : trigger.new) {
				listTeams.add(newAttachment.ParentId);	
		    }
		    Map<Id, Team__c> mapTeams = new Map<Id, Team__c>([select Name from Team__c where Id in : listTeams]);

			List<MiniFeed__c> listMiniFeeds = new List<MiniFeed__c>();
		    for(Attachment newAttachment : trigger.new) {
				// if the Attachment comes from a team
				if(mapTeams.containsKey(newAttachment.ParentId)) {
					// MiniFeed to insert
					MiniFeed__c miniFeed = new MiniFeed__c(
						Type__c = 'TeamMemberAttachmentAdd',
						User__c = newAttachment.CreatedById,
						Team__c = newAttachment.ParentId,
						FeedDate__c = System.now(),
						Message__c = 
							' has uploaded attachment ' + 
							'<a href="/servlet/servlet.FileDownload?file=' + newAttachment.Id + '" target=_blank>' + 
								newAttachment.Name + 
							'</a>' + 
							' to team ' + 
							'<a href="/apex/TeamsRedirect?id=' + newAttachment.ParentId + '">' + 
								mapTeams.get(newAttachment.ParentId).Name + 
							'</a>'
					);
			        listMiniFeeds.add(miniFeed);
				}
		    }
		    // perhaps there are no feeds
		    if (listMiniFeeds.size() > 0)
		    	insert listMiniFeeds;

		} finally {

        	TeamUtil.currentlyExeTrigger = false;

		}
	} 	

}