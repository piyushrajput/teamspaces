package com.salesforce.gantt.commands
{
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Dependency;
	import com.salesforce.gantt.model.Task;
	
	public class DeleteDependencyCommand implements IUndoCommand
	{
		
		/** The Task the dependency will be deleted from **/
		private var child : Task;
		/** The Dependency that will get deleted from the Task **/
		private var dependency : Dependency;

		/**
		 * Constructor
		 * 
		 * child is the Task that will have the dependency deleted from
		 * dependency is the Dependency that will get deleted to the Task 	 
		 */

		public function DeleteDependencyCommand(child : Task, dependency : Dependency) : void
		{
			this.child = child;
			this.dependency = dependency;
		}

        /**
        * Executes the command of deleting a dependency from the task
        */
        
        public function execute() : void
        {
        	child.removeDependency(dependency);
			
			var ids : Array = [dependency.id];
			Components.instance.salesforceService.dependencyOperation.deleteDependencies(ids);
		}
		
		/**
        * Undoes the command of deleting a dependency from the task
        */
        
		public function undo () : void
		{
			child.addDependency(dependency);
       		Components.instance.salesforceService.dependencyOperation.create(dependency, child);
		}
	}
}