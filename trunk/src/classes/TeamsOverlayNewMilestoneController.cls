/**
*@author Bruno Fagundez @ 07/10/2008
*/
public class TeamsOverlayNewMilestoneController {
	
	ProjectTask__c theNewTask = new ProjectTask__c();
   	public String TEAMID = System.currentPageReference().getParameters().get('id');
   	
    /**
    * Constructor
    */
    public TeamsOverlayNewMilestoneController(){
    	getCurrentProject();
    	genPermissions();	
	}

   	/**
   	*@return String
   	*/
   	public String getCurrentTeamId(){
   		return TEAMID;
   	}
   	
   	/**
   	*@param String team Id
   	*/
   	public void setCurrentTeamId(String s) {
   		TEAMID = s;
   	}
   	
   	public Project2__c currentProject = null;
   	

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
    
    /**
    *@param TeamMember__c
    */
    public void setTeamMember(TeamMember__c tm){
    	teamMember = tm;
    }
    
    //For rerender use
    public void dummyRefresh (){}
    
    /**
    * Create members select options
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
	* Returns Project for current team
	*/
	public void getCurrentProject(){
		if(TEAMID != null)
			currentProject = [select Id from Project2__c where Team__c =: TEAMID limit 1];
	}
	
	public UserPermissions userPermissions = TeamsDetailController.userPermission.clone();
	/**
	* Read User permissions
	*/
	public void genPermissions () {
		userPermissions.setId(UserInfo.getUserId());
		userPermissions.setTeam(TEAMID);
		userPermissions.setObjectType('Project');
		userPermissions.setPermissions();		
	}
	
	/**
	* Returns user location
	*@return String
	*/
	public String getUserLocale(){
		return Userinfo.getLocale();	
	}
	
   	/**
   	* Create new Milestone
   	*@throws CustomExceptions, message Insufficient Privileges
   	*/
   	public void insertMilestone (){ 
   		if(!userPermissions.getCanCreate()){
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