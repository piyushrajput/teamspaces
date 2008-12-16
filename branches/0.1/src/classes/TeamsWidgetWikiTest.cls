public class TeamsWidgetWikiTest {
	public static testMethod void testTeam() {
	TeamsWidgetWikiController team = new TeamsWidgetWikiController();
	List<WikiPage__c> listWikiPages= team.getWikiPages();
	  System.assert(listWikiPages.size()==0,'No tiene elementos en la lista');					
	
	
	}
}