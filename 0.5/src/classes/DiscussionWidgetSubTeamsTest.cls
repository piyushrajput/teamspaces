@IsTest private class DiscussionWidgetSubTeamsTest {

public static String teamId = System.currentPageReference().getParameters().get('id');
    public static testMethod void testDiscussion() {
    	
    	GenerateEnvironmentTest.gen();
    	Test.startTest();
    	
        DiscussionWidgetSubTeamsController dis = new DiscussionWidgetSubTeamsController();
        DiscussionWidgetSubTeamsController.subTeams sub = new DiscussionWidgetSubTeamsController.subTeams();
        
        dis.setTeamId(GenerateEnvironmentTest.newTeam.Id);
        
        dis.getCountSubTeams();
        dis.getSubTeams();

        sub.getName();
        sub.getId();
        sub.getCount();
        
        Test.stopTest();
        
    }       
}