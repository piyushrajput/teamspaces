package com.salesforce.gantt.model
{
	import mx.collections.ArrayCollection;
	import com.salesforce.gantt.controller.Components;
	
	[Bindable]
	public class Heriarchy
	{
		public var indent : int;
		public var parent : Task;
		public var next : Task;
		
		public function Heriarchy(indent : int, parent : Task = null, next : Task = null)
		{
			this.indent		= indent;
			this.parent		= parent;
			this.next		= next;
		}
		
		
		
		/**
        * Si la tarea tiene algun hijo
        */
		public function hasChildren(id : String) : Boolean
		{
			var hasChildren : Boolean = false;
			if(next != null)
			{
				if(next.heriarchy.parent != null)
		        {
		        	if(next.heriarchy.parent.id == id)
			  		{
			  			hasChildren = true;
			  		}
			    }
			}
		    return hasChildren;
		}
		
		/*
		public function moveChildren(task : Task, parentTask : Task, type : String) : void
        {
       		if(next != null)
       		{
       			if(next.heriarchy.parent != null)
				{
					if(next.heriarchy.parent.id == task.id)
					//if(parentTask.heriarchy.isParentHeriarchy(task))
					{
						if(type=='left')
						{
							next.heriarchy.indent--;
						} 
						else if(type=='right')
						{
							next.heriarchy.indent++;
						}
					}
       			}
       			//se conserva el padre de los padres(el primer padre)
       			next.heriarchy.moveChildren(next, parentTask, type);
       		}
		}
		*/
		
		/*
		 * Retorna todas las task hijas de la mamoria de forma recursiva (hijas ya sea directa o indirectamente)
		 */
		public function getChildren(task : Task, tasks : ArrayCollection) : ArrayCollection
		{
			
			if(next != null)
       		{
				if(task.heriarchy.isParentHeriarchy(next))
				{
					tasks.addItem(next);
				}
				return next.heriarchy.getChildren(task, tasks);				
       		}
			return tasks;
		}
		/**
		 * Retorna true si una tarea es padre(ya sea directa o indirectamente) de la otra
		 */
		public function isParentHeriarchy(task : Task) : Boolean
		{
			if(task != null)
			{
				if(this.parent != null)
				{
					if(this.parent.id == task.id)
					{
						return true;
					}
					else
					{
						return this.isParentHeriarchy(task.heriarchy.parent);
					}
				}
				else
				{
					return false;
				}
			}
			else
			{
				return false;
			}
		}
		/**
        * Si es primer padre de herarquia (Es padre y tiene indent en 0)
        */
        public function isFirstParent() : Boolean
        {
        	if(this.parent != null)
        	{
        		return (this.indent == 0 && this.hasChildren(this.parent.id));
        	}
        	return false;
		}
		
		/**
       * Indenta hacia la derecha o hacia laizquierda una tarea
       * Se encarga de llamar a las funciones que
       * 	- asignan o des-asignar nuevos padreas a las tareas alteradas
       * 	- agregan las imagenes de mas y menos
       * 	- muevenr las hijos
       **/
       public function updateIndent(task : Task, type : String) : void
       {
       		var error : Boolean = true;
       		if(type == 'left')
			{
				if(this.indent > 0)
				{
					moveChildren(task, type);
					this.indent--;
					//error = false;
				}
			} else {
				//si tiene padre
				if(this.parent != null)
				{
					//si el padre no es el que esta en el renglon anterior
					//if(this.parent.id != this.parent.heriarchy.next.id)
					//trace(this.parent.name);
					//trace(this.parent.heriarchy.next);
					
					if(this.parent.heriarchy.next.id != task.id)
					{
						moveChildren(task, type);
						this.indent++;
						//error = false;
					}
				} else {
					moveChildren(task, type);
					this.indent++;
					//error = false;
				}
			}
			//if(!error)
			//{
				//this.moveChildren(task, task, type);
			//}
        }
        /**
		 * Dada una tarea indenta todos sus hijos ya sea hacia la izquierda o hacia la derecha
		 */
        private function moveChildren(task : Task, type : String) : void
        {
        	var children : ArrayCollection = Components.instance.tasks.getAllChildren(task, new ArrayCollection());
        	for(var i : int = 0; i < children.length; i++)
        	{
        		var child : Task = Task(children.getItemAt(i));
				if(type=='left')
				{
					child.heriarchy.indent--;
				} 
				else if(type=='right')
				{
					child.heriarchy.indent++;
				}
				Components.instance.salesforceService.taskOperation.update(child);
        	}
        }
        /**
		 * Chequea si la tarea deberia tener(verifica segun la indentacion) 
		 * un padre de herarquia para asignarselo al objeto, de lo contrario le asigna null
		 */
        public function setParent(taskParent : Task) : Boolean
        {
        	var isParent : Boolean = false;
        	if(this.indent-1 == taskParent.heriarchy.indent)
			{
			 	this.parent = taskParent;
			 	isParent = true;
			}
			else if(this.indent == taskParent.heriarchy.indent)
			{
				//cuando mueve hacia la izquierda puede que al padre que tenia se le saque el signo de mas
				if(this.parent != null)
				{
					if(this.parent.id == taskParent.id)
					{
						this.parent = null;
					}
				}
			}
			return isParent;
        }
	}
}