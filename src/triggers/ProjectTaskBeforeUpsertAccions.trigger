trigger ProjectTaskBeforeUpsertAccions on ProjectTask__c (before insert, before update) {
	
	/*
	  This trigger calculates the end date
	*/
	for (ProjectTask__c p : Trigger.new) {		
		//Duration is asummed in days
		//Double dDurationInMinutes = p.Duration__c * 24 * 60;
		//p.EndDate__c = p.StartDate__c.addMinutes(dDurationInMinutes.intValue());
		
		 
		 if (Trigger.isInsert)
		 {
			//Set the correlative taskPosition in project
			List<ProjectTask__c> taskInProject = [SELECT Id FROM ProjectTask__c WHERE project__c =: p.project__c];
			long projectTaskQuantity =  taskInProject.size();
			p.Task_Position__c = projectTaskQuantity + 1; 
			 	
		 }
	}
}