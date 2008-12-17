public class ValidateTeamTypeLayoutsController {

    public String getPages() {
        return null;
    }


	public List<TeamType__c> types = new List<TeamType__c>();
	
	/**
	* Get getPages
	*@return List<ApexPage>
	*/
	public List<TeamType__c> getTypes(){
		return types;
	} 
	
	public ValidateTeamTypeLayoutsController(){
		validate ();
	}
	
	/**
	* Validate
	*@void
	*/
	public void validate (){
		String markup = null;
		types = [select Id from TeamType__c];
		markup = '<div>';
		for(TeamType__c theType : types){
								
		}	
	}

}