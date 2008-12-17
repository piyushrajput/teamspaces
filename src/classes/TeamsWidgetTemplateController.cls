public class TeamsWidgetTemplateController {
    
    public TeamsWidgetTemplateController(){}
    
    public String teamId = null;
    
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

}