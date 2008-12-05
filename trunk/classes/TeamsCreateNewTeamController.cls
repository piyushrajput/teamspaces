public without sharing class TeamsCreateNewTeamController {

	/**
	* Return the Namespace Prefix
	*/
	public String getNamespace () {
        return TeamUtil.getNamespace();
    } 
    
    //Get id from team item
    String param = System.currentPageReference().getParameters().get('id');
    
    Team__c theTeam = new Team__c();
    String teamPicture = '';
   
    public Attachment document = new Attachment();
	
	public void setdocument (Attachment attach) {
		this.document = attach;
	}
	 
	public Attachment getdocument () {     
		return document;
	}
       	
    /**
    * Set String param
    *@param String p
    *@void
    */
    public void setParam(String p){
    	param = p;
    }
    
    /**
    * Get team instance
    *@return Team__c
    */
    public Team__c getTeam(){
        return theTeam;
    }
    
    /**
    * Set Team
    *@param Team__c t
    */
    public void setTeam(Team__c t){
    	theTeam = t;
    }
    
    /**
    * Get picture
    *@return String pic
    */
    public String getTeamPicture (){
        return teamPicture;
    }
   
    public TeamsCreateNewTeamController(){
        if (param != null){
        	setTeam(param);
        	genPermissions();
        	
        	if(!userPermissions.getCanManage())
        		throw new CustomException('Insufficient Privileges');
        }
    }
    
    /* ---------------------------- */
   	/*   	 SHARING RULES			*/
   	/* ---------------------------- */	
	public UserPermissions userPermissions = null;
	
	public void genPermissions () {
		userPermissions = new UserPermissions();
		userPermissions.setId(UserInfo.getUserId());
		userPermissions.setTeam(param);
		userPermissions.setObjectType('Team');
		userPermissions.setPermissions();		
	}

	/* ---------------------------- */	
	
	public String TeamType {get; set;}
	
    /**
    * Get Team
    *@param String team id
    *@void
    */
    public void setTeam (String tId){
	    theTeam = [Select t.TeamType__c,  
	    			t.ContactEmail__c,
	                t.ParentTeam__c,
	                t.PublicProfile__c,
	                t.NewMemberProfile__c,
	                t.ParentTeam__r.Name, 
	                t.Name,
	                t.Picture__c, 
	                t.Id, 
	                t.Description__c 
	                From Team__c t Where t.Id =:tId];
	    if(theTeam.TeamType__c != null){
	    	TeamType = theTeam.TeamType__c;
	    }
	    if(theTeam.Id != null){
            getTeamImage();
    		if(theTeam.PublicProfile__c != null && theTeam.NewMemberProfile__c != null){
	    		newProfile.newProfileOpen = theTeam.NewMemberProfile__c;
	    		newProfile.publicProfileOpen = theTeam.PublicProfile__c;
    		}else if (theTeam.PublicProfile__c != null){
    			newProfile.publicProfileClosed = theTeam.PublicProfile__c;
    		}
	    } 
    }
    
    /**
    * Team Type Select
    *@return List<SelectOption>
    */   
    public List<SelectOption> getTypes() {
        List<TeamType__c> teamType = new List<TeamType__c>();  
        List<SelectOption> options = new List<SelectOption>();
        
        teamType = [Select t.Name, t.Id From TeamType__c t order by t.Name asc];  
        options.add(new SelectOption('', '-- select team type --'));
        for(TeamType__c c: teamType){
            options.add(new SelectOption(c.Id, c.Name));
        }
        return options;
    }
    
    /**
    * Team Profile Select
    *@return List<SelectOption>
    */
    public List<SelectOption> getProfiles(){
        List<TeamProfile__c> profiles = new List<TeamProfile__c>();
        List<SelectOption> options = new List<SelectOption>();
        profiles = [select p.Id, p.Name from TeamProfile__c p order by p.Name asc];
        for (TeamProfile__c tp : profiles){
            options.add(new SelectOption(tp.Id, tp.Name));
        }
        return options;
    }
        
    
    /**
    * Get Team Picture
    *@void
    */
    public void getTeamImage() {
        if(theTeam.Picture__c != null) teamPicture = '/servlet/servlet.FileDownload?file=' + theTeam.Picture__c;
    }
    

    /**
    *@class teamProfile
    */
    public class teamProfile {
    	public String publicProfileOpen { set; get; }
    	public String newProfileOpen { set; get; }
    	public String publicProfileClosed { set; get; }
    	public String teamOpenOrClosed { set; get; }     	
    }
    
    teamProfile newProfile = new teamProfile();
    
    public teamProfile getnewProfile(){
    	return newProfile;
    }
    
    /**
    * Save Team
    *@void
    */    
    public PageReference saveTeam(){
    	try{
    		if(newProfile.teamOpenOrClosed == 'open'){
    			theTeam.PublicProfile__c = newProfile.publicProfileOpen;
    			theTeam.NewMemberProfile__c = newProfile.newProfileOpen;	    			
    		}else if (newProfile.teamOpenOrClosed == 'close') {
    			theTeam.PublicProfile__c = newProfile.publicProfileClosed;
    			theTeam.NewMemberProfile__c = null;
    		}else if (newProfile.teamOpenOrClosed == 'private'){
    			theTeam.PublicProfile__c = null;
    			theTeam.NewMemberProfile__c = null;
    		}
    		
    		if(theTeam.Id == null){
	    		insert theTeam;
	    		if(document.name != null && document.name != ''){
	    			document.ParentId = theTeam.Id;
		    		insert document;
	    			theTeam.Picture__c = document.Id;
		    		update theTeam;
	    		}	
    		}else {
       			if(document.name != null && document.name != ''){
	    			document.ParentId = theTeam.Id;
	    			insert document;
	    			theTeam.Picture__c = document.Id;
	    		}
	    		if(theTeam.TeamType__c == null){
	    			theTeam.TeamType__c = TeamType; 
	    		}
	    		update theTeam;
	    	}
	    	PageReference pageRef = new PageReference('/apex/TeamsRedirect?id=' + theTeam.Id);
            pageRef.setRedirect(true);
            return pageRef;          
    	}catch(Exception e){
    		throw e;
    	}
    }

}