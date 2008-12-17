package com.salesforce.gantt.controller
{
	
	import com.salesforce.gantt.model.Calendar;
	import com.salesforce.gantt.model.GanttState;
	import com.salesforce.gantt.model.Session;
	import com.salesforce.gantt.model.UserProfile;
	import com.salesforce.gantt.services.SalesforceService;
	
	import mx.core.UIComponent;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.logging.LogEventLevel;
	
	/**
	 * 
	 */
	 
	public class Components extends UIComponent
	{			
		private static var logger : ILogger = Log.getLogger("Components");
		/** the current user permissions */
		public var userPermissions : UserPermissions;		
		/** the GanttStare **/		
		public var ganttState : GanttState;
		/** the Session, User, email **/		
		public var session : Session;
		/** the database connection **/
		public var salesforceService : SalesforceService;
		/** the controller has all UI functionality **/
		public var controller : IController;
		/** the list of Tasks to populate the task grid and gantt chart **/
		[Bindable]
		public var tasks : ITasks;
		/** the list of resource populate the resource grid **/
		public var resources : IResources;
		/** a singleton reference to this class **/
		private static var _instance : Components;
		/**  **/
		public var calendar : Calendar;
		
		public var users : IUsers;
		
		
		public var dependencies : IDependencies;
		
		/**
		 * Constructor
		 * initializes the class references
		 */
		 
		public function Components() : void
		{ 
			if (Log.isDebug())
				logger.log(LogEventLevel.DEBUG, "Components entry");
			_instance = this;
			this.session =  new Session();
			this.salesforceService =  new SalesforceService();
			this.calendar = new Calendar();
			this.controller = new Controller();
			this.tasks = new Tasks();
			this.resources = new Resources();
			
			// User Permissions
			this.userPermissions = new UserPermissions();
			
			this.users = new Users();
			this.dependencies = new Dependencies();
			
			var username : String = this.session.user.email;
			var password : String = this.session.user.password;
			this.salesforceService.authenticateOperation.authenticate (username, password);
			
			
			
			if (Log.isDebug())
				logger.log(LogEventLevel.DEBUG, "Components exit");
		}
		
		/**
		 * get instance makes sure we have only one instance of Components
		 * returns a reference to this class
		 */
		
		public static function get instance() : Components
        {
			if (Log.isDebug())
				logger.log(LogEventLevel.DEBUG, "instance entry");
        	if(_instance == null)
        	{
        		new Components();
        	}
			if (Log.isDebug())
				logger.log(LogEventLevel.DEBUG, "instance exit " + _instance.toString());
            return _instance;
        }
	}
}