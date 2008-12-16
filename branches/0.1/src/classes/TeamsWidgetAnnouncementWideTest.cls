public class TeamsWidgetAnnouncementWideTest {
		
		public static testMethod void testTeam() {
		TeamsWidgetAnnouncementWideController  team= new TeamsWidgetAnnouncementWideController();
		BlogEntry__c announcement = new BlogEntry__c();
		TeamsWidgetAnnouncementWideController.AnnouncementWrapper annou= new TeamsWidgetAnnouncementWideController.AnnouncementWrapper(announcement);
	    team.getRecentAnnouncements();
		
		}		
}