public class TeamsOverlayNewTaskController {
	
    ProjectTask__c theNewTask = new ProjectTask__c();
   	
   	public String TEAMID = System.currentPageReference().getParameters().get('id'); 
   	public Project2__c currentProject = null;   
   	
   	public void setTEAMID (String teamId) {
   		this.TEAMID = teamId;
   	}
   	
   	/**
    *@return ProjectTask__c
    */
    public ProjectTask__c newProyect = new ProjectTask__c();
    public ProjectTask__c getTask(){
    	return newProyect;
    }
    
    public void setTask(ProjectTask__c value){
    	newProyect = value;
    }
    
     /**
    *@return TeamMember__c
    */
    public TeamMember__c teamMember = new TeamMember__c();
    public TeamMember__c getTeamMember(){
    	return teamMember;
    }
    
    public void setTeamMember(TeamMember__c value){
    	teamMember = value;
    }
    
   	public String getCurrentTeamId(){
   		return TEAMID;
   	}
   	
     
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
    
    public TeamsOverlayNewTaskController(){
    	getCurrentProject();	
    	genPermissions();
	}
	
	public void getCurrentProject(){   
		if(TEAMID != null)
			currentProject = [select Id from Project2__c where Team__c =: TEAMID limit 1];
	}
	
	//Refresh method
	public void refreshMethod(){
		TeamsWidgetTasksMainController twtmc = new TeamsWidgetTasksMainController();
		twtmc.getAllProjectTasks();
	}
	
	public void dummyRefresh () {
		
	}   
	
	/* ---------------------------- */
   	/*   	 SHARING RULES			*/
   	/* ---------------------------- */	
	public UserPermissions userPermissions = TeamsDetailController.userPermission.clone();
	
	public void genPermissions () {
		userPermissions.setId(UserInfo.getUserId());
		userPermissions.setTeam(TEAMID);
		userPermissions.setObjectType('Project');
		userPermissions.setPermissions();		
	}

	/* ---------------------------- */	
	
	
	/* ---------------------------- */
   	/*   	  INSERT TASK		    */
   	/* ---------------------------- */  
   	
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