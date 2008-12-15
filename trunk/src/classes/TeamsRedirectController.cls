/**
*@author Yuri Alvarez @ 05/02/2008
*/
public class TeamsRedirectController {
	
	public String teamId = System.currentPageReference().getParameters().get('id');
	
	/**
	* Constructor
	*/
	public TeamsRedirectController() {
		if(teamId != null)
			getTeam();
	}

	/**
	*@param String s
	*/
	public void setTeamId(String s){
		teamId = s;
	}
	
	Team__c team = new Team__c();	
	TeamType__c teamtype = new TeamType__c();

	/**
	* Get Team
	*/
	public void getTeam(){
		team = [select TeamType__c from Team__c where Id =: teamId];
		if(team != null)
			teamtype = [select Id from TeamType__c where Id =: team.TeamType__c];			
	}
	
	/**
	* Forward to detail for TeamType assigned to team 
	*@return PageReference
	*/
	public PageReference redirect() {
		if(team.TeamType__c == null) 
			return System.currentPageReference();
		//We cannot use Page object for PageReference
		String pageurl = '/apex/TeamsDetail' + teamtype.Id + '?id=' + teamId;   		  
		PageReference pr = new PageReference(pageurl);  
		pr.setRedirect(true);     					 
		return pr;
	}

}