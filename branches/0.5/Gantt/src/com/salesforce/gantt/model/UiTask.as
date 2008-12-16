package com.salesforce.gantt.model
{	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class UiTask extends Task  
	{	
		//public var colorComplete : String = '#7EAEFF';
		//public var hRuleWidth : Number = 0;
		//public var hRuleX : Number = 0;
		//public var imageDependency : String = '';
		public var isExpanded : Boolean;
		public var alphaCut : Number = 0.1;
		public var redrawed : int = 0;
		public var isDeleted : Boolean = false;
		public var isHidden : Boolean = false;
		
		
		/*
		 * Costructor
		 */		
		public function UiTask(name : String, startDate : String, duration : int = 1, id : String = "", completed : int = 0, isExpand : Boolean = true, isMilestone : Boolean = false, priority : String = '' )
		{
			super(name, startDate, duration, id, completed, isMilestone, priority);
			this.isExpanded = true;
		}
		public function clone() : Task 
		{
			var task : Task = new UiTask('', '', 0, '');
			task.id 			= id;
	    	task.name 			= name;
	    	task.startDate.date.setTime(startDate.date.getTime());
	    	task.endDate.date.setTime(endDate.date.getTime());
	    	task.duration 		= duration;
	    	task.position 		= position;
	    	task.positionVisible = positionVisible;  
	    	task.completed 		= completed; 
	    	task.heriarchy 		= heriarchy;  
	    	task.dependencies 	= dependencies;  
	    	task.taskResources 	= taskResources;  
	    	task.isMilestone 	= isMilestone;
	    	task.createdBy 		= createdBy;
	    	task.lastModified 	= lastModified;  
	    	task.priority = priority;
	    	return task;
		}
		/*
        * Retorna true si una tarea es visible en la grilla
        */
        public function isVisible() : Boolean
        {
        	if(this.heriarchy.parent != null)
        	{
        		if(!UiTask(this.heriarchy.parent).isExpanded)
        		{
        			return false;
        		}
        		else
        		{
        			return UiTask(this.heriarchy.parent).isVisible();
        		}
        	}
           return true;
        }
		public function isEditable() : Boolean
		{
			if(this.heriarchy != null)	{
				return (!this.heriarchy.hasChildren(this.id));
			}
			return true;
		}
        public function imageSign() : int
        {
        	if(this.heriarchy.hasChildren(this.id))
        	{
        		if(this.isExpanded)
        		{
        			return 0;
        		}
        		else
        		{
        			return 1;
        		}
        	}
        	return -1;
        }
       
       
	}
}