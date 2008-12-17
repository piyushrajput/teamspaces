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
	import com.salesforce.gantt.model.TaskDate;
	import com.salesforce.gantt.model.TaskResource;
	import com.salesforce.gantt.model.UiTask;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	public class Tasks implements ITasks
	{
		
		[Bindable]
		public var selectedTask : UiTask = new UiTask('', '', 0, '');
		[Bindable]
		public var clipBoardTasks : ArrayCollection = new ArrayCollection();
		
		private var history : History = new History();		
		[Bindable]
		public var allTasks : ArrayCollection = new ArrayCollection();
		
		// Team name 
		// brx
		[Bindable]
		public var teamSpaceName : String = '';
		
		
		/*
		 * Constructor
		 */
		public function Tasks()
		{
			//Components.instance.salesforceService.authenticateOperation.addEventListener(Components.instance.salesforceService.authenticateOperation.ACTION, actionAuthenticateHandler);			
		}
		
		/**
		 * Copia una tarea en memoria, y asigna accion='cut' para saber que cuando
		 * pegue la tarea, ademas de crearse una nueva,
		 * se debe borrar la que copie a memoria
		 **/
		public function cut() : void
		{
			resetAlphaCut();
			clipBoardTasks.removeAll();
			clipBoardTasks.addItem(UiTask((UiTask(selectedTask)).clone()));
			getTask(selectedTask.id).alphaCut = 1;
			var getChildrens : ArrayCollection = getAllChildren(selectedTask, new ArrayCollection());
			for(var i : int = 0; i<getChildrens.length; i++)
			{
				clipBoardTasks.addItem(UiTask(getChildrens.getItemAt(i)));
				getTask(Task(getChildrens.getItemAt(i)).id).alphaCut = 1;
			}
		}
		/**
		 * Copia una tarea en memoria
		 **/
		public function copy() : void
		{
			resetAlphaCut();
			clipBoardTasks.removeAll();
			clipBoardTasks.addItem(UiTask((UiTask(selectedTask)).clone()));
			var getChildrens : ArrayCollection = getAllChildren(selectedTask, new ArrayCollection());
			for(var i : int = 0; i<getChildrens.length; i++)
			{
				clipBoardTasks.addItem(UiTask(getChildrens.getItemAt(i)));
			} 
		}
		/**
		 * Pega una tarea en memoria
		 **/
		public function paste() : void
		{	
			resetAlphaCut();
			setParent();
		}
		/**
		 * Deja con al alpha por defecto a atodas las tareas
		 * Es llamada cunado se debe desmarcar la tarea que se cortomemo
		 **/
		private function resetAlphaCut() : void
		{
			for(var i : int = 0; i < allTasks.length; i++)
			{
				UiTask(this.allTasks.getItemAt(i)).alphaCut = 0.1;
			}
		}
        /**
		 * Captura el evento luego de que se hace el login
		 */
        private function actionAuthenticateHandler(event:Event):void 
		{
			//Components.instance.salesforceService.taskOperation.load();
        }
        /**
        * Es llamada alcargar los datos en el inicio, despues que se indentan task,
        * cuando se crean task y cuando se editan
        * 
        * Se encarga de 
        * 	 actualizar las herarquias (agregando o quitando) entre las tareas
        * 	 actualizar los punteros a las siguiente tarea
        *    agregar o quitar las imagenes (simbolo mas y menos)
        */
        public function setParent(findStart : int = 0) : void
        {	
			var task : Task = null;
			var taskNext : Task = null;
			var taskParent : Task = null;
			for(var i : int = 0; i < allTasks.length; i++)
			{
				Task(allTasks.getItemAt(i)).position = i+1;
			}
       		for(i = findStart; i < allTasks.length; i++)
			{
				task = Task(allTasks.getItemAt(i));
				task.heriarchy.parent = null;
				task.heriarchy.next = null;
				taskNext = null;
				if((i+1)<allTasks.length)
				{
					taskNext = Task(allTasks.getItemAt(i+1));
				}
				task.heriarchy.next = taskNext;
			
				//Asigno un padre de la herarquia
	       		for( var j : int = i; j >= 0; j--)
				{	
					taskParent = Task(allTasks.getItemAt(j));
				//	trace(taskParent+'  '+taskParent.heriarchy.indent);
					if(task.heriarchy.setParent(taskParent))
					{
						var dependency : Dependency = null;
						if(task.isParent(taskParent))
						{
							dependency = Dependency(task.getDependency(taskParent.id,'idParent'));
							if(dependency != null)
							{
								Components.instance.controller.deleteDependency(dependency, task);
							}
						}
						else if(taskParent.isParent(task))
						{
							dependency = Dependency(taskParent.getDependency(task.id,'idParent'));
							if(dependency != null)
							{
								Components.instance.controller.deleteDependency(dependency, taskParent);
							}
						}
						break;
					}
				}
			}
			for(i = allTasks.length - 1; i >= 0; i--)
			{
				//reajusta las fechas inicio y fin de las tareas padres(fases) segun sus hijos
				setDates(Task(allTasks.getItemAt(i)));
			}
       }
       /**
	 	* Actualiza las fechas inicio y fin de todo el gantt
	 	* Es llamada cada vez que se crea o edita la fecha de una tarea
	 	*/
       private function setDates(taskParent : Task) : void
       {
       		var sum : int = 0;
       		var startDateTemp : Date = new Date();
			var endDateTemp : Date = new Date();
       		var childs : ArrayCollection = getAllChildren(taskParent, new ArrayCollection());
			for (var i : int = 0; i < childs.length; i++)
			{
				var child : Task = Task(childs.getItemAt(i));
				if(child.startDate.date.getTime() < startDateTemp.getTime() || i == 0)
				{
					startDateTemp.setTime(child.startDate.date.getTime());
				}
				if(child.endDate.date.getTime() > endDateTemp.getTime() || i == 0)
				{
					endDateTemp.setTime(child.endDate.date.getTime()); 
				}
				sum += child.completed;
			}
			if(childs.length > 0)
			{
				taskParent.isMilestone = false;
				taskParent.completed = sum / childs.length;
				taskParent.startDate.date.setTime(startDateTemp.getTime());
				taskParent.endDate.date.setTime(endDateTemp.getTime());
				taskParent.duration = taskParent.endDate.toDay() - taskParent.startDate.toDay();
				Components.instance.tasks.allTasks.setItemAt(taskParent, taskParent.position - 1);
			}
       }
       /**
	 	* Retorna todos los hijos de una tarea fase, ya sea directos o indirectos
	 	*/
       public function getAllChildren(taskParent : Task, children : ArrayCollection) : ArrayCollection
       {
       		var directChild : ArrayCollection = getDirectChildren(taskParent);
       		for(var i : int = 0; i < directChild.length; i++)
			{
				children.addItem(Task(directChild.getItemAt(i)));
				getAllChildren(Task(directChild.getItemAt(i)),children);
			}
			return children;
       }
       /**
	 	* Retorna los hijos directos de una tarea fase
	 	*/
       public function getDirectChildren(taskParent : Task) : ArrayCollection
       {
       		var directChild : ArrayCollection = new ArrayCollection();
       		for(var i : int = taskParent.position; i < allTasks.length; i++)
			{
				var taskChild : Task = Task(allTasks.getItemAt(i));
				if(taskParent.heriarchy.indent == taskChild.heriarchy.indent - 1)
				{
					directChild.addItem(taskChild)
				}
				else
				{
					break;
				}
			}
			return directChild;
       }
       /**
       * Retorna la primer tarea de la coleccion
       */
       private function getFirstTask() : Task
       {
       		if(allTasks.length > 0)
       		{
       			return Task(allTasks.getItemAt(0));
       		}
       		return null;
       }
       /*
		* Recibe el id de una tarea la busca y retorna la tarea
		*/
	   public function getTask(id : String) : UiTask
       {
       		var task : Task = null;
			for( var i : int = 0; i < allTasks.length; i++)
			{
				task = Task(allTasks.getItemAt(i));
				if(task.id == id)
				{
					return UiTask(task);
				}
			}
			return null;
       }
       /*
		* Recibe una tarea la busca y retorn el index en el array
		*/
       private  function getPosition(task : Task) : int
       {
			var taskIterator : Task = null;
			for(var i : int = 0; i < this.allTasks.length; i++)
			{
				taskIterator = Task(this.allTasks.getItemAt(i));
				if(taskIterator.id == task.id)
				{
					return i; 
				}
			}
			return -1;
       }
	    /*
		 * Llamada cuando una terea es seleccionada
		 */
	    public function select (id : String) : void
	    {
	    	var task : UiTask 			= getTask(id);
	    	if(task != null)
	    	{
		    	selectedTask.id 			= task.id;
		    	selectedTask.name 			= task.name;
		    	selectedTask.startDate 		= task.startDate;
		    	selectedTask.endDate 		= task.endDate;
		    	selectedTask.duration 		= task.duration;
		    	selectedTask.position 		= task.position; 
		    	selectedTask.positionVisible= task.positionVisible;  
		    	selectedTask.completed 		= task.completed; 
		    	selectedTask.heriarchy 		= task.heriarchy;  
		    	selectedTask.dependencies 	= task.dependencies;  
		    	selectedTask.taskResources 	= task.taskResources;  	
		    	selectedTask.isMilestone 	= task.isMilestone;  
		    	selectedTask.createdBy 		= task.createdBy;
		    	selectedTask.lastModified 	= task.lastModified;
		    	selectedTask.priority 		= task.priority;  		
		    }				
	    }
	    
	    /*
		 * Retorna un array con las tareas que pueden ser nuevos padres de la tarea seleccionada
		 */
	    public function possibleParentTasks(taskChild : Task) : ArrayCollection
	    {
	    	var parentTasks : ArrayCollection = new ArrayCollection();
		    var object : Object = new  Object();
			object.label = '';
			object.data = '';
			parentTasks.addItem(object);
			for(var i : int = 0; i < allTasks.length ; i++)
	    	{
	    		var task : Task = Task(allTasks.getItemAt(i));
	    		//si la tarea no esta como uno de sus hijos directos o indirectos
	    		
	    		if(!task.isParent(taskChild) && !taskChild.isParent(task))
	    		{
		    		if(task.id != taskChild.id)
		    		{
		    			if(taskChild.heriarchy.parent != null)
		    			{
		    				if(taskChild.heriarchy.parent.id != task.id)
		    				{
		    					object = new  Object();
				    			object.label = task.name;
				    			object.data = task.id;
				    			parentTasks.addItem(object);
		    				}
		    			}
		    			else if(task.heriarchy.parent != null)
    					{
    						if(task.heriarchy.parent.id != taskChild.id)
    						{
		    					object = new  Object();
				    			object.label = task.name;
				    			object.data = task.id;
				    			parentTasks.addItem(object);
				    		}
				    	}
				    	else
		    			{
			    			object = new  Object();
			    			object.label = task.name;
			    			object.data = task.id;
			    			parentTasks.addItem(object);
		    			}
		    		}
			    }
	    	}
	    	return parentTasks;
		}
		/*
		 * Retorna una array solamente con las tareas que se deben mostrar
		 */
		 private var visibleTasks : ArrayCollection = new ArrayCollection();
		 [Bindable]
		 public var countDeleted : int = 0;
		public function filterVisibleTask() : ArrayCollection
		{
			var hasAdd : Boolean = false;
			var positionVisible : int = 1;

			for(var i : int = 0; i < allTasks.length; i++)
			{	
				var task : UiTask = UiTask(allTasks.getItemAt(i));
				
				task.position = i + 1;
				task.positionVisible = positionVisible;
				hasAdd = false;
				
				if(task.heriarchy.parent != null)
				{
					if(task.isVisible())
					{
						hasAdd = true;
					}
				}
				else
				{
					hasAdd = true;
				}
				if(hasAdd)
				{
					if(visibleTasks.length >= positionVisible)
					{
						visibleTasks.setItemAt(task,positionVisible-1);
					}
					else
					{
						visibleTasks.addItem(task);
					}
					positionVisible++;
				}
			}
			var countNotVisible : int = allTasks.length + countDeleted - (positionVisible - 1);
			for(i = countNotVisible-1; i>=0; i--)
			{
				if(visibleTasks.length>=(positionVisible + i))
				{
					visibleTasks.removeItemAt(positionVisible - 1 + i);
				}
			}
			/*for(var i : int = 0; i < visibleTasks.length; i++)
			{	
				var task : UiTask = UiTask(visibleTasks.getItemAt(i));
				trace(task+'  '+task.positionVisible);
			}*/
			countDeleted = 0;
			return visibleTasks;
		}
		
		
		/**
	 	* Edita una tarea
	 	*/
		public function setUpdateTask(task : Task, type : String, text : String, saveInHistory : Boolean = true) : Boolean
		{
			trace('Task: '+task+ ' type: '+ type + ' text: '+ text + ' saveInHistory: '+ saveInHistory );
			var error : Boolean = false;
			if(text == '' && type != Constants.NAME)
			{
				error = true;
			}
			else
			{
				if(type == Constants.NAME)
				{
					if(text=='')
					{
						text = Constants.defaultTaskName;
					}
					task.name = text;
				}
				else if(type == Constants.START_DATE)
				{
					if(task.startDate.toString(Constants.FOUR_DIGIT_FORMAT) != text)
					{
						//var startDateOld : Date = new Date();
						//startDateOld.setTime(TaskDate.startDate.getTime());
						
						task.startDate = new TaskDate(text,0,Constants.FOUR_DIGIT_FORMAT);
						task.endDate 	= new TaskDate(task.startDate.toString(Constants.DATABASE), task.duration);
						
						//si la fecha inicio del gantt cambia
						/*if(startDateOld.getTime() != TaskDate.startDate.getTime())
						{
							setRefreshAllTasks();
						}*/
					}
					else
					{
						error = true;
					}
				}
				else if(type == Constants.END_DATE)
				{
					var taskDate : TaskDate = new TaskDate(text,0,Constants.FOUR_DIGIT_FORMAT);
					var durationTemporal : int = taskDate.toDay() - task.startDate.toDay();
					if(task.duration != durationTemporal && durationTemporal>=0)
					{
						task.duration = durationTemporal;
						task.endDate = new TaskDate(task.startDate.toString(Constants.DATABASE), task.duration);
						if(task.duration == 0)
						{
							task.isMilestone = true;
						}
						else
						{
							task.isMilestone = false;
						}
					}
					/*else
					{
						error = true;
					}*/
				}
				else if(type == Constants.DURATION)
				{
					task.duration = int(text);
					task.endDate = new TaskDate(task.startDate.toString(Constants.DATABASE), task.duration);
					if(task.duration == 0)
					{
						task.isMilestone = true;
					}
					else
					{
						task.isMilestone = false;
					}
				}
				else if(type == Constants.COMPLETED)
				{
					task.completed = int(text);
				}
				else if(type == Constants.ISMILESTONE)
				{
					if(text=='1')
					{
						task.isMilestone = true;
						task.duration = 0;
					}
					else
					{
						task.isMilestone = false;
						task.duration = 1;
					}
					task.endDate = new TaskDate(task.startDate.toString(Constants.DATABASE), task.duration);
				}			
				else if(type == Constants.PRIORITY)
				{
						task.priority = text;
				}				
			}
			if(!error)
			{
				if(task.validate())
				{
					Components.instance.controller.updateTask(task, true, saveInHistory);
					//setParent();
					Components.instance.tasks.select(task.id);
				}
				else
				{
					Components.instance.tasks.allTasks.setItemAt(selectedTask, selectedTask.position-1);
				}
			}
			return (!error);
		}
		/**
		 * Retorna todas las tareas que son hijas (de dependencia) de una tarea pasada como parametro
		 */
		public function getTaskDependencyChild(parentTask : Task) : ArrayCollection
		{
			var taskDependenciesChild : ArrayCollection = new ArrayCollection();
			for(var i : int = 0; i < allTasks.length; i++)
			{
				var task : Task = Task(allTasks.getItemAt(i));
				for(var j : int = 0; j < task.dependencies.length; j++)
				{
					var dependency : Dependency = Dependency(task.dependencies.getItemAt(j));
					if(dependency.task.id == parentTask.id)
					{
						taskDependenciesChild.addItem(task);
					}
				}
			}
			return taskDependenciesChild;
		}
		/**
		 * Le asigna a una tarea los usuarios de creacion y de ultima modificacion
		 */
		public function setTaskUsers() : void
		{
			for(var i : int = 0; i < allTasks.length;i++)
			{
				var task : Task = Task(allTasks.getItemAt(i));
				task.createdBy = Components.instance.users.getUser(task.createdBy.id);
				task.lastModified = Components.instance.users.getUser(task.lastModified.id);
			}
		}
		/*
		 * Retorna la tarea que tiene la fecha mas chica
		 */
		public function firstTask() : Task
		{
			var firstTask : Task = null;
			for(var i : int = 0; i < allTasks.length;i++)
			{
				var task : Task = Task(allTasks.getItemAt(i));
				if(i==0)
				{
					firstTask = task;
				}
				if(task.startDate.date.getTime() < firstTask.startDate.date.getTime())
				{
					firstTask = task;
				}
			}
			return firstTask;
		}
		/**
		 * Calcula y actualiza las fechas inicio y fin de todo el gantt
		 * Esta funcion es llamada cuando se edita, borra o crea una tarea.
		 */
		public function refreshDates() : void
		{
			var startDateAux : Date = new Date();
			var endDateAux : Date = new Date();
			for(var i : int =0; i < allTasks.length; i++)
			{
				var task : Task = Task(allTasks.getItemAt(i));
				if(task.startDate.date.getTime()<startDateAux.getTime())
				{
					startDateAux.setTime(task.startDate.date.getTime());
				}
				var date : Date = addDays(task.endDate.date, 20);
				if(date.getTime()>endDateAux.getTime())
				{
					endDateAux.setTime(date.getTime());
				}
			}
			if(startDateAux.getTime()!=TaskDate.startDate.getTime())//si cambio
			{
				TaskDate.startDate.setTime(addDays(startDateAux, -20).getTime());
			}
			if(endDateAux.getTime()!=TaskDate.endDate.getTime())//si cambio
			{
				TaskDate.endDate.setTime(endDateAux.getTime());
			}
		}
		/**
		 * Suma dias a una fecha y retorna la nueva fecha
		 */
		private function addDays(date : Date, days : Number): Date 
		{
			return new Date(date.getTime() + days * 24 * 60 * 60 * 1000);
		}
		/*public function setRefreshAllTasks() : void
		{
			for(var i : int = 0; i < this.allTasks.length; i++)
			{
				UiTask(this.allTasks.getItemAt(i)).redrawed = 0;
			}
		}*/
	}
}