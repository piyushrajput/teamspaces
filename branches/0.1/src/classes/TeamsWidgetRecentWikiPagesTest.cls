public class TeamsWidgetRecentWikiPagesTest {
	public static testMethod void testTeam() {
		TeamsWidgetRecentWikiPagesController team = new TeamsWidgetRecentWikiPagesController();
		List<WikiPage__c> listWikis = team.getWikis();
	}
}