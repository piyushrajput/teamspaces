package com.salesforce.gantt.controller
{
	import com.salesforce.gantt.model.Resource;
	import com.salesforce.gantt.model.Task;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public interface IResources
	{
		function set resources(resources : ArrayCollection) : void;
		function get resources() : ArrayCollection;
		
		function getResource(idResource : String) : Resource;
		function actionAuthenticateHandler(event : Event) : void;
		function getAvailabreResources(task : Task) :ArrayCollection;
	}
}