package com.salesforce.gantt.commands
{
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.gantt.model.User;	
	
	public class UpdateTaskCommand implements IUndoCommand
	{
		/** the new Task **/
		private var newTask : Task;
		/** we keep the old task in memory **/
		private var oldTask : Task;
		
		/**
		 * Constructor
		 * task is the new Task to update
		 * 
		 */
		public function UpdateTaskCommand(newTask : Task) : void
		{
			this.newTask = newTask;
			this.oldTask = Task(Components.instance.tasks.getTask(newTask.id));
			//this.oldTask = Task(Components.instance.tasks.allTasks.getItemAt(newTask.position-1))
		}
        
		/**
        * Executes the command of updating a the task
        */
        public function execute() : void
        {
			var _newTask : UiTask 	=  new UiTask(newTask.name, newTask.startDate.toString('database'), Number(newTask.duration), newTask.id, int(newTask.completed),true, newTask.isMilestone, newTask.priority );
			_newTask.position 		= newTask.position;
			_newTask.heriarchy 		= newTask.heriarchy;
			_newTask.dependencies 	= newTask.dependencies;
			_newTask.taskResources 	= newTask.taskResources;
			_newTask.positionVisible= newTask.positionVisible;
			_newTask.createdBy 		= newTask.createdBy;
			_newTask.createdBy 		= newTask.createdBy;
			_newTask.priority 		= newTask.priority;
			_newTask.lastModified 	= newTask.lastModified;
			
			Components.instance.tasks.allTasks.setItemAt(_newTask, _newTask.position - 1);
			Components.instance.salesforceService.taskOperation.update(_newTask);
			//Components.instance.tasks.select(_newTask.id);
		}
		
		/**
        * Undoes the command of updating a task
        */
		public function undo () : void
		{
			Components.instance.tasks.allTasks.setItemAt(oldTask, oldTask.position - 1);
			Components.instance.salesforceService.taskOperation.update(oldTask);
			//Components.instance.tasks.select(newTask.id);
		}
	}
}