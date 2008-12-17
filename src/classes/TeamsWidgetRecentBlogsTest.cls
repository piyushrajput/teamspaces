public class TeamsWidgetRecentBlogsTest {
	public static testMethod void testTeam() {
		TeamsWidgetRecentBlogsController team= new TeamsWidgetRecentBlogsController();
    	List<BlogEntry__c> blogs =  team.getBlogs();
    	Boolean previlege = team.getnewPrivileges();
	}
}