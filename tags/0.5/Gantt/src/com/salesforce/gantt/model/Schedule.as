package com.salesforce.gantt.model
{
	import mx.core.Application;
	import mx.controls.Alert;
	[Bindable]
	public class Schedule
	{
		public var id : String = Application.application.parameters.Project;
		public var name : String;
		public var team : String = Application.application.parameters.Team;
		
		public function Schedule () : void 
		{
			if(!Application.application.parameters.Project && !Application.application.parameters.Team){
				this.id = 'a0M30000000r9tfEAA';
				this.team = 'a0B30000001y2EvEAI';
			}
		}
	}
}