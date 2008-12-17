package com.salesforce.gantt.model
{
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectProxy;
	import com.salesforce.gantt.model.Heriarchy;
	import com.salesforce.gantt.controller.Components;
	import mx.controls.Alert;
	
	[Bindable]
	public class GanttState  
	{	
		public var id : String;
		public var user : User;
		public var startDate : Date;
		public var y : int;
		public var scale : int;
		
		/*
		 * Costructor
		 */	
		public function GanttState(scale : int, startDate : Date, y : int, user : User, id : String = "")
		{		
			this.id = id;
			this.startDate = startDate;
			this.y = y;		
			this.user = user;
			this.scale = scale;
		}
	}
}