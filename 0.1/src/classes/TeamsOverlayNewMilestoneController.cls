public class TeamsOverlayNewMilestoneController {
	
	ProjectTask__c theNewTask = new ProjectTask__c();
   	
   	public String TEAMID = System.currentPageReference().getParameters().get('id');
   	
   	public String getCurrentTeamId(){
   		return TEAMID;
   	}
   	
    /**
    *@return ProjectTask__c
    */
    public ProjectTask__c getTask(){
    	return theNewTask;
    }
     
    public List<TeamMember__c> getTeamMembers(){
    	
    	List<TeamMember__c> teamMemberList = new List<TeamMember__c>();
    	
    	teamMemberList = [Select Id, User__c, User__r.Name  From TeamMember__c where Team__c =: TEAMID];
    	
    	return teamMemberList;
    	
    }
    
    public TeamsOverlayNewMilestoneController(){
    	
	}
}