package com.salesforce.gantt.model
{
	import com.salesforce.gantt.controller.Components;
	[Bindable]
	public class Dependency 
	{	
		public var id : String;
		/*
		 *  lagType
		 *	1 = SF when parent starts the child finishes
		 *	2 = FS when parent finishes the child starts
		 *	3 = SS when parent starts the child starts
		 *	4 = FF when parent finished the child finishes
		 */
		public static const SF : int = 1; 
		public static const FS : int = 2; 
		public static const SS : int = 3; 
		public static const FF : int = 4; 
		
		public var lagType : int;
		
		
		/*
		 *  (numero de horas, dias, semenas)
		 */
		public var lagTime : int;
		
		/*
		 *  (hours, days, weeks)
		 */
		public static const HOURS : int = 1; 
		public static const DAYS : int = 2; 
		public static const WEEKS : int = 3; 
		
		public var lagUnits : int;
		
		public var type : int;
		
		/*
		* Parent object
		*/
		
		public var task : Task = null;

		/*
		 * Constructor
		 */	
		public function Dependency(task : Task, lagType : int, lagTime : int, lagUnits : int, id : String = '')
		{
			this.id			= id;			                  
			this.task		= task;
			this.lagType	= lagType;
			this.lagTime	= lagTime;
			this.lagUnits	= lagUnits;
			this.type		= type;
		}
		public function toString() : String
		{
			var lagType : String = '';
			var lagUnits : String = '';
			var sign : String  = '';
			var lagTime : String = '';
			
			switch (this.lagType)
			{
				case 1:
					lagType = 'SF';
					break;
				case 2:
					lagType = 'FS';
					break;
				case 3:
					lagType = 'SS';
					break;
				case 4:
					lagType = 'FF';
					break;	
			}
			
			if(this.lagTime != 0)
			{
				lagTime = String(this.lagTime);
				
				if(this.lagTime>0) sign='+';
							
				switch (this.lagUnits)
				{
					case 1:
						lagUnits = 'H';
						break;
					case 2:
						lagUnits = 'D';
						break;
					case 3:
						lagUnits = 'W';
						break;
				}
			}			
			return this.task.position + lagType + sign + lagTime + lagUnits;
		}
		/**
		 * Clona una dependencia
		 */
		public function clone() : Dependency
		{
			var dependency : Dependency = new Dependency(null, 0, 0, 0, '');		
			dependency.id		= id;
	    	dependency.lagType	= lagType;
	    	dependency.lagTime	= lagTime;
	    	dependency.lagUnits	= lagUnits;
	    	dependency.type		= type;
	    	dependency.task		= task;
	    	return dependency;
		}
		/**
		 * Retorna el width de la flecha que la dependencia ocupa en el gantt
		 */
		public function lineWidth(child : Task) : int
		{
			var start : int = 0;
			var end : int = 0;
		  if (this.task != null)
		  {
		  	var durationChild : int = child.duration;
		  	if(child.isMilestone)
		  	{
		  		durationChild = 1;
		  	}
			switch (this.lagType)
			{
				case SF:
					start = this.task.startDate.toDay();
					end = child.startDate.toDay() + durationChild + 1;
					break;
				case FS:
					start = this.task.startDate.toDay() + this.task.duration + 1;
					end = child.startDate.toDay();
					break;
				case SS:
					start = this.task.startDate.toDay();
					end = child.startDate.toDay();
					break;
				case FF:
					start = this.task.startDate.toDay() + this.task.duration;
					end = child.startDate.toDay() + durationChild;
					break;
			}
			return end - start;
		  }
		  return 0;
		}
		/**
		 * Retorna el height de la flecha que la dependencia ocupa en el gantt
		 */
		public function lineHeight(child : Task) : int
		{
			if(this.task != null)
			{
			   return child.positionVisible - this.task.positionVisible;
			}
			return 0;   
		}
		/**
		 * Retorna el x de la flecha que la dependencia tiene en el gantt
		 */
		public function lineX() : int
		{
			var lineX : int = 0;
			if (this.task != null)
			{
			   switch (this.lagType)
			   {
				  case SF:
				  case SS:
					   lineX = this.task.startDate.toDay();
					   break;
				  case FS:
				  case FF:
					   lineX = this.task.startDate.toDay() + (this.task.duration + 1);
					   break;
			    }
			    return lineX ;
			}
			return 0;
		}
	}
}