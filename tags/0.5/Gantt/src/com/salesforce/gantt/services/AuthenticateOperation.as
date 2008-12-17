package com.salesforce.gantt.services
{
	import com.salesforce.*;
	import com.salesforce.events.*;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.User;
	import com.salesforce.objects.*;
	import com.salesforce.results.*;
	import mx.core.Application;
	import mx.utils.ObjectUtil;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import mx.rpc.Responder;
	import mx.rpc.Responder;
	
	
	import mx.controls.Alert;
	import com.salesforce.gantt.model.Task;
	
	public class AuthenticateOperation extends EventDispatcher 
	{        
		public var ACTION : String = "AuthenticationOperation";
		public var connection : Connection = new Connection();
		
		/*
		 * Constructor
		 */
		public function AuthenticateOperation() : void 
		{

		}
		
		/*
		 * Hace el login y dispara evento para cargar los datos
		 */
		public function authenticate (username : String, password : String) : void 
		{
			/*
			 https://prerelwww.pre.salesforce.com/services/Soap/u/10.0 
			 */
			var loginRequest : LoginRequest = null;
			if(Application.application.parameters.session_id != undefined)
			{
				loginRequest = new LoginRequest(
				{
					server_url : Application.application.parameters.server_url,	
					session_id : Application.application.parameters.session_id,
					
					callback : new AsyncResponder(function (result : Object) : void
					{  
						Components.instance.session.user.id = result.userId;
						loadSchedule();
						Components.instance.salesforceService.ganttStateOperation.load();
					})
				}); 					
			}
			else
			{	
				loginRequest = new LoginRequest(
				{
					username : username,
					password : password,
					server_url : Application.application.parameters.server_url,	
					session_id : Application.application.parameters.session_id,
					callback : new AsyncResponder(function (result : Object) : void
					{
						Components.instance.session.user.id = result.userId;
						loadSchedule();
						Components.instance.salesforceService.ganttStateOperation.load();
					})
				}); 					
			}
			this.connection.login(loginRequest);
			
		}
		/**
		 * Carga el nombre del proyecto de la base de datos
		 */
		public function loadSchedule() : void
		{
			var query : String = "Select Name From Project2__c Where Id = '"+Components.instance.session.schedule.id+"'";
			
			connection.query(query,
			    new AsyncResponder(function (queryResult : QueryResult) : void
			    {
					if(queryResult.records !=  null)
					{
				    	Components.instance.session.schedule.name = queryResult.records[0].Name;
				    	dispatchEvent(new Event(ACTION));
				    	createAuthenticateUser();
			  		}
			    },genericFault)
			);
		}
		
		public function loadAuthenticateUsers() : void
		{
			/*var query : String = "Select Id, User__c From Schedule_Task_Current_User__c Where Schedule__c = '"+Components.instance.session.schedule.id+"'";
			connection.query(query,
			    new AsyncResponder(function (queryResult : QueryResult) : void
			    {
					if(queryResult.records !=  null)
					{
						var ids : Array = new Array();
				    	for (var i : int = 0; i < queryResult.records.length; i++) 
			            {
							var record : Object = queryResult.records[i];
							
							var user : User = new User();
							user.id = record.User__c;
							user.idAuthenticate = record.Id;
							
							Components.instance.users.users.addItem(user);
							ids.push(user.id);
			            }
			            
			           // ids.push(user.id);
						loadUsers(ids);
						//del(ids);
			  		}
			    })
			);*/
		}
		
		
		private function del(ids : Array) : void
		{
			connection.deleteIds([ids], new AsyncResponder(
			  	function delResult(result : Object) : void
			  	{
			  		//trace(result.toString());
				}) 
			);
		}
		
		
		public function createAuthenticateUser() : void
		{										
			/*var create : SObject = new SObject('Schedule_Task_Current_User__c');
			create.User__c 		= Components.instance.session.user.id;
			create.Schedule__c 	= Components.instance.session.schedule.id;
			
		  	connection.create([create], new AsyncResponder( 
		  		function (result : Object) : void 
		  		{
		  			Components.instance.session.user.idAuthenticate = result[0].id;
		  			trace(result[0].id);*/
		  			loadAuthenticateUsers();
			 	/*}
			));*/
	  	}
	  	
	  	
	  	/*
		 * Borra varias task
		 *
		 * @param ids Array con ids de task a borrar  
		 */	  	
		public function deleteAuthenticateUser() : void 
		{
			var ids : Array = new Array();
			ids.push(Components.instance.session.user.idAuthenticate);
			//trace(connection.getCurrentSessionid());
		  	connection.deleteIds([ids], new Responder(
			  	function delResult(result : Object) : void
			  	{
			  		
				}, genericFault )
			);
			//trace('exit');
		}
		/**
		 * Obtiene el nombre y el id de todos los usuarios logueados en el sistema
		 */
		public function loadUsers(ids : Array) : void
		{
			var idsJoin : String = ids.join("','");
			var query : String = "Select Id, Name From User Where Id IN ('"+idsJoin+"')";
			connection.query(query,
			    new AsyncResponder(function (queryResult : QueryResult) : void
			    {
					if(queryResult.records !=  null)
					{
				    	for (var i : int = 0; i < queryResult.records.length; i++) 
			            {
							var record : Object = queryResult.records[i];
							//trace(record.Id+' '+record.Name);
							Components.instance.users.getUser(record.Id).name = record.Name;
			            }
			            Components.instance.tasks.setTaskUsers();
			  		}
			    })
			);
		}
		
		/**
		 * Chequea si se hicieron cambios o si se crearon datos
		 */
		public function checkUpdate() : void
	    {
		  	var query : String = "Select Id From Schedule_Task_Current_User__c Where Schedule__c = '"+Components.instance.session.schedule.id+"'";
			connection.query(query,
			    new AsyncResponder(function (queryResult : QueryResult) : void
			    {
					if(queryResult.records ==  null)
					{
						Components.instance.salesforceService.activateCheckRefresh=false;
					}
					else
					{
						//si hay mas de 1 usuario logueado
						if(queryResult.records.length > 1)
						{
							Components.instance.salesforceService.activateCheckRefresh=true;
						} 
						else
						{
							Components.instance.salesforceService.activateCheckRefresh=false;
						}
			  		}
			    })
			);		 
	    }
	    /*
		 * Muestra un mensaje cuando hay algun error al hacer un 
		 * query por la aplicacion de salesforce
		 */
		private function genericFault(fault : Object) : void
		{
			Alert.show(ObjectUtil.toString(fault));
		}
	}
}