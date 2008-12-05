@IsTest private class DiscussionWidgetMostReadControllerTest {
    public static testMethod void test() {
        try{
			GenerateEnvironmentTest.gen();
            Test.startTest(); 
			DiscussionWidgetMostReadController mostRead = new DiscussionWidgetMostReadController();
			mostRead.getMostRead();
            Test.stopTest(); 
        }catch(Exception e){
            throw e;
        }
    } 
}