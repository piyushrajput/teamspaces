/**
*@author Martin Prado @ 09/15/2008
*/
public class TeamSubscribeController 
{
	/**
	* Constructor
	*/
	public TeamSubscribeController() {	}

	//Team Id
	public String TEAM;

	/**
	*@param String
	*/
	public void setTEAM(String id) {
		TEAM = id;	
	}
	
	/**
	*@return String
	*/
	public String getTEAM(){
		return TEAM;
	}

}