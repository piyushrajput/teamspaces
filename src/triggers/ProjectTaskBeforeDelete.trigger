trigger ProjectTaskBeforeDelete on ProjectTask__c bulk(before delete) {
  
  ProjectTask__c[] p = Trigger.old;
    
	List<ProjectAssignee__c> projectAssigneeList = [Select Id from ProjectAssignee__c where ProjectTask__c in :Trigger.old  ];    	
	delete projectAssigneeList; 
}