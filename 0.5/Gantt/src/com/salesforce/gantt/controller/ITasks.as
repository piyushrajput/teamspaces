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
	
	public interface ITasks
	{
		function set allTasks(tasks : ArrayCollection) : void;
		function get allTasks() : ArrayCollection;
		function set selectedTask(tasks : UiTask) : void;
		function get selectedTask() : UiTask;
		function get clipBoardTasks() : ArrayCollection;
		function set clipBoardTasks(task : ArrayCollection) : void;
		function get countDeleted() : int;
		function set countDeleted(count : int) : void;
		//Team name
		//Brx
		function set teamSpaceName(teamName: String) : void;
		function get teamSpaceName() : String;
		
		function setParent(findStart : int = 0) : void;
		function getTask(id : String) : UiTask;
		function select (id : String) : void;

		function cut() : void;
		function copy() : void;
		function paste() : void;
		
		function possibleParentTasks(taskChild : Task) : ArrayCollection;
		function filterVisibleTask() : ArrayCollection;
		function setUpdateTask(task : Task, type : String, text : String, saveInHistory : Boolean = true) : Boolean;
		function getTaskDependencyChild(parentTask : Task) : ArrayCollection;
		function getDirectChildren(taskParent : Task) : ArrayCollection;
		function getAllChildren(taskParent : Task, children : ArrayCollection) : ArrayCollection;
		function setTaskUsers() : void;
		function firstTask() : Task;
		function refreshDates() : void;
		//function setRefreshAllTasks() : void;
	}
}