public class TeamsWidgetWikiController {


	Id teamspaceId;
	
	public TeamsWidgetWikiController() {
		teamspaceId = System.currentPageReference().getParameters().get('id');
	}
	
	public Id getTeamspaceId() {
		return teamspaceId;
	}
	
	public List<WikiPage__c> getWikiPages() {
		
		if(teamspaceId==null) return new List<WikiPage__c>();
		
		List<WikiPage__c> pages = [SELECT Name
									   FROM WikiPage__c
									   WHERE Team__c =: teamspaceId
									   ORDER BY LastModifiedDate DESC
									   LIMIT 5];
		
		return pages;
	}
	
	
	public Integer getWikiPagesSize(){
		List<WikiPage__c> wikis = getWikiPages();
		
		return wikis.size();		
	}

}