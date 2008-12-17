@IsTest private class ProjectLookupControllerTest 
{	
	public static testMethod void ProjectLookupController()    
	{
		
		GenerateEnvironmentTest.gen();
    	Test.startTest();
		ProjectLookupController PLC =  new ProjectLookupController();
		List<ProjectTask__c> myTask =  PLC.getTask();
		Test.stopTest();
	} 
}