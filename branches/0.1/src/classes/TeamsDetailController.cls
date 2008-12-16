public class TeamsDetailController {
	
	// COLLABSUITE-883
	Team__c teamspace = new Team__c();
	 
	//Bookmarks variables 
	Bookmark__c bookmark;
    boolean noImage; 
    boolean emailTeamspace;
    String  error = '';
    boolean showError = false; 
	
	String teamIdParam = System.currentPageReference().getParameters().get('id');
	
	public String USERID =  UserInfo.getUserId();
	
	/**
	* @return String teamIdParam The Id of the team
	*/
	public String getTeamIdParam(){
		return teamIdParam;
	}
	/**
	* Boolean to determine if show buttons.
	*/
	Boolean teamIsOpen = false;
	
	public Boolean getTeamIsOpen(){
		return teamIsOpen;
	}
	
		
	public TeamsDetailController(){
		
		// Constructor, Query team:		
		teamIdParam = System.currentPageReference().getParameters().get('id');
		
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
		} catch(Exception e ){
			System.debug('\n ///////////////////////////////////// \n ' + e);
		}
		
		List<TeamMember__c> isTeamMember = new List<TeamMember__c>();
		
		if(teamspace != null ){
				
			try {
					isTeamMember = [Select Id, User__c, Team__c from TeamMember__c where User__c =: USERID and Team__c =: teamspace.Id ];		
			
			} catch(Exception e ){
				
				System.Debug('\n ///////////////////////////////////////////////////// \n List Size after query' + e);
			}
			
			
			 if((teamspace.PublicProfile__c != null) && (teamspace.NewMemberProfile__c != null)){
			 		if(isTeamMember.size() > 0 ){ teamIsOpen = false; } 
			 		else { teamIsOpen = true; }		 		
			 }  
		} 
        
        assignShowJoinTeamMessage();
        
	}
	
	/**
	* Perform the addition to the team
	*/	
	
	public boolean showJoinTeamMessage = false;
	
	public void assignShowJoinTeamMessage () {
		String joinedTeamParam = System.currentPageReference().getParameters().get('j');
		
		
		if(joinedTeamParam == 'true'){
			showJoinTeamMessage =  true;
		} else {
			showJoinTeamMessage =  false;
		}
	}
	
	public boolean getShowJoinTeamMessage(){
		return showJoinTeamMessage;
	}
	
	
	public void joinTeam(){
		 
		 TeamMember__c newUserJoin = new TeamMember__c();
		 if(teamspace != null ){
		 	
			 newUserJoin.User__c = USERID;
			 newUserJoin.Team__c = teamspace.Id;
			 newUserJoin.TeamProfile__c = teamspace.NewMemberProfile__c;		 
			 teamIsOpen = false;
			 showJoinTeamMessage = true;
			 
			 insert newUserJoin;
			 System.Debug('\n //////////////////////////////////// \n');
		 }
	}
	
	
	/**
	* Perform the remove from the team
	*/		
	
	public void leaveTeam(){
		 
		 TeamMember__c userRow = new TeamMember__c();
		
		 try {
		 	userRow = [Select Id, User__c, Team__c from TeamMember__c where User__c =: USERID and Team__c =: teamspace.Id ];
		 	
		 } catch(Exception e){ }
		 		 
		 teamIsOpen = true;
		 showJoinTeamMessage = false;
		
		 delete userRow; 		 
		 
	}
	
	
	        
	public Team__c getTeamspace() {

       
        
        teamspace = [select name, description__c from Team__c
                                                where id=:System.currentPageReference().getParameters().get('id')];
        
         if(teamspace == null) {
         	return null;
         }else {
    		return teamspace;
         }
    }
    
    public String getTeamspaceImage() {
    	List<Attachment> attach = [SELECT Id 
        									 FROM Attachment 
        									 WHERE ParentId =:System.currentPageReference().getParameters().get('id')];
        	if(attach.size() == 0) return '';					
        		return '/servlet/servlet.FileDownload?file=' + attach[0].Id;
    }  
    
 
   	public void refreshWikis () {
    	System.debug('\n //////////////////// \n REFRESH THE WIKIS \n ////////////////// \n');
   	}
  
}