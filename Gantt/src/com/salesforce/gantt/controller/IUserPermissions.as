package com.salesforce.gantt.controller
{
	import com.salesforce.gantt.model.UserProfile;
	
	public interface IUserPermissions
	{
		function set userPermissions(id: String) : void; 
		function get userPermissions() : String;
		
		function genUserPermissions() : void;
		function getCanManage() : Boolean;
		function getCanCreate() : Boolean;
		function getWebServiceRun() : void; 
	}
}