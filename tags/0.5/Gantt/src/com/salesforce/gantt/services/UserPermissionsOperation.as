package com.salesforce.gantt.services
{
		
	
	import com.salesforce.*;
	import com.salesforce.events.*;
	import com.salesforce.objects.*;
	import com.salesforce.results.*;
	
	import flash.events.EventDispatcher;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.controller.Constants;
	
	import mx.rpc.events.*;
	import mx.rpc.soap.*;
	import mx.rpc.wsdl.*;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class UserPermissionsOperation extends EventDispatcher 
	{
		private var connection : Connection;
		private var queryResult : String;
		public var canManage : Boolean = false;
		public var canCreate : Boolean = false;
		
		public function UserPermissionsOperation(connection : Connection) : void
		{
			this.connection = connection;
		}
		
		public function load() : void
		{
			 var ar : AsyncResponder = new AsyncResponder(
				function(result){
					
					
					var userperms : String = result;
					var userpermsm : Array = userperms.split('|');
					
					if(userpermsm[0] == 'true'){ canCreate = true; };
					if(userpermsm[1] == 'true'){ canManage = true; };
					
					//trace('the splitted create string'+userpermsm[0]);
					dispatchEvent(new Event(Constants.LOADING_END));				
					
				},
				function(fault){
					trace('Fault Received'+fault);
				}
			);
			
			var arg1:Parameter = new Parameter("UserId",Components.instance.session.user.id, false);
			var arg2:Parameter = new Parameter("TeamId",Components.instance.session.schedule.team , false);
			//var arg1:Parameter = new Parameter("UserId",'00530000001bALKAA2', false);
   			//var arg2:Parameter = new Parameter("TeamId",'a0B30000002NQV0EAO', false);
   			
			connection.execute("FlexWebService","generatePermissions",[arg1, arg2] ,ar);
		}
		
		public function getQueryResult() : void{ }
		
		public function getCanManage() : Boolean { 
			return canManage;	 
		}

		public function getCanCreate() : Boolean { 
			return canCreate;	 
		}		
		

	}
}