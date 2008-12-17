package com.salesforce.gantt.commands
{
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Dependency;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.UiTask;
	
	public class AddDependencyCommand implements IUndoCommand
	{
		/** The Task the dependency will be added to **/
		private var child : Task;
		/** The Dependency that will get added to the Task **/
		private var dependency : Dependency;
		
		private var move : Boolean = false;
		
		/**
		 * Constructor
		 * 
		 * child is the Task that will have the dependency added to
		 * dependency is the Dependency that will get added to the Task 	 
		 */
		 
		public function AddDependencyCommand(child : Task, dependency : Dependency, move : Boolean) : void
		{
			this.child = child;
			this.dependency = dependency;
			this.move = move;
		}
        
        /**
        * Executes the command of adding a dependency to the task
        */
        
        public function execute() : void
        {
        	child.addDependency(dependency);
       		Components.instance.salesforceService.dependencyOperation.create(dependency, child);
       		
       		if(move)
			{
				Components.instance.controller.moveCalcDependencies(dependency, Task(UiTask(child).clone()));
			}
		}

        /**
        * Undoes the command of adding a dependency to the task
        */
		
		public function undo () : void
		{
			child.removeDependency(dependency);
			var ids : Array = [dependency.id];
			Components.instance.salesforceService.dependencyOperation.deleteDependencies(ids);
			Components.instance.controller.updateTask(child,false,false);
		}
	}
}