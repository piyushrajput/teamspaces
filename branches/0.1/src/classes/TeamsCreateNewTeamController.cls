public class TeamsCreateNewTeamController {
	
	// Get id from team item
    String param = System.currentPageReference().getParameters().get('id');
    
    Team__c theTeam = new Team__c();
    String teamPicture = '';

    /**
    *@return Team__c
    */
    public Team__c getTeam(){
    	return theTeam;
    }
    
    public String getTeamPicture (){
    	return teamPicture;
    }
   
	public TeamsCreateNewTeamController(){
    	if (param != null){
    		    		
    	  	theTeam = [Select t.TeamType__c,  
  						t.ParentTeam__c,
  						t.PublicProfile__c,
  						t.NewMemberProfile__c,
  						t.ParentTeam__r.Name, 
  						t.Name, 
  						t.Id, 
						t.Description__c 
						From Team__c t Where t.Id =: param];
    		if(theTeam.Id != null)
    			getTeamImage();
    	}
	}
	   
    public List<SelectOption> getTypes() {
    	List<TeamType__c> teamType = new List<TeamType__c>();  
  	 	List<SelectOption> options = new List<SelectOption>();
  	 	
  	 	teamType = [Select t.Name, t.Id From TeamType__c t order by t.Name asc];  
  	 	options.add(new SelectOption('', '-- select team type --'));
  	 	for(TeamType__c c: teamType) {
    		options.add(new SelectOption(c.Id, c.Name));
 		}
  	 	return options;
   	}
   	
   	public List<SelectOption> getProfiles(){
   		List<TeamProfile__c> profiles = new List<TeamProfile__c>();
   		List<SelectOption> options = new List<SelectOption>();
   		profiles = [select p.Id, p.Name from TeamProfile__c p order by p.Name asc];
   		for (TeamProfile__c tp : profiles){
   			options.add(new SelectOption(tp.Id, tp.Name));
   		}
   		return options;
   	}
   		
   	
    public void getTeamImage() {
    	List<Attachment> attach = [select Id 
        							from Attachment 
        							where ParentId =: theTeam.Id];
    	if(attach.size() > 0)				
    		teamPicture = '/servlet/servlet.FileDownload?file=' + attach[0].Id;
    }
}