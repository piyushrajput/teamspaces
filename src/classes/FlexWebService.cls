global class FlexWebService {	
		
	public UserPermissions userPermissions = new UserPermissions();
	
	public void genPermissions (String TeamId, String UserId) {
        userPermissions.setId(UserId);
        userPermissions.setTeam(TeamId);
        userPermissions.setObjectType('Project');
        userPermissions.setPermissions();       
    }
    
    webservice static String generatePermissions (String user, String team) {
    	UserPermissions userPermissions = new UserPermissions();
    	
    	userPermissions.setId(user);
        userPermissions.setTeam(team);
        userPermissions.setObjectType('Project');
        userPermissions.setPermissions();

		//Can Manage:
		//userPermissions.canManage;
		//userPermissions.canCreate;
		String canCreate = 'false';
		String canManage = 'false';
		
		if(userPermissions.getCanCreate()){ canCreate = 'true';}
		if(userPermissions.getCanManage()){ canManage = 'true';}
		
		//String to return
		String userPermissionsString = canCreate+'|'+canManage;
		return userPermissionsString; 
	}

}