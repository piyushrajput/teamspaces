package com.salesforce.gantt.services
{
	import com.salesforce.*;
	import com.salesforce.events.*;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.controller.Constants;
	import com.salesforce.gantt.model.Heriarchy;
	import com.salesforce.gantt.model.Resource;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.TaskDate;
	import com.salesforce.gantt.model.TaskResource;
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.gantt.model.User;
	import com.salesforce.objects.*;
	import com.salesforce.results.*;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	public class TaskOperation extends EventDispatcher 
	{        
		private var connection : Connection;
		
		public function TaskOperation(connection : Connection) : void
		{
			this.connection = connection;
		}

		/* 
		 * Carga las tasks de la base de datos a la memoria, esto se hace solo al comienzo de todo.
		 * Se calcula cuales son las fecha inicio y fin de todas las tasks(para luego trabajar en ese "espacio escala")
		 * Se inicializan las clases mxml's incluyendo la controladora.
		 * Se llama a la funcion que despliega los controles (grild, bars, smallbars, edition) en pantalla.
		 */
		public function load() : void
		{
			var query : String = "SELECT " + 
					"p.Id, " + 
					"p.Name," + 
					"p.ParentTask__c, " + 
					"p.StartDate__c, " + 
					"p.EndDate__c, " + 
					"p.Duration__c, " + 
					"p.Percent_Completed__c, " + 
					"p.Task_Position__c," + 
					"p.Indent__c, " + 
					"p.Is_Expanded__c, " + 
					"p.Milestone__c, " +
					"p.Priority__c, " +
					"p.Team__r.Name, " +
					"p.LastModifiedById, " + 
					"p.CreatedById" + 
		    		" FROM ProjectTask__c p " + 
		    		" WHERE ProjectTask__c.Team__c  = '"+ Components.instance.session.schedule.team +"'" +
		    		" ORDER BY ProjectTask__c.Task_Position__c";
				connection.query(query,
			    new AsyncResponder(function (queryResult : QueryResult) : void
			    {
			    	
			    	// trace('This is the task list'+queryResult.records);
			    	if(queryResult.records != null)
			    	{
			    		var usersIds : Array = new Array();
			    		var tasksTemp : ArrayCollection = new ArrayCollection();
				    	for (var i : int = 0; i < queryResult.records.length; i++) 
			            {
							var record : Object = queryResult.records[i];
							var name : String = record.Name;
							var startDate : String = record.StartDate__c;
							//trace('Added the task:'+record.Name+'this is the end date'+record.EndDate__c);						
							
							
							var endDate : String = record.EndDate__c;							
						
							var duration : int = record.Duration__c;
							var id : String = record.Id;
							var completed : int = record.Percent_Completed__c;
							var isExpanded : Boolean = record.Is_Expanded__c;
							var isMilestone : Boolean = record.Milestone__c;
							if(record.Priority__c != null)
							{
								var priority : String = record.Priority__c;
							}	else {
								var priority : String = 'Normal';
							}
							
							var task : UiTask = new UiTask(name, startDate, duration, id, completed, isExpanded, isMilestone, priority);
							
							task.position = record.Task_Position__c;
							task.heriarchy = new Heriarchy(record.Indent__c, null);

							var createUser : User = new User(record.CreatedById);
							task.createdBy = createUser;
							var lastModifiedUser : User = new User(record.LastModifiedById);
							task.lastModified = lastModifiedUser;
							if(!existInArray(usersIds, record.CreatedById))
							{
								usersIds.push(record.CreatedById);
								Components.instance.users.users.addItem(createUser);
							}
							if(!existInArray(usersIds, record.LastModifiedById))
							{
								usersIds.push(record.LastModifiedById);
								Components.instance.users.users.addItem(lastModifiedUser);
							}
							if(task.id.substring(0,task.name.length)==task.name)
							{
								task.name=Constants.defaultTaskName;
							}
							
							task.position = i + 1;
							task.positionVisible = i + 1;
							tasksTemp.addItem(task);
			            }
			            if(usersIds.length > 0)
			            {
			            	Components.instance.salesforceService.authenticateOperation.loadUsers(usersIds);
			            }
			            Components.instance.tasks.allTasks.list = tasksTemp;
			            
			            TaskDate.startDate.setTime(addDays(TaskDate.startDate, -20).getTime());			            
			            TaskDate.endDate.setTime(addDays(TaskDate.endDate, 20).getTime());
			           	
			           	var teamName : String =  queryResult.records[0].Team__r.Name;
			           	if(teamName.length > 22){
			           		Components.instance.tasks.teamSpaceName = teamName.substr(0,20)+'...';
			           	} else {
			           		Components.instance.tasks.teamSpaceName = teamName;
			           	}
			            //Components.instance.tasks.teamSpaceName = queryResult.records[0].Team__r.Name; 
			            //trace('The Team name:'+Components.instance.tasks.teamSpaceName);
			            
				        Components.instance.tasks.setParent();
				        Components.instance.salesforceService.taskResourceOperation.loadTasksResources();
						Components.instance.salesforceService.dependencyOperation.load();
						//Components.instance.calendar.loadDates();
			    	}
			    	else
			    	{
			    		dispatchEvent(new Event(Constants.LOADING_END));
			    		dispatchEvent(new Event(Constants.REFRESHDATES));
			    	}
		        })
		    ); 
	     }
	     /**
		 * 
		 */
	     public function loadUserTask(id : String) : void
		 {
		 	var task : Task = Components.instance.tasks.getTask(id);
		 	if(task!=null)
		 	{
		 		if(task.position <= Components.instance.tasks.allTasks.length)
		 		{
					var query : String = "SELECT p.Id, p.LastModifiedById, p.CreatedById" + 
				    			" FROM ProjectTask__c p" + 
				    			" WHERE p.Project__c  = '"+Components.instance.session.schedule.id+"'" +
				    					" AND p.Id = '"+id+"' LIMIT 1";
				    connection.query(query,
					    new AsyncResponder(function (queryResult : QueryResult) : void
					    {
					    	if(queryResult.records != null)
					    	{
					    		//el if es porque pude llegar a borrarse la tarea antes que llegue aca debido al tiempo que demora el AsyncResponder
					    		if(task.position<=Components.instance.tasks.allTasks.length)
					    		{
									var record : Object = queryResult.records[0];
									var createUser : User = Components.instance.users.getUser(record.CreatedById);
									var lastModifiedUser : User = Components.instance.users.getUser(record.LastModifiedById);
									
									Task(Components.instance.tasks.allTasks.getItemAt(task.position - 1)).createdBy = createUser;
									Task(Components.instance.tasks.allTasks.getItemAt(task.position - 1)).lastModified = lastModifiedUser;
									
									/*task.createdBy = createUser;
									task.lastModified = lastModifiedUser;
									
									Components.instance.tasks.allTasks.setItemAt(task, task.position - 1);*/
					    		}
					    	}
				        })
				    );
				 }
			 } 
		 }
		 /**
		 * Retorna true si existe un string en un array de string
		 * */
	     private function existInArray(array : Array, item : String) : Boolean
	     {
	     	var exist : Boolean = false;
	     	for(var i : int = 0; i <= array.length; i++)
	     	{
	     		if(array[i] == item)
	     		{
	     			exist = true;
		     	}
	     	}
	     	return exist;
	     }
	     /**
		 * Suma dias a una fecha
		 * */
		private function addDays(date : Date, days : Number): Date 
		{
			return new Date(date.getTime() + days * 24 * 60 * 60 * 1000);
		}
	    /*
		 * Crea una nueva task en la base de datos
		 */
		public function create(task : Task) : void
		{
			var create : SObject = new SObject('ProjectTask__c');
			create.Task_Position__c 		= task.position;
			create.StartDate__c 			= task.startDate.toString('database');
			create.EndDate__c				= task.endDate.toString('database');
			create.Duration__c 				= task.duration;
			create.Percent_Completed__c 	= task.completed;
			create.Project__c 				= Components.instance.session.schedule.id;
			create.Team__c					= Components.instance.session.schedule.team;
			create.Name 					= task.name;
			create.Priority__c 					= task.priority;
			create.Milestone__c				= task.isMilestone;
			create.Indent__c				= task.heriarchy.indent;
			
		  	connection.create([create], new AsyncResponder( 
		  		function (result : Object) : void 
		  		{
		  			task.id = result[0].id;
		  			var r : Resource = Components.instance.resources.getResource(Components.instance.session.user.id);
		  			var taskResource : TaskResource = new TaskResource('', r, 100);		  			
		  			Components.instance.salesforceService.taskResourceOperation.addTaskResource(task, taskResource);		  			
		  			loadUserTask(task.id);
		  			dispatchEvent(new Event(Constants.LOADING_END));
			 	}
			));
			
		}	  	
		/*
		 * Edita una task en la base de datos
		 */	  	
		public function update(task : Task) : void
		{
			var upd : SObject = new SObject('ProjectTask__c');
			upd.Task_Position__c 		= task.position;
			upd.StartDate__c 			= task.startDate.toString('database');
			upd.EndDate__c				= task.endDate.toString('database');
			upd.Duration__c 			= task.duration;	
			upd.Percent_Completed__c 	= task.completed;
			upd.Indent__c				= task.heriarchy.indent;
			upd.Id 						= task.id;
			upd.Name 					= task.name;
			upd.Milestone__c			= task.isMilestone;
			upd.Priority__c			= task.priority;
			
			connection.update([upd],  new AsyncResponder(
				function updResult(result : Object) : void 
				{
					loadUserTask(task.id);
					dispatchEvent(new Event(Constants.LOADING_END));
				}, genericFault
			));
		}
		/*
		 * Borra varias task
		 *
		 * @param ids Array con ids de task a borrar  
		 */	  	
		public function deleteTasks(ids : Array) : void 
		{
		  	connection.deleteIds([ids], new AsyncResponder(
			  	function delResult(result : Object) : void
			  	{
			  		dispatchEvent(new Event(Constants.LOADING_END));
				}) 
			);
		}	
		
		/**
		 * Chequea si se hicieron cambios o si se crearon datos
		 */
		public function checkUpdate(start : Date, end : Date) : void
	    {
		  	connection.getUpdated("ProjectTask__c",start,end, new AsyncResponder(
			  	function (result:Object):void
				{
					if(result.ids != undefined)
					{
						load();
					}
				}, 
			genericFault));	  
	    }
	    /**
		 * Chequea si se borraron datos
		 */
	    public function checkDeleted(start : Date, end : Date) : void
	    {
		  	connection.getDeleted("ProjectTask__c",start,end, new AsyncResponder(
			  	function (result:Object):void
				{
					if(result.ids != undefined)
					{
						load();
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
			trace('genericFault');
		}
	}
}