package com.salesforce.gantt.services
{
	import com.salesforce.*;
	import com.salesforce.events.*;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Resource;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.TaskResource;
	import com.salesforce.objects.*;
	import com.salesforce.results.*;
	import mx.utils.ObjectUtil;
	import mx.collections.ArrayCollection;
	
	public class TaskResourceOperation
	{        
		private var connection : Connection;
		
		/* 
		 * Constructor
		 */	
		public function TaskResourceOperation(connection : Connection) : void
		{
			this.connection = connection;
		}
		/* 
		 * Carga las relaciones que hay entre las tareas y los recursos de la base de datos a la memoria, 
		 * esto se hace solo al comienzo de todo
		 */	
		public function loadTasksResources() : void
		{
			//var query : String = "Select Id,ProjectTask__c, Resource__c,Percent_Dedicated__c From ProjectTaskResource__c";
			var query : String = "Select Id, ProjectTask__c, User__c, PercentDedicated__c From ProjectAssignee__c";
			connection.query(query,
			    new AsyncResponder(function (queryResult : QueryResult) : void
			    {
					if(queryResult.records !=  null)
					{
				    	for (var i : int = 0; i < queryResult.records.length; i++) 
				    	{ 
				    		var taskResourceId : String = queryResult.records[i].Id;
				    		var taskId : String = queryResult.records[i].ProjectTask__c;
				    		var dedicated : int = Number(queryResult.records[i].PercentDedicated__c);
				    		var resourceId : int = queryResult.records[i].User__c;
				    		
							var resource : Resource = Components.instance.resources.getResource(resourceId);
							var taskResource : TaskResource = new TaskResource(taskResourceId, resource, dedicated);
							var task : Task = Components.instance.tasks.getTask(taskId);
							if(task != null)
							{
								task.taskResources.addItem(taskResource);	
							}
				    	}
			  		}
			    })
			);
		}
		
		/*
		 * Edita una relacon tarea/recurso en la base de datos
		 */		
		public function update (taskResource : TaskResource) : void
		{
			var update : SObject = new SObject('ProjectAssignee__c');
			update.PercentDedicated__c 	= taskResource.dedicated;
			update.Id 						= taskResource.id;		
			
			trace('updating: '+update.Id + 'this percent is the new :'+ update.PercentDedicated__c);	
			connection.update([update],  new AsyncResponder(
				function updateResult(result : Object) : void 
				{
					if(result[0].success){
						trace('Success updating the resource');						
					}
					
				})
			);
		}
		
		/*
		 * Crea una nueva relacion task/recurso en la base de datos
		 */		
		public function addTaskResource (task : Task, taskResource : TaskResource) : void
		{
			var create : SObject = new SObject('ProjectAssignee__c');
			create.User__c 					= taskResource.resource.id.toString();
			create.PercentDedicated__c 		= taskResource.dedicated.toString();
			create.ProjectTask__c	 		= task.id.toString();
			
			trace('This is the task user__c : '+ taskResource.resource.id + ' this is the task dedicated percent: '+ taskResource.dedicated + ' this is the task id'+ task.id);
		  	connection.create([create],  new AsyncResponder( 
		  		function (result : Object) : void 
		  		{
		  			taskResource.id	= result[0].id;
					task.taskResources.addItem(taskResource);
					Components.instance.tasks.allTasks.setItemAt(task, task.position-1);
					
					if(result[0].success){
						trace('Success adding the resource');
						trace('Id : '+  result[0].id);
					}
			 	}
			 	,genericFault
			));
	  	}		
	  	
	  	
	  	/*
		 * Borra varias tasks resources
		 *
		 * @param ids Array con ids de taskResources a borrar  
		 */	  	
		public function deleteTaskResource(taskResourceId : String) : void 
		{
		  	connection.deleteIds([taskResourceId], new AsyncResponder(
			  	function deleteTaskResource(result : Object) : void
			  	{
			  		if(result[0].success){
						trace('Success deleting the resource');							
					}
				}) 
			);
		}	
	  	/**
		 * Chequea si se hicieron cambios o si se crearon datos
		 */
		public function checkUpdate(start : Date, end : Date) : void
	    {
		  	connection.getUpdated("ProjectAssignee__c",start,end, new AsyncResponder(
			  	function (result:Object):void
				{
					if(result.ids != undefined)
					{
						loadTasksResources();
					}
				}, 
			genericFault));	  
	    }
	    /**
		 * Chequea si se borraron datos
		 */
	    public function checkDeleted(start : Date, end : Date) : void
	    {
		  	connection.getDeleted("ProjectAssignee__c",start,end, new AsyncResponder(
			  	function (result:Object):void
				{
				  	if(result.ids != undefined)
					{
						loadTasksResources();
					}
				}, 
			genericFault));	  
	    }
	    /*
		 * Muestra un mensaje cuando hay algun error al hacer un 
		 * query por la aplicacion de salesforce
		 */
		private function genericFault(fault : Object) : void
		{
			trace(ObjectUtil.toString(fault));
		}
	}
}