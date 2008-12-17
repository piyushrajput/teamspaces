public class TeamsWidgetActiveDiscussionsTest {

	public static testMethod void testTeam() {
	TeamsWidgetActiveDiscussionsController team = new TeamsWidgetActiveDiscussionsController();
	List<DiscussionTopic__c> discussions;
	DiscussionForum__c forum;
	Id teamspaceId;
	Integer actdisSize;
	String userId = UserInfo.getUserId();
    Boolean previleges=team.getnewPrivileges();
    System.assert(previleges==false,'El usuario no tiene TeamMember');
	DiscussionTopic__c dis = new DiscussionTopic__c();
	TeamsWidgetActiveDiscussionsController.Discussion disc= new	TeamsWidgetActiveDiscussionsController.Discussion(dis);
	team.getDiscussions();	
	//System.assert(list.size()<0,'La lista no tiene elementos');	
	Datetime d =System.now();
	String fecha= disc.formatDateToText(d);
	System.assert(fecha=='Today ','OK'); 	
	
	}
}