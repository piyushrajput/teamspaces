public class TeamAdminQuickLinksController {
	
	/**
	*
	*/
	public Id getQueueGroupId(){
		Group teamAdmin = [SELECT Id FROM Group WHERE Name = 'Team Admin'];           
		return teamAdmin.Id;
	}
	
	/**
	*
	*/
	public boolean getPermissionAuthorApex(){
		User user = [Select u.Profile.Name, u.ProfileId, u.Name, u.Profile.PermissionsAuthorApex, u.Id From User u Where Id =: UserInfo.getUserId()];
		return user.Profile.PermissionsAuthorApex;
	}
	
	/**
	*
	*/
	public boolean getIsTeamAdmin(){
		List<GroupMember> groupMember = new List<GroupMember>(); 
		groupMember = [select Id
                        from GroupMember
                        where GroupId =: getQueueGroupId()
                        and UserOrGroupId =: UserInfo.getUserId()];
        if(getPermissionAuthorApex() && groupMember.size() != 0){
        	return true;
        }
        return false;
	}

}