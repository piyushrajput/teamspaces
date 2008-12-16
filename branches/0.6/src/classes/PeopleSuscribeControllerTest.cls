@IsTest private class PeopleSuscribeControllerTest {
    public static testMethod void test() {
        try{
			GenerateEnvironmentTest.gen();
            Test.startTest(); 
		
			PeopleSuscribeController suscribe = new PeopleSuscribeController();

			PeopleSubscription__c ps = new PeopleSubscription__c();
			ps.Name = 'Test';
			ps.Person__c = UserInfo.getUserId();
			ps.Subscriber__c = UserInfo.getUserId();
			insert ps;
			
			suscribe.setPersonId(UserInfo.getUserId());
			suscribe.getPersonId();
			suscribe.getCurrentId();
			suscribe.getIsCurrentUser();
			
			suscribe.getSubscriptionStatus();
			suscribe.Subscribe();
			suscribe.getSubscribedBoolean();
			suscribe.getSubscribedName();
			suscribe.getSubsRow();
			suscribe.Subscribe();

            Test.stopTest(); 
        }catch(Exception e){
            throw e;
        }
    } 
}