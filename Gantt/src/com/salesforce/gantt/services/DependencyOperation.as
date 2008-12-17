package com.salesforce.gantt.services
{
	import com.salesforce.*;
	import com.salesforce.events.*;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Dependency;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.objects.*;
	import com.salesforce.results.*;
	
	import mx.controls.Alert;
	import mx.utils.ObjectUtil;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import com.salesforce.gantt.controller.Constants;
	
	public class DependencyOperation extends EventDispatcher 
	{        
		private var connection : Connection;

		public function DependencyOperation(connection : Connection) : void
		{
			this.connection = connection;
		}

		/* 
		 * Carga las dependencias de la base de datos a la memoria
		 */
		public function load() : void
		{
			var query : String = "Select ProjectTaskPred__c.Id, ProjectTaskPred__c.Lag_Type__c, ProjectTaskPred__c.Lag_Time__c, ProjectTaskPred__c.Lag_Unit__c, ProjectTaskPred__c.Predecessor__c, ProjectTaskPred__c.Parent__c" + 
			" From ProjectTaskPred__c";			
			connection.query(query,
			    new AsyncResponder(function (queryResult : QueryResult) : void
			    {
			    	if(queryResult.records != null)
			    	{
				    	for (var i : int = 0; i < queryResult.records.length; i++) 
			            {
			            	var record : Object 	= queryResult.records[i];
							var lagType : int		= record.Lag_Type__c;
							var lagTime : int		= record.Lag_Time__c;
							var lagUnits : int 		= record.Lag_Unit__c;
							var id : String			= record.Id;
							var parentId : String	= record.Parent__c;
							var childId : String	= record.Predecessor__c;
							
							var parent : Task = Components.instance.tasks.getTask(parentId);
							var child : Task = Components.instance.tasks.getTask(childId);				
							
							if(parent!= null)
							{						
								var dependency : Dependency = new Dependency(parent, lagType, lagTime, lagUnits, id);
								if (child != null)
								{
									child.addDependency(dependency);
									Components.instance.tasks.allTasks.setItemAt(child,child.position-1);
								}
							}
			            }
			    	}
			    	dispatchEvent(new Event(Constants.LOADING_END));
			    	dispatchEvent(new Event(Constants.REFRESHDATES));
		        })
		    ); 
	     }
	    /*
		 * Crea una nueva dependencia en la base de datos
		 */
		public function create(dependency : Dependency, task : Task) : void
		{
			try
			{			
			   var create : SObject = new SObject('ProjectTaskPred__c');
			   create.Parent__c 			= dependency.task.id;
			   create.Predecessor__c 	= task.id;
			   create.Lag_Type__c 		= dependency.lagType;
			   create.Lag_Time__c		= dependency.lagTime;
			   create.Lag_Unit__c		= dependency.lagUnits;
			   
			   //trace(create.Parent__c+' '+create.Predecessor__c);
			   
			   connection.create([create], new AsyncResponder( 
		  		  function (result : Object) : void 
		  		  {
		  			  dependency.id = result[0].id;
		  			  //trace(dependency.id);
			 	  }
			      ));
			}
			catch (ex : *)
			{
			}
	  	}
	  	
		/*
		 * Edita una dependencia en la base de datos
		 */	  	
		public function update(dependency : Dependency, task : Task) : void
		{
			var upd : SObject = new SObject('ProjectTaskPred__c');
			if(task != null)
			{
				upd.Parent__c 	= task.id;
			}
			upd.Lag_Type__c 		= dependency.lagType;
			upd.Lag_Time__c		= dependency.lagTime;
			upd.Lag_Unit__c		= dependency.lagUnits;
			upd.Id 							= dependency.id;		
			connection.update([upd],  new AsyncResponder(
				function updResult(result : Object) : void 
				{
					
				}, this.genericFault
			));
		}
		/*
		 * Borra varias dependencias
		 *
		 * @param ids Array con ids de dependencias a borrar  
		 */	  	
		public function deleteDependencies(ids : Array) : void 
		{
		  	connection.deleteIds([ids], new AsyncResponder(
			  	function delResult(result : Object) : void
			  	{
			  		
				}) 
			);
		}	
		/**
		 * Chequea si se hicieron cambios o si se crearon datos
		 */
		public function checkUpdate(start : Date, end : Date) : void
	    {
		  	connection.getUpdated("ProjectTaskPred__c",start,end, new AsyncResponder(
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
		  	connection.getDeleted("ProjectTaskPred__c",start,end, new AsyncResponder(
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
			
		}
	}
}
