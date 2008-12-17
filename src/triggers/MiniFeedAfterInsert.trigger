trigger MiniFeedAfterInsert on MiniFeed__c bulk (after insert) {
	
	private final Integer MAX_FEED_LIMIT_NUM = 500;
	
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
	
	//MiniFeeds Limit Number
	if (!TeamUtil.isTest) { 
		Integer feedsCount = [select count() from MiniFeed__c limit : MAX_FEED_LIMIT_NUM];
		if(feedsCount >= MAX_FEED_LIMIT_NUM){
			List<MiniFeed__c> feesToDelete = new List<MiniFeed__c>();
			feesToDelete = [select Id from MiniFeed__c order by CreatedDate asc limit : feeds.size()];
			if(feesToDelete.size() > 0)
				delete feesToDelete;
		}
	}
	
	//Insert new feeds
	insert feeds;
	
	//throw new CustomException('Only to get the System Debug');	
}