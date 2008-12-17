package com.salesforce.gantt.services
{
	import com.salesforce.*;
	import com.salesforce.events.*;
	import com.salesforce.objects.*;
	import com.salesforce.results.*;
	
	import flash.events.EventDispatcher;
	
	import flash.events.TimerEvent;
    import flash.utils.Timer;
    
    import flash.external.*;
    import com.salesforce.gantt.model.GanttState;
    
    public class SalesforceService extends EventDispatcher
    {  
		public var authenticateOperation : AuthenticateOperation = new AuthenticateOperation();
		public var ganttStateOperation : GanttStateOperation = new GanttStateOperation(authenticateOperation.connection);
		public var resourceOperation : ResourceOperation = new ResourceOperation(authenticateOperation.connection);
		public var taskOperation : TaskOperation = new TaskOperation(authenticateOperation.connection);
		public var taskResourceOperation : TaskResourceOperation = new TaskResourceOperation(authenticateOperation.connection);
		public var dependencyOperation : DependencyOperation = new DependencyOperation(authenticateOperation.connection);
		// User Permissions:
		public var userPermissionsOperation : UserPermissionsOperation = new UserPermissionsOperation(authenticateOperation.connection);
		
		
		
		private var timer : Timer;
    	public var activateCheckRefresh : Boolean = false;
    	private var dateStart : Date = serverDate(new Date());
		/* 
		 * Costructor
		 */
		public function SalesforceService() : void
		{
			initTimer();
		}
		public function initTimer() : void 
	    {
	        // creates a new five-second Timer
	        timer = new Timer(5 * 60 * 1000, 1);
	        
	        // designates listeners for the interval and completion events
	       // timer.addEventListener(TimerEvent.TIMER, check);
	        timer.addEventListener(TimerEvent.TIMER_COMPLETE, complete);
	        
	        // starts the timer ticking
	        
    		//HAY QUE DESCOMENTAR ESTOPARA PRENDER EL TIMER
	        //timer.start();
	    }
	    public function check(event : TimerEvent) : void
		{
			if(activateCheckRefresh)
			{
				checkRefresh();
			}
			authenticateOperation.checkUpdate(); 
		}
	    public function complete(event : TimerEvent):void
	    {
	    	timer.stop();
			initTimer();
	    }
    	public function checkRefresh() : void
		{
			var dateEnd : Date = serverDate(new Date());
			//this.dateStart = serverDate(dateStart);
			
			//verifican si se hicieron cambios (create o update)en la base de datos
			taskOperation.checkUpdate(dateStart, dateEnd);
			taskResourceOperation.checkUpdate(dateStart, dateEnd);
			dependencyOperation.checkUpdate(dateStart, dateEnd);
			
			//verifican si se borraron datos en la base 
			//taskOperation.checkDeleted(dateStart, dateEnd);
			//taskResourceOperation.checkDeleted(dateStart, dateEnd);
			//dependencyOperation.checkDeleted(dateStart, dateEnd);
			
			this.dateStart = dateEnd;
			//trace("---> "+dateStart);
		}
	    private function serverDate(date : Date) : Date
	    {
	    	//Cambiar esto
	    	//ajusto defasaje hora uruguay/estados unidos
	    	return new Date(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours()-4, date.getMinutes(), date.getSeconds());
	    }
    }
}