/**
*@author Bruno Fagundez @ 10/06/2008
*/
global class FlexWebService {	
		
	public UserPermissions userPermissions = new UserPermissions();
	
	/**
	* Load permissions for one user for some team
	*@param String Team id
	*@param Stirng User id
	*/
	public void genPermissions (String TeamId, String UserId) {
        userPermissions.setId(UserId);
        userPermissions.setTeam(TeamId);
        userPermissions.setObjectType('Project');
        userPermissions.setPermissions();       
    }
    
    /**
    * Generate permissions for one user for some team (web service use)
    *@static
	*@param String Team id
	*@param Stirng User id
    */
    webservice static String generatePermissions (String user, String team) {
    	UserPermissions userPermissions = new UserPermissions();
    	
    	userPermissions.setId(user);
        userPermissions.setTeam(team);
        userPermissions.setObjectType('Project');
        userPermissions.setPermissions();
		
		String canCreate = 'false';
		String canManage = 'false';
		
		if(userPermissions.getCanCreate())
			canCreate = 'true';
		if(userPermissions.getCanManage())
			canManage = 'true';
		
		//String to return
		String userPermissionsString = canCreate+'|'+canManage;
		return userPermissionsString; 
	}
}