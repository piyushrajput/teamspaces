/**
*@author Bruno Fagundez @ 6-9-2008
*/
public without sharing class TeamDetailsWidgetController {
	
	// Get Team Id Attribute
	String team;
	
	/**
	* Constructor
	*/
	public TeamDetailsWidgetController(){}	
	
	/**
	* Setter method for Team Id variable
	*@param String teamId
	*/
	public void setTeam(String tID) {
		team = tID;
	}
	
	/**
	* Getter method for Team Id variable
	*@return String teamId
	*/
	public String getTeam(){
		return team;
	}
	
	// Active user ID
	public String USERID =  UserInfo.getUserId();
	
	/**
	*@return String userId
	*/
	public String getCurrentUser(){
		return USERID;
	}
	
	/**
	* Return the Namespace Prefix
	*@return String
	*/
	public String getNamespace () {
        return TeamUtil.getNamespace();
    } 
	
	Team__c teamspace = new Team__c();
	
	public UserPermissions userPermissions = TeamsDetailController.userPermission.clone();
	
	/**
	* Generate user permissions
	*@void
	*/
	public void genPermissions() {
		userPermissions.setId(UserInfo.getUserId());
		userPermissions.setTeam(team);
		userPermissions.setObjectType('Team');
		userPermissions.setPermissions();		
	}
	
	/**
	* Return user permissions
	*@return UserPermissions
	*/
	public UserPermissions getUserPermissions () {
		return userPermissions;
	}	
	
	/**
	* Return Team data
	*@return Team__c
	*/
	public Team__c getTeamspace() {
		try {
			teamspace = [Select  t.SystemModstamp, 
									t.OwnerId, t.Name,						
									t.LastModifiedDate,
									t.LastModifiedById, 
									t.IsDeleted,
									t.Id, 
									t.Description__c,
									t.Picture__c, 
									t.CreatedDate, 
									t.CreatedById 
									From Team__c t 
									where id =: team];
									
			// The following is to clean text for the widget
			teamspace.Description__c = teamspace.Description__c.replaceAll('[\n\r]*','');
			teamspace.Description__c = teamspace.Description__c.replaceAll('[\n]*',''); 
		
			genPermissions();									
		} catch(Exception e){
			
		}
		
    	return teamspace;
    }
    
	// Boolean to determine if show buttons
	Boolean teamIsOpen = false;
	
    /**
	* Boolean to determine if show buttons
	*@return Boolean
	*/
	public Boolean getTeamIsOpen(){
		List<TeamMember__c> member = [select Id from TeamMember__c where User__c =: UserInfo.getUserId() and Team__c =: teamspace.Id limit 1];
		teamIsOpen = (member.size() == 0);
		return teamIsOpen;
	}
	
	/**
	* Show join event
	*@return Boolean
	*/
	public Boolean showJoinEvent(){
		Boolean canShow = false;
		List<TeamMember__c> members = [select Id from TeamMember__c where User__c =: UserInfo.getUserId() and Team__c =: teamspace.Id limit 1];
		
		canShow = (members.size() == 0) && ((teamspace.PublicProfile__c != null && teamspace.NewMemberProfile__c != null) ||
											(userPermissions.getCanManage()));
		
		return canShow;
	}
	
	/**
   	* For show join button
   	*@void
   	*/
   	public void refreshJoinEvent(){
   		teamIsOpen = showJoinEvent();
   	}
    
    /**
    * Send id of teammember (if any)
    *@return String
    */
    public String getTeamMemberId(){
    	List<TeamMember__c> tmember = new List<TeamMember__c>();
    	
    	try{
    		tmember = [Select TeamProfile__r.Name, TeamProfile__c From TeamMember__c where User__c =: USERID and Team__c =: team];
    	} catch(Exception e){}
    	
    	if(tmember.size() > 0){
    		Id teamMemberId = tmember[0].Id;
    		tmember.clear();	    	
	    	return teamMemberId; 	    	
    	}else {
    		tmember.clear();
    		return 'no';
    	}    	 
    }
    
    
    /**
    * Look if the user is the team admin
    *@return boolean
    */    
    public boolean getIsTeamAdmin(){
    	TeamMember__c tmember = new TeamMember__c();    	
    	
    	try{
    		tmember = [Select TeamProfile__r.Name, TeamProfile__c From TeamMember__c where User__c =: USERID and Team__c =: team];
    	} catch(Exception e){}

    	return ((tmember != null) && (tmember.TeamProfile__r.Name == 'Team Administrator'));
    }
    
    /**
    * Get The list of admins to this team
    *@return String
    */
    public String getTeamAdmins(){
    	List<TeamMember__c> tmemberList = new List<TeamMember__c>();
    	
    	try {
    		tmemberList = [Select User__r.Name, User__c From TeamMember__c where TeamProfile__r.Name = 'Team Administrator' and Team__c =: team];
    	} catch (Exception e){
    		throw e;
    	}
    	
    	String teamMemberList = ' ';
    	
    	if(tmemberList.size() > 0 ){ 
	    	for(TeamMember__c tm: tmemberList){
	    		teamMemberList += '<a href="PeopleProfileDisplay?id=' + tm.User__c + '" >'+ tm.User__r.Name +'</a><br />';    	
	    	}     	
    	}
    	tmemberList.clear();
    	return teamMemberList;
    }
    
    /**
    * Get The count of members at the team
    *@return Integer
    */
    public Integer getTeamCount(){
    	List<TeamMember__c> tmemberList = new List<TeamMember__c>();
    	
    	try {
    		tmemberList = [Select Id From TeamMember__c where Team__c =: team];
    	} catch (Exception e){
    		throw e;
    	}
    	return tmemberList.size();
    }
    
	public String getTeamspaceImage() {
    	if(teamspace.Picture__c == null) 
    		return '';
    	return '/servlet/servlet.FileDownload?file=' + teamspace.Picture__c;   		
    }
    
    /**
    * Leave a Team
    *@void
    */
    public void leaveTeam (){
    	List<TeamMember__c> userRow = new List<TeamMember__c>();
		
		 try {
		 	userRow = [Select Id, User__c, Team__c from TeamMember__c where User__c =: USERID and Team__c =: teamspace.Id];
		 } catch(Exception e){ 
		 
		 }
		 		 
		 
		 if (userRow.size() == 1) {
		 	delete userRow;
		 	teamIsOpen = true;
		 }
    }
    
    /**
   	* For show leave link
   	*@void
   	*/
   	public void refreshLeaveEvent(){
		
   	}
	
}