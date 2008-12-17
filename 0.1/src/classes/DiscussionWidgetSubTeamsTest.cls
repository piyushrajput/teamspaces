public class DiscussionWidgetSubTeamsTest {

public static String teamId = System.currentPageReference().getParameters().get('id');
	public static testMethod void testDiscussion() {

	DiscussionWidgetSubTeamsController dis = new DiscussionWidgetSubTeamsController();
	DiscussionWidgetSubTeamsController.subTeams sub = new DiscussionWidgetSubTeamsController.subTeams();
    //List<DiscussionWidgetSubTeamsController.subTeams> list = new dis.getSubTeam(String teamId)
 	//System.assert(list.size()==0,'La lista no tiene elementos');	
	}	 	
}