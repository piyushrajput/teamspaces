package com.salesforce.gantt.controller
{
	import mx.collections.ArrayCollection;
	import com.salesforce.gantt.model.Dependency;
	import com.salesforce.gantt.model.Task;
	
	public class Dependencies implements IDependencies
	{		
		/*
		 * Constructor
		 */
		public function Dependencies() : void
		{
			
		}
		
		/*
		 * Dado un padre y un hijo retorna la dependencia que las une
		 */
		public function getDependency(parentTask : Task, childTask : Task) : Dependency
		{
			var dependency : Dependency = null;
			for(var i : int = 0; i < childTask.dependencies.length; i++)
			{
				var dependencyTemp : Dependency = Dependency(childTask.dependencies.getItemAt(i));
				if(dependencyTemp.task.id == parentTask.id)
				{
					dependency = dependencyTemp;
				}
			}
			return dependency;
		}
		/*
		 * Retorna todas las dependencias dirctas (o se las de primer orden)
		 */
		public function getDirectDependencies(parentTask : Task) : ArrayCollection
		{
			var tasks : ArrayCollection = new ArrayCollection();
			for(var i : int = 0; i < Components.instance.tasks.allTasks.length; i++)
			{
				var childTask : Task = Task(Components.instance.tasks.allTasks.getItemAt(i));
				for(var j : int = 0; j < childTask.dependencies.length; j++)
				{
					var dependency : Dependency = Dependency(childTask.dependencies.getItemAt(j));
					if(dependency.task.id == parentTask.id)
					{
						tasks.addItem(childTask);
					}
				}
			}
			return tasks;
		}
		/*
		 * Valida que una tarea pueda depender de otra
		 */
		public function validateDependency(parentTask : Task, childTask : Task) : Boolean
		{
			var validate : Boolean = false;
			var parentTasks : ArrayCollection = Components.instance.tasks.possibleParentTasks(childTask);
			for(var i : int = 0; i < parentTasks.length; i++)
			{
				var task : Object = Object(parentTasks.getItemAt(i));
				if(task.data == parentTask.id)
				{
					validate = true;
				}
			}
			return validate;
		}
	}
}