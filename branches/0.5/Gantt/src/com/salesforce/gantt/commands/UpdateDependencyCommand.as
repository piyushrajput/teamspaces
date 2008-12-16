package com.salesforce.gantt.commands
{
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Dependency;
	import com.salesforce.gantt.model.Task;
	
	public class UpdateDependencyCommand implements IUndoCommand
	{
		
		/** The Task with the Dependency to update **/
		private var child : Task;
		/** The Dependency to update **/		
		private var oldDependency : Dependency;
		/** The updated Dependency **/		
		private var newDependency : Dependency;
		
		/**
		 * Constructor
		 * 
		 * child is the Task with the Dependency to update
		 * oldDependency is the Dependency to update
		 * newDependency is the updated Dependency
		 */
		 
		public function UpdateDependencyCommand(child : Task, newDependency : Dependency, oldDependency : Dependency) : void
		{
			this.child = child;
			this.oldDependency = oldDependency;
			this.newDependency = newDependency;
		}

		/**
        * Executes the command of updating a dependency to the task
        */
        
        public function execute() : void
        {
        	child.updateDependency(newDependency);
        	Components.instance.tasks.allTasks.setItemAt(child, child.position - 1);
        	Components.instance.salesforceService.dependencyOperation.update(newDependency, newDependency.task);
		}
		
		/**
        * Undoes the command of updating a dependency to the task
        */
        
		public function undo () : void
		{
			child.updateDependency(oldDependency);
			Components.instance.tasks.allTasks.setItemAt(child, child.position - 1);
			Components.instance.salesforceService.dependencyOperation.update(oldDependency, oldDependency.task);
		}
	}
}