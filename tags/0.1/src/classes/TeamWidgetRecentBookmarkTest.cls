public class TeamWidgetRecentBookmarkTest {
	public static testMethod void testTeam() {
	TeamWidgetRecentBookmarkController team = new TeamWidgetRecentBookmarkController();
	List<Bookmark__c> listBookmarks= team.getBookmarks();
    Boolean privilege = team.getnewPrivileges();
    System.assert(privilege==false,'No tiene previlegios');
    
	}
}