public class TeamsCreateNewTaskControllerTest {
	
	public static testMethod void TestCreateTask()
	{
		TeamsCreateNewTaskController n = new TeamsCreateNewTaskController();
		String type2 = n.getTypeOfAction();
		System.assertEquals(type2,'Add New');	
		
		n.setParam('0000sdasdas0dasd');
		
		List<SelectOption> percent = n.getPercent();
		if(percent.size() == 0){
			System.assert(false, 'test mio');
		}
		
		List<SelectOption> member = n.getMembers();
		if(member.size() == 0){
			System.assert(false, 'no members');
		}
		
		 List<SelectOption> priority =  n.getPriority();
		 if(priority.size() == 0){
		 	System.assert(false, 'no priority List');
		 }
		
		TeamsCreateNewTaskController.dateMyFormat dateMy =  n.getdateMy();
		 if(dateMy == null){
		 	System.assert(false, 'No correct Reference');
		 }
		 
		
		TeamsCreateNewTaskController.assingTo assign = n.getassingTo();
		 if(assign == null){
		 	System.assert(false, 'No correct Reference');
		 }
		 
		 ProjectTask__c taskP = n.getTask();
		 if(taskP == null){
		 	System.assert(false, 'No correct Reference');
		 }
		 
		 List<SelectOption> perD = n.getPercentDedicated();
		if(perD.size() == 0){
		 	System.assert(false, 'no priority List');
		 }
		 
		List<TeamsCreateNewTaskController.assingTo> assTo = n.getAssignMember();
		if(assTo == null){
		 	System.assert(false, 'no priority List');
		 }
		 
		n.getTaskForEdit('a0B30000001u1fEEAQ','a0S30000000YEMoEAO');
		
	}	
}