@IsTest private class TeamsWidgetActivityFeedControllerTest {
    public static testMethod void test() {
        try{
			GenerateEnvironmentTest.gen();
            Test.startTest(); 
		
			TeamsWidgetActivityFeedController activity = new TeamsWidgetActivityFeedController();
			activity.getFeeds();
			activity.getMinifeeds();
			
			// Test MiniFeeds inner class
			MiniFeed__c newMini = [Select m.User__c, m.User__r.Name, m.Type__c, m.Message__c, m.Id, m.CreatedDate from MiniFeed__c m limit 1];
			TeamsWidgetActivityFeedController.MiniFeeds miniFeeds  = new TeamsWidgetActivityFeedController.MiniFeeds(newMini);
			miniFeeds.getFeed();
			miniFeeds.getFormatedDate();

            Test.stopTest(); 
        }catch(Exception e){
            throw e;
        }
    } 
}