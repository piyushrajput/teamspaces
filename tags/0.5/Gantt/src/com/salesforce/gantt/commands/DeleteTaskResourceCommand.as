package com.salesforce.gantt.commands
{
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.TaskResource;
	
	public class DeleteTaskResourceCommand implements IUndoCommand
	{
		/** The Task the Resource will be deleted from **/
		private var task : Task;
		/** The Resources that will get deleted from the Task **/
		private var taskResource : TaskResource;

		/**
		 * Constructor
		 * 
		 * task is the Task that will have the Resources deleted from
		 * resources are the Resources that will get deleted from this Task 	 
		 */
		
		public function DeleteTaskResourceCommand(task : Task, taskResource : TaskResource) : void
		{
			this.task = task;
			this.taskResource = taskResource;
		}
        
        /**
        * Executes the command of deleting the Resources from the task
        */
        
        public function execute() : void
        {
			Components.instance.salesforceService.taskResourceOperation.deleteTaskResource(taskResource.id);
			task.removeTaskResource(taskResource.id);
			Components.instance.tasks.allTasks.setItemAt(task, task.position-1);
		}
		
		/**
        * Undoes the command of deleting Resources from the Task
        */
		
		public function undo () : void
		{
    		Components.instance.salesforceService.taskResourceOperation.addTaskResource(task, taskResource);
		}
	}
}