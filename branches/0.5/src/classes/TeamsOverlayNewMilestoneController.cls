public class TeamsOverlayNewMilestoneController {
	
	ProjectTask__c theNewTask = new ProjectTask__c();
   	
   	public String TEAMID = System.currentPageReference().getParameters().get('id');
   	
   	public String getCurrentTeamId(){
   		return TEAMID;
   	}
   	
   	public void setCurrentTeamId(String s) {
   		TEAMID = s;
   	}
   	
   	public Project2__c currentProject = null;
   	
   	//public String name {get; set;}
   	
    /**
    *@return ProjectTask__c
    */
    public ProjectTask__c newProyect = new ProjectTask__c();
    public ProjectTask__c getTask(){
    	return newProyect;
    }
    
    public void setNewProyect(ProjectTask__c pT) {
    	newProyect = pT;
    }
     /**
    *@return TeamMember__c
    */
    public TeamMember__c teamMember = new TeamMember__c();
    public TeamMember__c getTeamMember(){
    	return teamMember;
    }
    
    public void setTeamMember(TeamMember__c tm){
    	teamMember = tm;
    }
    
    public void dummyRefresh () {   
		
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
    
    public TeamsOverlayNewMilestoneController(){
    	getCurrentProject();
    	genPermissions();	
	}
	
	public void getCurrentProject(){
		if(TEAMID != null)
			currentProject = [select Id from Project2__c where Team__c =: TEAMID limit 1];
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
	
	public String getUserLocale(){
		return Userinfo.getLocale();	
	}
	
	/* ---------------------------- */
   	/*   	  INSERT MILESTONE		*/
   	/* ---------------------------- */  
   	
   	public void insertMilestone () 
   	{ 
   		if(!userPermissions.getCanCreate())
   		{
        	throw new CustomException('Insufficient Privileges');
   		}		
   		
		
		newProyect.Milestone__c = true;
		newProyect.Team__c = TEAMID;
		newProyect.StartDate__c = newProyect.EndDate__c;
		newProyect.Percent_Completed__c = 0;
		newProyect.Project__c = currentProject.Id;
  		insert newProyect; 
  		
  		ProjectAssignee__c Assign = new ProjectAssignee__c();
		Assign.User__c = teamMember.User__c;
		Assign.ProjectTask__c = newProyect.Id;
		insert Assign;
		
		Assign = new ProjectAssignee__c();
		newProyect = new ProjectTask__c();
   		
 		
   	}
}