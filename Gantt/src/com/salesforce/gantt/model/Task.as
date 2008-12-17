package com.salesforce.gantt.model
{
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectProxy;
	import com.salesforce.gantt.model.Heriarchy;
	import com.salesforce.gantt.controller.Components;
	import mx.controls.Alert;
	
	[Bindable]
	public class Task  
	{	
		public var id : String;
		public var name : String;
		public var startDate : TaskDate;
		public var endDate : TaskDate;
		public var duration : int;
		public var position : int;
		public var positionVisible : int;
		public var completed : int;	
		public var dependencies : ArrayCollection = new ArrayCollection();
		public var taskResources : ArrayCollection = new ArrayCollection();
		public var heriarchy : Heriarchy;
		public var isMilestone : Boolean;
		public var priority : String;
		
		public var createdBy : User;
		public var lastModified : User;
		
		/*
		 * Costructor
		 */	
		public function Task(name : String, start : String, duration : int = 1, id : String = "", completed : int = 0, isMilestone : Boolean = false,  priority : String = "")
		{		
			this.id = id;
			this.name = name;
			this.duration = duration;		
			this.startDate = new TaskDate(start);
			this.endDate = new TaskDate(start, duration);
			this.completed = completed;
			this.isMilestone = isMilestone;
			this.priority = priority;
		}

		/*
		 * Agrega una dependencia al padre y al hijo
		 * 
		 * Esto viene a reemplazar AssignDependencies
		 */
		public function addDependency(dependency : Dependency) : void
		{
			this.dependencies.addItem(dependency);
		}
		/*
		 * Edita una dependencia
		 */	
		public function updateDependency(dependency : Dependency) : void
		{
			for(var i : int = 0; i < dependencies.length; i++)
			{
				if(dependencies.getItemAt(i).id == dependency.id)
				{
					dependencies.setItemAt(dependency, i);
				}
			}
		}
		/*
		 * Borra una dependencia
		 */				
		public function removeDependency(dependency : Dependency) : void
		{
			for(var i : int = 0; i < dependencies.length; i++)
			{
				if(dependencies.getItemAt(i).id == dependency.id)
				{
					dependencies.removeItemAt(i);
				}
			}
		}

		 /**
		 * Retorna verdadero si la tarea es padre ya sea diecta o indirectamente
		 * */
		 public function isParent(parentTask : Task) : Boolean
		 {
		 	var dependency : Dependency;
		 	for(var i : int = 0; i < dependencies.length; i++)
			{
				dependency = Dependency(dependencies.getItemAt(i));
	    		if(dependency.task != null && parentTask != null){
					if(dependency.task.id == parentTask.id)
					{
						return true;
					}
					else
					{
						isParent(dependency.task);
					}
	    		}
			}
		 	return false;
		 }
		 

		/*
		 * Retorna una dependencia
		 * La uscar por id de dependencia, o por id de tarea padre
		 */
		public function getDependency(value : String, find : String = 'id') : Dependency
		{
			var dependency : Dependency;
			for(var i : int = 0; i < dependencies.length; i++)
			{
				dependency = Dependency(dependencies.getItemAt(i));
				if(find == 'id')
				{
					if(dependency.id == value)
					{
						return dependency;
					}
				}
				else if(find == 'idParent')
				{
					if(dependency.task.id == value)
					{
						return dependency;
					}
				}
			}
			return null;
		}
		
		/*
		 * Retorna un objeto taskResource que tiene el id que se pasa como 
		 * parametro
		 *
		 * @param taskResourceId Identificador de un TaskResource
		 * @return Objeto TaskResource
		 */
		 public function getTaskResource(taskResourceId : String = '', resource : Resource = null) : TaskResource
		 {
		 	var taskResource : TaskResource;
		 	for(var i : int = 0; i < this.taskResources.length; i++)
			{
				taskResource = TaskResource(this.taskResources.getItemAt(i));
				if(taskResourceId != '')
				{
					if(taskResource.id == taskResourceId)
					{
						return taskResource;		
					}
				}
				if(resource != null)
				{
					if(taskResource.resource.id == resource.id)
					{
						return taskResource;		
					}
				}
			}
			return null;
		 }
		 /**
		  * Reemplaza un obj task resource en la coleccion de task resources
		  */
		 public function setTaskResource(taskResourceId : String, taskResource : TaskResource) : void
		 {
		 	for(var i : int = 0; i < this.taskResources.length; i++)
			{
				if(TaskResource(this.taskResources.getItemAt(i)).id == taskResourceId)
				{
					this.taskResources.setItemAt(taskResource,i);
				}
			}
		 }
		 /*
		 * Borra de la memoria a una task, una task resource
		 */				
		public function removeTaskResource(taskResourceId : String) : void
		{
			for(var i : int = 0; i < this.taskResources.length; i++)
			{
				if(this.taskResources.getItemAt(i).id == taskResourceId)
				{
					this.taskResources.removeItemAt(i);		
				}
			}
		}
		/*
	    * Retorna true si existe el recurso asignado en la tarea
	    *
	    * @param resource. Resource a buscar
	    */
	    public function hasResource(resource : Resource) : Boolean
	    {
	    	var exist : Boolean = false;
	    	for(var i : int = 0; i < this.taskResources.length ; i++)
	   		{
	   			if(this.taskResources.getItemAt(i).resource.id == resource.id)
	   			{
	   				exist = true;
	   				break;
	   			}
	    	}
	    	return exist;
	    }
		/*
		 * metodo toString
		 */		
		public function toString() : String
		{
			return this.position+') '+this.name;
		}

		/*
		 * Actualiza el campo position de la tarea en la base de datos
		 * Es llamada cuando se crea, edita o mueve una tarea
		 */	
		public function resetPositions(index : int) : void
		{
			if(this.heriarchy.next != null)
       		{
       			index++;
				this.position = index;
				if(this.id != '')
				{
					//Components.instance.salesforceService.taskOperation.update(UiTask(this));	
				}
				this.heriarchy.next.resetPositions(index);
			}
		}
		/*
		 * Llamada cuando se ingresa o modifica una tarea para validar que los datos sean correctos
		 */
		public function validate () : Boolean
		{
  			if((this.completed >= 0 && this.completed <= 100) || (this.name != ' ' || this.name != null))
  			{
				return true;
  			}	
  			else
  			{
  				Alert.show('Please check the task data');
				return false;
  			}
		}
		/*
		 * Concatena en un string las dependencias
		 */
		public function concatDependencies(separator : String) : String
		{
			var link : String = '';
			//var dependency : Dependency = null;
			
			if(this.dependencies.length>0)
			{
				link = (Dependency(this.dependencies.getItemAt(0))).toString();
				if(this.dependencies.length>1)
				{
					link += '...';
				}
			}
			/*for(var i : int = 0; i < this.dependencies.length; i++)
			{
				dependency = Dependency(this.dependencies.getItemAt(i));
				link += dependency.toString() + separator;
			}
			if(link != '')
			{
				link = link.substr(0,link.length-separator.length);
			}*/
			return link;
		}
		/**
		 * Concatena en un string las dependencias de una tarea
		 */
		public function concatAlternatedDependencies(separator1 : String, separator2 : String, alternated : int) : String
		{
			var separatorTemp : String = '';
			var link : String = '';
			var dependency : Dependency = null;
			
			for(var i : int = 0; i < this.dependencies.length; i++)
			{
				separatorTemp = separator1;
				if((i+1) % alternated == 0)
				{
					separatorTemp = separator2;
				}
				dependency = Dependency(this.dependencies.getItemAt(i));
				link += dependency.toString() + separatorTemp;
			}
			if(link != '')
			{
				link = link.substr(0,link.length-separatorTemp.length);
			}
			return link;
		}
		/*
		 * Concatena en un string las dependencias
		 */
		public function concatTaskResouces(separator : String) : String
		{
			var link : String = '';
			var taskResource : TaskResource = null;
			
			for(var i : int = 0; i < this.taskResources.length; i++)
			{
				taskResource = TaskResource(this.taskResources.getItemAt(i));
				link += taskResource.resource.name + '('+taskResource.dedicated+')' + separator;
			}
			if(link != '')
			{
				link = link.substr(0,link.length-separator.length);
			}
			return link;
		}
	}
}