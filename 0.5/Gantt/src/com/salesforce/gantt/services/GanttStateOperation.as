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
	import mx.controls.Alert;
	import com.salesforce.gantt.model.GanttState;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class GanttStateOperation extends EventDispatcher 
	{        
		public var ACTION : String = "AuthenticationOperation";
		private var connection : Connection;
		/*
		 * Constructor
		 */
		public function GanttStateOperation(connection : Connection) : void 
		{
			this.connection = connection;
		}
		/*
		 * Carga el estado de la base de datos
		 */	
		public function load() : void
		{
			
			/*var query : String = "Select timeline_state__c.Id, timeline_state__c.date__c, timeline_state__c.scale__c, timeline_state__c.y__c" + 
		    			" From timeline_state__c " + 
		    			" where timeline_state__c.Project__c  = '"+Components.instance.session.schedule.id+"'" + 
		    					" AND timeline_state__c.User__c ='"+Components.instance.session.user.id+"'";
			connection.query(query,
			    new AsyncResponder(function (queryResult : QueryResult) : void
			    {
			    	if(queryResult.records != null)
			    	{
						var record : Object = queryResult.records[0];
						var id : String = record.Id;
						var arrayDate : Array = record.date__c.split('-');
						var startDate : Date = new Date(arrayDate[0],arrayDate[1]-1,arrayDate[2]);
						var scale : String = record.scale__c;
						var y : String = record.y__c;
						var user : User = Components.instance.session.user;
						
						//var lastDate  : Date = Components.instance.calendar.add(new Date(), -30);
						Components.instance.ganttState = new GanttState(scale,startDate,y,user,id);
			    	}
			    	dispatchEvent(new Event(ACTION));
		        })
		    ); */
		    dispatchEvent(new Event(ACTION));
		}
		/*
		 * Agrega el estado en la base de datos
		 */	
		public function create(ganttStare : GanttState) : void
		{
			var create : SObject = new SObject('timeline_state__c');
			create.y__c 		= ganttStare.y;
			create.scale__c 	= ganttStare.scale;
			create.date__c 	= ganttStare.startDate;
			create.User__c 	= Components.instance.session.user.id;
			create.Project__c	= Components.instance.session.schedule.id;			
			
		  	connection.create([create], new AsyncResponder( 
		  		function (result : Object) : void 
		  		{
		  			ganttStare.id = result[0].id;
			 	}
			));
		}
		/*
		 * Edita el estado en la base de datos
		 */	  	
		public function update(ganttStare : GanttState) : void
		{
			var upd : SObject = new SObject('timeline_state__c');
			upd.Id			 		= ganttStare.id;
			upd.y__c 		= ganttStare.y;
			upd.scale__c 	= ganttStare.scale;
			upd.date__c 	= ganttStare.startDate;
			upd.User__c 	= Components.instance.session.user.id;
			upd.Project__c = Components.instance.session.schedule.id;			
			
			connection.update([upd],  new AsyncResponder(
				function updResult(result : Object) : void 
				{
				}, genericFault
			));
		}
	    /*
		 * Muestra un mensaje cuando hay algun error al hacer un 
		 * query por la aplicacion de salesforce
		 */
		private function genericFault(fault : Object) : void
		{
			trace('Error genericFault');
		}
	}
}