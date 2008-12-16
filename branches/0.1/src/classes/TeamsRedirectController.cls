public class TeamsRedirectController {
	
	public String teamId = System.currentPageReference().getParameters().get('id');
	
	Team__c team = new Team__c();	
	TeamType__c teamtype = new TeamType__c();
	
	public TeamsRedirectController() {
		try {
			team = [SELECT TeamType__c
			       					 	  	FROM Team__c
			       					 	  	WHERE Id =: teamId];
			
			 				 	  		
			teamtype = [SELECT 	Id	 	  	FROM TeamType__c
			       					 	  	WHERE Id =: team.TeamType__c];
			 
		} catch(Exception e) {
		
			System.Debug('the error' + e);
		}
	
	}
	
	public PageReference redirect() {
				
		if(team.TeamType__c == null) return System.currentPageReference();

		String pageurl = '/apex/TeamsDetail' + teamtype.Id + '?id=' + teamId;   		  
		
		System.debug('pageurl = ' + pageurl );
		
		PageReference pr = new PageReference(pageurl);  
		
		pr.setRedirect(true);     					 

		return pr;
	}

}