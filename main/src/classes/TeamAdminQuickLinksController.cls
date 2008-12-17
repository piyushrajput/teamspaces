/**
*@author Nicolas Gunther @ 6-13-2008
*/
public class TeamAdminQuickLinksController {

    /**
    * Return if user has permission
    *@return boolean
    */
    public boolean getPermissionAuthorApex(){
        User user = [Select u.Profile.Name, u.ProfileId, u.Name, u.Profile.PermissionsAuthorApex, u.Id From User u Where Id =: UserInfo.getUserId()];
        return user.Profile.PermissionsAuthorApex;
    }
    
    /**
    * Return if user is Team Admin
    *@return boolean
    */
    public boolean getIsTeamAdmin(){
        List<User> teamAdmin = [Select id, Profile.PermissionsModifyAllData, ProfileId, Name From User where id =:UserInfo.getUserId() limit 1];
        if(getPermissionAuthorApex() && teamAdmin[0].Profile.PermissionsModifyAllData){
            return true;
        }
        return false;
    }

}