/**
*@author: Federico Garcia @ 08-08-2008 
*/
public class AdminWidgetConfigController {
	
	/**
	* Construct
	*/
	public AdminWidgetConfigController(){
	}
		
	/**
	* Vefify if current user is an Admin
	*/
	public void verifyAdminPerm(){
		TeamUtil.isAdminMemberUser();
	}
	
	/**
	* Return the Namespace Prefix
	*@return String
	*/
	public String getNamespace () {
        return TeamUtil.getNamespace();
    } 

}