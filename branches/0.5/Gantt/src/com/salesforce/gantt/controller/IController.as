package com.salesforce.gantt.controller
{
	import com.salesforce.gantt.model.Dependency;
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.TaskResource;
	import com.salesforce.gantt.model.UI;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	public interface IController
	{
		function get action() : String;

	  	/** Indents a task to the right or left **/
		function indent(task : Task, type : String) : void;
	
		
		/** Stores a task on the clipboard to cut **/
		function cut() : void;
		/** Stores a task in the clipboard to copy **/
		function copy() : void;
		/** Cuts or copies a task **/
		function paste() : void;

		/** Undoes any commmand invoked **/		
		function undo() : void;
		/** Redoes any commmand invoked **/		
		function redo() : void;
		
		/** Creates a new Task **/
		function addTask(task : Task, action : String) : void;
		/** Updates an existing Task **/
		function updateTask(task : Task, isSelected : Boolean = true, saveInHistory : Boolean = true) : void
		/** Deletes an existing Task **/
        function deleteTask(task : Task) : void;
		
		/** Creates a new TaskResource **/
		function addTaskResource(resources : ArrayCollection) : void;
		/** Updates an existing TaskResource **/
		function updateTaskResource(taskResource : TaskResource) : void;
		/** Deletes an existing TaskResource **/
		function deleteTaskResource(taskResource : TaskResource) : void;
		
		/** Creates a new Dependency **/
		function addDependency(dependency : Dependency, task : Task, move : Boolean = true) : void;
		/** Updates an existing Dependency **/
		function updateDependency(newDependency : Dependency, oldDependency : Dependency) : void;
		/** Deletes an existing Dependency **/
		function deleteDependency(dependency : Dependency, task : Task) : void;
		
		function moveCalcDependencies(dependency : Dependency, task : Task) : void;
		
		function resetPositions() : void;
	}
}