package com.salesforce.gantt.controller
{
	import com.salesforce.gantt.commands.AddDependencyCommand;
	import com.salesforce.gantt.commands.AddTaskCommand;
	import com.salesforce.gantt.commands.AddTaskResourceCommand;
	import com.salesforce.gantt.commands.DeleteDependencyCommand;
	import com.salesforce.gantt.commands.DeleteTaskCommand;
	import com.salesforce.gantt.commands.DeleteTaskResourceCommand;
	import com.salesforce.gantt.commands.History;
	import com.salesforce.gantt.commands.UpdateDependencyCommand;
	import com.salesforce.gantt.commands.UpdateTaskCommand;
	import com.salesforce.gantt.commands.UpdateTaskResourceCommand;
	import com.salesforce.gantt.model.Dependency;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.TaskResource;
	import com.salesforce.gantt.model.UiTask;
	import mx.controls.Alert; 
	import mx.collections.ArrayCollection;
	import com.salesforce.gantt.model.TaskDate;
	import com.salesforce.gantt.model.Heriarchy;
	
	public class Controller implements IController
	{	
		/**
		 * action can be either cut or copy
		 * to know if we need to delete the selected Task or not
		 * If it's cut then we delete the selected Task
		 * If it's copy then we don't delete the selected Task
		 */
		[Bindable]
		public var action : String = '';
		/** stores the history of commands selected by the user **/
		private var history : History = new History();
		
		/**
		 * Constructor
		 */
		public function Controller()
		{						
		}
		
	  /**
       * Indents a task to the right or left
       * This method 
       * 	- assigns or unassigns parents to affected tasks
       * 	- sets + - images
       * 	- assigns or unassigns children of affected tasks
       */
       
       public function indent(task : Task, type : String) : void
       {
       		//var selectedTask : Task = Components.instance.tasks.selectedTask;
			var clonedTask : Task = (UiTask(task)).clone();
			
			/*if((selectedTask.position-2)>=0)//la posicion d la tarea anterior en el array
			{
				UiTask(Components.instance.tasks.allTasks.getItemAt(selectedTask.position-2)).redrawed = 0;;
			}
			UiTask(selectedTask).redrawed = 0;*/
       		task.heriarchy.updateIndent(clonedTask, type);
       	 	Components.instance.salesforceService.taskOperation.update(clonedTask);
			Components.instance.tasks.setParent(clonedTask.position - 1);
       }
       
		/**
		 * Stores a task on the clipboard to cut
		 **/
		public function cut() : void
		{
			var selectedTask : Task = Components.instance.tasks.selectedTask;
			//Alert.show('cutted!'+selectedTask);
			trace('Cutted:'+selectedTask);
			if(selectedTask.id != '' && selectedTask.name != '')
			{
				action='cut';
				Components.instance.tasks.cut();
			}
		}
		
		/**
		 * Stores a task in the clipboard to copy
		 **/
		 
		public function copy() : void
		{
			var selectedTask : Task = Components.instance.tasks.selectedTask;
			if(selectedTask.id != '' && selectedTask.name != '')
			{
				action='copy';
				Components.instance.tasks.copy();
			}
		}
		
		/**
		 * Creates a new Task identical to the one on the clipBoard 
		 * that has been either cut or copied
		 * (but may have different hierarchy and parent)
		 * If it was cut then the selected Task is deleted otherwise 
		 * the clipboard Task is left alone
		 * 
		 **/
		 
		public function paste() : void
		{
			trace('Pasting...');
			//var clipBoardTasks : ArrayCollection = Components.instance.tasks.clipBoardTasks;
			if(Components.instance.tasks.clipBoardTasks.length>0)
			{
				trace('Pasting:'+Components.instance.tasks.clipBoardTasks);
				var indexAfter : int =0;
				var indent : int = 0;
				var parent : Task = null;
				var subtract : int = 0;
				var i : int = 0;
				var clipBoardTask : UiTask = null;
				
				if(action == 'cut')
				{
					//deleteTask(clipBoardTask);
					//addTask(clipBoardTask, action);
					//trace(clipBoardTask.id+' '+clipBoardTask.dependencies.length);
					trace('Pasting:'+Components.instance.tasks.clipBoardTasks);
					var indexBefore : int = UiTask(Components.instance.tasks.clipBoardTasks.getItemAt(0)).position - 1;
					for(i = 0; i < Components.instance.tasks.clipBoardTasks.length; i++)
					{
		    			Components.instance.tasks.allTasks.removeItemAt(indexBefore);
					}
					indexAfter = Components.instance.tasks.selectedTask.position - 1;
					indent = Components.instance.tasks.selectedTask.heriarchy.indent;
					parent = Components.instance.tasks.selectedTask.heriarchy.parent;
					subtract = 0;
					if(indexBefore < indexAfter)
					{
						subtract = Components.instance.tasks.clipBoardTasks.length - 1;
					}
					var diffIndent : int = 0;
					for(i = 0; i < Components.instance.tasks.clipBoardTasks.length; i++)
					{
						clipBoardTask = UiTask(Components.instance.tasks.clipBoardTasks.getItemAt(i));
						if(i==0)
						{
							diffIndent = indent - clipBoardTask.heriarchy.indent;
			  				clipBoardTask.heriarchy = new Heriarchy(indent, parent);
						}
						else
						{
							clipBoardTask.heriarchy = new Heriarchy(diffIndent + clipBoardTask.heriarchy.indent);
						}
		    			Components.instance.tasks.allTasks.addItemAt(clipBoardTask, indexAfter + i - subtract);
						//addTask(clipBoardTask, action);
						//updateTask(clipBoardTask, false);
					}
				}
				if(action == 'copy')
				{
					indexAfter = Components.instance.tasks.selectedTask.position - 1;
					indent = Components.instance.tasks.selectedTask.heriarchy.indent;
					parent = Components.instance.tasks.selectedTask.heriarchy.parent;
					subtract = 0;
					for(i = 0; i < Components.instance.tasks.clipBoardTasks.length; i++)
					{
						clipBoardTask = UiTask(Components.instance.tasks.clipBoardTasks.getItemAt(i));
						if(i==0)
						{
							diffIndent = indent - clipBoardTask.heriarchy.indent;
			  				clipBoardTask.heriarchy = new Heriarchy(indent, parent);
						}
						else
						{
							clipBoardTask.heriarchy = new Heriarchy(diffIndent + clipBoardTask.heriarchy.indent);
						}
		    			Components.instance.tasks.allTasks.addItemAt(clipBoardTask, indexAfter + i);
						Components.instance.salesforceService.taskOperation.create(clipBoardTask);
					}
					//addTask(clipBoardTask, action);
				}
				//clipBoardTasks.removeAll();
				resetPositions();
				Components.instance.tasks.paste();
			}
		}
		/**
		 * Le resetea a las tareas las posiciones de cada una y actualiza la base de datos
		 * Este metodo es llamado cuando se crea una tarea entre medio de todas, teniendo que actualizar las posiciones de todas las
		 * que estan por debajo para qe luego que se cargue el proyecto nuevamente
		 * se carguen en el mismo orden en el que estaban
		 * */
		public function resetPositions() : void
		{
			var task : Task;
			var j : int = 0;
			for(var i : int = 0; i < Components.instance.tasks.allTasks.length; i++)
			{
				task = Task(Components.instance.tasks.allTasks.getItemAt(i));
				task.position = i + 1;
				if(UiTask(task).isVisible())
				{
					j++;
					task.positionVisible = j;
				}
				//trace(Task(Components.instance.tasks.allTasks.getItemAt(i))+' '+Task(Components.instance.tasks.allTasks.getItemAt(i)).heriarchy.indent);
				updateTask(task, false);
			}
		}
		/**
		 * Undo
		 */
		 
		public function undo() : void
		{
			history.undo();
		}
       
       	/**
		 * Redo
		 */
		 
		public function redo() : void
		{
			history.redo();
		}

		/**
		 * Creates a new Task command and executes it
		 */
		 
		public function addTask(task : Task, action : String) : void
		{
			var addTaskCommand : AddTaskCommand = null;
			if(task != null)
			{
				if(task.validate())
				{
					var clonedTask : Task = (UiTask(task)).clone();
					clonedTask.dependencies = new ArrayCollection();
					
					addTaskCommand = new AddTaskCommand(clonedTask, action);
					addTaskCommand.execute();
					history.addCommand(addTaskCommand);
					//Components.instance.tasks.setParent(clonedTask.position - 1);
					
					Components.instance.tasks.setParent(0);
				}
			}
			else
			{
				//the first task
				var startDate : Date = new Date();
				task = new UiTask('', Components.instance.calendar.toString(startDate), 1);

				addTaskCommand = new AddTaskCommand(task, action);
				addTaskCommand.execute();
				history.addCommand(addTaskCommand);
			}
		}

		/**
		 * Creates an edit Task command and executes it
		 */

		public function updateTask(task : Task, isSelected : Boolean = true, saveInHistory : Boolean = true) : void
		{	
			if(isSelected)
			{
				var selectedTask : Task = Components.instance.tasks.selectedTask;
				var clonedTask : Task = (UiTask(selectedTask)).clone();
				
				var moveEnd : int = 0;
				if(clonedTask.isMilestone)
				{
					moveEnd = task.endDate.toDay() - (clonedTask.startDate.toDay()+1);
				}
				else
				{
					moveEnd = task.endDate.toDay() - clonedTask.endDate.toDay();
				}
				moveDependencies(task, task.startDate.toDay() - clonedTask.startDate.toDay(), moveEnd, 0);
			}	
			//UiTask(task).redrawed = 0;
			var updateTaskCommand : UpdateTaskCommand = new UpdateTaskCommand(task);
			updateTaskCommand.execute();
			if(saveInHistory)
			{
				history.addCommand(updateTaskCommand);
			}
			Components.instance.tasks.setParent(0);
		}
		
		/*
		 * Mueva las dependencias un valor (moveStart) el cual indica la cantidad de dias
		 * Es llamada en forma recursiva
		 */
		private function moveDependencies(parentTask : Task, moveStart : int, moveEnd : int, order : int) : void
		{
			if(moveStart != 0 || moveEnd != 0)
			{
				var taskDependenciesChild : ArrayCollection = Components.instance.tasks.getTaskDependencyChild(parentTask);
				for(var i : int = 0; i < taskDependenciesChild.length; i++)
				{
					var task : Task = UiTask(taskDependenciesChild.getItemAt(i)).clone();
					
					var dependency : Dependency = Components.instance.dependencies.getDependency(parentTask, task);
					
					if(moveStart != 0)//se movio fecha inicio
					{
						task = moveTaskDependency(parentTask, task, dependency, moveStart);
						
						moveDependencies(task, moveStart, 0, order++);
					}
					else if(moveEnd != 0 && order == 0)//se movio fecha fin y la dependencia esta en primer orden (o sea es una dependencia directa de la tarea movida)
					{
						if(dependency.lagType == Dependency.FS || dependency.lagType == Dependency.FF)
						{
							//si entra la primera vez, no se debe preguntar mas por la fecha fin,
							//pero si se debe preguntar por la fecha inicio
							moveStart = moveEnd;
							
							task = moveTaskDependency(parentTask, task, dependency, moveStart);
							
							moveDependencies(task, moveStart, 0, order++);
						}
					}
				}
			}
		}
		/**
		 * Cambia las fechas inicio y fin de una tarea y la edita en la base de datos
		 * Este metodo es llamado cunado se mueve una tarea que tiene hijos de dependencia
		 * los cuales deben moverse tambien
		 */
		private function moveTaskDependency(parentTask : Task, task : Task, dependency : Dependency, moveStart : int) : Task 
		{
			task.startDate.date = Components.instance.calendar.add(task.startDate.date, moveStart);
			task.endDate.date = Components.instance.calendar.add(task.endDate.date, moveStart);
			
			Components.instance.tasks.allTasks.setItemAt(task, task.position - 1);
			Components.instance.salesforceService.taskOperation.update(task);
			
			dependency.task = parentTask;
			task.updateDependency(dependency);
			return task;
		}
		/**
		 * Creates a delete Task command and executes it
		 */
        
        public function deleteTask(task : Task) : void
		{
			var tasks : ArrayCollection = new ArrayCollection();
			var clonedTask : Task = (UiTask(task)).clone();				
			
			tasks.addItem(clonedTask);
  			//tasks = clonedTask.heriarchy.getChildren(clonedTask, tasks);
  			
  			//borra las dependencias
  			var directChildren : ArrayCollection = Components.instance.dependencies.getDirectDependencies(clonedTask);
  			for(var i : int = 0; i < directChildren.length; i++)
  			{
  				var childTask : Task = Task(directChildren.getItemAt(i));

  				var dependency : Dependency = Components.instance.dependencies.getDependency(clonedTask, childTask);
  				childTask.removeDependency(dependency);

				var ids : Array = [dependency.id];
				Components.instance.salesforceService.dependencyOperation.deleteDependencies(ids);
  			}
  			
  			//borrar las hijas si lo que se esta borrando es una fase
  			var children : ArrayCollection = Components.instance.tasks.getAllChildren(clonedTask, new ArrayCollection());
  			for(i = 0; i < children.length; i++)
  			{
	  			tasks.addItem(Task(children.getItemAt(i)));
	  		}
  			
  			Components.instance.tasks.countDeleted = tasks.length;
  			
			var deleteTaskCommand : DeleteTaskCommand = new DeleteTaskCommand(tasks);
			deleteTaskCommand.execute();
			history.addCommand(deleteTaskCommand);
			
			//Components.instance.tasks.setParent();
		}

		/**
		 * Creates a new TaskResouce command and executes it
		 */

	    public function addTaskResource(resources : ArrayCollection) : void
	    {
			var clonedTask : Task = (UiTask(Components.instance.tasks.selectedTask)).clone();							
			var addTaskResourceCommand : AddTaskResourceCommand = new AddTaskResourceCommand(clonedTask, resources);
			addTaskResourceCommand.execute();
			history.addCommand(addTaskResourceCommand);
	    }
	    
		/**
		 * Creates an update TaskResouce command and executes it
		 */

	    public function updateTaskResource(taskResource : TaskResource) : void
		{	
			var selectedTask : Task = Components.instance.tasks.selectedTask;
			var clonedTask : Task = (UiTask(selectedTask)).clone();							

  			var oldTaskResource : TaskResource = selectedTask.getTaskResource(taskResource.id).clone();
			var newTaskResource : TaskResource = TaskResource(selectedTask.getTaskResource(taskResource.id));
			newTaskResource.dedicated = taskResource.dedicated;
			
			var updateTaskResourceCommand : UpdateTaskResourceCommand = new UpdateTaskResourceCommand(Task(clonedTask), oldTaskResource, newTaskResource);
			updateTaskResourceCommand.execute();
			history.addCommand(updateTaskResourceCommand);
		}

		/**
		 * Creates a delete TaskResouce command and executes it
		 */

		public function deleteTaskResource(taskResource : TaskResource) : void
		{	
			var clonedTask : Task = (UiTask(Components.instance.tasks.selectedTask)).clone();										  			
			var deleteTaskResourceCommand : DeleteTaskResourceCommand = new DeleteTaskResourceCommand(clonedTask, taskResource);
			deleteTaskResourceCommand.execute();
			history.addCommand(deleteTaskResourceCommand);
		}

		/**
		 * Creates a new Dependency command and executes it
		 */

       public function addDependency(dependency : Dependency, task : Task, move : Boolean = true) : void
       {
			var clonedTask : Task = (UiTask(task)).clone();		
			var addDependencyCommand : AddDependencyCommand = new AddDependencyCommand(Task(clonedTask), dependency, move);
			addDependencyCommand.execute();
			history.addCommand(addDependencyCommand);
			
			Components.instance.tasks.setParent(0);
       }
		
		/**
		 * Creates an update Dependency command and executes it
		 */

		public function updateDependency(newDependency : Dependency, oldDependency : Dependency) : void
		{
			var clonedTask : Task = (UiTask(Components.instance.tasks.selectedTask)).clone();								
			var updateDependencyCommand : UpdateDependencyCommand = new UpdateDependencyCommand(clonedTask, newDependency, oldDependency);
			updateDependencyCommand.execute();
			history.addCommand(updateDependencyCommand);
			
			moveCalcDependencies(newDependency, clonedTask);	
		}
		
		/**
		 * Creates a delete Dependency command and executes it
		 */

		public function deleteDependency(dependency : Dependency, task : Task) : void
		{
			//var clonedTask : Task = (UiTask(Components.instance.tasks.selectedTask)).clone();
			var clonedTask : Task = (UiTask(task)).clone();									
			var deleteDependencyCommand : DeleteDependencyCommand = new DeleteDependencyCommand(Task(clonedTask), dependency);
			deleteDependencyCommand.execute();
			history.addCommand(deleteDependencyCommand);	
		}
		/**
		 * Metodo llamado cuando se mueve una tarea que tiene hijos (de dependencia)
		 * el cual calcula cuantos dias deben moverse las fechas inicio y fin de las tareas hijas
		 */
		public function moveCalcDependencies(dependency : Dependency, task : Task) : void
		{
			var durationChild : int = task.duration;
			if(task.isMilestone)
			{
				durationChild = 1;
			}
			//se ajusta la fecha de la tarea dependiente, calculando para esto el valor a mover en cantidad de dias(moveStart)
			var moveStart : int = 0;
			switch (dependency.lagType)
			{
				case Dependency.SF:
					moveStart = dependency.task.startDate.toDay()-task.startDate.toDay()-durationChild;
					break;
				case Dependency.FS:
					moveStart = dependency.task.startDate.toDay()+dependency.task.duration-task.startDate.toDay();
					break;
				case Dependency.SS:
					moveStart = dependency.task.startDate.toDay() - task.startDate.toDay();
					break;
				case Dependency.FF:
					moveStart = dependency.task.startDate.toDay()+dependency.task.duration-task.startDate.toDay()-durationChild;
					break;
			}
			if(moveStart != 0)
			{
				//se ajusta la fechade la tarea
				
				task = moveTaskDependency(dependency.task, task, dependency, moveStart);
						
				//se ajusta la fecha de los hijos
				moveDependencies(task, moveStart, 0, 0);
				
				//para que se ajusten las tareas padres(las fases)
				//Components.instance.tasks.setParent();
			}
		}
	}
}