/**
*@author: Martin Prado @ 9-29-2008
*/
public class ProjectLookupController {
	
	/**
	* Constructor
	*/
	public ProjectLookupController(){}
	
	public String teamID = System.currentPageReference().getParameters().get('id');
	public String taskID = System.currentPageReference().getParameters().get('taskId');
	public  List<ProjectTask__c> myTask = new List<ProjectTask__c>();
	
	/**
	* Return Project Tasks with teamID and taskID if exists
	*@return List<ProjectTask__c>
	*/
	public List<ProjectTask__c> getTask(){	
		if (taskID != null) {
			myTask = [Select p.ParentTask__c, p.Name, p.Id From ProjectTask__c p where p.Team__c =: teamID and p.Id !=: taskID];
		}else {
			myTask = [Select p.ParentTask__c, p.Name, p.Id From ProjectTask__c p where p.Team__c =: teamID];
		}
		
    	return myTask;
	}
}