public class TeamsWidgetRecentAnnouncementController {
	
	Id teamspaceId;
	
	public TeamsWidgetRecentAnnouncementController() {
		
		teamspaceId = System.currentPageReference().getParameters().get('id');
	}
	
	public Id getTeamspaceId() {
		return teamspaceId;
	}
	
	public List<BlogEntry__c> getRecentAnnouncements() {
		
		if(teamspaceId == null) return new List<BlogEntry__c>();
		
		List<BlogEntry__c> announcements = [SELECT Title__c
									   		   FROM BlogEntry__c
									   		   WHERE Team__c =: teamspaceId
									  		   ORDER BY CreatedDate DESC
									   		   LIMIT 5];
		
		return announcements;
	}

}