@IsTest private class TeamsSubscriptionControllerTest {
	public static testMethod void test(){
        try{
			GenerateEnvironmentTest.gen();
            Test.startTest();
            
            TeamsSubscriptionController subscription = new TeamsSubscriptionController();
            subscription.getSubscriptionCount();
            subscription.getSubscription();
            subscription.getIdTeam();
            subscription.setIdTeam(GenerateEnvironmentTest.newTeam.Id);
            subscription.constructMethods();
            subscription.saveSubscription();
            subscription.cancelSubscription();
            subscription.deleteSubscription();
            
            Test.stopTest();	
        }catch(Exception e){		
        	throw e;
        }
	}
}