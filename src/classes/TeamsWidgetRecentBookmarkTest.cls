public class TeamsWidgetRecentBookmarkTest {
	public static testMethod void testTeam() {
		TeamsWidgetRecentBookmarkController team = new TeamsWidgetRecentBookmarkController();
		List<Bookmark__c> bookmarks = team.getRecentBookmarks(); 
	}	
}