@IsTest private class TeamsWidgetMyTasksAndMilTest {
	
	public static testMethod void TeamsWidgetMyTasksAndMilTest() {
		
		GenerateEnvironmentTest.gen();   
    	Test.startTest();
    	TeamsWidgetMyTasksAndMilController con = new TeamsWidgetMyTasksAndMilController();
    	TeamsWidgetMyTasksAndMilController.ProjectTasks pT = new TeamsWidgetMyTasksAndMilController.ProjectTasks();
    	
    	if (con.getAllProjectTasks() == null) 
    		System.assert(true,'getAllProjectTasks failed');
    		
    	if (pT.getDaysCount() == null) 
    		System.assert(true,'getDaysCount failed');
    	
    	Test.stopTest();
	}

}