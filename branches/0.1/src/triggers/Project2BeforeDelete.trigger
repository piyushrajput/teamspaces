trigger Project2BeforeDelete on Project2__c bulk(before delete) {
 
    Project2__c[] p = Trigger.old;
    
	List<ProjectTask__c> projectTaskList = [Select Id from ProjectTask__c where Project__c in :Trigger.old  ];    	
	delete projectTaskList; 
	
	List<ProjectIssue__c> projectIssueList = [Select Id from ProjectIssue__c where Project__c in :Trigger.old  ];    	
	delete projectIssueList;  
	
	List<ProjectRisk__c> projectRiskList = [Select Id from ProjectRisk__c where Project__c in :Trigger.old  ];    	
	delete projectRiskList;   	 
}