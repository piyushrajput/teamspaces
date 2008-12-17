package com.salesforce.gantt.commands
{
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Heriarchy;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.gantt.model.User;
	import mx.collections.ArrayCollection;
	
	public class AddTaskCommand implements IUndoCommand
	{
		/** The Task to add to the list and the database **/
		private var task : Task;
		private var taskUndo : Task;
		/** The actions are: add, cut, copy **/
		private var action : String;
		
		/**
		 * Constructor
		 * task is the Task to add to the list and the database 
		 * action is the type of command, there are 4 actions:
		 * 1. add before this task in the array
		 * 2. add after this task in the array
		 * 3. copy this task
		 * 4. cut this task
		 */
		 
		public function AddTaskCommand(task : Task, action : String) : void
		{
			this.task = UiTask(task).clone();
			this.taskUndo = task;
			this.action = action;
		}
        
        /**
        * Executes the command of adding this Task to the list and to the database
        * 
        */
        
        public function execute() : void
        {
        	var clonedTask : Task = (UiTask(task)).clone();
			if(action == 'before' || action == 'after' || action == 'firstTask')
			{
		  		clonedTask.id = '';
		  		clonedTask.name = '';
		  		clonedTask.duration = 1;
		  		clonedTask.completed = 0;
			} 
			if(action == 'before')
	  		{
		  		clonedTask.position = task.position;
		  		clonedTask.heriarchy = new Heriarchy(task.heriarchy.indent, task.heriarchy.parent);
		  	}
		  	else if(action == 'after')
		  	{
		  		if(task.heriarchy.hasChildren(task.id))
		  		{
		  			var taskParent : Task = Components.instance.tasks.getTask(task.id)
		  			
		  			if(!UiTask(taskParent).isExpanded)//NO pasa a ser hija de la tarea fase sobre la que se clickeo en la flecha de creacion de tara q apunta hacia abajo
		  			{
		  				var tasksChildren : ArrayCollection = Components.instance.tasks.getAllChildren(taskParent,new ArrayCollection());
		  				clonedTask.position = task.position + tasksChildren.length + 1;
		  				clonedTask.heriarchy = new Heriarchy(0, null, null);
		  			}
		  			else//pasa a ser hija de la tarea fase sobre la que se clickeo en la flecha de creacion de tara q apunta hacia abajo
		  			{
		  				clonedTask.position = task.position + 1;
			  			clonedTask.heriarchy = new Heriarchy(task.heriarchy.indent+1, taskParent);
			  		}
		  		}
		  		else
		  		{
		  			clonedTask.position = task.position + 1;
		  			clonedTask.heriarchy = new Heriarchy(task.heriarchy.indent, task.heriarchy.parent);
		  		}
		  	}
		  	else if(action == 'copy' || action == 'cut')
		  	{
		  		//clonedTask.position = Components.instance.tasks.selectedTask.position;
		  		//clonedTask.heriarchy = new Heriarchy(Components.instance.tasks.selectedTask.heriarchy.indent, Components.instance.tasks.selectedTask.heriarchy.parent);
		  	}
		  	else if(action == 'firstTask')
		  	{
		  		clonedTask.position = 1;
		  		clonedTask.heriarchy = new Heriarchy(0, null, null);
		  	}
		  	else if(action == 'lastTask')
		  	{
		  		clonedTask.position = Components.instance.tasks.allTasks.length + 1;
		  		clonedTask.heriarchy = new Heriarchy(0, null, null);
		  	}
		  	else if(action == 'writing')
		  	{
		  		clonedTask.position = Components.instance.tasks.allTasks.length + 1;
		  	}
	  		
	  		//var user : User = User(Components.instance.users.getUser(Components.instance.session.user.id));
			//clonedTask.createdBy = user
			//clonedTask.lastModified = user;
			Components.instance.tasks.allTasks.addItemAt(clonedTask, clonedTask.position - 1);
			Components.instance.salesforceService.taskOperation.create(clonedTask);
			taskUndo.position = clonedTask.position;
		}
		
		/**
        * Undoes the command of adding this task to the list and the database
        */
		
		public function undo () : void
		{
			var ids : Array = new Array();
			//obtengo el id dela coleccion allTasks porque en task el id esta vacio
			ids.push(Task(Components.instance.tasks.allTasks.getItemAt(taskUndo.position - 1)).id);
			Components.instance.tasks.allTasks.removeItemAt(taskUndo.position - 1);
			
			Components.instance.tasks.countDeleted = 1;
			Components.instance.salesforceService.taskOperation.deleteTasks(ids);
			if(Components.instance.tasks.allTasks.length > 0)
			{
				Task(Components.instance.tasks.allTasks.getItemAt(0)).resetPositions(0);
			}
		}
	}
}