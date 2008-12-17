package com.salesforce.gantt.controller
{
	import com.salesforce.gantt.services.SalesforceService;
	
	public class UserPermissions implements IUserPermissions
	{
		[Bindable]
		public var userPermissions : String = '';
		
		// Constructor
		public function UserPermissions()
		{	}
		
		public function genUserPermissions() : void {
			Components.instance.salesforceService.userPermissionsOperation.load();			
		}
		
		public function getWebServiceRun() : void {
			Components.instance.salesforceService.userPermissionsOperation.getQueryResult();
		}
		
		public function getCanManage() : Boolean {
			return Components.instance.salesforceService.userPermissionsOperation.getCanManage();			
		}
		
		public function getCanCreate() : Boolean {
			return Components.instance.salesforceService.userPermissionsOperation.getCanCreate();
		}
	}
}