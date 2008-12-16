package com.salesforce.gantt.commands
{
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Resource;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.TaskResource;
	
	import mx.collections.ArrayCollection;

		
	public class AddTaskResourceCommand implements IUndoCommand
	{
		/** The Task the Resource will be added to **/
		private var task : Task;
		/** The Resources that will get added to the Task **/
		private var resources : ArrayCollection;
		
		/**
		 * Constructor
		 * 
		 * task is the Task that will have the Resources added to
		 * resources are the Resources that will get added to the Task 	 
		 */
		 
		public function AddTaskResourceCommand(task : Task, resources : ArrayCollection) : void
		{
			this.task = task;
			this.resources = resources;
		}
        
        /**
        * Executes the command of adding the Resources to the task
        */
        
        public function execute() : void
        {
        	//Components.instance.salesforceService.taskResourceOperation.addTaskResources(task, resources);
        	
			for(var i : int = 0; i < resources.length ; i++)
	    	{
	    		//var taskResource : TaskResource = new TaskResource('', Resource(resources.getItemAt(i)));
	    		
	    		Components.instance.salesforceService.taskResourceOperation.addTaskResource(task, resources[i]);
	    	}
	    	
		}
		
		/**
        * Undoes the command of adding Resources to the Task
        */
		 
		public function undo () : void
		{
			var taskResource : TaskResource;
			for(var i : int = 0; i < resources.length ; i++)
	    	{
	    		taskResource = task.getTaskResource('', Resource(resources.getItemAt(i)));
				if(taskResource != null)
				{
					Components.instance.salesforceService.taskResourceOperation.deleteTaskResource(taskResource.id);
					task.removeTaskResource(taskResource.id);
				}
			}
		}
	}
}