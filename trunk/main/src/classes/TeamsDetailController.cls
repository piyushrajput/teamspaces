/**
*@author Bruno Fagundez @ 06/09/2008
*/
public with sharing class TeamsDetailController {
	
	Team__c teamspace = new Team__c();
	 
    boolean noImage; 
    boolean emailTeamspace;
    String  error = '';
    boolean showError = false;
	
	public static UserPermissions userPermission = new UserPermissions();
	
	String teamIdParam = System.currentPageReference().getParameters().get('id'); 
	
	/**
	* Constructor
	*/
	public TeamsDetailController(){
		if(teamIdParam != null)
			getTeamDetail();		
		genPermissions();
	}	
	
	/**
	*@param String team id
	*/
	public void setTeamIdParam (String idTeam){ 
		teamIdParam = idTeam;
	}
	
	/**
	* Check if is TeamsSuscription page
	*@return Boolean 
	*/
	public Boolean getInTeamSubscription () {
		String currentPageUrl = System.currentPageReference().getUrl();
		return (currentPageUrl != null && currentPageUrl.indexOf('TeamsSubscription') != -1);
	} 
	
	public String USERID =  UserInfo.getUserId();
	
	public UserPermissions userPermissionsTeam = new UserPermissions();
	
	public UserPermissions userPermissionsWiki = new UserPermissions();
	
	/**
	*@return UserPermission
	*/
	public UserPermissions getUserPermissionsWiki () {
		return userPermissionsWiki;
	}
	
	/**
	* Load permission for current user
	*/
	public void genPermissions () {
		userPermission.setId(UserInfo.getUserId());
		userPermission.setTeam(teamIdParam);
		userPermission.setObjectType('Wiki');
		userPermission.setPermissions();
		userPermissionsWiki = userPermission;
		
		userPermissionsTeam.setId(UserInfo.getUserId());
		userPermissionsTeam.setTeam(teamIdParam);
		userPermissionsTeam.setObjectType('Team');
		userPermissionsTeam.setPermissions();					
	}

	/**
	*@return UserPermission
	*/
	public UserPermissions getUserPermission () {
		return userPermission;
	}	
	/* ---------------------------- */		
	
	
	/**
	* @return String teamIdParam The Id of the team
	*/
	public String getTeamIdParam(){
		return teamIdParam;
	}

	/**
	* Read Team
	*@throws Exception
	*/
	public void getTeamDetail(){
		try {
			teamspace = [Select  t.SystemModstamp, 
							t.OwnerId, t.Name,						
							t.LastModifiedDate,
							t.LastModifiedById, 
							t.NewMemberProfile__c,
							t.PublicProfile__c,
							t.IsDeleted,
							t.Id, 
							t.Description__c, 
							t.CreatedDate, 
							t.CreatedById
							From Team__c t 
							where id =: teamIdParam];
			teamIsOpen = showJoinEvent();
		} catch(Exception e ){
			throw e;
		}	
	}
	
	/**
	* Boolean to determine if show buttons.
	*/
	Boolean teamIsOpen = false;
	
	/**
	* Returns true if team is open
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
											(userPermissionsTeam.getCanManage()));
		
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
	* Join Team
	*/
	public void joinTeam(){
		 TeamMember__c newUserJoin = new TeamMember__c();
		 if(teamIsOpen){
			 newUserJoin.User__c = USERID;
			 newUserJoin.Name = UserInfo.getName();
			 newUserJoin.Team__c = teamspace.Id;
			 newUserJoin.TeamProfile__c = teamspace.NewMemberProfile__c;		 
			 teamIsOpen = false;
			 			 
			 insert newUserJoin;
		 }
	}
	
	
	/**
	* Perform the remove from the team
	*@throws Exception
	*/		
	public void leaveTeam(){
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
	* Get Teamspace
	*@return Team__c
	*/
	public Team__c getTeamspace() {
         teamspace = [select name, description__c, NewMemberProfile__c, TeamType__r.Name, TeamType__r.Id from Team__c
                     where id=: teamIdParam];
         if(teamspace == null) {
         	return null;
         }else {
    		return teamspace;
         }
    }
    
    /**
    * Get Teamspace image
    *@return String
    */
    public String getTeamspaceImage() {
    
        List<Team__c> teamAvatar = [select Picture__c
        								from Team__c
        								where Id =:System.currentPageReference().getParameters().get('id')];
        if(teamAvatar.size() == 0) 
        	return '';
        return '/servlet/servlet.FileDownload?file=' + teamAvatar[0].Picture__c;
    }  
    
 
   	/**
   	* Refresh wiki list for widgets
   	*@void
   	*/
   	public void refreshWikis () {}
   	
   	public static ProjectTask__c taskT;

}