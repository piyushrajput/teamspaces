package com.salesforce.gantt.commands
{
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.TaskResource;

	
	public class UpdateTaskResourceCommand implements IUndoCommand
	{
		
		/** The Task with the Resource to update **/
		private var task : Task;
		/** The Resource to update **/				
		private var oldTaskResource : TaskResource;
		/** The updated Resource **/		
		private var newTaskResource : TaskResource;
		

		/**
		 * Constructor
		 * 
		 * task is the Task with the Resource to update
		 * oldTaskResource is the Resource to update
		 * newTaskResource is the updated Resource
		 */

		public function UpdateTaskResourceCommand(task : Task, oldTaskResource : TaskResource, newTaskResource : TaskResource) : void
		{
			this.task = task;
			this.newTaskResource = newTaskResource;
			this.oldTaskResource = oldTaskResource;
		}
        
        /**
        * Executes the command of updating a Resource to the Task
        */
        
        public function execute() : void
        {
			Components.instance.salesforceService.taskResourceOperation.update(newTaskResource);
		}
		
		/**
        * Undoes the command of updating a Resource to the Task
        */
        
		public function undo () : void
		{
			Task(Components.instance.tasks.getTask(task.id)).setTaskResource(oldTaskResource.id, oldTaskResource);
			Components.instance.salesforceService.taskResourceOperation.update(oldTaskResource);
		}
	}
}