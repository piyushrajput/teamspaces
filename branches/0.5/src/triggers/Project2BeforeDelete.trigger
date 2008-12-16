trigger Project2BeforeDelete on Project2__c bulk(before delete) {
    if (!TeamUtil.currentlyExeTrigger) {
		try {	
			TeamUtil.currentlyExeTrigger = true;
			List<ProjectTask__c> projectTaskList = [Select Id from ProjectTask__c where Project__c in :Trigger.old  ];    	
			delete projectTaskList; 
		} finally {
        	TeamUtil.currentlyExeTrigger = false;
		}
	} 
}