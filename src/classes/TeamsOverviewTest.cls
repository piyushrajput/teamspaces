public class TeamsOverviewTest {

	public static testMethod void testTeam() {
		 TeamsOverviewController team = new TeamsOverviewController();
	     team.getFeeds();
	     MiniFeed__c m = new MiniFeed__c();
         TeamsOverviewController.MiniFeeds feed= new TeamsOverviewController.MiniFeeds(m);
    
	}
}