@IsTest private class TeamsWidgetRecentActivityTest {
    public static testMethod void testTeam() {
        try{
	        GenerateEnvironmentTest.gen();
	        Test.startTest();		        
	        
	        TeamsWidgetRecentActivityController team= new TeamsWidgetRecentActivityController();
	        List<TeamsWidgetRecentActivityController.miniFeed> feeds = team.getMiniFeeds();   
	       
	        TeamsWidgetRecentActivityController.miniFeed feed = new TeamsWidgetRecentActivityController.miniFeed();
	        feed.getTypeOfFeed();
	        feed.setTypeOfFeed('String');
	        feed.getName();
	        feed.getUser();
	        feed.setUser('User name');
	        feed.getMessage();
	        feed.setMessage('String Message');
	        feed.getFeedDate();
	        feed.setFeedDate(System.now());
	        feed.setFeedDateString('String');
	        feed.getFeedDateString();
	        feed.getFeedDateClass();
	        feed.setFeedDateClass('String');

	
			Test.stopTest();
        }catch(Exception e){
    		throw e;
    	}
    }

}