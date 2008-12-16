public with sharing class TeamsWidgetRecentWikiPagesController {
	
	
	// Get Team Id Attribute
	String teamId;
	
	// Setter method for Team Id variable
	public void setTeamId(String tID) {
		if (teamId == null || teamID != tID) {
			teamId = tID;	
			genPermissions();
		}		
	}
	
	public String getTeamId(){
		return teamId;
	}
	
	public Boolean sidebar = false;
	
	/**
	* Set Sidebar
	*@void
	*/
	public void setSidebar (Boolean b){
		sidebar = b;
	}
	
	/**
	* Get Sidebar
	*@return Boolean
	*/
	public Boolean getSidebar(){
		return sidebar;
	}	
	
	Integer wikiPagesCount;
    
   	/* ---------------------------- */
   	/*   	 SHARING RULES			*/
   	/* ---------------------------- */	
	public UserPermissions userPermissions = TeamsDetailController.userPermission.clone();
		
	public void genPermissions () {
		userPermissions.setId(UserInfo.getUserId());
		userPermissions.setTeam(teamId);
		userPermissions.setObjectType('Wiki');
		userPermissions.setPermissions();		
	}
	
	public UserPermissions getUserPermissions () {
		System.debug('\n //////////////////////// \n USER PERMISSIONS: \n' + userPermissions + '\n //////////////////////////////// \n');
		return userPermissions;
	}
	/* ---------------------------- */	
    
    
    public List<WikiPage__c> getWikis() {
     	
       	// Wikis
	    List<WikiPage__c> myWikis = new List<WikiPage__c>();
	    myWikis =  [Select Team__c,
					 LastModifiedDate ,
					 Name, Id, 
					 CreatedBy.Name, 
					 CreatedBy.Id, 
					 CreatedById
					 From WikiPage__c  
					 Where Team__c =: teamId
					 ORDER BY Name ASC LIMIT 10];
		                                
 		
 		wikiPagesCount = myWikis.size();
    	return myWikis;
    } 
    
     public Integer getWikiPagesCount(){
    	return wikiPagesCount;
    }
    
    /*
    public void setWikiPagesCount(Integer count){
    	wikiPagesCount = count;
    }
    */
	       
    					
	
}