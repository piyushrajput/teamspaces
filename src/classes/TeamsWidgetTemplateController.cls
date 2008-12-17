public class TeamsWidgetTemplateController {
    
    public TeamsWidgetTemplateController(){}
    
    public String teamId = null;
   	public UserPermissions u = TeamsDetailController.userPermission.clone();
    
    /**
    * Set Team Id
    *@param String team
    */
    public void setTeamId(String team){
        teamId = team;
    }
    
    /**
    * Get Team Id
    *@return String 
    */
    public String getTeamId (){
        return teamId;
    }
    
    public void setPermission (UserPermissions up){
    	u = up;
    }
    
    public UserPermissions getPermission (){
    	return u;
    }

}