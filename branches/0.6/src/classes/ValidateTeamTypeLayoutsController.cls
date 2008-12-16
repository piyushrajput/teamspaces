/**
*@author Nicolas Gunther 09/12/2008
*/
public class ValidateTeamTypeLayoutsController {

	/**
	* Constructor
	*/
	public ValidateTeamTypeLayoutsController(){
		validate ();
	}
	
	/**
	*@return String
	*/
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

	/**
	* Execute validation
	*/
	public void validate (){
		String markup = null;
		types = [select Id from TeamType__c];
		markup = '<div>';
		for(TeamType__c theType : types){
			
		}	
	}

}