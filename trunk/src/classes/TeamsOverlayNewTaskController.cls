/**
*@author Martin Prado @ 06/24/2008
*/
public class TeamsOverlayNewTaskController {
	
    ProjectTask__c theNewTask = new ProjectTask__c();
   	
   	public String TEAMID = System.currentPageReference().getParameters().get('id'); 
   	public Project2__c currentProject = null;   
   	
    /**
    * Constructor
    */
    public TeamsOverlayNewTaskController(){
    	getCurrentProject();	
    	genPermissions();
	}

   	/**
   	*@param String team id
   	*/
   	public void setTEAMID (String teamId) {
   		this.TEAMID = teamId;
   	}
   	
    public ProjectTask__c newProyect = new ProjectTask__c();
   	/**
    *@return ProjectTask__c
    */
    public ProjectTask__c getTask(){
    	return newProyect;
    }
    
	/**
	*@param ProjectTask__c
	*/    
    public void setTask(ProjectTask__c value){
    	newProyect = value;
    }
    

    public TeamMember__c teamMember = new TeamMember__c();    
    /**
    *@return TeamMember__c
    */
    public TeamMember__c getTeamMember(){
    	return teamMember;
    }
    
    /**
    *@param TeamMember__c
    */
    public void setTeamMember(TeamMember__c value){
    	teamMember = value;
    }
    
   	/**
   	*@return String
   	*/
   	public String getCurrentTeamId(){
   		return TEAMID;
   	}
   	
    
    /**
    * Return members select options
    *@return List<SelectOption>
    */ 
	public List<SelectOption> getTeamMembers() {
    	List<TeamMember__c> teamMembers = new List<TeamMember__c>();  
  	 	List<SelectOption> options = new List<SelectOption>();
  	 	if(TEAMID != null){
	  	 	teamMembers = [Select t.Team__c, t.User__r.Name, t.Name, t.User__c, t.Id From TeamMember__c t where t.Team__c =: TEAMID];  
	  	 	options.add(new SelectOption('-1', 'Choose a team Member'));
	  	 	for(TeamMember__c c: teamMembers) {
	    		options.add(new SelectOption(c.User__c, c.User__r.Name)); 
	 		}
  	 	}
  	 	return options;
   	}

	/**
	* Read Project for current team
	*/
	public void getCurrentProject(){   
		if(TEAMID != null)
			currentProject = [select Id from Project2__c where Team__c =: TEAMID limit 1];
	}
	
	/**
	* Refresh method
	*/
	public void refreshMethod(){
		TeamsWidgetTasksMainController twtmc = new TeamsWidgetTasksMainController();
		twtmc.getAllProjectTasks();
	}
	
	/**
	* For rerender use
	*/
	public void dummyRefresh (){}   
	

	public UserPermissions userPermissions = TeamsDetailController.userPermission.clone();
	/**
	* Read user permissions
	*/	
	public void genPermissions () {
		userPermissions.setId(UserInfo.getUserId());
		userPermissions.setTeam(TEAMID);
		userPermissions.setObjectType('Project');
		userPermissions.setPermissions();		
	}
   	
   	/**
   	* Create new task
   	*@throws CustomException message Insufficient Privileges
   	*/
   	public void insertTask (){ 
   		if(!userPermissions.getCanCreate()){
        	throw new CustomException('Insufficient Privileges');
   		}else{	
   			newProyect.Milestone__c = false;
			newProyect.Team__c = TEAMID;
			newProyect.Project__c = currentProject.Id;
			newProyect.Priority__c = 'Normal';
			insert newProyect; 

	  		ProjectAssignee__c Assign = new ProjectAssignee__c();
			Assign.User__c = teamMember.User__c;
			Assign.ProjectTask__c = newProyect.Id;
			insert Assign;
			newProyect = new ProjectTask__c();
			Assign = new ProjectAssignee__c();
   		}
   	}
}