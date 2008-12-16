package com.salesforce.gantt.controller
{
	import com.salesforce.gantt.model.User;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.Dependency;
	import mx.collections.ArrayCollection;
	
	public interface IDependencies
	{
		function getDependency(parentTask : Task, childTask : Task) : Dependency;
		function getDirectDependencies(parentTask : Task) : ArrayCollection;
		function validateDependency(parentTask : Task, childTask : Task) : Boolean;
	}
}