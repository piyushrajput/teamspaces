package com.salesforce.gantt.commands
{
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Task;
	
	import mx.collections.ArrayCollection;
	
	public class DeleteTaskCommand implements IUndoCommand
	{
		/** The Task to delete from the list and the database **/
		private var tasks : ArrayCollection;


		/**
		 * Constructor
		 * task is the Task to delete from the list and the database 
		 */		
		 
		public function DeleteTaskCommand(tasks : ArrayCollection) : void
		{
			this.tasks = tasks;
		}
        
        /**
        * Executes the command of deleting this Task from the list and to the database
        * 
        */
        
        public function execute() : void
        {
			var ids : Array = new Array();
			var positionRemove : int = -1;
	  		for(var i : int = 0; i < tasks.length; i++)
	  		{
	  			//borro la tarea de la memoria
	  			if(positionRemove == -1)
	  			{
	  				positionRemove = Task(tasks.getItemAt(i)).position - 1;
	  			}
				Components.instance.tasks.allTasks.removeItemAt(positionRemove);
				ids.push(Task(tasks.getItemAt(i)).id);
	  		}
	 		Components.instance.salesforceService.taskOperation.deleteTasks(ids);
		}

		/**
        * Undoes the command of deleting this task from the list and the database
        */
				
		public function undo () : void
		{
			var task : Task;
			for(var i : int = 0; i < tasks.length; i++)
	  		{
	  			task = Task(tasks.getItemAt(i));
				Components.instance.tasks.allTasks.addItemAt(task, task.position - 1);
				//trace(Task(Components.instance.tasks.allTasks.getItemAt(i))+' '+Task(Components.instance.tasks.allTasks.getItemAt(i)).heriarchy.indent);
				Components.instance.salesforceService.taskOperation.create(task);
	  		}
	  		Components.instance.controller.resetPositions();
	  		if(tasks.length > 0 )
	  		{
	  			Components.instance.tasks.setParent();
	  			task = Task(tasks.getItemAt(tasks.length - 1));
	  			Components.instance.tasks.select(task.id);
	  		}
		}
	}
}