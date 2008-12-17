/**
*@author Martin Prado @ 06/10/2008
*/
public with sharing class TeamsWidgetRecentWikiPagesController {
	
	// Get Team Id Attribute
	String teamId;
	
	/**
	*@param String
	*/
	public void setTeamId(String tID) {
		if (teamId == null || teamID != tID) {
			teamId = tID;	
			genPermissions();
		}		
	}
	
	/**
	*@return String
	*/
	public String getTeamId(){
		return teamId;
	}
	
	public Boolean sidebar = false;
	
	/**
	* Set Sidebar
	*@param Boolean
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
    
	public UserPermissions userPermissions = TeamsDetailController.userPermission.clone();
		
	/**
	* Read user permissions
	*/
	public void genPermissions () {
		userPermissions.setId(UserInfo.getUserId());
		userPermissions.setTeam(teamId);
		userPermissions.setObjectType('Wiki');
		userPermissions.setPermissions();		
	}
	
	/**
	*@return UserPermissions
	*/
	public UserPermissions getUserPermissions () {
		return userPermissions;
	}

    /**
    * Read 10 wikis sorted by name asc
    *@return List<WikiPage__c> 
    */
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
    
    /**
    * Return wiki list size
    *@return Integer
    */
    public Integer getWikiPagesCount(){
    	return wikiPagesCount;
    }

}