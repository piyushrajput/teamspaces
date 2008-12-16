trigger MiniFeedAfterInsert on MiniFeed__c bulk (after insert) {
	
	
	if (!TeamUtil.isTest) { 	
		TeamsSubscribersEmailServices TS = new TeamsSubscribersEmailServices();
		for(MiniFeed__c m : Trigger.new) {	
			TS.TeamsMembersSubscribers(m.Team__c, m,''); 
		}
	}
	
	List<String> teamSharingGroupNames = new List<String>();		
	for(MiniFeed__c m : Trigger.new) {
		teamSharingGroupNames.add('teamSharing' + m.Team__c);
	}
	
	System.debug('\n\n/////////////////////////////// TEAM SHARING GROUP NAMES : ' + teamSharingGroupNames + '\n////////////////////////////////////\n\n');
	
	Map<String, Id> teamMap = new Map<String, Id>();					
	for(Group g: [select id, name from Group where Name in: teamSharingGroupNames]) {
		teamMap.put(g.Name, g.Id);
	}
	
	
	List<MiniFeed__Share> feeds = new List<MiniFeed__Share>();
	for(MiniFeed__c m : Trigger.new) {
		
		MiniFeed__Share f = new MiniFeed__Share();
		f.ParentId = m.Id;
		if(m.Team__c != null) f.UserOrGroupId = teamMap.get('teamSharing' + m.Team__c);
		else                  f.UserOrGroupId = TeamUtil.getOrganizationGroup().Id;
	    f.AccessLevel = 'Read';
	    f.RowCause = 'Manual';
	    feeds.add(f);
	}
	
	insert feeds;
	
	//throw new CustomException('Only to get the System Debug');	
}