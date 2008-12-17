public class TeamsWidgetRecentActivitiesTest {

	public static testMethod void testTeam() {
		TeamsWidgetRecentActivitiesController team = new TeamsWidgetRecentActivitiesController();	
		List<TeamsWidgetRecentActivitiesController.miniFeed> feeds=team.getMiniFeeds();	
		TeamsWidgetRecentActivitiesController.miniFeed feed = new TeamsWidgetRecentActivitiesController.miniFeed();
	}
}