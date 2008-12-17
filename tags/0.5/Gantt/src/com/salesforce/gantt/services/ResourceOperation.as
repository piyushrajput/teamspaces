package com.salesforce.gantt.services
{
	import com.salesforce.*;
	import com.salesforce.events.*;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Resource;
	import com.salesforce.objects.*;
	import com.salesforce.results.*;
	
	import mx.collections.ArrayCollection;
	
	public class ResourceOperation  
	{
		private var connection : Connection;
		
		/*
		 * Constructor
		 */

		public function ResourceOperation(connection : Connection) : void
		{
			this.connection = connection;
		}

		/*
		 * Carga todos los recursos
		 */
		public function loadResources(resources : ArrayCollection, ids : Array) : void
		{
			if(ids.length != 0)
			{
				//var query : String = "Select Id, Name From Resource__c Where Id IN ('"+ids.join("','")+"')";
				var query : String = "Select Id, Name From User Where Id IN ('"+ids.join("','")+"')";
				connection.query(query,
				    new AsyncResponder(function (queryResult : QueryResult) : void
				    {
				    	if(queryResult.records !=  null)
						{
					    	for (var i : int = 0; i < queryResult.records.length; i++) 
					    	{ 				    		
					    		var resourceName : String = queryResult.records[i].Name;
					    		var resourceId : String = queryResult.records[i].Id;
					    		var resource : Resource = new Resource(resourceName, resourceId);
								resources.addItem(resource); 
					    	}
					 	}
					 	Components.instance.salesforceService.taskOperation.load();
				    })
				);
			}
			else
			{
				Components.instance.salesforceService.taskOperation.load();
			}
		}
		
		
		/**
		 * Obtiene todos los recursos habilitados para el proyecto
		 */
		public function loadProyectResources(resources : ArrayCollection) : void
		{
			//var query : String = "Select Resource__c From ProjectResource__c Where Project__c='"+Components.instance.session.schedule.id+"'";
			//Project__c='"+Components.instance.session.schedule.id+"' AND
			var query : String = "Select User__c From TeamMember__c Where Team__c = '" + Components.instance.session.schedule.team + "'";
			//trace(query);
			connection.query(query,
			    new AsyncResponder(function (queryResult : QueryResult) : void
			    {
			    	var ids : Array = new Array();
			    	if(queryResult.records !=  null)
					{
				    	for (var i : int = 0; i < queryResult.records.length; i++) 
				    	{ 			
							//ids.push(queryResult.records[i].Resource__c);
							ids.push(queryResult.records[i].User__c);			    		 
				    	}
				 	}
				 	loadResources(resources, ids);
			    })
			); 
		}

	  	/*
		 * Muestra un mensaje cuando hay algun error al hacer un 
		 * query por la aplicacion de salesforce
		 */

		private function genericFault(fault : Object) : void
		{
		
		}
	}
}